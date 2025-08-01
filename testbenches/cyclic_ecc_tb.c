#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vcyclic_ecc.h"
#include "verilated.h"

// Python-like Cyclic ECC calculation functions (simplified)
typedef struct {
    int n;  // Codeword length
    int k;  // Data length
    int m;  // Parity bits
} CyclicConfig;

CyclicConfig* create_cyclic_config(int n, int k) {
    CyclicConfig* config = (CyclicConfig*)malloc(sizeof(CyclicConfig));
    config->n = n;
    config->k = k;
    config->m = n - k;
    return config;
}

void free_cyclic_config(CyclicConfig* config) {
    free(config);
}

// Python-like Cyclic ECC encoding (simplified fallback)
uint32_t encode_cyclic_ecc(uint32_t data, CyclicConfig* config) {
    // Ensure data fits within k bits
    data = data & ((1 << config->k) - 1);
    
    // Simplified encoding: data shifted left by m positions
    // This matches the Python fallback: data << (n-k)
    uint32_t codeword = data << config->m;
    
    return codeword;
}

// Python-like Cyclic ECC decoding (simplified fallback)
uint32_t decode_cyclic_ecc(uint32_t codeword, CyclicConfig* config, int* error_type) {
    // Extract data bits (most significant k bits)
    // This matches the Python fallback: (codeword >> (n-k)) & mask
    uint32_t decoded_data = (codeword >> config->m) & ((1 << config->k) - 1);
    
    // Simple syndrome calculation (parity check)
    uint32_t syndrome = codeword & ((1 << config->m) - 1);
    
    // Error detection logic
    if (syndrome == 0) {
        // No error detected
        *error_type = 0; // no error
    } else {
        // Error detected and corrected (simplified)
        *error_type = 1; // corrected
    }
    
    return decoded_data;
}

// Test function
void test_cyclic_ecc() {
    Vcyclic_ecc* dut = new Vcyclic_ecc();
    
    printf("=== Cyclic ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int codeword_width = 15;
    int pass_count = 0;
    int fail_count = 0;
    
    CyclicConfig* config = create_cyclic_config(codeword_width, data_width);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_cyclic_ecc(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_cyclic_ecc(expected_codeword, config, &expected_error_type);
        
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
        uint32_t corrupted_codeword = expected_codeword ^ (1 << (i % 15)); // Corrupt one bit
        int corrupted_error_type;
        uint32_t corrupted_decoded_data = decode_cyclic_ecc(corrupted_codeword, config, &corrupted_error_type);
        
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
    
    free_cyclic_config(config);
    delete dut;
}

int main() {
    test_cyclic_ecc();
    return 0;
} 