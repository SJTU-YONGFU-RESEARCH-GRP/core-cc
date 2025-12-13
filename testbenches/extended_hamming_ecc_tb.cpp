#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vextended_hamming_ecc.h"
#include "verilated.h"

// Python-like Extended Hamming calculation functions
typedef struct {
    int n;  // Codeword length
    int k;  // Data length
    int* parity_positions;
    int* data_positions;
    int parity_count;
    int data_count;
    int extended_parity_position;
} ExtendedHammingConfig;

ExtendedHammingConfig* create_extended_hamming_config(int word_length) {
    ExtendedHammingConfig* config = (ExtendedHammingConfig*)malloc(sizeof(ExtendedHammingConfig));
    
    if (word_length <= 4) {
        config->n = 8;
        config->k = 4;
        config->parity_count = 3;
        config->data_count = 4;
        config->extended_parity_position = 7;
        
        config->parity_positions = (int*)malloc(3 * sizeof(int));
        config->parity_positions[0] = 0;
        config->parity_positions[1] = 1;
        config->parity_positions[2] = 3;
        
        config->data_positions = (int*)malloc(4 * sizeof(int));
        config->data_positions[0] = 2;
        config->data_positions[1] = 4;
        config->data_positions[2] = 5;
        config->data_positions[3] = 6;
    } else if (word_length <= 8) {
        config->n = 13;
        config->k = 8;
        config->parity_count = 4;
        config->data_count = 8;
        config->extended_parity_position = 12;
        
        config->parity_positions = (int*)malloc(4 * sizeof(int));
        config->parity_positions[0] = 0;
        config->parity_positions[1] = 1;
        config->parity_positions[2] = 3;
        config->parity_positions[3] = 7;
        
        config->data_positions = (int*)malloc(8 * sizeof(int));
        config->data_positions[0] = 2;
        config->data_positions[1] = 4;
        config->data_positions[2] = 5;
        config->data_positions[3] = 6;
        config->data_positions[4] = 8;
        config->data_positions[5] = 9;
        config->data_positions[6] = 10;
        config->data_positions[7] = 11;
    } else {
        // Default to 8-bit configuration
        config->n = 13;
        config->k = 8;
        config->parity_count = 4;
        config->data_count = 8;
        config->extended_parity_position = 12;
        
        config->parity_positions = (int*)malloc(4 * sizeof(int));
        config->parity_positions[0] = 0;
        config->parity_positions[1] = 1;
        config->parity_positions[2] = 3;
        config->parity_positions[3] = 7;
        
        config->data_positions = (int*)malloc(8 * sizeof(int));
        config->data_positions[0] = 2;
        config->data_positions[1] = 4;
        config->data_positions[2] = 5;
        config->data_positions[3] = 6;
        config->data_positions[4] = 8;
        config->data_positions[5] = 9;
        config->data_positions[6] = 10;
        config->data_positions[7] = 11;
    }
    
    return config;
}

void free_extended_hamming_config(ExtendedHammingConfig* config) {
    free(config->parity_positions);
    free(config->data_positions);
    free(config);
}

// Count ones in a number
int count_ones(uint32_t num) {
    int count = 0;
    while (num) {
        count += num & 1;
        num >>= 1;
    }
    return count;
}

// Calculate Hamming parity bits
uint32_t calculate_hamming_parity(uint32_t data, ExtendedHammingConfig* config) {
    uint32_t codeword = 0;
    uint32_t parity = 0;
    
    // Insert data bits
    for (int i = 0; i < config->data_count; i++) {
        uint32_t bit = (data >> i) & 1;
        codeword |= (bit << config->data_positions[i]);
    }
    
    // Calculate parity bits
    for (int i = 0; i < config->parity_count; i++) {
        uint32_t p = 0;
        for (int j = 0; j < config->n; j++) {
            if (j != config->parity_positions[i] && ((codeword >> j) & 1)) {
                if ((j + 1) & (1 << i)) {
                    p ^= 1;
                }
            }
        }
        parity |= (p << config->parity_positions[i]);
    }
    
    return parity;
}

// Extract data from codeword
uint32_t extract_data(uint32_t codeword, ExtendedHammingConfig* config) {
    uint32_t data = 0;
    for (int i = 0; i < config->data_count; i++) {
        uint32_t bit = (codeword >> config->data_positions[i]) & 1;
        data |= (bit << i);
    }
    return data;
}

// Calculate syndrome
uint32_t calculate_syndrome(uint32_t codeword, ExtendedHammingConfig* config) {
    uint32_t syndrome = 0;
    
    for (int i = 0; i < config->parity_count; i++) {
        uint32_t expected_parity = 0;
        uint32_t actual_parity = (codeword >> config->parity_positions[i]) & 1;
        
        for (int j = 0; j < config->n; j++) {
            if (j != config->parity_positions[i] && ((codeword >> j) & 1)) {
                if ((j + 1) & (1 << i)) {
                    expected_parity ^= 1;
                }
            }
        }
        
        if (expected_parity != actual_parity) {
            syndrome |= (1 << i);
        }
    }
    
    return syndrome;
}

