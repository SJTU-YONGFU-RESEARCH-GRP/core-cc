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

// Auto-detect DATA_WIDTH from the DUT
#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

// Helper macros for wide port access
#if DATA_WIDTH > 64
    #define SET_DATA_IN(dut, val) SET_WIDE_PORT(dut, data_in, val, DATA_WIDTH)
    
    // Parity ECC: codeword is DATA_WIDTH + 1
    #define SET_CODEWORD_IN(dut, val) SET_WIDE_PORT(dut, codeword_in, val, DATA_WIDTH+1)
        
    #define GET_CODEWORD_OUT(dut, val) GET_WIDE_PORT(dut, codeword_out, val, DATA_WIDTH+1)

    #define GET_DATA_OUT(dut, val) GET_WIDE_PORT(dut, data_out, val, DATA_WIDTH)
#else
    #define SET_DATA_IN(dut, val) (dut)->data_in = to_u64(val)
    #define GET_DATA_OUT(dut, val) (val) = from_u64((dut)->data_out)
    
    // Check codeword width for simple scalar vs wide
    #if DATA_WIDTH >= 64
        // 64+1 = 65 bits -> WData
        #define SET_CODEWORD_IN(dut, val) SET_WIDE_PORT(dut, codeword_in, val, DATA_WIDTH+1)
        #define GET_CODEWORD_OUT(dut, val) GET_WIDE_PORT(dut, codeword_out, val, DATA_WIDTH+1)
    #else
        #define SET_CODEWORD_IN(dut, val) (dut)->codeword_in = to_u64(val)
        #define GET_CODEWORD_OUT(dut, val) (val) = from_u64((dut)->codeword_out)
    #endif
#endif

// Python-like parity calculation functions
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
    // Parity bit at position 0 (shared convention, check Verilog)
    // Verilog: assign codeword_out = {data_in, expected_parity}; -> Parity at LSB (idx 0)
    codeword.set_bit(0, parity);
    for(int i=0; i<data_width; i++) {
        codeword.set_bit(i+1, data.get_bit(i));
    }
    return codeword;
}

BitArray decode_parity(const BitArray& codeword, int data_width, int* error_detected) {
    BitArray data;
    int parity_bit = codeword.get_bit(0);
    for(int i=0; i<data_width; i++) {
        data.set_bit(i, codeword.get_bit(i+1));
    }
    
    int expected_parity = calculate_parity(data, data_width);
    *error_detected = (parity_bit != expected_parity);
    return data;
}

// Test function
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
    
    for (int i = 0; i < NUM_TESTS; i++) {
        BitArray test_data;
        for(int w=0; w<MAX_WORDS; w++) test_data.words[w] = rand() | (rand()<<16);
        // Mask unused
        for(int b=data_width; b<MAX_WORDS*32; b++) test_data.set_bit(b, 0);
        
        BitArray expected_codeword = encode_parity(test_data, data_width);
        int expected_error_detected; // dummy for encode check
        
        // Reset DUT
        dut->rst_n = 0; dut->eval();
        dut->rst_n = 1; dut->eval();
        
        // Test Encode
        dut->encode_en = 1; dut->decode_en = 0;
        SET_DATA_IN(dut, test_data);
        int encode_cycles = 0;
        do {
            dut->clk = 0; dut->eval();
            dut->clk = 1; dut->eval();
            encode_cycles++;
        } while (!dut->valid_out && encode_cycles < 100);
        if (encode_cycles > max_encode_cycles) max_encode_cycles = encode_cycles;
        
        BitArray dut_cw;
        GET_CODEWORD_OUT(dut, dut_cw);
        
        if (dut_cw == expected_codeword) {
            pass_count++;
        } else {
            printf("ENCODE FAIL Test %d\n", i);
            fail_count++;
        }
        
        // Test Decode
        dut->encode_en = 0; dut->decode_en = 1;
        SET_CODEWORD_IN(dut, expected_codeword);
        int decode_cycles = 0;
        do {
            dut->clk = 0; dut->eval();
            dut->clk = 1; dut->eval();
            decode_cycles++;
        } while (!dut->valid_out && decode_cycles < 100);
        if (decode_cycles > max_decode_cycles) max_decode_cycles = decode_cycles;
        
        BitArray dut_out;
        GET_DATA_OUT(dut, dut_out);
        
        if (dut_out == test_data && !dut->error_detected) {
            pass_count++;
        } else {
            printf("DECODE FAIL Test %d\n", i);
            fail_count++;
        }
        
        // Test Error
        BitArray corrupted = expected_codeword;
        corrupted.set_bit(0, !corrupted.get_bit(0)); // Flip parity bit (LSB)
        
        SET_CODEWORD_IN(dut, corrupted);
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        
        if (dut->error_detected) {
            pass_count++;
        } else {
            printf("ERROR DETECTION FAIL Test %d\n", i);
            fail_count++;
        }
    }
    
    printf("Passed: %d, Failed: %d\n", pass_count, fail_count);
    if (fail_count == 0) printf("RESULT: PASS\n");
    else printf("RESULT: FAIL\n");
    printf("ENCODE_CYCLES=%d\n", max_encode_cycles);
    printf("DECODE_CYCLES=%d\n", max_decode_cycles);
    
    delete dut;
}

int main() {
    test_parity_ecc();
    return 0;
}