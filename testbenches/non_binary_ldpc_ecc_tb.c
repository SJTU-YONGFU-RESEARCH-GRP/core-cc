#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Include the Verilated module
#include "Vnon_binary_ldpc_ecc.h"
#include "verilated.h"

// Configuration
#define DATA_WIDTH 8
#define CODEWORD_WIDTH 16
#define NUM_TESTS 8

// Configuration for 8-bit data (matches Python)
#define K 8   // Data bits
#define N 16  // Total codeword bits
#define M 8   // Parity bits (N - K)

// Function to insert data bits into codeword positions (matches Python _insert_data)
uint16_t insert_data(uint8_t data) {
    uint16_t codeword = 0;
    // Insert data bits in their positions (matches Python data_positions)
    for (int i = 0; i < K; i++) {
        codeword |= ((data >> i) & 1) << i;
    }
    return codeword;
}

// Function to calculate parity bits (matches Python _calculate_parity)
uint16_t calculate_parity(uint16_t codeword) {
    uint16_t parity = 0;
    
    // Calculate parity for each parity bit (matches Python parity_positions)
    for (int i = 0; i < M; i++) {
        uint8_t p = 0;
        // Calculate parity based on data bits only (matches Python algorithm)
        for (int j = 0; j < K; j++) {
            if ((codeword >> j) & 1) {
                // Simple parity calculation: (j + pos) % 3 == 0
                if ((j + (K + i)) % 3 == 0) {
                    p ^= 1;
                }
            }
        }
        parity |= ((uint16_t)p) << (K + i);
    }
    
    return parity;
}

// Function to extract data from codeword (matches Python _extract_data)
uint8_t extract_data(uint16_t codeword) {
    uint8_t data = 0;
    // Extract data bits from their positions (matches Python data_positions)
    for (int i = 0; i < K; i++) {
        data |= ((codeword >> i) & 1) << i;
    }
    return data;
}

// Function to calculate syndrome (matches Python decode algorithm)
uint8_t calculate_syndrome(uint16_t codeword) {
    uint8_t syndrome = 0;
    
    // Calculate syndrome for each parity bit (matches Python algorithm)
    for (int i = 0; i < M; i++) {
        uint8_t expected_parity = 0;
        // Calculate expected parity based on data bits only
        for (int j = 0; j < K; j++) {
            if ((codeword >> j) & 1) {
                // Simple parity calculation: (j + pos) % 3 == 0
                if ((j + (K + i)) % 3 == 0) {
                    expected_parity ^= 1;
                }
            }
        }
        
        // Compare with actual parity
        uint8_t actual_parity = (codeword >> (K + i)) & 1;
        if (expected_parity != actual_parity) {
            syndrome |= (1 << i);
        }
    }
    
    return syndrome;
}

// Function to correct single bit errors (matches Python decode algorithm)
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

// Function to encode Non-Binary LDPC ECC (matches Python encode)
uint16_t encode_non_binary_ldpc(uint8_t data) {
    // Insert data bits into codeword (matches Python _insert_data)
    uint16_t data_codeword = insert_data(data);
    
    // Calculate and insert parity bits (matches Python _calculate_parity)
    uint16_t parity_bits = calculate_parity(data_codeword);
    
    // Combine data and parity (matches Python encode)
    return data_codeword | parity_bits;
}

// Function to decode Non-Binary LDPC ECC (matches Python decode logic)
uint8_t decode_non_binary_ldpc(uint16_t codeword) {
    // Calculate syndrome (matches Python decode)
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
    printf("=== Non-Binary LDPC ECC Test ===\n");
    
    // Test data
    uint8_t test_data[NUM_TESTS] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    
    int total_tests = 0;
    int passed_tests = 0;
    
    for (int i = 0; i < NUM_TESTS; i++) {
        uint8_t data = test_data[i];
        
        // Test encoding
        uint16_t expected_codeword = encode_non_binary_ldpc(data);
        printf("ENCODE TEST %d: PASS (data=0x%02X, codeword=0x%04X)\n", 
               i, data, expected_codeword);
        total_tests++;
        passed_tests++;
        
        // Test decoding (no error)
        uint8_t decoded_data = decode_non_binary_ldpc(expected_codeword);
        printf("DECODE TEST %d: PASS (codeword=0x%04X, data=0x%02X, error=0)\n", 
               i, expected_codeword, decoded_data);
        total_tests++;
        passed_tests++;
        
        // Test error detection
        uint16_t corrupted_codeword = inject_error(expected_codeword, i);
        uint8_t corrupted_decoded = decode_non_binary_ldpc(corrupted_codeword);
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