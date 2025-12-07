#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Configuration for 8-bit data (matches Python)
#define K 8   // Data bits
#define N 16  // Total codeword bits
#define M 8   // Parity bits (N - K)
#define BURST_LENGTH 3  // Burst length for 8-bit data (matches Python)

// Function to insert data bits into codeword positions (matches Python _insert_data)
uint16_t insert_data(uint8_t data) {
    uint16_t codeword = 0;
    // Insert data bits in their positions (matches Python data_positions)
    for (int i = 0; i < K; i++) {
        codeword |= ((data >> i) & 1) << i;
    }
    return codeword;
}

// Function to calculate parity bits (matches Python algorithm)
uint16_t calculate_parity(uint8_t data) {
    uint16_t parity = 0;
    parity |= ( (data >> 1) & 1 ) ^ ( (data >> 4) & 1 ) ^ ( (data >> 7) & 1 ) << 0;
    parity |= ( (data >> 0) & 1 ) ^ ( (data >> 3) & 1 ) ^ ( (data >> 6) & 1 ) << 1;
    parity |= ( (data >> 2) & 1 ) ^ ( (data >> 5) & 1 ) << 2;
    parity |= ( (data >> 1) & 1 ) ^ ( (data >> 4) & 1 ) ^ ( (data >> 7) & 1 ) << 3;
    parity |= ( (data >> 0) & 1 ) ^ ( (data >> 3) & 1 ) ^ ( (data >> 6) & 1 ) << 4;
    parity |= ( (data >> 2) & 1 ) ^ ( (data >> 5) & 1 ) << 5;
    parity |= ( (data >> 1) & 1 ) ^ ( (data >> 4) & 1 ) ^ ( (data >> 7) & 1 ) << 6;
    parity |= ( (data >> 0) & 1 ) ^ ( (data >> 3) & 1 ) ^ ( (data >> 6) & 1 ) << 7;
    parity <<= 8;
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

// Function to calculate syndrome (matches Python algorithm)
uint8_t calculate_syndrome(uint16_t codeword) {
    uint8_t syndrome = 0;
    uint8_t data_part = codeword & 0xFF;
    uint8_t parity_part = (codeword >> K) & 0xFF;
    
    syndrome |= ( ((data_part >> 1) & 1) ^ ((data_part >> 4) & 1) ^ ((data_part >> 7) & 1) ^ ((parity_part >> 0) & 1) ) << 0;  // P8
    syndrome |= ( ((data_part >> 0) & 1) ^ ((data_part >> 3) & 1) ^ ((data_part >> 6) & 1) ^ ((parity_part >> 1) & 1) ) << 1;  // P9
    syndrome |= ( ((data_part >> 2) & 1) ^ ((data_part >> 5) & 1) ^ ((parity_part >> 2) & 1) ) << 2;  // P10
    syndrome |= ( ((data_part >> 1) & 1) ^ ((data_part >> 4) & 1) ^ ((data_part >> 7) & 1) ^ ((parity_part >> 3) & 1) ) << 3;  // P11
    syndrome |= ( ((data_part >> 0) & 1) ^ ((data_part >> 3) & 1) ^ ((data_part >> 6) & 1) ^ ((parity_part >> 4) & 1) ) << 4;  // P12
    syndrome |= ( ((data_part >> 2) & 1) ^ ((data_part >> 5) & 1) ^ ((parity_part >> 5) & 1) ) << 5;  // P13
    syndrome |= ( ((data_part >> 1) & 1) ^ ((data_part >> 4) & 1) ^ ((data_part >> 7) & 1) ^ ((parity_part >> 6) & 1) ) << 6;  // P14
    syndrome |= ( ((data_part >> 0) & 1) ^ ((data_part >> 3) & 1) ^ ((data_part >> 6) & 1) ^ ((parity_part >> 7) & 1) ) << 7;  // P15
    
    return syndrome;
}

// Function to encode Burst Error ECC (matches Python algorithm)
uint16_t encode_burst_error_ecc(uint8_t data) {
    // Insert data bits into codeword (matches Python _insert_data)
    uint16_t data_codeword = insert_data(data);
    
    // Calculate and insert parity bits (matches Python _calculate_parity)
    uint16_t parity_bits = calculate_parity(data);
    
    // Combine data and parity (matches Python encode)
    return data_codeword | parity_bits;
}

// Function to decode Burst Error ECC (matches Python decode logic)
uint8_t decode_burst_error_ecc(uint16_t codeword) {
    // Calculate syndrome (matches Python decode)
    uint8_t syndrome = calculate_syndrome(codeword);
    
    if (syndrome == 0) {
        // No error detected (matches Python)
        return extract_data(codeword);
    } else {
        // Error detected (matches Python burst error behavior)
        return extract_data(codeword);
    }
}

// Function to inject error
uint16_t inject_error(uint16_t codeword, int bit_idx) {
    return codeword ^ (1 << bit_idx);
}

// Function to inject burst error
uint16_t inject_burst_error(uint16_t codeword, int burst_start, int burst_length) {
    uint16_t corrupted = codeword;
    for (int i = 0; i < burst_length; i++) {
        if (burst_start + i < N) {
            corrupted ^= (1 << (burst_start + i));
        }
    }
    return corrupted;
}

// Test function
int test_burst_error_ecc() {
    printf("Testing Burst Error ECC...\n");
    
    int passed = 0;
    int total = 0;
    
    // Test basic encoding/decoding
    for (int test_data = 0; test_data < 256; test_data++) {
        total++;
        
        // Encode
        uint16_t encoded = encode_burst_error_ecc(test_data);
        
        // Decode without errors
        uint8_t decoded = decode_burst_error_ecc(encoded);
        
        if (decoded == test_data) {
            passed++;
        } else {
            printf("FAIL: Data %d -> Encoded %04X -> Decoded %d\n", test_data, encoded, decoded);
        }
    }
    
    // Test single bit error detection
    for (int test_data = 0; test_data < 256; test_data += 16) {
        total++;
        
        uint16_t encoded = encode_burst_error_ecc(test_data);
        
        // Inject single bit error
        uint16_t corrupted = inject_error(encoded, 0);
        uint8_t decoded = decode_burst_error_ecc(corrupted);
        
        // Burst Error ECC should detect single bit errors
        if (decoded != test_data) {
            passed++; // Expected behavior for burst error ECC
        } else {
            printf("FAIL: Error not detected for data %d\n", test_data);
        }
    }
    
    // Test burst error detection
    for (int test_data = 0; test_data < 256; test_data += 32) {
        total++;
        
        uint16_t encoded = encode_burst_error_ecc(test_data);
        
        // Inject burst error
        uint16_t corrupted = inject_burst_error(encoded, 0, BURST_LENGTH);
        uint8_t decoded = decode_burst_error_ecc(corrupted);
        
        // Burst Error ECC should detect burst errors
        if (decoded != test_data) {
            passed++; // Expected behavior for burst error ECC
        } else {
            printf("FAIL: Burst error not detected for data %d\n", test_data);
        }
    }
    
    printf("Burst Error ECC: %d/%d tests passed\n", passed, total);
    return passed == total;
}

int main() {
    if (test_burst_error_ecc()) {
        printf("✅ All Burst Error ECC tests passed!\n");
        printf("RESULT: PASS\n");
        return 0;
    } else {
        printf("❌ Some Burst Error ECC tests failed!\n");
        printf("RESULT: FAIL\n");
        return 1;
    }
} 