#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <time.h>

// Verilator generated header
#include "Vsystem_ecc.h"
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


void test_system_ecc() {
    Vsystem_ecc* dut = new Vsystem_ecc();
    
    printf("=== system_ecc Test (DATA_WIDTH=%d) ===\n", DATA_WIDTH);
    
    const int NUM_TESTS = 20;
    srand(12345);
    int pass_count = 0;
    int fail_count = 0;
    int max_encode_cycles = 0;
    int max_decode_cycles = 0;
    
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
        int encode_cycles = 0;
        do {
            dut->clk = 0; dut->eval();
            dut->clk = 1; dut->eval();
            encode_cycles++;
        } while (!dut->valid_out && encode_cycles < 100);
        if (encode_cycles > max_encode_cycles) max_encode_cycles = encode_cycles;
        // Wait for valid (Latency might be > 1 due to wrapper)
        int timeout = 100;
        int match_wait = 0;
        while (!dut->valid_out && timeout-- > 0) {
            dut->clk = 0; dut->eval();
            dut->clk = 1; dut->eval();
            match_wait++;
        }
        
        if (i < 5) {
             printf("Test %d: Waited %d cycles for valid. valid=%d\n", i, match_wait, dut->valid_out);
             // Removed direct codeword access to avoid scalar/wide compilation issues
        }
        
        BitArray encoded_cw;
        GET_CODEWORD_OUT(dut, encoded_cw);
        
        // Feed back
        // GAP to clear valid_out (Pipeline depth requires > 2 cycles)
        dut->encode_en = 0; dut->decode_en = 0;
        for(int gap=0; gap<5; gap++) {
            dut->clk = 0; dut->eval(); 
            dut->clk = 1; dut->eval();
        }

        dut->encode_en = 0; dut->decode_en = 1;
        SET_CODEWORD_IN(dut, encoded_cw);
        int decode_cycles = 0;
        do {
            dut->clk = 0; dut->eval();
            dut->clk = 1; dut->eval();
            decode_cycles++;
        } while (!dut->valid_out && decode_cycles < 100);
        if (decode_cycles > max_decode_cycles) max_decode_cycles = decode_cycles;
        
        // Wait for valid (Decode)
        int timeout_dec = 100;
        while (!dut->valid_out && timeout_dec-- > 0) {
            dut->clk = 0; dut->eval();
            dut->clk = 1; dut->eval();
        }
        
        BitArray decoded_data;
        GET_DATA_OUT(dut, decoded_data);
        
        // Verify Loopback
        // Mocks usually copy data[DATA_WIDTH-1:0] out. 
        // If data matches, valid.
        
        if (decoded_data == test_data) {
            pass_count++;
        } else {
             if (fail_count < 5) {
                 printf("FAIL Test %d\n", i);
                 printf("  Data: 0x%lx\n", (unsigned long)test_data.words[0]);
                 printf("  Decoded: 0x%lx\n", (unsigned long)decoded_data.words[0]);
                 printf("  Valid: %d\n", dut->valid_out);
             }
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
    test_system_ecc();
    return 0;
}
