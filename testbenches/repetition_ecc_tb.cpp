#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <time.h>

// Verilator generated header
#include "Vrepetition_ecc.h"
#include "verilated.h"
#include "ecc_test_utils.h"

// Auto-detect DATA_WIDTH from the DUT
#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

// Repetition Factor default to 3 if not specified (Verilog default)
#ifndef REPETITION_FACTOR
#define REPETITION_FACTOR 3
#endif

// Helper macros for wide port access
#if DATA_WIDTH > 64
    #define SET_DATA_IN(dut, val) SET_WIDE_PORT(dut, data_in, val, DATA_WIDTH)
    
    #define GET_DATA_OUT(dut, val) GET_WIDE_PORT(dut, data_out, val, DATA_WIDTH)
        
    // Codeword is DATA*Factor. 128*3 = 384. Definitely wide.
    #define SET_CODEWORD_IN(dut, val) SET_WIDE_PORT(dut, codeword_in, val, DATA_WIDTH*REPETITION_FACTOR)

    #define GET_CODEWORD_OUT(dut, val) GET_WIDE_PORT(dut, codeword_out, val, DATA_WIDTH*REPETITION_FACTOR)
#else
    #define SET_DATA_IN(dut, val) (dut)->data_in = to_u64(val)
    #define GET_DATA_OUT(dut, val) (val) = from_u64((dut)->data_out)
    
    // Check codeword width for simple scalar vs wide
    #if (DATA_WIDTH * REPETITION_FACTOR) > 64
        #define SET_CODEWORD_IN(dut, val) SET_WIDE_PORT(dut, codeword_in, val, DATA_WIDTH*REPETITION_FACTOR)
        #define GET_CODEWORD_OUT(dut, val) GET_WIDE_PORT(dut, codeword_out, val, DATA_WIDTH*REPETITION_FACTOR)
    #else
        #define SET_CODEWORD_IN(dut, val) (dut)->codeword_in = to_u64(val)
        #define GET_CODEWORD_OUT(dut, val) (val) = from_u64((dut)->codeword_out)
    #endif
#endif

// Python-like repetition logic
BitArray encode_repetition(const BitArray& data, int data_width, int rep_factor) {
    BitArray codeword;
    for(int i=0; i<data_width; i++) {
        int bit = data.get_bit(i);
        for(int j=0; j<rep_factor; j++) {
            codeword.set_bit(i*rep_factor + j, bit);
        }
    }
    return codeword;
}

BitArray decode_repetition(const BitArray& codeword, int data_width, int rep_factor, int* error_type) {
    BitArray data;
    int error_corrected = 0;
    
    for(int i=0; i<data_width; i++) {
        int ones = 0;
        for(int j=0; j<rep_factor; j++) {
            if (codeword.get_bit(i*rep_factor + j)) ones++;
        }
        
        // Majority vote
        int decoded_bit = (ones > rep_factor/2) ? 1 : 0;
        data.set_bit(i, decoded_bit);
        
        // Check correction
        if (decoded_bit == 1 && ones != rep_factor) error_corrected = 1;
        if (decoded_bit == 0 && ones != 0) error_corrected = 1;
    }
    
    // Re-verify against assumption
    // Simple logic: if input != encoded(output), then corrected (or detected)
    BitArray re_encoded = encode_repetition(data, data_width, rep_factor);
    if (re_encoded != codeword) {
        *error_type = 1; // corrected
    } else {
        *error_type = 0;
    }
    
    return data;
}

void test_repetition_ecc() {
    Vrepetition_ecc* dut = new Vrepetition_ecc();
    
    int data_width = DATA_WIDTH;
    int rep_factor = REPETITION_FACTOR;
    
    printf("=== Repetition ECC Test (DATA_WIDTH=%d, FACTOR=%d) ===\n", data_width, rep_factor);
    
    const int NUM_TESTS = 20;
    srand(12345);
    int pass_count = 0;
    int fail_count = 0;
    
    for (int i = 0; i < NUM_TESTS; i++) {
        BitArray test_data;
        for(int w=0; w<MAX_WORDS; w++) test_data.words[w] = rand() | (rand()<<16);
        for(int b=data_width; b<MAX_WORDS*32; b++) test_data.set_bit(b, 0);
        
        BitArray expected_codeword = encode_repetition(test_data, data_width, rep_factor);
        
        // Reset
        dut->rst_n = 0; dut->eval();
        dut->rst_n = 1; dut->eval();
        
        // Encode
        dut->encode_en = 1; dut->decode_en = 0;
        SET_DATA_IN(dut, test_data);
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        
        BitArray dut_cw;
        GET_CODEWORD_OUT(dut, dut_cw);
        
        if (dut_cw == expected_codeword) {
            pass_count++;
        } else {
            printf("ENCODE FAIL Test %d\n", i);
            fail_count++;
        }
        
        // Decode
        dut->encode_en = 0; dut->decode_en = 1;
        SET_CODEWORD_IN(dut, expected_codeword);
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        
        BitArray dut_out;
        GET_DATA_OUT(dut, dut_out);
        
        if (dut_out == test_data && !dut->error_detected) {
            pass_count++;
        } else {
            printf("DECODE FAIL Test %d\n", i);
            fail_count++;
        }
        
        // Error Correction (Flip 1 bit in first block)
        BitArray corrupted = expected_codeword;
        corrupted.set_bit(0, !corrupted.get_bit(0)); // Flip bit 0
        
        SET_CODEWORD_IN(dut, corrupted);
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        
        GET_DATA_OUT(dut, dut_out);
        
        // Error should be corrected (majority 2vs1)
        if (dut_out == test_data && dut->error_corrected) {
            pass_count++;
        } else {
            printf("CORRECTION FAIL Test %d\n", i);
            fail_count++;
        }
    }
    
    printf("Passed: %d, Failed: %d\n", pass_count, fail_count);
    if (fail_count == 0) printf("RESULT: PASS\n");
    else printf("RESULT: FAIL\n");
    
    delete dut;
}

int main() {
    test_repetition_ecc();
    return 0;
}