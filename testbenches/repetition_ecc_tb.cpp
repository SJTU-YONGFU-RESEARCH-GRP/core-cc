#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vrepetition_ecc.h"
#include "verilated.h"

// Python-like Repetition ECC calculation functions
typedef struct {
    int repetition_factor;
    int data_length;
} RepetitionConfig;

RepetitionConfig* create_repetition_config(int data_length, int repetition_factor) {
    RepetitionConfig* config = (RepetitionConfig*)malloc(sizeof(RepetitionConfig));
    config->repetition_factor = repetition_factor;
    config->data_length = data_length;
    return config;
}

void free_repetition_config(RepetitionConfig* config) {
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

// Python-like repetition encoding
uint32_t encode_repetition(uint32_t data, RepetitionConfig* config) {
    int data_bits[32];
    int codeword_bits[256]; // Max size for safety
    int codeword_length = config->data_length * config->repetition_factor;
    
    // Convert data to bit array
    int_to_bits(data, data_bits, config->data_length);
    
    // Encode with repetition (each bit repeated n times)
    int codeword_idx = 0;
    for (int i = 0; i < config->data_length; i++) {
        for (int j = 0; j < config->repetition_factor; j++) {
            codeword_bits[codeword_idx++] = data_bits[i];
        }
    }
    
    // Convert back to integer
    return bits_to_int(codeword_bits, codeword_length);
}

// Python-like repetition decoding with majority voting
uint32_t decode_repetition(uint32_t codeword, RepetitionConfig* config, int* error_type) {
    int codeword_bits[256]; // Max size for safety
    int decoded_bits[32];
    int codeword_length = config->data_length * config->repetition_factor;
    
    // Convert codeword to bit array
    int_to_bits(codeword, codeword_bits, codeword_length);
    
    // Decode using majority voting
    for (int i = 0; i < config->data_length; i++) {
        int ones = 0;
        for (int j = 0; j < config->repetition_factor; j++) {
            ones += codeword_bits[i * config->repetition_factor + j];
        }
        // Majority vote
        decoded_bits[i] = (ones > config->repetition_factor / 2) ? 1 : 0;
    }
    
    // Convert back to integer
    uint32_t decoded_data = bits_to_int(decoded_bits, config->data_length);
    
    // Check if decoding was successful (simplified error detection)
    uint32_t re_encoded = encode_repetition(decoded_data, config);
    if (re_encoded != codeword) {
        *error_type = 1; // corrected
    } else {
        *error_type = 0; // No error detected
    }
    
    return decoded_data;
}

// Test function
void test_repetition_ecc() {
    Vrepetition_ecc* dut = new Vrepetition_ecc();
    
    printf("=== Repetition ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int repetition_factor = 3;
    int pass_count = 0;
    int fail_count = 0;
    
    RepetitionConfig* config = create_repetition_config(data_width, repetition_factor);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_repetition(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_repetition(expected_codeword, config, &expected_error_type);
        
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
            printf("ENCODE TEST %d: PASS (data=0x%02X, codeword=0x%06X)\n", 
                   i, test_data, dut->codeword_out);
            pass_count++;
        } else {
            printf("ENCODE TEST %d: FAIL (data=0x%02X, expected=0x%06X, got=0x%06X)\n", 
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
            printf("DECODE TEST %d: PASS (codeword=0x%06X, data=0x%02X, error_detected=%d, error_corrected=%d)\n", 
                   i, expected_codeword, dut->data_out, dut->error_detected, dut->error_corrected);
            pass_count++;
        } else {
            printf("DECODE TEST %d: FAIL (codeword=0x%06X, expected_data=0x%02X, got_data=0x%02X, expected_error_detected=%d, got_error_detected=%d, expected_error_corrected=%d, got_error_corrected=%d)\n", 
                   i, expected_codeword, expected_decoded_data, dut->data_out, expected_error_detected, dut->error_detected, expected_error_corrected, dut->error_corrected);
            fail_count++;
        }
        
        // Test error injection and correction
        uint32_t corrupted_codeword = expected_codeword ^ 1; // Flip LSB
        int expected_error_type_corrupted;
        uint32_t expected_decoded_data_corrupted = decode_repetition(corrupted_codeword, config, &expected_error_type_corrupted);
        
        dut->codeword_in = corrupted_codeword;
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        
        int expected_error_detected_corrupted = (expected_error_type_corrupted == 2);
        int expected_error_corrected_corrupted = (expected_error_type_corrupted == 1);
        
        if (dut->error_detected == expected_error_detected_corrupted &&
            dut->error_corrected == expected_error_corrected_corrupted) {
            printf("ERROR CORRECTION TEST %d: PASS (corrupted_codeword=0x%06X, error_detected=%d, error_corrected=%d)\n", 
                   i, corrupted_codeword, dut->error_detected, dut->error_corrected);
            pass_count++;
        } else {
            printf("ERROR CORRECTION TEST %d: FAIL (corrupted_codeword=0x%06X, expected_error_detected=%d, got_error_detected=%d, expected_error_corrected=%d, got_error_corrected=%d)\n", 
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
    
    free_repetition_config(config);
    delete dut;
}

int main() {
    test_repetition_ecc();
    return 0;
} 