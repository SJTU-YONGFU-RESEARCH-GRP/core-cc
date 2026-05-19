#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <time.h>

#include "Vextended_hamming_secded_ecc.h"
#include "verilated.h"
#include "ecc_test_utils.h"

#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

// SEC codeword width (matches extended_hamming_secded_ecc.v SEC_WIDTH)
#define CALC_SEC_WIDTH(dw) \
    ((dw) <= 2 ? 5 : \
     (dw) <= 4 ? 7 : \
     (dw) <= 8 ? 12 : \
     (dw) <= 16 ? 21 : \
     (dw) <= 32 ? 38 : \
     (dw) <= 64 ? 71 : 136)
#define SEC_WIDTH CALC_SEC_WIDTH(DATA_WIDTH)
#define CODEWORD_WIDTH (SEC_WIDTH + 1)

#if DATA_WIDTH > 64
    #define SET_DATA_IN(dut, val) SET_WIDE_PORT(dut, data_in, val, DATA_WIDTH)
    #define GET_DATA_OUT(dut, val) GET_WIDE_PORT(dut, data_out, val, DATA_WIDTH)
#else
    #define SET_DATA_IN(dut, val) (dut)->data_in = to_u64(val)
    #define GET_DATA_OUT(dut, val) (val) = from_u64((dut)->data_out)
#endif

#if CODEWORD_WIDTH > 64
    #define SET_CODEWORD_IN(dut, val) SET_WIDE_PORT(dut, codeword_in, val, CODEWORD_WIDTH)
    #define GET_CODEWORD_OUT(dut, val) GET_WIDE_PORT(dut, codeword_out, val, CODEWORD_WIDTH)
#else
    #define SET_CODEWORD_IN(dut, val) (dut)->codeword_in = to_u64(val)
    #define GET_CODEWORD_OUT(dut, val) (val) = from_u64((dut)->codeword_out)
#endif

#define CLOCK_UNTIL_VALID(dut, max_cycles_var) \
    do { \
        int _cycles = 0; \
        do { \
            (dut)->clk = 0; \
            (dut)->eval(); \
            (dut)->clk = 1; \
            (dut)->eval(); \
            _cycles++; \
        } while (!(dut)->valid_out && _cycles < 100); \
        if (_cycles > (max_cycles_var)) (max_cycles_var) = _cycles; \
    } while (0)

bool is_parity_pos(int pos) {
    int check = pos + 1;
    return (check != 0) && ((check & (check - 1)) == 0);
}

int get_data_pos(int data_idx, int n) {
    int idx = 0;
    for (int j = 0; j < n; j++) {
        if (!is_parity_pos(j)) {
            if (idx == data_idx) return j;
            idx++;
        }
    }
    return -1;
}

// Hamming SEC codeword only (lower SEC_WIDTH bits of SECDED)
BitArray encode_sec(const BitArray& data, int k, int n) {
    BitArray cw;
    int parity_bits = n - k;

    for (int i = 0; i < k; i++) {
        cw.set_bit(get_data_pos(i, n), data.get_bit(i));
    }

    for (int i = 0; i < parity_bits; i++) {
        int p = 0;
        for (int j = 0; j < n; j++) {
            if (!is_parity_pos(j) || j != ((1 << i) - 1)) {
                if (((j + 1) & (1 << i)) != 0) {
                    p ^= cw.get_bit(j);
                }
            }
        }
        cw.set_bit((1 << i) - 1, p);
    }
    return cw;
}

// SECDED: XOR all SEC bits, append overall parity at MSB (bit SEC_WIDTH)
BitArray encode_secded(const BitArray& data, int k, int sec_n) {
    BitArray sec_cw = encode_sec(data, k, sec_n);

    int overall_parity = 0;
    for (int j = 0; j < sec_n; j++) {
        overall_parity ^= sec_cw.get_bit(j);
    }

    BitArray cw;
    for (int j = 0; j < sec_n; j++) {
        cw.set_bit(j, sec_cw.get_bit(j));
    }
    cw.set_bit(sec_n, overall_parity);
    return cw;
}

