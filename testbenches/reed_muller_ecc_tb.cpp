#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vreed_muller_ecc.h"
#include "verilated.h"

// Python-like Reed-Muller ECC calculation functions
typedef struct {
    int n;  // Codeword length
    int k;  // Data length
    int m;  // Parity bits
    int* data_positions;
    int* parity_positions;
    int data_count;
    int parity_count;
} ReedMullerConfig;

ReedMullerConfig* create_reed_muller_config(int word_length) {
    ReedMullerConfig* config = (ReedMullerConfig*)malloc(sizeof(ReedMullerConfig));
    
    if (word_length <= 4) {
        config->n = 8;
        config->k = 4;
        config->m = 4;
        config->data_count = 4;
        config->parity_count = 4;
    } else if (word_length <= 8) {
        config->n = 16;
        config->k = 8;
        config->m = 8;
        config->data_count = 8;
        config->parity_count = 8;
    } else if (word_length <= 16) {
        config->n = 32;
        config->k = 16;
        config->m = 16;
        config->data_count = 16;
        config->parity_count = 16;
    } else {
        config->n = 64;
        config->k = 32;
        config->m = 32;
        config->data_count = 32;
        config->parity_count = 32;
    }
    
    // Allocate and initialize data positions
    config->data_positions = (int*)malloc(config->data_count * sizeof(int));
    for (int i = 0; i < config->data_count; i++) {
        config->data_positions[i] = i;
    }
    
    // Allocate and initialize parity positions
    config->parity_positions = (int*)malloc(config->parity_count * sizeof(int));
    for (int i = 0; i < config->parity_count; i++) {
        config->parity_positions[i] = config->k + i;
    }
    
    return config;
}

void free_reed_muller_config(ReedMullerConfig* config) {
    free(config->data_positions);
    free(config->parity_positions);
    free(config);
}

// Extract data from codeword
uint32_t extract_data(uint32_t codeword, ReedMullerConfig* config) {
    uint32_t data = 0;
    for (int i = 0; i < config->data_count; i++) {
        uint32_t bit = (codeword >> config->data_positions[i]) & 1;
        data |= (bit << i);
    }
    return data;
}

// Insert data into codeword
uint32_t insert_data(uint32_t data, ReedMullerConfig* config) {
    uint32_t codeword = 0;
    for (int i = 0; i < config->data_count; i++) {
        uint32_t bit = (data >> i) & 1;
        codeword |= (bit << config->data_positions[i]);
    }
    return codeword;
}

// Calculate parity bits
uint32_t calculate_parity(uint32_t codeword, ReedMullerConfig* config) {
    uint32_t parity = 0;
    
    for (int i = 0; i < config->parity_count; i++) {
        uint32_t p = 0;
        int pos = config->parity_positions[i];
        
        for (int j = 0; j < config->data_count; j++) {
            if ((codeword >> config->data_positions[j]) & 1) {
                // Simple parity calculation
                if ((j + pos) % 2 == 0) {
                    p ^= 1;
                }
            }
        }
        parity |= (p << pos);
    }
    
    return parity;
}

// Calculate syndrome
uint32_t calculate_syndrome(uint32_t codeword, ReedMullerConfig* config) {
    uint32_t syndrome = 0;
    
    for (int i = 0; i < config->parity_count; i++) {
        uint32_t expected_parity = 0;
        int pos = config->parity_positions[i];
        
        for (int j = 0; j < config->data_count; j++) {
            if ((codeword >> config->data_positions[j]) & 1) {
                // Simple parity calculation
                if ((j + pos) % 2 == 0) {
                    expected_parity ^= 1;
                }
            }
        }
        
        uint32_t actual_parity = (codeword >> pos) & 1;
        if (expected_parity != actual_parity) {
            syndrome |= (1 << i);
        }
    }
    
    return syndrome;
}

// Python-like Reed-Muller ECC encoding
uint32_t encode_reed_muller_ecc(uint32_t data, ReedMullerConfig* config) {
    // Ensure data fits within word_length bits
    data = data & ((1 << config->k) - 1);
    
    // Insert data bits into codeword
    uint32_t codeword = insert_data(data, config);
    
    // Calculate and insert parity bits
    uint32_t parity = calculate_parity(codeword, config);
    codeword |= parity;
    
    return codeword;
}

// Python-like Reed-Muller ECC decoding
uint32_t decode_reed_muller_ecc(uint32_t codeword, ReedMullerConfig* config, int* error_type) {
    // Calculate syndrome
    uint32_t syndrome = calculate_syndrome(codeword, config);
    
    if (syndrome == 0) {
        // No error detected
        *error_type = 0; // no error
        uint32_t decoded_data = extract_data(codeword, config);
        return decoded_data;
    } else {
        // Try to correct single bit errors
        for (int bit_pos = 0; bit_pos < config->n; bit_pos++) {
            // Try flipping this bit
            uint32_t test_codeword = codeword ^ (1 << bit_pos);
            
            // Check if this fixes the syndrome
            uint32_t test_syndrome = calculate_syndrome(test_codeword, config);
            
            if (test_syndrome == 0) {
                // Error corrected
                *error_type = 1; // corrected
                uint32_t decoded_data = extract_data(test_codeword, config);
                return decoded_data;
            }
        }
        
        // Error detected but not corrected
        *error_type = 2; // detected
        uint32_t decoded_data = extract_data(codeword, config);
        return decoded_data;
    }
}

// Test function
void test_reed_muller_ecc() {
    Vreed_muller_ecc* dut = new Vreed_muller_ecc();
    
    printf("=== Reed-Muller ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int pass_count = 0;
    int fail_count = 0;
    
    ReedMullerConfig* config = create_reed_muller_config(data_width);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_reed_muller_ecc(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_reed_muller_ecc(expected_codeword, config, &expected_error_type);
        
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
        uint32_t corrupted_codeword = expected_codeword ^ (1 << (i % 16)); // Corrupt one bit
        int corrupted_error_type;
        uint32_t corrupted_decoded_data = decode_reed_muller_ecc(corrupted_codeword, config, &corrupted_error_type);
        
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
    
    free_reed_muller_config(config);
    delete dut;
}

int main() {
    test_reed_muller_ecc();
    return 0;
} 