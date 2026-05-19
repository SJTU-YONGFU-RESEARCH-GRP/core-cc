#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <time.h>

// Verilator generated header
#include "Vparity_ecc.h"
#include "verilated.h"
#include "ecc_test_utils.h"

// DATA_WIDTH must match the DUT parameter (set via -DDATA_WIDTH / -GDATA_WIDTH)
#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

// Port access macros (wide paths when DATA_WIDTH > 64)
#if DATA_WIDTH > 64
    #define SET_DATA_IN(dut, val) SET_WIDE_PORT(dut, data_in, val, DATA_WIDTH)

    // Codeword layout: DATA_WIDTH data bits plus 1 parity bit
    #define SET_CODEWORD_IN(dut, val) SET_WIDE_PORT(dut, codeword_in, val, DATA_WIDTH+1)

    #define GET_CODEWORD_OUT(dut, val) GET_WIDE_PORT(dut, codeword_out, val, DATA_WIDTH+1)

    #define GET_DATA_OUT(dut, val) GET_WIDE_PORT(dut, data_out, val, DATA_WIDTH)
#else
    #define SET_DATA_IN(dut, val) (dut)->data_in = to_u64(val)
    #define GET_DATA_OUT(dut, val) (val) = from_u64((dut)->data_out)

    #if DATA_WIDTH >= 64
        // 65-bit codeword uses Verilator WData ports
        #define SET_CODEWORD_IN(dut, val) SET_WIDE_PORT(dut, codeword_in, val, DATA_WIDTH+1)
        #define GET_CODEWORD_OUT(dut, val) GET_WIDE_PORT(dut, codeword_out, val, DATA_WIDTH+1)
    #else
        #define SET_CODEWORD_IN(dut, val) (dut)->codeword_in = to_u64(val)
        #define GET_CODEWORD_OUT(dut, val) (val) = from_u64((dut)->codeword_out)
    #endif
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

// Reference model: even parity, parity at bit 0, data at bits [DATA_WIDTH:1]
int calculate_parity(const BitArray& data, int data_width) {
    int parity = 0;
    for (int i = 0; i < data_width; i++) {
        if (data.get_bit(i)) parity ^= 1;
    }
    return parity;
}

BitArray encode_parity(const BitArray& data, int data_width) {
    int parity = calculate_parity(data, data_width);
    BitArray codeword;
    // Matches Verilog: encoded_codeword = {data_in, encode_parity_bit}
    codeword.set_bit(0, parity);
    for (int i = 0; i < data_width; i++) {
        codeword.set_bit(i + 1, data.get_bit(i));
    }
    return codeword;
}

BitArray decode_parity(const BitArray& codeword, int data_width, int* error_detected) {
    BitArray data;
    int parity_bit = codeword.get_bit(0);
    for (int i = 0; i < data_width; i++) {
        data.set_bit(i, codeword.get_bit(i + 1));
    }

    int expected_parity = calculate_parity(data, data_width);
    *error_detected = (parity_bit != expected_parity);
    return data;
}

