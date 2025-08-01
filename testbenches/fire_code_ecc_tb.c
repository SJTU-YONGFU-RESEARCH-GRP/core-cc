#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vfire_code_ecc.h"
#include "verilated.h"

// Python-like Fire Code ECC calculation functions
typedef struct {
    int burst_length;
    int data_length;
    int parity_length;
    int n;
    int k;
} FireCodeConfig;

FireCodeConfig* create_fire_code_config(int data_length, int burst_length) {
    FireCodeConfig* config = (FireCodeConfig*)malloc(sizeof(FireCodeConfig));
    
    config->burst_length = burst_length;
    config->data_length = data_length;
    config->parity_length = 2 * burst_length;
    config->n = data_length + config->parity_length;
    config->k = data_length;
    
    return config;
}

void free_fire_code_config(FireCodeConfig* config) {
    free(config);
}

// Calculate parity bits
uint32_t calculate_parity(uint32_t data, FireCodeConfig* config) {
    uint32_t parity = 0;
    
    for (int i = 0; i < config->k; i++) {
        if ((data >> i) & 1) {
            // Add contribution to parity
            parity ^= (1 << (i % config->parity_length));
        }
    }
    
    return parity;
}

// Extract data from codeword
uint32_t extract_data(uint32_t codeword, FireCodeConfig* config) {
    return (codeword >> config->parity_length) & ((1 << config->k) - 1);
}

// Calculate syndrome
uint32_t calculate_syndrome(uint32_t codeword, FireCodeConfig* config) {
    uint32_t data = extract_data(codeword, config);
    uint32_t received_parity = codeword & ((1 << config->parity_length) - 1);
    uint32_t expected_parity = calculate_parity(data, config);
    
    return received_parity ^ expected_parity;
}

// Correct burst errors (simplified)
uint32_t correct_burst_errors(uint32_t data, uint32_t syndrome, FireCodeConfig* config) {
    uint32_t corrected_data = data;
    
    // Try different burst positions
    for (int start_pos = 0; start_pos < config->n; start_pos++) {
        // Try to correct a burst starting at start_pos
        uint32_t error_pattern = 0;
        for (int i = 0; i < config->burst_length; i++) {
            if (start_pos + i < config->parity_length) {
                error_pattern |= (1 << (start_pos + i));
            }
        }
        
        // Check if this error pattern matches the syndrome
        if ((error_pattern & ((1 << config->parity_length) - 1)) == syndrome) {
            // Found matching error pattern
            for (int i = 0; i < config->burst_length; i++) {
                if (start_pos + i >= config->parity_length) {
                    int bit_pos = start_pos + i - config->parity_length;
                    if (bit_pos < config->k) {
                        corrected_data ^= (1 << bit_pos);
                    }
                }
            }
            break;
        }
    }
    
    return corrected_data;
}

// Python-like Fire Code ECC encoding
uint32_t encode_fire_code_ecc(uint32_t data, FireCodeConfig* config) {
    // Ensure data fits within k bits
    data = data & ((1 << config->k) - 1);
    
    // Create systematic code: data bits followed by parity bits
    uint32_t codeword = data << config->parity_length;
    
    // Calculate and add parity bits
    uint32_t parity = calculate_parity(data, config);
    codeword |= parity;
    
    return codeword;
}

// Python-like Fire Code ECC decoding
uint32_t decode_fire_code_ecc(uint32_t codeword, FireCodeConfig* config, int* error_type) {
    // Extract data and calculate syndrome
    uint32_t data = extract_data(codeword, config);
    uint32_t syndrome = calculate_syndrome(codeword, config);
    
    if (syndrome == 0) {
        // No errors
        *error_type = 0; // no error
        return data;
    } else {
        // Try to correct burst errors
        uint32_t corrected_data = correct_burst_errors(data, syndrome, config);
        
        // Check if correction was successful
        uint32_t corrected_codeword = (corrected_data << config->parity_length) | 
                                     calculate_parity(corrected_data, config);
        uint32_t corrected_syndrome = calculate_syndrome(corrected_codeword, config);
        
        if (corrected_syndrome == 0) {
            // Correction successful
            *error_type = 1; // corrected
            return corrected_data;
        } else {
            // Error detected but not corrected
            *error_type = 2; // detected
            return data;
        }
    }
}

// Test function
void test_fire_code_ecc() {
    Vfire_code_ecc* dut = new Vfire_code_ecc();
    
    printf("=== Fire Code ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int burst_length = 3;
    int pass_count = 0;
    int fail_count = 0;
    
    FireCodeConfig* config = create_fire_code_config(data_width, burst_length);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_fire_code_ecc(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_fire_code_ecc(expected_codeword, config, &expected_error_type);
        
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
        
        // Test burst error detection (corrupt multiple consecutive bits)
        uint32_t corrupted_codeword = expected_codeword;
        for (int j = 0; j < burst_length; j++) {
            corrupted_codeword ^= (1 << (i % 14 + j)); // Corrupt consecutive bits
        }
        
        int corrupted_error_type;
        uint32_t corrupted_decoded_data = decode_fire_code_ecc(corrupted_codeword, config, &corrupted_error_type);
        
        dut->codeword_in = corrupted_codeword;
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        
        int corrupted_expected_error_detected = (corrupted_error_type == 2);
        int corrupted_expected_error_corrected = (corrupted_error_type == 1);
        
        if (dut->error_detected == corrupted_expected_error_detected &&
            dut->error_corrected == corrupted_expected_error_corrected) {
            printf("BURST ERROR DETECTION TEST %d: PASS (corrupted_codeword=0x%04X, error_detected=%d, error_corrected=%d)\n", 
                   i, corrupted_codeword, dut->error_detected, dut->error_corrected);
            pass_count++;
        } else {
            printf("BURST ERROR DETECTION TEST %d: FAIL (corrupted_codeword=0x%04X, expected_error_detected=%d, got_error_detected=%d, expected_error_corrected=%d, got_error_corrected=%d)\n", 
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
    
    free_fire_code_config(config);
    delete dut;
}

int main() {
    test_fire_code_ecc();
    return 0;
} 