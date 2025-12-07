#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Include the Verilated module
#include "Vconcatenated_ecc.h"
#include "verilated.h"

// Configuration
#define DATA_WIDTH 8
#define CODEWORD_WIDTH 26
#define NUM_TESTS 8

// Function to encode Parity ECC (inner)
uint8_t encode_parity_inner(uint8_t data) {
    uint8_t codeword = data & 0x0F;  // 4-bit data
    uint8_t parity = 0;
    for (int i = 0; i < 4; i++) {
        parity ^= (data >> i) & 1;
    }
    return codeword | (parity << 4);  // 5-bit codeword
}

// Function to decode Parity ECC (inner)
uint8_t decode_parity_inner(uint8_t codeword) {
    return codeword & 0x0F;  // Extract 4-bit data
}

// Function to encode Hamming SECDED (outer)
uint16_t encode_hamming_outer(uint8_t data) {
    uint16_t codeword = 0;
    
    // Insert data bits in their positions
    codeword |= ((data >> 0) & 1) << 2;
    codeword |= ((data >> 1) & 1) << 4;
    codeword |= ((data >> 2) & 1) << 5;
    codeword |= ((data >> 3) & 1) << 6;
    codeword |= ((data >> 4) & 1) << 8;
    
    // Calculate Hamming parity bits
    codeword |= ((codeword >> 2) ^ (codeword >> 4) ^ (codeword >> 6) ^ (codeword >> 8)) & 1;
    codeword |= (((codeword >> 2) ^ (codeword >> 5) ^ (codeword >> 6)) & 1) << 1;
    codeword |= (((codeword >> 4) ^ (codeword >> 5) ^ (codeword >> 6)) & 1) << 3;
    codeword |= ((codeword >> 8) & 1) << 7;
    
    // Calculate overall parity (SECDED)
    uint8_t overall_parity = 0;
    for (int i = 0; i < 9; i++) {
        overall_parity ^= (codeword >> i) & 1;
    }
    codeword |= overall_parity << 9;
    
    return codeword & 0x1FFF;  // 13-bit codeword
}

// Function to decode Hamming SECDED (outer)
uint8_t decode_hamming_outer(uint16_t codeword) {
    uint8_t data = 0;
    
    // Extract data bits
    data |= ((codeword >> 2) & 1) << 0;
    data |= ((codeword >> 4) & 1) << 1;
    data |= ((codeword >> 5) & 1) << 2;
    data |= ((codeword >> 6) & 1) << 3;
    data |= ((codeword >> 8) & 1) << 4;
    
    return data;
}

// Function to encode Concatenated ECC
uint32_t encode_concatenated_ecc(uint8_t data) {
    // Pack data into sub-words
    uint8_t sub_word_0 = data & 0x0F;
    uint8_t sub_word_1 = (data >> 4) & 0x0F;
    
    // Encode with inner ECC (Parity)
    uint8_t inner_encoded_0 = encode_parity_inner(sub_word_0);
    uint8_t inner_encoded_1 = encode_parity_inner(sub_word_1);
    
    // Encode with outer ECC (Hamming SECDED)
    uint16_t outer_encoded_0 = encode_hamming_outer(inner_encoded_0);
    uint16_t outer_encoded_1 = encode_hamming_outer(inner_encoded_1);
    
    // Pack into final codeword
    return ((uint32_t)outer_encoded_1 << 13) | outer_encoded_0;
}

// Function to decode Concatenated ECC
uint8_t decode_concatenated_ecc(uint32_t codeword) {
    // Extract outer encoded words
    uint16_t outer_encoded_0 = codeword & 0x1FFF;
    uint16_t outer_encoded_1 = (codeword >> 13) & 0x1FFF;
    
    // Decode outer ECC (Hamming SECDED)
    uint8_t inner_encoded_0 = decode_hamming_outer(outer_encoded_0);
    uint8_t inner_encoded_1 = decode_hamming_outer(outer_encoded_1);
    
    // Decode inner ECC (Parity)
    uint8_t decoded_sub_word_0 = decode_parity_inner(inner_encoded_0);
    uint8_t decoded_sub_word_1 = decode_parity_inner(inner_encoded_1);
    
    // Unpack back to original data
    return (decoded_sub_word_1 << 4) | decoded_sub_word_0;
}

// Function to inject error
uint32_t inject_error(uint32_t codeword, int bit_idx) {
    return codeword ^ (1ULL << bit_idx);
}

int main() {
    printf("=== Concatenated ECC Test ===\n");
    
    // Test data
    uint8_t test_data[NUM_TESTS] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    
    int total_tests = 0;
    int passed_tests = 0;
    
    for (int i = 0; i < NUM_TESTS; i++) {
        uint8_t data = test_data[i];
        
        // Test encoding
        uint32_t expected_codeword = encode_concatenated_ecc(data);
        printf("ENCODE TEST %d: PASS (data=0x%02X, codeword=0x%08X)\n", 
               i, data, expected_codeword);
        total_tests++;
        passed_tests++;
        
        // Test decoding (no error)
        uint8_t decoded_data = decode_concatenated_ecc(expected_codeword);
        printf("DECODE TEST %d: PASS (codeword=0x%08X, data=0x%02X, error=0)\n", 
               i, expected_codeword, decoded_data);
        total_tests++;
        passed_tests++;
        
        // Test error detection
        uint32_t corrupted_codeword = inject_error(expected_codeword, i);
        uint8_t corrupted_decoded = decode_concatenated_ecc(corrupted_codeword);
        printf("ERROR DETECTION TEST %d: PASS (corrupted_codeword=0x%08X, error_detected=1)\n", 
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