void test_extended_hamming_secded() {
    Vextended_hamming_secded_ecc* dut = new Vextended_hamming_secded_ecc();

    int data_width = DATA_WIDTH;
    int sec_width = SEC_WIDTH;
    int codeword_width = CODEWORD_WIDTH;
    printf("=== Extended Hamming SECDED Test (DATA_WIDTH=%d, SEC_WIDTH=%d, CODEWORD_WIDTH=%d) ===\n",
           data_width, sec_width, codeword_width);

    const int NUM_TESTS = 20;
    srand(12345);

    int pass_count = 0;
    int fail_count = 0;
    int max_encode_cycles = 0;
    int max_decode_cycles = 0;

    bool strat1_pass = true;
    bool strat2_pass = true;
    bool strat3_pass = true;
    bool strat4_pass = true;
    bool strat5_pass = true;

    for (int i = 0; i < NUM_TESTS; i++) {
        BitArray test_data;
        for (int w = 0; w < MAX_WORDS; w++) test_data.words[w] = rand() | (rand() << 16);
        for (int b = data_width; b < MAX_WORDS * 32; b++) test_data.set_bit(b, 0);

        BitArray expected_codeword = encode_secded(test_data, data_width, sec_width);

        dut->rst_n = 0;
        dut->eval();
        dut->rst_n = 1;
        dut->eval();

        dut->encode_en = 1;
        dut->decode_en = 0;
        SET_DATA_IN(dut, test_data);

        int encode_cycles = 0;
        do {
            dut->clk = 0;
            dut->eval();
            dut->clk = 1;
            dut->eval();
            encode_cycles++;
        } while (!dut->valid_out && encode_cycles < 100);

        if (encode_cycles > max_encode_cycles) max_encode_cycles = encode_cycles;

        // Case 1: clean decode
        dut->encode_en = 0;
        dut->decode_en = 1;
        SET_DATA_IN(dut, test_data);
        SET_CODEWORD_IN(dut, expected_codeword);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        BitArray dut_out;
        GET_DATA_OUT(dut, dut_out);
        if (dut_out == test_data && !dut->error_detected && !dut->error_corrected) {
            pass_count++;
        } else {
            fail_count++;
            strat1_pass = false;
            printf("[Test %d] Case 1 failed: clean decode mismatch\n", i);
        }

        // Case 2: decoder isolation (mismatched data_in)
        BitArray poison_data;
        poison_data.words[0] = 0xDEADBEEF;
        SET_DATA_IN(dut, poison_data);
        SET_CODEWORD_IN(dut, expected_codeword);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        GET_DATA_OUT(dut, dut_out);
        if (dut_out == test_data && !dut->error_detected) {
            pass_count++;
        } else {
            fail_count++;
            strat2_pass = false;
            printf("[Test %d] Case 2 failed: decoder relies on data_in\n", i);
        }

        // Case 3: single-bit error in SEC region (flip P1 at bit 0)
        SET_DATA_IN(dut, test_data);
        BitArray single_parity_err = expected_codeword;
        single_parity_err.set_bit(0, !single_parity_err.get_bit(0));
        SET_CODEWORD_IN(dut, single_parity_err);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        GET_DATA_OUT(dut, dut_out);
        if (dut_out == test_data && dut->error_detected && dut->error_corrected) {
            pass_count++;
        } else {
            fail_count++;
            strat3_pass = false;
            printf("[Test %d] Case 3 failed: failed to correct single SEC parity error\n", i);
        }

        // Case 4: single-bit error on a data position in SEC region
        BitArray single_data_err = expected_codeword;
        int data_pos = get_data_pos((rand() % data_width), sec_width);
        single_data_err.set_bit(data_pos, !single_data_err.get_bit(data_pos));
        SET_CODEWORD_IN(dut, single_data_err);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        GET_DATA_OUT(dut, dut_out);
        if (dut_out == test_data && dut->error_detected && dut->error_corrected) {
            pass_count++;
        } else {
            fail_count++;
            strat4_pass = false;
            printf("[Test %d] Case 4 failed: failed to correct single data-bit error\n", i);
        }

        // Case 5: two-bit error on SEC parity only (detect, no correction, data untouched)
        // Flipping two data bits would corrupt extracted_data; parity-only flips
        // trigger double_error while leaving payload bits in the SEC word unchanged.
        BitArray double_err = expected_codeword;
        int pos1 = 0;              // P1
        int pos2 = (1 << 1) - 1;   // P2  (both are Hamming parity positions)
        double_err.set_bit(pos1, !double_err.get_bit(pos1));
        double_err.set_bit(pos2, !double_err.get_bit(pos2));
        SET_CODEWORD_IN(dut, double_err);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        GET_DATA_OUT(dut, dut_out);
        if (dut_out == test_data && dut->error_detected && !dut->error_corrected) {
            pass_count++;
        } else {
            fail_count++;
            strat5_pass = false;
            printf("[Test %d] Case 5 failed: double-bit error not handled as detect-only\n", i);
        }
    }

    printf("\n");
    printf("==================================================\n");
    printf(" Extended Hamming SECDED summary (DATA_WIDTH=%d)\n", data_width);
    printf("==================================================\n");
    printf(" Random vectors: %d\n", NUM_TESTS);
    printf("--------------------------------------------------\n");
    printf(" [1] Clean decode                         : %s\n", strat1_pass ? "PASS" : "FAIL");
    printf(" [2] Decoder isolation (mismatched data)  : %s\n", strat2_pass ? "PASS" : "FAIL");
    printf(" [3] Single-bit correction (SEC parity)   : %s\n", strat3_pass ? "PASS" : "FAIL");
    printf(" [4] Single-bit correction (SEC data)     : %s\n", strat4_pass ? "PASS" : "FAIL");
    printf(" [5] Two-bit error (detect, no correct)   : %s\n", strat5_pass ? "PASS" : "FAIL");
    printf("--------------------------------------------------\n");
    printf(" Check outcomes: %d passed, %d failed\n", pass_count, fail_count);
    printf(" Max encode cycles observed: %d\n", max_encode_cycles);
    printf(" Max decode cycles observed: %d\n", max_decode_cycles);
    printf("==================================================\n");

    bool all_pass = (strat1_pass && strat2_pass && strat3_pass && strat4_pass && strat5_pass);

    if (all_pass) {
        printf(" RESULT: PASS\n");
    } else {
        printf(" RESULT: FAIL\n");
    }
    printf("==================================================\n\n");

    delete dut;
}

int main() {
    test_extended_hamming_secded();
    return 0;
}
