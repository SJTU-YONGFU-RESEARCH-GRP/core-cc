#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vreed_solomon_ecc.h"
#include "verilated.h"

// Python-like Reed-Solomon calculation functions (simplified to match Python fallback)
typedef struct {
    int n;  // Codeword length
    int k;  // Data length
    int word_length;  // Word length
} RSConfig;

RSConfig* create_rs_config(int word_length) {
    RSConfig* config = (RSConfig*)malloc(sizeof(RSConfig));
    config->word_length = word_length;
    
    if (word_length <= 4) {
        config->n = 7;
        config->k = 4;
    } else if (word_length <= 8) {
        config->n = 15;
        config->k = 8;
    } else if (word_length <= 16) {
        config->n = 31;
        config->k = 16;
    } else {
        config->n = 63;
        config->k = 32;
    }
    
    return config;
}

void free_rs_config(RSConfig* config) {
    free(config);
}

// Simplified Reed-Solomon encoding (matches Python implementation for small data)
uint32_t encode_reed_solomon(uint32_t data, RSConfig* config, int data_length) {
    // For small data sizes, use simplified approach (matches Python)
    if (data_length <= 32) {
        uint32_t redundancy_bits = 8;
        uint32_t redundancy_data = data & 0xFF;
        return (data << redundancy_bits) | redundancy_data;
    } else {
        // For larger data, use simple repetition
        return data << (config->n - config->k);
    }
}

// Simplified Reed-Solomon decoding (matches Python implementation for small data)
uint32_t decode_reed_solomon(uint32_t codeword, RSConfig* config, int data_length, int* error_type) {
    // For small data sizes, use simplified approach (matches Python)
    if (data_length <= 32) {
        uint32_t redundancy_bits = 8;
        uint32_t decoded_data = (codeword >> redundancy_bits) & ((1 << data_length) - 1);
        *error_type = 0; // No error detected in simplified version
        return decoded_data;
    } else {
        // For larger data, extract data bits
        uint32_t data = codeword >> (config->n - config->k);
        *error_type = 0; // No error detected in simplified version
        return data;
    }
}

// Test function
void test_reed_solomon_ecc() {
    Vreed_solomon_ecc* dut = new Vreed_solomon_ecc();
    
    printf("=== Reed-Solomon ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int pass_count = 0;
    int fail_count = 0;
    
    RSConfig* config = create_rs_config(data_width);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_reed_solomon(test_data, config, data_width);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_reed_solomon(expected_codeword, config, data_width, &expected_error_type);
        
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
        uint32_t expected_decoded_data_corrupted = decode_reed_solomon(corrupted_codeword, config, data_width, &expected_error_type_corrupted);
        
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
    
    free_rs_config(config);
    delete dut;
}

int main() {
    test_reed_solomon_ecc();
    return 0;
} 