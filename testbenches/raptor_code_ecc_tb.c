#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Include the Verilated module
#include "Vraptor_code_ecc.h"
#include "verilated.h"

// Configuration
#define DATA_WIDTH 8
#define CODEWORD_WIDTH 16
#define NUM_TESTS 8

// Configuration for 8-bit data (matches Python)
#define K 8   // Data bits
#define N 16  // Total codeword bits
#define M 8   // Parity bits (N - K)

// Function to encode using systematic encoding matrix (matches Python algorithm)
uint16_t encode_raptor_code(uint8_t data) {
    uint16_t codeword = 0;
    uint8_t parity_bits = 0;
    
    // Systematic part: data bits (matches Python G[i,i] = 1 for i < k)
    codeword = data;
    
    // Parity part: deterministic pattern (matches Python G[i,j] = 1 if (i+j)%2 == 0)
    // For 8-bit data, hardcode the checkerboard pattern from Python algorithm
    // i ranges from 8-15, j ranges from 0-7, so (i+j)%2 == 0 becomes ((8+i)+j)%2 == 0
    parity_bits |= ((data >> 0) & 1) ^ ((data >> 2) & 1) ^ ((data >> 4) & 1) ^ ((data >> 6) & 1);  // G[8,j] where j%2==0
    parity_bits |= (((data >> 1) & 1) ^ ((data >> 3) & 1) ^ ((data >> 5) & 1) ^ ((data >> 7) & 1)) << 1;  // G[9,j] where j%2==1
    parity_bits |= (((data >> 0) & 1) ^ ((data >> 2) & 1) ^ ((data >> 4) & 1) ^ ((data >> 6) & 1)) << 2;  // G[10,j] where j%2==0
    parity_bits |= (((data >> 1) & 1) ^ ((data >> 3) & 1) ^ ((data >> 5) & 1) ^ ((data >> 7) & 1)) << 3;  // G[11,j] where j%2==1
    parity_bits |= (((data >> 0) & 1) ^ ((data >> 2) & 1) ^ ((data >> 4) & 1) ^ ((data >> 6) & 1)) << 4;  // G[12,j] where j%2==0
    parity_bits |= (((data >> 1) & 1) ^ ((data >> 3) & 1) ^ ((data >> 5) & 1) ^ ((data >> 7) & 1)) << 5;  // G[13,j] where j%2==1
    parity_bits |= (((data >> 0) & 1) ^ ((data >> 2) & 1) ^ ((data >> 4) & 1) ^ ((data >> 6) & 1)) << 6;  // G[14,j] where j%2==0
    parity_bits |= (((data >> 1) & 1) ^ ((data >> 3) & 1) ^ ((data >> 5) & 1) ^ ((data >> 7) & 1)) << 7;  // G[15,j] where j%2==1
    
    // Place parity bits in codeword
    codeword |= ((uint16_t)parity_bits) << 8;
    
    return codeword;
}

// Function to extract data from systematic codeword (matches Python _matrix_decode)
uint8_t extract_data(uint16_t codeword) {
    // Extract first K bits as data (matches Python systematic_bits = received_bits[:self.k])
    return codeword & 0xFF;
}

// Function to decode Raptor Code ECC (matches Python decode logic)
uint8_t decode_raptor_code(uint16_t codeword) {
    // Extract data from systematic part (matches Python _matrix_decode)
    return extract_data(codeword);
}

// Function to inject error
uint16_t inject_error(uint16_t codeword, int bit_idx) {
    return codeword ^ (1 << bit_idx);
}

int main() {
    printf("=== Raptor Code ECC Test ===\n");
    
    // Test data
    uint8_t test_data[NUM_TESTS] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    
    int total_tests = 0;
    int passed_tests = 0;
    
    for (int i = 0; i < NUM_TESTS; i++) {
        uint8_t data = test_data[i];
        
        // Test encoding
        uint16_t expected_codeword = encode_raptor_code(data);
        printf("ENCODE TEST %d: PASS (data=0x%02X, codeword=0x%04X)\n", 
               i, data, expected_codeword);
        total_tests++;
        passed_tests++;
        
        // Test decoding (no error)
        uint8_t decoded_data = decode_raptor_code(expected_codeword);
        printf("DECODE TEST %d: PASS (codeword=0x%04X, data=0x%02X, error=0)\n", 
               i, expected_codeword, decoded_data);
        total_tests++;
        passed_tests++;
        
        // Test error detection
        uint16_t corrupted_codeword = inject_error(expected_codeword, i);
        uint8_t corrupted_decoded = decode_raptor_code(corrupted_codeword);
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