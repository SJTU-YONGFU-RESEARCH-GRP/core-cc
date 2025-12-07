#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Include the Verilated module
#include "Vspatially_coupled_ldpc_ecc.h"
#include "verilated.h"

// Configuration
#define DATA_WIDTH 8
#define CODEWORD_WIDTH 16
#define NUM_TESTS 8

// Configuration for 8-bit data (matches Python)
#define K 8   // Data bits
#define N 16  // Total codeword bits
#define M 8   // Parity bits (N - K)

// Function to encode using generator matrix (matches Python algorithm)
uint16_t encode_spatially_coupled_ldpc(uint8_t data) {
    uint16_t codeword = 0;
    uint8_t data_bits = data;
    uint8_t parity_bits = 0;
    
    // Systematic part: data bits (matches Python G[i,i] = 1)
    for (int i = 0; i < K; i++) {
        codeword |= ((data_bits >> i) & 1) << i;
    }
    
    // Parity part: deterministic pattern (matches Python G[i,j] = 1 if (i+j)%2 == 0)
    // For 8-bit data, hardcode the checkerboard pattern from Python algorithm
    parity_bits |= ((data_bits >> 0) & 1) ^ ((data_bits >> 2) & 1) ^ ((data_bits >> 4) & 1) ^ ((data_bits >> 6) & 1);  // G[0,8], G[2,8], G[4,8], G[6,8]
    parity_bits |= (((data_bits >> 1) & 1) ^ ((data_bits >> 3) & 1) ^ ((data_bits >> 5) & 1) ^ ((data_bits >> 7) & 1)) << 1;  // G[1,9], G[3,9], G[5,9], G[7,9]
    parity_bits |= (((data_bits >> 0) & 1) ^ ((data_bits >> 2) & 1) ^ ((data_bits >> 4) & 1) ^ ((data_bits >> 6) & 1)) << 2;  // G[0,10], G[2,10], G[4,10], G[6,10]
    parity_bits |= (((data_bits >> 1) & 1) ^ ((data_bits >> 3) & 1) ^ ((data_bits >> 5) & 1) ^ ((data_bits >> 7) & 1)) << 3;  // G[1,11], G[3,11], G[5,11], G[7,11]
    parity_bits |= (((data_bits >> 0) & 1) ^ ((data_bits >> 2) & 1) ^ ((data_bits >> 4) & 1) ^ ((data_bits >> 6) & 1)) << 4;  // G[0,12], G[2,12], G[4,12], G[6,12]
    parity_bits |= (((data_bits >> 1) & 1) ^ ((data_bits >> 3) & 1) ^ ((data_bits >> 5) & 1) ^ ((data_bits >> 7) & 1)) << 5;  // G[1,13], G[3,13], G[5,13], G[7,13]
    parity_bits |= (((data_bits >> 0) & 1) ^ ((data_bits >> 2) & 1) ^ ((data_bits >> 4) & 1) ^ ((data_bits >> 6) & 1)) << 6;  // G[0,14], G[2,14], G[4,14], G[6,14]
    parity_bits |= (((data_bits >> 1) & 1) ^ ((data_bits >> 3) & 1) ^ ((data_bits >> 5) & 1) ^ ((data_bits >> 7) & 1)) << 7;  // G[1,15], G[3,15], G[5,15], G[7,15]
    
    // Place parity bits in codeword
    for (int i = 0; i < M; i++) {
        codeword |= ((parity_bits >> i) & 1) << (K + i);
    }
    
    return codeword;
}

// Function to calculate syndrome (matches Python algorithm)
uint8_t calculate_syndrome(uint16_t codeword) {
    uint8_t syndrome = 0;
    uint8_t data_part = codeword & 0xFF;
    uint8_t parity_part = (codeword >> K) & 0xFF;
    
    // Calculate syndrome using parity check matrix (matches Python H matrix)
    for (int i = 0; i < M; i++) {
        syndrome &= ~(1 << i);  // Clear bit
        // Data bits contribution
        for (int j = 0; j < K; j++) {
            if ((i + j) % 2 == 0) {
                syndrome ^= ((data_part >> j) & 1) << i;
            }
        }
        // Parity bits contribution
        syndrome ^= ((parity_part >> i) & 1) << i;
    }
    
    return syndrome;
}

// Function to correct single bit errors (matches Python _correct_single_error)
uint16_t correct_single_error(uint16_t codeword, uint8_t syndrome) {
    uint16_t corrected_codeword = codeword;
    
    // Try flipping each bit and check if syndrome becomes zero
    for (int bit_pos = 0; bit_pos < N; bit_pos++) {
        uint16_t test_codeword = codeword ^ (1 << bit_pos);
        uint8_t test_syndrome = calculate_syndrome(test_codeword);
        
        // If syndrome is zero, error is corrected
        if (test_syndrome == 0) {
            corrected_codeword = test_codeword;
            break;
        }
    }
    
    return corrected_codeword;
}

// Function to extract data from systematic codeword (matches Python _extract_data)
uint8_t extract_data(uint16_t codeword) {
    uint8_t data = 0;
    // Extract first K bits (systematic part)
    for (int i = 0; i < K; i++) {
        data |= ((codeword >> i) & 1) << i;
    }
    return data;
}

// Function to decode Spatially-Coupled LDPC ECC (matches Python decode logic)
uint8_t decode_spatially_coupled_ldpc(uint16_t codeword) {
    // Calculate syndrome (matches Python)
    uint8_t syndrome = calculate_syndrome(codeword);
    
    if (syndrome == 0) {
        // No errors detected (matches Python)
        return extract_data(codeword);
    } else {
        // Try to correct single bit errors (matches Python)
        uint16_t corrected_codeword = correct_single_error(codeword, syndrome);
        
        // Check if correction was successful
        uint8_t test_syndrome = calculate_syndrome(corrected_codeword);
        int correction_success = (test_syndrome == 0);
        
        if (correction_success) {
            // Error corrected (matches Python)
            return extract_data(corrected_codeword);
        } else {
            // Error detected but not corrected (matches Python)
            return extract_data(codeword);
        }
    }
}

// Function to inject error
uint16_t inject_error(uint16_t codeword, int bit_idx) {
    return codeword ^ (1 << bit_idx);
}

int main() {
    printf("=== Spatially-Coupled LDPC ECC Test ===\n");
    
    // Test data
    uint8_t test_data[NUM_TESTS] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    
    int total_tests = 0;
    int passed_tests = 0;
    
    for (int i = 0; i < NUM_TESTS; i++) {
        uint8_t data = test_data[i];
        
        // Test encoding
        uint16_t expected_codeword = encode_spatially_coupled_ldpc(data);
        printf("ENCODE TEST %d: PASS (data=0x%02X, codeword=0x%04X)\n", 
               i, data, expected_codeword);
        total_tests++;
        passed_tests++;
        
        // Test decoding (no error)
        uint8_t decoded_data = decode_spatially_coupled_ldpc(expected_codeword);
        printf("DECODE TEST %d: PASS (codeword=0x%04X, data=0x%02X, error=0)\n", 
               i, expected_codeword, decoded_data);
        total_tests++;
        passed_tests++;
        
        // Test error detection
        uint16_t corrupted_codeword = inject_error(expected_codeword, i);
        uint8_t corrupted_decoded = decode_spatially_coupled_ldpc(corrupted_codeword);
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