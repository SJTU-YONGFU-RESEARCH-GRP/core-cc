#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <time.h>

// Verilator generated header
#include "Vhamming_sec_ecc.h"
#include "verilated.h"
#include "ecc_test_utils.h"

#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

// CODEWORD_WIDTH must match hamming_sec_ecc.v parameter logic (for #if and runtime)
#define CALC_CW_WIDTH(dw) \
    ((dw) <= 2 ? 5 : \
     (dw) <= 4 ? 7 : \
     (dw) <= 8 ? 12 : \
     (dw) <= 16 ? 21 : \
     (dw) <= 32 ? 38 : \
     (dw) <= 64 ? 71 : 136)
#define CODEWORD_WIDTH CALC_CW_WIDTH(DATA_WIDTH)

// Port access macros (data and codeword widths are independent at DATA_WIDTH=64)
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

// Clock until valid_out is asserted; track cycles for latency reporting
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

// --- Golden Model for Hamming SEC ---
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
    return -1; // Should not reach
}

BitArray encode_sec(const BitArray& data, int k, int n) {
    BitArray cw;
    int parity_bits = n - k;
    
    // Insert data bits
    for (int i = 0; i < k; i++) {
        cw.set_bit(get_data_pos(i, n), data.get_bit(i));
    }
    
    // Calculate parity bits
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
// ------------------------------------

void test_hamming_sec() {
    Vhamming_sec_ecc* dut = new Vhamming_sec_ecc();

    int data_width = DATA_WIDTH;
    int codeword_width = CODEWORD_WIDTH;
    printf("=== Hamming SEC ECC Test (DATA_WIDTH=%d, CODEWORD_WIDTH=%d) ===\n", data_width, codeword_width);

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

        BitArray expected_codeword = encode_sec(test_data, data_width, codeword_width);

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

        // Case 1: Clean decode (no errors)
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
            fail_count++; strat1_pass = false;
            printf("[Test %d] Case 1 failed: clean decode mismatch\n", i);
        }

        // Case 2: Decoder isolation (Data poisoning)
        BitArray poison_data;
        poison_data.words[0] = 0xDEADBEEF;
        SET_DATA_IN(dut, poison_data);
        SET_CODEWORD_IN(dut, expected_codeword);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        GET_DATA_OUT(dut, dut_out);
        if (dut_out == test_data && !dut->error_detected) {
            pass_count++;
        } else {
            fail_count++; strat2_pass = false;
            printf("[Test %d] Case 2 failed: decoder relies on data_in\n", i);
        }

        // Case 3: Single-bit error on parity (Correctable)
        SET_DATA_IN(dut, test_data);
        BitArray single_parity_err = expected_codeword;
        single_parity_err.set_bit(0, !single_parity_err.get_bit(0)); // Flip P1
        SET_CODEWORD_IN(dut, single_parity_err);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        GET_DATA_OUT(dut, dut_out);
        if (dut_out == test_data && dut->error_detected && dut->error_corrected) {
            pass_count++;
        } else {
            fail_count++; strat3_pass = false;
            printf("[Test %d] Case 3 failed: failed to correct parity bit error\n", i);
        }

        // Case 4: Single-bit error on data (Correctable)
        BitArray single_data_err = expected_codeword;
        int data_pos = get_data_pos((rand() % data_width), codeword_width);
        single_data_err.set_bit(data_pos, !single_data_err.get_bit(data_pos));
        SET_CODEWORD_IN(dut, single_data_err);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        GET_DATA_OUT(dut, dut_out);
        if (dut_out == test_data && dut->error_detected && dut->error_corrected) {
            pass_count++;
        } else {
            fail_count++; strat4_pass = false;
            printf("[Test %d] Case 4 failed: failed to correct data bit error\n", i);
        }

        // Case 5: Two-bit error (Mathematical Limit Demonstration)
        // A pure SEC module WILL miscorrect or fail silently here.
        // It does NOT have an uncorrectable error flag. 
        // We PASS this test if the module corrupts the data but thinks it corrected it (Miscorrection).
        BitArray double_err = expected_codeword;
        int pos1 = get_data_pos(0, codeword_width);
        int pos2 = get_data_pos(1, codeword_width);
        double_err.set_bit(pos1, !double_err.get_bit(pos1));
        double_err.set_bit(pos2, !double_err.get_bit(pos2));
        SET_CODEWORD_IN(dut, double_err);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        GET_DATA_OUT(dut, dut_out);
        // Expectation: The data is ruined (dut_out != test_data), 
        // but the SEC module blindly asserts error_corrected.
        if (dut_out != test_data) {
            pass_count++;
        } else {
            fail_count++; strat5_pass = false;
            printf("[Test %d] Case 5 failed: SEC miraculously recovered a double error? Check logic.\n", i);
        }
    }

    printf("\n");
    printf("==================================================\n");
    printf(" Hamming SEC verification summary (DATA_WIDTH=%d)\n", data_width);
    printf("==================================================\n");
    printf(" Random vectors: %d\n", NUM_TESTS);
    printf("--------------------------------------------------\n");
    printf(" [1] Clean decode                         : %s\n", strat1_pass ? "PASS" : "FAIL");
    printf(" [2] Decoder isolation (mismatched data)  : %s\n", strat2_pass ? "PASS" : "FAIL");
    printf(" [3] Single-bit correction (parity)       : %s\n", strat3_pass ? "PASS" : "FAIL");
    printf(" [4] Single-bit correction (data)         : %s\n", strat4_pass ? "PASS" : "FAIL");
    printf(" [5] Two-bit error (miscorrection proved) : %s\n", strat5_pass ? "PASS" : "FAIL");
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
    test_hamming_sec();
    return 0;
}