void test_parity_ecc() {
    Vparity_ecc* dut = new Vparity_ecc();

    int data_width = DATA_WIDTH;
    printf("=== Parity ECC Test (DATA_WIDTH=%d) ===\n", data_width);

    const int NUM_TESTS = 20;
    srand(12345);

    int pass_count = 0;
    int fail_count = 0;
    int max_encode_cycles = 0;
    int max_decode_cycles = 0;

    // Per-check pass flags (cleared on first failure in that category)
    bool strat1_pass = true;
    bool strat2_pass = true;
    bool strat3_pass = true;
    bool strat4_pass = true;
    bool strat5_pass = true;

    for (int i = 0; i < NUM_TESTS; i++) {
        // Setup: random data, encode through DUT
        BitArray test_data;
        for (int w = 0; w < MAX_WORDS; w++) test_data.words[w] = rand() | (rand() << 16);
        for (int b = data_width; b < MAX_WORDS * 32; b++) test_data.set_bit(b, 0);

        BitArray expected_codeword = encode_parity(test_data, data_width);

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

        // Decode checks (five cases per random vector)

        // Case 1: valid codeword, data_in consistent with codeword
        dut->encode_en = 0;
        dut->decode_en = 1;
        SET_DATA_IN(dut, test_data);
        SET_CODEWORD_IN(dut, expected_codeword);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        BitArray dut_out;
        GET_DATA_OUT(dut, dut_out);
        if (dut_out == test_data && !dut->error_detected) {
            pass_count++;
        } else {
            fail_count++;
            strat1_pass = false;
            printf("[Test %d] Case 1 failed: clean decode mismatch or spurious error_detected\n", i);
        }

        // Case 2: valid codeword, data_in unrelated (decoder must not use data_in)
        BitArray poison_data;
        poison_data.words[0] = 0xDEADBEEF;
        SET_DATA_IN(dut, poison_data);
        SET_CODEWORD_IN(dut, expected_codeword);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        if (!dut->error_detected) {
            pass_count++;
        } else {
            fail_count++;
            strat2_pass = false;
            printf("[Test %d] Case 2 failed: spurious error_detected when data_in does not match codeword\n", i);
        }

        // Case 3: flip parity bit (bit 0); must assert error_detected
        SET_DATA_IN(dut, test_data);
        BitArray parity_corrupted = expected_codeword;
        parity_corrupted.set_bit(0, !parity_corrupted.get_bit(0));
        SET_CODEWORD_IN(dut, parity_corrupted);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        if (dut->error_detected) {
            pass_count++;
        } else {
            fail_count++;
            strat3_pass = false;
            printf("[Test %d] Case 3 failed: parity-bit error not detected\n", i);
        }

        // Case 4: flip one data bit (bits 1..DATA_WIDTH); must assert error_detected
        BitArray data_corrupted = expected_codeword;
        int random_bit_pos = (rand() % data_width) + 1;
        data_corrupted.set_bit(random_bit_pos, !data_corrupted.get_bit(random_bit_pos));
        SET_CODEWORD_IN(dut, data_corrupted);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        if (dut->error_detected) {
            pass_count++;
        } else {
            fail_count++;
            strat4_pass = false;
            printf("[Test %d] Case 4 failed: single data-bit error not detected\n", i);
        }

        // Case 5: flip two data bits; even parity may not detect (expect no error)
        BitArray double_corrupted = expected_codeword;
        int pos1 = (rand() % data_width) + 1;
        int pos2 = (pos1 % data_width) + 1;
        double_corrupted.set_bit(pos1, !double_corrupted.get_bit(pos1));
        double_corrupted.set_bit(pos2, !double_corrupted.get_bit(pos2));
        SET_CODEWORD_IN(dut, double_corrupted);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        if (!dut->error_detected) {
            pass_count++;
        } else {
            fail_count++;
            strat5_pass = false;
            printf("[Test %d] Case 5 failed: false positive on two-bit data error\n", i);
        }
    }

    printf("\n");
    printf("==================================================\n");
    printf(" Parity ECC verification summary (DATA_WIDTH=%d)\n", data_width);
    printf("==================================================\n");
    printf(" Random vectors: %d\n", NUM_TESTS);
    printf("--------------------------------------------------\n");
    printf(" [1] Clean decode                         : %s\n", strat1_pass ? "PASS" : "FAIL");
    printf(" [2] Decoder isolation (mismatched data_in): %s\n", strat2_pass ? "PASS" : "FAIL");
    printf(" [3] Single-bit error on parity           : %s\n", strat3_pass ? "PASS" : "FAIL");
    printf(" [4] Single-bit error on data             : %s\n", strat4_pass ? "PASS" : "FAIL");
    printf(" [5] Two-bit data error (undetectable)   : %s\n", strat5_pass ? "PASS" : "FAIL");
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
    test_parity_ecc();
    return 0;
}