// Python-like Extended Hamming encoding
uint32_t encode_extended_hamming(uint32_t data, ExtendedHammingConfig* config) {
    // Create Hamming codeword
    uint32_t hamming_codeword = 0;
    
    // Insert data bits
    for (int i = 0; i < config->data_count; i++) {
        uint32_t bit = (data >> i) & 1;
        hamming_codeword |= (bit << config->data_positions[i]);
    }
    
    // Add Hamming parity bits
    hamming_codeword |= calculate_hamming_parity(data, config);
    
    // Calculate extended parity (even parity over all Hamming codeword bits)
    uint32_t total_ones = count_ones(hamming_codeword);
    uint32_t extended_parity = total_ones % 2;
    
    // Combine Hamming codeword with extended parity
    uint32_t codeword = hamming_codeword | (extended_parity << config->extended_parity_position);
    
    return codeword;
}

// Python-like Extended Hamming decoding
uint32_t decode_extended_hamming(uint32_t codeword, ExtendedHammingConfig* config, int* error_type) {
    // Extract Hamming codeword (without extended parity)
    uint32_t hamming_codeword = codeword & ~(1 << config->extended_parity_position);
    uint32_t extended_parity = (codeword >> config->extended_parity_position) & 1;
    
    // Calculate expected extended parity
    uint32_t total_ones = count_ones(hamming_codeword);
    uint32_t expected_extended_parity = total_ones % 2;
    
    // Check extended parity error
    int extended_parity_error = (extended_parity != expected_extended_parity);
    
    // Calculate Hamming syndrome
    uint32_t syndrome = calculate_syndrome(hamming_codeword, config);
    
    // Determine error type
    if (syndrome == 0) {
        if (extended_parity_error) {
            // Extended parity error but no Hamming error - extended parity bit error
            *error_type = 1; // corrected
        } else {
            // No error
            *error_type = 0; // no error
        }
        } else if (syndrome <= config->n) {
            if (extended_parity_error) {
                // Single bit error detected and corrected
                *error_type = 1; // corrected
            } else {
                // Extended parity error and Hamming corrected - likely double-bit error
                *error_type = 2; // detected
            }
        } else {
        if (!extended_parity_error) {
            // No extended parity error but Hamming detected - single-bit error in extended parity
            *error_type = 1; // corrected
        } else {
            // Double bit error detected but not corrected
            *error_type = 2; // detected
        }
    }
    
    // Extract data
    return extract_data(hamming_codeword, config);
}

// Test function
void test_extended_hamming_ecc() {
    Vextended_hamming_ecc* dut = new Vextended_hamming_ecc();
    
    printf("=== Extended Hamming ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int pass_count = 0;
    int fail_count = 0;
    
    ExtendedHammingConfig* config = create_extended_hamming_config(data_width);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_extended_hamming(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_extended_hamming(expected_codeword, config, &expected_error_type);
        
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
        int expected_error_detected = (expected_error_type == 2);
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
        
        // Test error detection (corrupt one bit)
        uint32_t corrupted_codeword = expected_codeword ^ (1 << (i % 13)); // Corrupt one bit
        int corrupted_error_type;
        uint32_t corrupted_decoded_data = decode_extended_hamming(corrupted_codeword, config, &corrupted_error_type);
        
        dut->codeword_in = corrupted_codeword;
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        
        int corrupted_expected_error_detected = (corrupted_error_type == 2);
        int corrupted_expected_error_corrected = (corrupted_error_type == 1);
        
        if (dut->error_detected == corrupted_expected_error_detected &&
            dut->error_corrected == corrupted_expected_error_corrected) {
            printf("ERROR DETECTION TEST %d: PASS (corrupted_codeword=0x%04X, error_detected=%d, error_corrected=%d)\n", 
                   i, corrupted_codeword, dut->error_detected, dut->error_corrected);
            pass_count++;
        } else {
            printf("ERROR DETECTION TEST %d: FAIL (corrupted_codeword=0x%04X, expected_error_detected=%d, got_error_detected=%d, expected_error_corrected=%d, got_error_corrected=%d)\n", 
                   i, corrupted_codeword, corrupted_expected_error_detected, dut->error_detected, corrupted_expected_error_corrected, dut->error_corrected);
            fail_count++;
        }
    }
    
    printf("\n=== Test Summary ===\n");
    printf("Total tests: %d\n", num_tests * 3);
    printf("Passed: %d\n", pass_count);
    printf("Failed: %d\n", fail_count);
    
    if (fail_count == 0) {
        printf("RESULT: PASS\n");
    } else {
        printf("RESULT: FAIL\n");
    }
    
    free_extended_hamming_config(config);
    delete dut;
}

int main() {
    test_extended_hamming_ecc();
    return 0;
} 