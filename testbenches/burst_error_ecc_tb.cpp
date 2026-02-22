#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <time.h>

// Verilator generated header
#include "Vburst_error_ecc.h"
#include "verilated.h"
#include "ecc_test_utils.h"

#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

// Port Access Logic

#if DATA_WIDTH > 64
    #define SET_DATA_IN(dut, val) SET_WIDE_PORT(dut, data_in, val, DATA_WIDTH)
    #define GET_DATA_OUT(dut, val) GET_WIDE_PORT(dut, data_out, val, DATA_WIDTH)
    
    // Use sizeof to detect width for codeword
    #define SET_CODEWORD_IN(dut, val) \
        do { \
            int nwords = sizeof((dut)->codeword_in) / sizeof(uint32_t); \
            for(int w=0; w<nwords && w<MAX_WORDS; w++) \
                (dut)->codeword_in[w] = (val).words[w]; \
        } while(0)
        
    #define GET_CODEWORD_OUT(dut, val) \
        do { \
            (val).clear(); \
            int nwords = sizeof((dut)->codeword_out) / sizeof(uint32_t); \
            for(int w=0; w<nwords && w<MAX_WORDS; w++) \
                (val).words[w] = (dut)->codeword_out[w]; \
        } while(0)
#else
    #define SET_DATA_IN(dut, val) (dut)->data_in = to_u64(val)
    #define GET_DATA_OUT(dut, val) (val) = from_u64((dut)->data_out)
    
    // For Codeword, if > 64 bits (e.g. Rate 1/3), Verilator uses wide.
    // If <= 64, scalar.
    // We can use a template or overload to distinguish? 
    // Or just #if DATA_WIDTH logic. 
    // Just use 3x logic if unknown.
    // But this is generic "param".
    
    // Simplest: Check DATA_WIDTH. If high enough, assume wide. 
    // But sizeof trick doesn't work well if scalar (member is uint64_t). sizeof=8. nwords=2.
    // If we access [0] on uint64_t, it fails compilation.
    
    // Fallback: Use #if.
    // If DATA <= 32: assume scalar for most?
    // If DATA=32, CW=64 or 96?
    // Let's assume for PROTOTYPING/MOCKING, if DATA <= 16, everything scalar. 
    // If DATA >= 32, we check known multipliers?
    
    // Actually, "Safe Large Loop" is mostly needed for writing.
    // Writing 16 words to a 3-word array is bad.
    // Writing 2 words to 1 scalar is ... compilation error (array access).
    
    // Let's rely on specific multipliers for known modules.
    // For generic "param", we assume CODEWORD ~ DATA.
    // If DATA <= 32, assume scalar.
    // If DATA >= 64, assume wide.
    
    #if DATA_WIDTH >= 64
        #define SET_CODEWORD_IN(dut, val) \
            do { \
                int nwords = sizeof((dut)->codeword_in) / sizeof(uint32_t); \
                for(int w=0; w<nwords && w<MAX_WORDS; w++) (dut)->codeword_in[w] = (val).words[w]; \
            } while(0)
        #define GET_CODEWORD_OUT(dut, val) \
             do { \
                (val).clear(); \
                int nwords = sizeof((dut)->codeword_out) / sizeof(uint32_t); \
                for(int w=0; w<nwords && w<MAX_WORDS; w++) (val).words[w] = (dut)->codeword_out[w]; \
            } while(0)
    #else
        #define SET_CODEWORD_IN(dut, val) (dut)->codeword_in = to_u64(val)
        #define GET_CODEWORD_OUT(dut, val) (val) = from_u64((dut)->codeword_out)
    #endif
#endif


void test_burst_error_ecc() {
    Vburst_error_ecc* dut = new Vburst_error_ecc();
    
    printf("=== burst_error_ecc Test (DATA_WIDTH=%d) ===\n", DATA_WIDTH);
    
    const int NUM_TESTS = 20;
    srand(12345);
    int pass_count = 0;
    int fail_count = 0;
    
    for (int i = 0; i < NUM_TESTS; i++) {
        BitArray test_data;
        for(int w=0; w<MAX_WORDS; w++) test_data.words[w] = rand() | (rand()<<16);
        for(int b=DATA_WIDTH; b<MAX_WORDS*32; b++) test_data.set_bit(b, 0);
        
        // Reset
        dut->rst_n = 0; dut->eval();
        dut->rst_n = 1; dut->eval();
        
        // Encode
        dut->encode_en = 1; dut->decode_en = 0;
        SET_DATA_IN(dut, test_data);
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        
        BitArray encoded_cw;
        GET_CODEWORD_OUT(dut, encoded_cw);
        
        // Feed back
        dut->encode_en = 0; dut->decode_en = 1;
        SET_CODEWORD_IN(dut, encoded_cw);
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        
        BitArray decoded_data;
        GET_DATA_OUT(dut, decoded_data);
        
        // Verify Loopback
        // Mocks usually copy data[DATA_WIDTH-1:0] out. 
        // If data matches, valid.
        
        if (decoded_data == test_data) {
            pass_count++;
        } else {
            // printf("FAIL Test %d\n", i);
            fail_count++;
        }
    }
    
    printf("Passed: %d, Failed: %d\n", pass_count, fail_count);
    if (fail_count == 0) printf("RESULT: PASS\n");
    else printf("RESULT: FAIL\n");
    
    delete dut;
}

int main() {
    test_burst_error_ecc();
    return 0;
}
