#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <time.h>

// Verilator generated header
#include "Vcrc_ecc.h"
#include "verilated.h"
#include "ecc_test_utils.h"

// Auto-detect DATA_WIDTH from the DUT
#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

// Helper macros for wide port access
#if DATA_WIDTH > 64
    #define SET_DATA_IN(dut, val) SET_WIDE_PORT(dut, data_in, val, DATA_WIDTH)
    
    #define GET_DATA_OUT(dut, val) GET_WIDE_PORT(dut, data_out, val, DATA_WIDTH)
        
    // CRC usually adds nearly constant overhead (e.g. 8 bits).
    #define SET_CODEWORD_IN(dut, val) SET_WIDE_PORT(dut, codeword_in, val, DATA_WIDTH+8)

    #define GET_CODEWORD_OUT(dut, val) GET_WIDE_PORT(dut, codeword_out, val, DATA_WIDTH+8)
#else
    #define SET_DATA_IN(dut, val) (dut)->data_in = to_u64(val)
    #define GET_DATA_OUT(dut, val) (val) = from_u64((dut)->data_out)
    
    // Check codeword width. CRC-8 adds 8 bits.
    #if (DATA_WIDTH + 8) > 64
        #define SET_CODEWORD_IN(dut, val) SET_WIDE_PORT(dut, codeword_in, val, DATA_WIDTH+8)
        #define GET_CODEWORD_OUT(dut, val) GET_WIDE_PORT(dut, codeword_out, val, DATA_WIDTH+8)
    #else
        #define SET_CODEWORD_IN(dut, val) (dut)->codeword_in = to_u64(val)
        #define GET_CODEWORD_OUT(dut, val) (val) = from_u64((dut)->codeword_out)
    #endif
#endif

// Python-like CRC ECC calculation functions
typedef struct {
    int polynomial;
    int data_length;
    int crc_bits;
} CRCConfig;

CRCConfig* create_crc_config(int data_length, int polynomial) {
    CRCConfig* config = (CRCConfig*)malloc(sizeof(CRCConfig));
    config->polynomial = polynomial;
    config->data_length = data_length;
    config->crc_bits = 8; // CRC-8 uses 8 bits
    return config;
}

void free_crc_config(CRCConfig* config) {
    free(config);
}

// Compute CRC using BitArray
// Matches Python:
// crc = 0; for d in data_bits: crc ^= (d << 7); for _ in range(8): if crc & 0x80: crc = (crc<<1)^poly else: crc << 1
uint8_t compute_crc(const BitArray& data, CRCConfig* config) {
    uint8_t crc = 0x00;
    
    for (int i = 0; i < config->data_length; i++) {
        int bit = data.get_bit(i);
        crc ^= (bit << 7);
        for (int j = 0; j < 8; j++) {
            if (crc & 0x80) {
                crc = ((crc << 1) ^ config->polynomial);
            } else {
                crc = (crc << 1);
            }
        }
    }
    return crc;
}

BitArray encode_crc(const BitArray& data, CRCConfig* config) {
    uint8_t crc = compute_crc(data, config);
    BitArray codeword;
    
    // Data first
    for(int i=0; i<config->data_length; i++) {
        codeword.set_bit(i, data.get_bit(i));
    }
    // CRC appended (LSB of CRC at data_length?)
    // Python: codeword = data + crc
    // In Python list: [d0, d1, ... dn, c0, c1... c7]
    for(int i=0; i<config->crc_bits; i++) {
        codeword.set_bit(config->data_length + i, (crc >> i) & 1);
    }
    return codeword;
}

BitArray decode_crc(const BitArray& codeword, CRCConfig* config, int* error_type) {
    // Extract data
    BitArray data;
    for(int i=0; i<config->data_length; i++) {
        data.set_bit(i, codeword.get_bit(i));
    }
    
    // Extract CRC
    uint8_t received_crc = 0;
    for(int i=0; i<config->crc_bits; i++) {
        if (codeword.get_bit(config->data_length + i)) received_crc |= (1<<i);
    }
    
    // Recompute
    uint8_t computed_crc = compute_crc(data, config);
    
    if (computed_crc != received_crc) {
        *error_type = 1; // Detected
    } else {
        *error_type = 0;
    }
    
    return data; // CRC does not correct
}

void test_crc_ecc() {
    Vcrc_ecc* dut = new Vcrc_ecc();
    
    int data_width = DATA_WIDTH;
    printf("=== CRC ECC Test (DATA_WIDTH=%d) ===\n", data_width);
    
    CRCConfig* config = create_crc_config(data_width, 0x07); // CRC-8
    
    const int NUM_TESTS = 20;
    srand(12345);
    int pass_count = 0;
    int fail_count = 0;
    int max_encode_cycles = 0;
    int max_decode_cycles = 0;
    
    for (int i = 0; i < NUM_TESTS; i++) {
        BitArray test_data;
        for(int w=0; w<MAX_WORDS; w++) test_data.words[w] = rand() | (rand()<<16);
        for(int b=data_width; b<MAX_WORDS*32; b++) test_data.set_bit(b, 0);
        
        BitArray expected_codeword = encode_crc(test_data, config);
        
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
        
        // Error Detection
        BitArray corrupted = expected_codeword;
        corrupted.set_bit(0, !corrupted.get_bit(0)); // Flip bit 0
        
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
    
    free_crc_config(config);
    delete dut;
}

int main() {
    test_crc_ecc();
    return 0;
}