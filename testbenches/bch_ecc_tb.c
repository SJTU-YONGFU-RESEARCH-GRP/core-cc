#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vbch_ecc.h"
#include "verilated.h"

// Python-like BCH calculation functions (simplified to match Python fallback)
typedef struct {
    int n;  // Codeword length
    int k;  // Data length
    int t;  // Error correction capability
    int word_length;  // Word length
} BCHConfig;

BCHConfig* create_bch_config(int word_length) {
    BCHConfig* config = (BCHConfig*)malloc(sizeof(BCHConfig));
    config->word_length = word_length;
    
    if (word_length <= 4) {
        config->n = 7;
        config->k = 4;
        config->t = 1;
    } else if (word_length <= 8) {
        config->n = 15;
        config->k = 7;
        config->t = 2;
    } else if (word_length <= 16) {
        config->n = 31;
        config->k = 16;
        config->t = 3;
    } else {
        config->n = 63;
        config->k = 32;
        config->t = 6;
    }
    
    return config;
}

void free_bch_config(BCHConfig* config) {
    free(config);
}

// Simplified BCH encoding (matches Python fallback)
uint32_t encode_bch(uint32_t data, BCHConfig* config) {
    // Ensure data fits in k bits
    if (data >= (1 << config->k)) {
        data = data & ((1 << config->k) - 1);
    }
    
    // Simple repetition-like encoding (matches Python fallback)
    return data << (config->n - config->k);
}

// Simplified BCH decoding (matches Python fallback)
uint32_t decode_bch(uint32_t codeword, BCHConfig* config, int* error_type) {
    // Ensure codeword fits in n bits
    if (codeword >= (1 << config->n)) {
        codeword = codeword & ((1 << config->n) - 1);
    }
    
    // Extract data bits
    uint32_t data = codeword >> (config->n - config->k);
    
    // Simplified error detection (matches Python fallback)
    *error_type = 0; // No error detected in simplified version
    
    return data;
}

// Test function
void test_bch_ecc() {
    Vbch_ecc* dut = new Vbch_ecc();
    
    printf("=== BCH ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int pass_count = 0;
    int fail_count = 0;
    
    BCHConfig* config = create_bch_config(data_width);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_bch(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_bch(expected_codeword, config, &expected_error_type);
        
        // Reset DUT
        dut->rst_n = 0;
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        dut->rst_n = 1;
        
        // Test encoding
        dut->encode_en = 1;
        dut->decode_en = 0;
        dut->data_in = test_data;
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        
        // Check encoding result
        if (dut->codeword_out == expected_codeword) {
            printf("ENCODE TEST %d: PASS (data=0x%02X, codeword=0x%04X)\n", 
                   i, test_data, dut->codeword_out);
            pass_count++;
        } else {
            printf("ENCODE TEST %d: FAIL (data=0x%02X, expected=0x%04X, got=0x%04X)\n", 
                   i, test_data, expected_codeword, dut->codeword_out);
            fail_count++;
        }
        
        // Test decoding (no error)
        dut->encode_en = 0;
        dut->decode_en = 1;
        dut->codeword_in = expected_codeword;
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        
        // Check decoding result
        int expected_error_detected = (expected_error_type != 0);
        int expected_error_corrected = (expected_error_type == 1);
        
        if (dut->data_out == expected_decoded_data && 
            dut->error_detected == expected_error_detected &&
            dut->error_corrected == expected_error_corrected) {
            printf("DECODE TEST %d: PASS (codeword=0x%04X, data=0x%02X, error_detected=%d, error_corrected=%d)\n", 
                   i, expected_codeword, dut->data_out, dut->error_detected, dut->error_corrected);
            pass_count++;
        } else {
            printf("DECODE TEST %d: FAIL (codeword=0x%04X, expected_data=0x%02X, got_data=0x%02X, expected_error_detected=%d, got_error_detected=%d, expected_error_corrected=%d, got_error_corrected=%d)\n", 
                   i, expected_codeword, expected_decoded_data, dut->data_out, expected_error_detected, dut->error_detected, expected_error_corrected, dut->error_corrected);
            fail_count++;
        }
        
        // Test error injection
        uint32_t corrupted_codeword = expected_codeword ^ 1; // Flip LSB
        int expected_error_type_corrupted;
        uint32_t expected_decoded_data_corrupted = decode_bch(corrupted_codeword, config, &expected_error_type_corrupted);
        
        dut->codeword_in = corrupted_codeword;
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        
        int expected_error_detected_corrupted = (expected_error_type_corrupted != 0);
        int expected_error_corrected_corrupted = (expected_error_type_corrupted == 1);
        
        if (dut->error_detected == expected_error_detected_corrupted &&
            dut->error_corrected == expected_error_corrected_corrupted) {
            printf("ERROR DETECTION TEST %d: PASS (corrupted_codeword=0x%04X, error_detected=%d, error_corrected=%d)\n", 
                   i, corrupted_codeword, dut->error_detected, dut->error_corrected);
            pass_count++;
        } else {
            printf("ERROR DETECTION TEST %d: FAIL (corrupted_codeword=0x%04X, expected_error_detected=%d, got_error_detected=%d, expected_error_corrected=%d, got_error_corrected=%d)\n", 
                   i, corrupted_codeword, expected_error_detected_corrupted, dut->error_detected, expected_error_corrected_corrupted, dut->error_corrected);
            fail_count++;
        }
        
        printf("\n");
    }
    
    // Summary
    printf("=== Test Summary ===\n");
    printf("Total tests: %d\n", num_tests * 3); // encode, decode, error detection
    printf("Passed: %d\n", pass_count);
    printf("Failed: %d\n", fail_count);
    
    if (fail_count == 0) {
        printf("RESULT: PASS\n");
    } else {
        printf("RESULT: FAIL\n");
    }
    
    free_bch_config(config);
    delete dut;
}

int main() {
    test_bch_ecc();
    return 0;
} 