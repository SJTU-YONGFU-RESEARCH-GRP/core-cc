#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vhamming_secded_ecc.h"
#include "verilated.h"

// Python-like Hamming SECDED calculation functions
typedef struct {
    int n;  // Codeword length
    int k;  // Data length
    int parity_bits;
    int* parity_positions;
    int* data_positions;
} HammingConfig;

HammingConfig* create_hamming_config(int word_length) {
    HammingConfig* config = (HammingConfig*)malloc(sizeof(HammingConfig));
    
    if (word_length <= 4) {
        config->n = 7;
        config->k = 4;
        config->parity_bits = 3;
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
        config->n = 12;
        config->k = 8;
        config->parity_bits = 4;
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
        config->n = 12;
        config->k = 8;
        config->parity_bits = 4;
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

void free_hamming_config(HammingConfig* config) {
    free(config->parity_positions);
    free(config->data_positions);
    free(config);
}

uint32_t extract_data_from_codeword(uint32_t codeword, HammingConfig* config) {
    uint32_t data = 0;
    for (int i = 0; i < config->k; i++) {
        int bit = (codeword >> config->data_positions[i]) & 1;
        data |= (bit << i);
    }
    return data;
}

uint32_t insert_data_into_codeword(uint32_t data, HammingConfig* config) {
    uint32_t codeword = 0;
    for (int i = 0; i < config->k; i++) {
        int bit = (data >> i) & 1;
        codeword |= (bit << config->data_positions[i]);
    }
    return codeword;
}

uint32_t calculate_parity_bits(uint32_t codeword, HammingConfig* config) {
    uint32_t parity = 0;
    for (int i = 0; i < config->parity_bits; i++) {
        int p = 0;
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

uint32_t encode_hamming(uint32_t data, HammingConfig* config) {
    uint32_t codeword = insert_data_into_codeword(data, config);
    uint32_t parity = calculate_parity_bits(codeword, config);
    return codeword | parity;
}

uint32_t calculate_syndrome(uint32_t codeword, HammingConfig* config) {
    uint32_t syndrome = 0;
    for (int i = 0; i < config->parity_bits; i++) {
        int expected_parity = 0;
        for (int j = 0; j < config->n; j++) {
            if (j != config->parity_positions[i] && ((codeword >> j) & 1)) {
                if ((j + 1) & (1 << i)) {
                    expected_parity ^= 1;
                }
            }
        }
        int actual_parity = (codeword >> config->parity_positions[i]) & 1;
        if (expected_parity != actual_parity) {
            syndrome |= (1 << i);
        }
    }
    return syndrome;
}

uint32_t decode_hamming(uint32_t codeword, HammingConfig* config, int* error_type) {
    uint32_t syndrome = calculate_syndrome(codeword, config);
    
    if (syndrome == 0) {
        *error_type = 0; // No error
        return extract_data_from_codeword(codeword, config);
    } else if (syndrome <= config->n) {
        // Single bit error - correct it
        uint32_t corrected_codeword = codeword ^ (1 << (syndrome - 1));
        *error_type = 1; // Corrected
        return extract_data_from_codeword(corrected_codeword, config);
    } else {
        // Double bit error - detected but not corrected
        *error_type = 2; // Detected
        return extract_data_from_codeword(codeword, config);
    }
}

// Test function
void test_hamming_secded_ecc() {
    Vhamming_secded_ecc* dut = new Vhamming_secded_ecc();
    
    printf("=== Hamming SECDED ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int pass_count = 0;
    int fail_count = 0;
    
    HammingConfig* config = create_hamming_config(data_width);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_hamming(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_hamming(expected_codeword, config, &expected_error_type);
        
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
            printf("ENCODE TEST %d: PASS (data=0x%02X, codeword=0x%03X)\n", 
                   i, test_data, dut->codeword_out);
            pass_count++;
        } else {
            printf("ENCODE TEST %d: FAIL (data=0x%02X, expected=0x%03X, got=0x%03X)\n", 
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
            printf("DECODE TEST %d: PASS (codeword=0x%03X, data=0x%02X, error_detected=%d, error_corrected=%d)\n", 
                   i, expected_codeword, dut->data_out, dut->error_detected, dut->error_corrected);
            pass_count++;
        } else {
            printf("DECODE TEST %d: FAIL (codeword=0x%03X, expected_data=0x%02X, got_data=0x%02X, expected_error_detected=%d, got_error_detected=%d, expected_error_corrected=%d, got_error_corrected=%d)\n", 
                   i, expected_codeword, expected_decoded_data, dut->data_out, expected_error_detected, dut->error_detected, expected_error_corrected, dut->error_corrected);
            fail_count++;
        }
        
        // Test single bit error correction
        uint32_t corrupted_codeword = expected_codeword ^ 1; // Flip LSB
        int expected_error_type_corrupted;
        uint32_t expected_decoded_data_corrupted = decode_hamming(corrupted_codeword, config, &expected_error_type_corrupted);
        
        dut->codeword_in = corrupted_codeword;
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        
        int expected_error_detected_corrupted = (expected_error_type_corrupted != 0);
        int expected_error_corrected_corrupted = (expected_error_type_corrupted == 1);
        
        if (dut->error_detected == expected_error_detected_corrupted &&
            dut->error_corrected == expected_error_corrected_corrupted) {
            printf("SINGLE ERROR CORRECTION TEST %d: PASS (corrupted_codeword=0x%03X, error_detected=%d, error_corrected=%d)\n", 
                   i, corrupted_codeword, dut->error_detected, dut->error_corrected);
            pass_count++;
        } else {
            printf("SINGLE ERROR CORRECTION TEST %d: FAIL (corrupted_codeword=0x%03X, expected_error_detected=%d, got_error_detected=%d, expected_error_corrected=%d, got_error_corrected=%d)\n", 
                   i, corrupted_codeword, expected_error_detected_corrupted, dut->error_detected, expected_error_corrected_corrupted, dut->error_corrected);
            fail_count++;
        }
        
        printf("\n");
    }
    
    // Summary
    printf("=== Test Summary ===\n");
    printf("Total tests: %d\n", num_tests * 3); // encode, decode, error correction
    printf("Passed: %d\n", pass_count);
    printf("Failed: %d\n", fail_count);
    
    if (fail_count == 0) {
        printf("RESULT: PASS\n");
    } else {
        printf("RESULT: FAIL\n");
    }
    
    free_hamming_config(config);
    delete dut;
}

int main() {
    test_hamming_secded_ecc();
    return 0;
} 