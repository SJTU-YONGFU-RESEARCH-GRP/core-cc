#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vcrc_ecc.h"
#include "verilated.h"

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

// Python-like CRC computation
uint32_t compute_crc(int* data_bits, int data_length, CRCConfig* config) {
    uint32_t crc = 0x00; // Initial value
    
    for (int i = 0; i < data_length; i++) {
        crc ^= (data_bits[i] << 7);
        for (int j = 0; j < 8; j++) {
            if (crc & 0x80) {
                crc = ((crc << 1) ^ config->polynomial) & 0xFF;
            } else {
                crc = (crc << 1) & 0xFF;
            }
        }
    }
    
    return crc;
}

// Python-like CRC encoding
uint32_t encode_crc(uint32_t data, CRCConfig* config) {
    int data_bits[32];
    int crc_bits[8];
    int codeword_bits[40]; // data_length + crc_bits
    
    // Convert data to bit array
    int_to_bits(data, data_bits, config->data_length);
    
    // Compute CRC
    uint32_t crc = compute_crc(data_bits, config->data_length, config);
    
    // Convert CRC to bit array (LSB first)
    int_to_bits(crc, crc_bits, config->crc_bits);
    
    // Combine data and CRC
    int codeword_idx = 0;
    for (int i = 0; i < config->data_length; i++) {
        codeword_bits[codeword_idx++] = data_bits[i];
    }
    for (int i = 0; i < config->crc_bits; i++) {
        codeword_bits[codeword_idx++] = crc_bits[i];
    }
    
    // Convert back to integer
    return bits_to_int(codeword_bits, config->data_length + config->crc_bits);
}

// Python-like CRC checking
int check_crc(int* codeword_bits, int codeword_length, CRCConfig* config) {
    if (codeword_length < config->crc_bits) {
        return 0; // Invalid codeword
    }
    
    int data_length = codeword_length - config->crc_bits;
    int data_bits[32];
    int crc_bits[8];
    
    // Extract data bits
    for (int i = 0; i < data_length; i++) {
        data_bits[i] = codeword_bits[i];
    }
    
    // Extract CRC bits
    for (int i = 0; i < config->crc_bits; i++) {
        crc_bits[i] = codeword_bits[data_length + i];
    }
    
    // Compute expected CRC
    uint32_t expected_crc = compute_crc(data_bits, data_length, config);
    
    // Convert expected CRC to bits
    int expected_crc_bits[8];
    int_to_bits(expected_crc, expected_crc_bits, config->crc_bits);
    
    // Compare CRC bits
    for (int i = 0; i < config->crc_bits; i++) {
        if (crc_bits[i] != expected_crc_bits[i]) {
            return 0; // CRC mismatch
        }
    }
    
    return 1; // CRC valid
}

// Python-like CRC decoding
uint32_t decode_crc(uint32_t codeword, CRCConfig* config, int* error_type) {
    int codeword_length = config->data_length + config->crc_bits;
    int codeword_bits[40];
    
    // Convert codeword to bit array
    int_to_bits(codeword, codeword_bits, codeword_length);
    
    // Check CRC validity
    if (check_crc(codeword_bits, codeword_length, config)) {
        // Extract data bits (all except last 8 CRC bits)
        int data_bits[32];
        for (int i = 0; i < config->data_length; i++) {
            data_bits[i] = codeword_bits[i];
        }
        
        // Convert back to integer
        uint32_t decoded_data = bits_to_int(data_bits, config->data_length);
        *error_type = 0; // No error
        return decoded_data;
    } else {
        // CRC check failed - error detected
        *error_type = 1; // Error detected
        return codeword; // Return original codeword as data
    }
}

// Test function
void test_crc_ecc() {
    Vcrc_ecc* dut = new Vcrc_ecc();
    
    printf("=== CRC ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int polynomial = 0x07; // CRC-8 polynomial
    int pass_count = 0;
    int fail_count = 0;
    
    CRCConfig* config = create_crc_config(data_width, polynomial);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_crc(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_crc(expected_codeword, config, &expected_error_type);
        
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
        uint32_t expected_decoded_data_corrupted = decode_crc(corrupted_codeword, config, &expected_error_type_corrupted);
        
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
    
    free_crc_config(config);
    delete dut;
}

int main() {
    test_crc_ecc();
    return 0;
} 