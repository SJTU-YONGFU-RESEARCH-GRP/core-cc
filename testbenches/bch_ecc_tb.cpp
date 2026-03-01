#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <time.h>

// Verilator generated header
#include "Vbch_ecc.h"
#include "verilated.h"
#include "ecc_test_utils.h"

#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

// Port Access Logic

// Fixed Wide Ports (Always Wide)
#if DATA_WIDTH > 64
    #define SET_DATA_IN(dut, val) SET_WIDE_PORT(dut, data_in, val, DATA_WIDTH)
    #define GET_DATA_OUT(dut, val) GET_WIDE_PORT(dut, data_out, val, DATA_WIDTH)
#else
    #define SET_DATA_IN(dut, val) (dut)->data_in = to_u64(val)
    #define GET_DATA_OUT(dut, val) (val) = from_u64((dut)->data_out)
#endif

// Codeword is ALWAYS wide. Use sizeof trick safe.
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


void test_bch_ecc() {
    Vbch_ecc* dut = new Vbch_ecc();
    
    printf("=== bch_ecc Test (DATA_WIDTH=%d) ===\n", DATA_WIDTH);
    
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
        
        BitArray encoded_cw;
        GET_CODEWORD_OUT(dut, encoded_cw);
        
        // Feed back
        dut->encode_en = 0; dut->decode_en = 1;
        SET_CODEWORD_IN(dut, encoded_cw);
        int decode_cycles = 0;
        do {
            dut->clk = 0; dut->eval();
            dut->clk = 1; dut->eval();
            decode_cycles++;
        } while (!dut->valid_out && decode_cycles < 100);
        if (decode_cycles > max_decode_cycles) max_decode_cycles = decode_cycles;
        
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
    printf("ENCODE_CYCLES=%d\n", max_encode_cycles);
    printf("DECODE_CYCLES=%d\n", max_decode_cycles);
    
    delete dut;
}

int main() {
    test_bch_ecc();
    return 0;
}
