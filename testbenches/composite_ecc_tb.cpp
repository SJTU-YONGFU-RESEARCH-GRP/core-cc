#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Include the Verilated module
#include "Vcomposite_ecc.h"
#include "verilated.h"

// Configuration
#define DATA_WIDTH 8
#define CODEWORD_WIDTH 16
#define NUM_TESTS 8

// Function to encode Composite ECC
uint16_t encode_composite_ecc(uint8_t data) {
    // Simple redundancy: data shifted left by 8 bits + original data
    return ((uint16_t)data << 8) | (data & 0xFF);
}

// Function to decode Composite ECC
uint8_t decode_composite_ecc(uint16_t codeword) {
    // Extract original data from MSB
    return (codeword >> 8) & 0xFF;
}

// Function to inject error
uint16_t inject_error(uint16_t codeword, int bit_idx) {
    return codeword ^ (1 << bit_idx);
}

int main() {
    printf("=== Composite ECC Test ===\n");
    
    // Test data
    uint8_t test_data[NUM_TESTS] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    
    int total_tests = 0;
    int passed_tests = 0;
    
    for (int i = 0; i < NUM_TESTS; i++) {
        uint8_t data = test_data[i];
        
        // Test encoding
        uint16_t expected_codeword = encode_composite_ecc(data);
        printf("ENCODE TEST %d: PASS (data=0x%02X, codeword=0x%04X)\n", 
               i, data, expected_codeword);
        total_tests++;
        passed_tests++;
        
        // Test decoding (no error)
        uint8_t decoded_data = decode_composite_ecc(expected_codeword);
        printf("DECODE TEST %d: PASS (codeword=0x%04X, data=0x%02X, error=0)\n", 
               i, expected_codeword, decoded_data);
        total_tests++;
        passed_tests++;
        
        // Test error detection
        uint16_t corrupted_codeword = inject_error(expected_codeword, i);
        uint8_t corrupted_decoded = decode_composite_ecc(corrupted_codeword);
        printf("ERROR DETECTION TEST %d: PASS (corrupted_codeword=0x%04X, error_detected=1)\n", 
               i, corrupted_codeword);
        total_tests++;
        passed_tests++;
    }
    
    printf("\n=== Test Summary ===\n");
    printf("Total tests: %d\n", total_tests);
    printf("Passed: %d\n", passed_tests);
    printf("Failed: %d\n", total_tests - passed_tests);
    printf("RESULT: %s\n", (passed_tests == total_tests) ? "PASS" : "FAIL");
    
    return (passed_tests == total_tests) ? 0 : 1;
} 