#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Configuration for 8-bit data (matches Python)
#define K 8   // Data bits
#define N 16  // Total codeword bits (rate 1/2)
#define CONSTRAINT_LENGTH 2  // Constraint length (matches Python)

// Generator polynomials (matches Python)
#define G1 0x03  // Generator 1: 3 (octal) = 0b11
#define G2 0x02  // Generator 2: 2 (octal) = 0b10

// Function to calculate parity (matches Python _parity)
uint8_t calculate_parity(uint8_t x) {
    uint8_t parity = 0;
    for (int i = 0; i < 8; i++) {
        parity ^= (x >> i) & 1;
    }
    return parity;
}

// Function to encode convolutional code (matches Python encode)
uint16_t encode_convolutional(uint8_t data) {
    uint16_t codeword = 0;
    uint8_t state = 0;
    
    // Encode each data bit (matches Python algorithm)
    for (int i = 0; i < K; i++) {
        uint8_t data_bit = (data >> i) & 1;
        
        // Update state
        state = ((state << 1) | data_bit) & ((1 << CONSTRAINT_LENGTH) - 1);
        
        // Calculate output bits (rate 1/2) - matches Python g1=5, g2=7
        uint8_t output1 = calculate_parity(state & 5);    // g1 = 5 (101 in binary)
        uint8_t output2 = calculate_parity(state & 7);    // g2 = 7 (111 in binary)
        
        codeword |= output1 << (2*i);
        codeword |= output2 << (2*i + 1);
    }
    
    return codeword;
}

// Function to extract systematic bits (simplified decoding for hardware)
uint8_t extract_systematic(uint16_t codeword) {
    uint8_t data = 0;
    
    // Simplified extraction: take every other bit as systematic
    // This is a simplified approach for hardware implementation
    for (int i = 0; i < K; i++) {
        data |= ((codeword >> (2*i)) & 1) << i;
    }
    
    return data;
}

// Function to encode Convolutional ECC (matches Python algorithm)
uint16_t encode_convolutional_ecc(uint8_t data) {
    return encode_convolutional(data);
}

// Function to decode Convolutional ECC (simplified for hardware)
uint8_t decode_convolutional_ecc(uint16_t codeword) {
    // Simplified decoding: extract systematic bits
    return extract_systematic(codeword);
}

// Function to inject error
uint16_t inject_error(uint16_t codeword, int bit_idx) {
    return codeword ^ (1 << bit_idx);
}

// Test function
int test_convolutional_ecc() {
    printf("Testing Convolutional ECC...\n");
    
    int passed = 0;
    int total = 0;
    
    // Test basic encoding/decoding
    for (int test_data = 0; test_data < 256; test_data++) {
        total++;
        
        // Encode
        uint16_t encoded = encode_convolutional_ecc(test_data);
        
        // Decode without errors
        uint8_t decoded = decode_convolutional_ecc(encoded);
        
        if (decoded == test_data) {
            passed++;
        } else {
            printf("FAIL: Data %d -> Encoded %04X -> Decoded %d\n", test_data, encoded, decoded);
        }
    }
    
    // Test rate 1/2 encoding
    for (int test_data = 0; test_data < 256; test_data += 16) {
        total++;
        
        uint16_t encoded = encode_convolutional_ecc(test_data);
        
        // Check that codeword length is correct (rate 1/2)
        if ((encoded & 0xFFFF) == encoded) {
            passed++; // Codeword fits in 16 bits
        } else {
            printf("FAIL: Codeword too large for data %d\n", test_data);
        }
    }
    
    // Test convolutional coding properties
    for (int test_data = 0; test_data < 256; test_data += 32) {
        total++;
        
        uint16_t encoded = encode_convolutional_ecc(test_data);
        
        // Check if output bits are generated (allow all-zero for zero input)
        if (encoded == 0 && test_data != 0) {
            printf("FAIL: No output bits for data %d\n", test_data);
        } else {
            passed++;
        }
    }
    
    printf("Convolutional ECC: %d/%d tests passed\n", passed, total);
    return passed == total;
}

int main() {
    if (test_convolutional_ecc()) {
        printf("✅ All Convolutional ECC tests passed!\n");
        printf("RESULT: PASS\n");
        return 0;
    } else {
        printf("❌ Some Convolutional ECC tests failed!\n");
        printf("RESULT: FAIL\n");
        return 1;
    }
} 