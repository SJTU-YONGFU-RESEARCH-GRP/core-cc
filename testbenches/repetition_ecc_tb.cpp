#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <time.h>

#include "Vrepetition_ecc.h"
#include "verilated.h"
#include "ecc_test_utils.h"

#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

#ifndef REPETITION_FACTOR
#define REPETITION_FACTOR 3
#endif

#define CODEWORD_WIDTH (DATA_WIDTH * REPETITION_FACTOR)

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

BitArray encode_repetition(const BitArray& data, int data_width, int rep_factor) {
    BitArray codeword;
    for (int i = 0; i < data_width; i++) {
        int bit = data.get_bit(i);
        for (int j = 0; j < rep_factor; j++) {
            codeword.set_bit(i * rep_factor + j, bit);
        }
    }
    return codeword;
}

void test_repetition_ecc() {
    Vrepetition_ecc* dut = new Vrepetition_ecc();

    int data_width = DATA_WIDTH;
    int rep_factor = REPETITION_FACTOR;
    int codeword_width = CODEWORD_WIDTH;

    printf("=== Repetition ECC Test (DATA_WIDTH=%d, REPETITION_FACTOR=%d, CODEWORD_WIDTH=%d) ===\n",
           data_width, rep_factor, codeword_width);

    const int NUM_TESTS = 20;
    srand(12345);

    int pass_count = 0;
    int fail_count = 0;
    int max_encode_cycles = 0;
    int max_decode_cycles = 0;

    bool strat1_pass = true;
    bool strat2_pass = true;
    bool strat3_pass = true;
    bool strat5_pass = true;
    const bool run_tie_test = (rep_factor % 2 == 0);

    for (int i = 0; i < NUM_TESTS; i++) {
        BitArray test_data;
        for (int w = 0; w < MAX_WORDS; w++) test_data.words[w] = rand() | (rand() << 16);
        for (int b = data_width; b < MAX_WORDS * 32; b++) test_data.set_bit(b, 0);

        BitArray expected_codeword = encode_repetition(test_data, data_width, rep_factor);

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

        // Case 3: single-bit error (majority corrects; detect + correct both allowed)
        BitArray single_err = expected_codeword;
        single_err.set_bit(0, !single_err.get_bit(0));
        SET_CODEWORD_IN(dut, single_err);
        CLOCK_UNTIL_VALID(dut, max_decode_cycles);

        GET_DATA_OUT(dut, dut_out);
        if (dut_out == test_data && dut->error_corrected) {
            pass_count++;
        } else {
            fail_count++;
            strat3_pass = false;
            printf("[Test %d] Case 3 failed: single-bit error not corrected\n", i);
        }

        // Case 5: even-factor tie (2-of-4), detect only, no correction
        if (run_tie_test) {
            BitArray tie_data = test_data;
            tie_data.set_bit(0, 0);
            BitArray tie_cw = encode_repetition(tie_data, data_width, rep_factor);
            tie_cw.set_bit(0, 1);
            tie_cw.set_bit(1, 1);

            SET_DATA_IN(dut, tie_data);
            SET_CODEWORD_IN(dut, tie_cw);
            CLOCK_UNTIL_VALID(dut, max_decode_cycles);

            GET_DATA_OUT(dut, dut_out);
            if (dut_out == tie_data && dut->error_detected && !dut->error_corrected) {
                pass_count++;
            } else {
                fail_count++;
                strat5_pass = false;
                printf("[Test %d] Case 5 failed: tie not reported as detect-only\n", i);
            }
        }
    }

    printf("\n");
    printf("==================================================\n");
    printf(" Repetition ECC summary (DATA_WIDTH=%d, FACTOR=%d)\n", data_width, rep_factor);
    printf("==================================================\n");
    printf(" Random vectors: %d\n", NUM_TESTS);
    printf("--------------------------------------------------\n");
    printf(" [1] Clean decode                         : %s\n", strat1_pass ? "PASS" : "FAIL");
    printf(" [2] Decoder isolation (mismatched data)  : %s\n", strat2_pass ? "PASS" : "FAIL");
    printf(" [3] Single-bit correction                : %s\n", strat3_pass ? "PASS" : "FAIL");
    if (run_tie_test) {
        printf(" [5] Tie / dead-lock (even factor)        : %s\n", strat5_pass ? "PASS" : "FAIL");
    } else {
        printf(" [5] Tie / dead-lock (even factor)        : SKIP (odd REPETITION_FACTOR)\n");
    }
    printf("--------------------------------------------------\n");
    printf(" Check outcomes: %d passed, %d failed\n", pass_count, fail_count);
    printf(" Max encode cycles observed: %d\n", max_encode_cycles);
    printf(" Max decode cycles observed: %d\n", max_decode_cycles);
    printf("==================================================\n");

    bool all_pass = strat1_pass && strat2_pass && strat3_pass && (run_tie_test ? strat5_pass : true);

    if (all_pass) {
        printf(" RESULT: PASS\n");
    } else {
        printf(" RESULT: FAIL\n");
    }
    printf("==================================================\n\n");

    delete dut;
}

int main() {
    test_repetition_ecc();
    return 0;
}
