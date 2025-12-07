#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vsystem_ecc.h"
#include "verilated.h"

// Python-like System ECC calculation functions
typedef struct {
    int n;  // Codeword length
    int k;  // Data length
    int hamming_n;  // Hamming codeword length
    int* parity_positions;
    int* data_positions;
    int parity_count;
    int data_count;
    int system_parity_position;
} SystemConfig;

SystemConfig* create_system_config(int word_length) {
    SystemConfig* config = (SystemConfig*)malloc(sizeof(SystemConfig));
    
    if (word_length <= 8) {
        config->n = 13;  // Hamming(12,8) + 1 system parity bit
        config->k = 8;
        config->hamming_n = 12;
        config->parity_count = 4;
        config->data_count = 8;
        config->system_parity_position = 12;
        
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
        config->hamming_n = 12;
        config->parity_count = 4;
        config->data_count = 8;
        config->system_parity_position = 12;
        
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

void free_system_config(SystemConfig* config) {
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
uint32_t calculate_hamming_parity(uint32_t data, SystemConfig* config) {
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
        for (int j = 0; j < config->hamming_n; j++) {
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

// Extract data from Hamming codeword
uint32_t extract_data(uint32_t codeword, SystemConfig* config) {
    uint32_t data = 0;
    for (int i = 0; i < config->data_count; i++) {
        uint32_t bit = (codeword >> config->data_positions[i]) & 1;
        data |= (bit << i);
    }
    return data;
}

// Calculate Hamming syndrome
uint32_t calculate_syndrome(uint32_t codeword, SystemConfig* config) {
    uint32_t syndrome = 0;
    
    for (int i = 0; i < config->parity_count; i++) {
        uint32_t expected_parity = 0;
        uint32_t actual_parity = (codeword >> config->parity_positions[i]) & 1;
        
        for (int j = 0; j < config->hamming_n; j++) {
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

// Python-like System ECC encoding
uint32_t encode_system_ecc(uint32_t data, SystemConfig* config) {
    // Use Hamming SECDED for base encoding
    uint32_t hamming_codeword = 0;
    
    // Insert data bits
    for (int i = 0; i < config->data_count; i++) {
        uint32_t bit = (data >> i) & 1;
        hamming_codeword |= (bit << config->data_positions[i]);
    }
    
    // Add Hamming parity bits
    hamming_codeword |= calculate_hamming_parity(data, config);
    
    // Compute system-level parity (even parity over all Hamming codeword bits)
    uint32_t total_ones = count_ones(hamming_codeword);
    uint32_t system_parity = total_ones % 2;
    
    // Add system parity bit as MSB
    uint32_t codeword = hamming_codeword | (system_parity << config->system_parity_position);
    
    return codeword;
}

// Python-like System ECC decoding
uint32_t decode_system_ecc(uint32_t codeword, SystemConfig* config, int* error_type) {
    // Extract system parity bit (MSB)
    uint32_t system_parity = (codeword >> config->system_parity_position) & 1;
    
    // Extract base Hamming codeword (all bits except system parity)
    uint32_t hamming_codeword = codeword & ~(1 << config->system_parity_position);
    
    // Check system parity
    uint32_t total_ones = count_ones(hamming_codeword);
    uint32_t computed_parity = total_ones % 2;
    if (system_parity != computed_parity) {
        // System parity error detected
        *error_type = 2; // detected
        return extract_data(hamming_codeword, config);
    }
    
    // Decode with base Hamming SECDED
    uint32_t syndrome = calculate_syndrome(hamming_codeword, config);
    
    if (syndrome == 0) {
        // No error detected
        *error_type = 0; // no error
    } else if (syndrome <= config->hamming_n) {
        // Single bit error detected and corrected
        *error_type = 1; // corrected
    } else {
        // Double bit error detected but not corrected
        *error_type = 2; // detected
    }
    
    return extract_data(hamming_codeword, config);
}

// Test function
void test_system_ecc() {
    Vsystem_ecc* dut = new Vsystem_ecc();
    
    printf("=== System ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int pass_count = 0;
    int fail_count = 0;
    
    SystemConfig* config = create_system_config(data_width);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_system_ecc(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_system_ecc(expected_codeword, config, &expected_error_type);
        
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
        uint32_t corrupted_decoded_data = decode_system_ecc(corrupted_codeword, config, &corrupted_error_type);
        
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
    
    free_system_config(config);
    delete dut;
}

int main() {
    test_system_ecc();
    return 0;
} 