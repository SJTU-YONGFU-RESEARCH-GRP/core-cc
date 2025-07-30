#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vparity_ecc.h"
#include "verilated.h"

// Python-like parity calculation functions
uint32_t calculate_parity(uint32_t data, int data_width) {
    uint32_t parity = 0;
    for (int i = 0; i < data_width; i++) {
        parity ^= ((data >> i) & 1);
    }
    return parity;
}

uint32_t encode_parity(uint32_t data, int data_width) {
    uint32_t parity = calculate_parity(data, data_width);
    return (data << 1) | parity;
}

uint32_t decode_parity(uint32_t codeword, int data_width, int* error_detected) {
    uint32_t data_bits = codeword >> 1;
    uint32_t parity_bit = codeword & 1;
    uint32_t expected_parity = calculate_parity(data_bits, data_width);
    
    *error_detected = (parity_bit != expected_parity);
    return data_bits;
}

// Test function
void test_parity_ecc() {
    Vparity_ecc* dut = new Vparity_ecc();
    
    printf("=== Parity ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int pass_count = 0;
    int fail_count = 0;
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_parity(test_data, data_width);
        int expected_error_detected;
        uint32_t expected_decoded_data = decode_parity(expected_codeword, data_width, &expected_error_detected);
        
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
        if (dut->data_out == expected_decoded_data && dut->error_detected == expected_error_detected) {
            printf("DECODE TEST %d: PASS (codeword=0x%03X, data=0x%02X, error=%d)\n", 
                   i, expected_codeword, dut->data_out, dut->error_detected);
            pass_count++;
        } else {
            printf("DECODE TEST %d: FAIL (codeword=0x%03X, expected_data=0x%02X, got_data=0x%02X, expected_error=%d, got_error=%d)\n", 
                   i, expected_codeword, expected_decoded_data, dut->data_out, expected_error_detected, dut->error_detected);
            fail_count++;
        }
        
        // Test error detection (inject error)
        uint32_t corrupted_codeword = expected_codeword ^ 1; // Flip LSB
        int expected_error_detected_corrupted;
        uint32_t expected_decoded_data_corrupted = decode_parity(corrupted_codeword, data_width, &expected_error_detected_corrupted);
        
        dut->codeword_in = corrupted_codeword;
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        
        // Check error detection
        if (dut->error_detected == expected_error_detected_corrupted) {
            printf("ERROR DETECTION TEST %d: PASS (corrupted_codeword=0x%03X, error_detected=%d)\n", 
                   i, corrupted_codeword, dut->error_detected);
            pass_count++;
        } else {
            printf("ERROR DETECTION TEST %d: FAIL (corrupted_codeword=0x%03X, expected_error=%d, got_error=%d)\n", 
                   i, corrupted_codeword, expected_error_detected_corrupted, dut->error_detected);
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
    
    delete dut;
}

int main() {
    test_parity_ecc();
    return 0;
} 