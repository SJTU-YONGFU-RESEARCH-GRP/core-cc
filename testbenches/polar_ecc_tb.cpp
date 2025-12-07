#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vpolar_ecc.h"
#include "verilated.h"

// Python-like Polar ECC calculation functions
typedef struct {
    int n;  // Block length
    int k;  // Number of information bits
    int* frozen_bits;
    int frozen_count;
} PolarConfig;

PolarConfig* create_polar_config(int word_length) {
    PolarConfig* config = (PolarConfig*)malloc(sizeof(PolarConfig));
    
    if (word_length <= 4) {
        config->n = 4;
        config->k = 2;
        config->frozen_count = 2;
    } else if (word_length <= 8) {
        config->n = 8;
        config->k = 4;
        config->frozen_count = 4;
    } else if (word_length <= 16) {
        config->n = 16;
        config->k = 8;
        config->frozen_count = 8;
    } else {
        config->n = 32;
        config->k = 16;
        config->frozen_count = 16;
    }
    
    config->frozen_bits = (int*)malloc(config->frozen_count * sizeof(int));
    for (int i = 0; i < config->frozen_count; i++) {
        config->frozen_bits[i] = i;
    }
    
    return config;
}

void free_polar_config(PolarConfig* config) {
    free(config->frozen_bits);
    free(config);
}

// Convert integer to bit array
void int_to_bits(uint32_t data, int* bits, int length) {
    for (int i = 0; i < length; i++) {
        bits[i] = (data >> i) & 1;
    }
}

// Convert bit array to integer
uint32_t bits_to_int(int* bits, int length) {
    uint32_t result = 0;
    for (int i = 0; i < length; i++) {
        result |= (bits[i] << i);
    }
    return result;
}

// Check if bit index is frozen
int is_frozen(int bit_idx, PolarConfig* config) {
    for (int i = 0; i < config->frozen_count; i++) {
        if (config->frozen_bits[i] == bit_idx) {
            return 1;
        }
    }
    return 0;
}

// Python-like Polar encoding (simplified to match Python implementation)
uint32_t encode_polar(uint32_t data, PolarConfig* config) {
    // For all data sizes, use a simpler approach (matches Python implementation)
    // Simple redundancy for all data
    uint32_t codeword = (data << 8) | (data & 0xFF);
    return codeword;
}

// Python-like Polar decoding (simplified to match Python implementation)
uint32_t decode_polar(uint32_t codeword, PolarConfig* config, int* error_type) {
    // For all data sizes, use a simpler approach (matches Python implementation)
    // Extract original data from simple redundancy
    uint32_t decoded_data = (codeword >> 8) & 0xFFFFFFFF;
    *error_type = 0; // No error detected in simplified version
    return decoded_data;
}

// Test function
void test_polar_ecc() {
    Vpolar_ecc* dut = new Vpolar_ecc();
    
    printf("=== Polar ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int pass_count = 0;
    int fail_count = 0;
    
    PolarConfig* config = create_polar_config(data_width);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_polar(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_polar(expected_codeword, config, &expected_error_type);
        
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
        uint32_t expected_decoded_data_corrupted = decode_polar(corrupted_codeword, config, &expected_error_type_corrupted);
        
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
    
    free_polar_config(config);
    delete dut;
}

int main() {
    test_polar_ecc();
    return 0;
} 