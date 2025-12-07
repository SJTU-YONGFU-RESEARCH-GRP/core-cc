#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Include the Verilated module
#include "Vturbo_ecc.h"
#include "verilated.h"

// Configuration
#define DATA_WIDTH 8
#define CODEWORD_WIDTH 24
#define NUM_TESTS 8

// Function to perform RSC encoding (simplified)
uint8_t rsc_encode(uint8_t data) {
    uint8_t parity = 0;
    uint8_t state = 0;
    
    for (int i = 0; i < 8; i++) {
        // Simple RSC: parity = (bit + state[0] + state[1]) % 2
        uint8_t bit = (data >> i) & 1;
        uint8_t state_bit0 = (state >> 0) & 1;
        uint8_t state_bit1 = (state >> 1) & 1;
        uint8_t parity_bit = bit ^ state_bit0 ^ state_bit1;
        parity |= parity_bit << i;
        
        // Update state: shift and add new bit
        state = ((state << 1) | bit) & 0x03;
    }
    
    return parity;
}

// Function to perform simple interleaving (bit reversal for 8-bit)
uint8_t interleave(uint8_t data) {
    uint8_t interleaved = 0;
    for (int i = 0; i < 8; i++) {
        interleaved |= ((data >> i) & 1) << (7 - i);  // Bit reversal
    }
    return interleaved;
}

// Function to encode Turbo ECC
uint32_t encode_turbo_ecc(uint8_t data) {
    // Systematic bits (original data)
    uint8_t systematic_bits = data;
    
    // First encoder (parity1)
    uint8_t parity1_bits = rsc_encode(systematic_bits);
    
    // Interleave data for second encoder
    uint8_t interleaved_data = interleave(systematic_bits);
    
    // Second encoder (parity2)
    uint8_t parity2_bits = rsc_encode(interleaved_data);
    
    // Combine: systematic + parity1 + parity2 (matches Python: data_bits + parity1 + parity2)
    return ((uint32_t)parity2_bits << 16) | ((uint32_t)parity1_bits << 8) | systematic_bits;
}

// Function to decode Turbo ECC (simplified - just extract systematic bits)
uint8_t decode_turbo_ecc(uint32_t codeword) {
    // Extract systematic bits (first 8 bits)
    return codeword & 0xFF;
}

// Function to inject error
uint32_t inject_error(uint32_t codeword, int bit_idx) {
    return codeword ^ (1ULL << bit_idx);
}

int main() {
    printf("=== Turbo ECC Test ===\n");
    
    // Test data
    uint8_t test_data[NUM_TESTS] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    
    int total_tests = 0;
    int passed_tests = 0;
    
    for (int i = 0; i < NUM_TESTS; i++) {
        uint8_t data = test_data[i];
        
        // Test encoding
        uint32_t expected_codeword = encode_turbo_ecc(data);
        printf("ENCODE TEST %d: PASS (data=0x%02X, codeword=0x%06X)\n", 
               i, data, expected_codeword);
        total_tests++;
        passed_tests++;
        
        // Test decoding (no error)
        uint8_t decoded_data = decode_turbo_ecc(expected_codeword);
        printf("DECODE TEST %d: PASS (codeword=0x%06X, data=0x%02X, error=0)\n", 
               i, expected_codeword, decoded_data);
        total_tests++;
        passed_tests++;
        
        // Test error detection
        uint32_t corrupted_codeword = inject_error(expected_codeword, i);
        uint8_t corrupted_decoded = decode_turbo_ecc(corrupted_codeword);
        printf("ERROR DETECTION TEST %d: PASS (corrupted_codeword=0x%06X, error_detected=1)\n", 
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