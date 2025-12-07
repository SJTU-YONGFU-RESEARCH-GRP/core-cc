#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vproduct_code_ecc.h"
#include "verilated.h"

// Python-like Product Code ECC calculation functions
typedef struct {
    int word_length;
    int sub_word_length;
    int num_sub_words;
    int hamming_n;
    int hamming_k;
    int hamming_m;
    int parity_n;
    int parity_k;
    int parity_m;
} ProductCodeConfig;

ProductCodeConfig* create_product_code_config(int word_length) {
    ProductCodeConfig* config = (ProductCodeConfig*)malloc(sizeof(ProductCodeConfig));
    
    config->word_length = word_length;
    
    if (word_length <= 4) {
        config->sub_word_length = 2;
    } else if (word_length <= 8) {
        config->sub_word_length = 4;
    } else if (word_length <= 16) {
        config->sub_word_length = 8;
    } else {
        config->sub_word_length = 16;
    }
    
    config->num_sub_words = (word_length + config->sub_word_length - 1) / config->sub_word_length;
    
    // Hamming SECDED parameters
    if (config->sub_word_length <= 4) {
        config->hamming_n = 8;
    } else if (config->sub_word_length <= 8) {
        config->hamming_n = 13;
    } else if (config->sub_word_length <= 16) {
        config->hamming_n = 22;
    } else {
        config->hamming_n = 32;
    }
    config->hamming_k = config->sub_word_length;
    config->hamming_m = config->hamming_n - config->hamming_k;
    
    // Parity ECC parameters
    config->parity_n = config->sub_word_length + 1;
    config->parity_k = config->sub_word_length;
    config->parity_m = 1;
    
    return config;
}

void free_product_code_config(ProductCodeConfig* config) {
    free(config);
}

// Pack data into sub-words
void pack_data(uint32_t data, uint32_t* sub_words, ProductCodeConfig* config) {
    uint32_t mask = (1 << config->sub_word_length) - 1;
    
    for (int i = 0; i < config->num_sub_words; i++) {
        sub_words[i] = (data >> (i * config->sub_word_length)) & mask;
    }
}

// Unpack sub-words back to data
uint32_t unpack_data(uint32_t* sub_words, ProductCodeConfig* config) {
    uint32_t data = 0;
    
    for (int i = 0; i < config->num_sub_words; i++) {
        data |= (sub_words[i] << (i * config->sub_word_length));
    }
    
    return data;
}

// Encode Hamming SECDED (simplified)
uint32_t encode_hamming(uint32_t data, ProductCodeConfig* config) {
    uint32_t codeword = 0;
    
    if (config->sub_word_length == 4) {
        // Simplified Hamming encoding for 4-bit data
        codeword |= ((data & 1) ^ ((data >> 1) & 1) ^ ((data >> 3) & 1)) << 0;  // P1
        codeword |= ((data & 1) ^ ((data >> 2) & 1) ^ ((data >> 3) & 1)) << 1;  // P2
        codeword |= (data & 1) << 2;                                             // D1
        codeword |= (((data >> 1) & 1) ^ ((data >> 2) & 1) ^ ((data >> 3) & 1)) << 3;  // P3
        codeword |= ((data >> 1) & 1) << 4;                                      // D2
        codeword |= ((data >> 2) & 1) << 5;                                      // D3
        codeword |= ((data >> 3) & 1) << 6;                                      // D4
        
        // Extended parity
        uint32_t extended_parity = 0;
        for (int i = 0; i < 7; i++) {
            extended_parity ^= (codeword >> i) & 1;
        }
        codeword |= extended_parity << 7;
    } else {
        codeword = data; // Fallback for other sizes
    }
    
    return codeword;
}

// Decode Hamming SECDED (simplified)
uint32_t decode_hamming(uint32_t codeword, ProductCodeConfig* config) {
    uint32_t data = 0;
    
    if (config->sub_word_length == 4) {
        // Simplified Hamming decoding for 4-bit data
        data |= ((codeword >> 2) & 1) << 0;  // D1
        data |= ((codeword >> 4) & 1) << 1;  // D2
        data |= ((codeword >> 5) & 1) << 2;  // D3
        data |= ((codeword >> 6) & 1) << 3;  // D4
    } else {
        data = codeword & ((1 << config->hamming_k) - 1); // Fallback for other sizes
    }
    
    return data;
}

// Encode Parity ECC
uint32_t encode_parity(uint32_t data, ProductCodeConfig* config) {
    uint32_t parity_bit = 0;
    
    for (int i = 0; i < config->parity_k; i++) {
        parity_bit ^= (data >> i) & 1;
    }
    
    return (parity_bit << config->parity_k) | data;
}

// Decode Parity ECC
uint32_t decode_parity(uint32_t codeword, ProductCodeConfig* config) {
    return codeword & ((1 << config->parity_k) - 1);
}

// Python-like Product Code ECC encoding
uint32_t encode_product_code_ecc(uint32_t data, ProductCodeConfig* config) {
    // Ensure data fits within word length
    data = data & ((1 << config->word_length) - 1);
    
    // Pack data into sub-words
    uint32_t sub_words[4];
    pack_data(data, sub_words, config);
    
    // Encode each sub-word with row ECC (Hamming SECDED)
    uint32_t row_encoded_words[4];
    for (int i = 0; i < config->num_sub_words; i++) {
        row_encoded_words[i] = encode_hamming(sub_words[i], config);
    }
    
    // Encode each sub-word with column ECC (Parity)
    uint32_t col_encoded_words[4];
    for (int i = 0; i < config->num_sub_words; i++) {
        col_encoded_words[i] = encode_parity(sub_words[i], config);
    }
    
    // Pack encoded words into a single codeword
    uint32_t codeword = 0;
    int bit_pos = 0;
    
    // Pack row encoded words
    for (int i = 0; i < config->num_sub_words; i++) {
        codeword |= (row_encoded_words[i] << bit_pos);
        bit_pos += config->hamming_n;
    }
    
    // Pack column encoded words
    for (int i = 0; i < config->num_sub_words; i++) {
        codeword |= (col_encoded_words[i] << bit_pos);
        bit_pos += config->parity_n;
    }
    
    return codeword;
}

// Python-like Product Code ECC decoding
uint32_t decode_product_code_ecc(uint32_t codeword, ProductCodeConfig* config, int* error_type) {
    uint32_t row_encoded_words[4];
    uint32_t col_encoded_words[4];
    int bit_pos = 0;
    
    // Extract row encoded words
    for (int i = 0; i < config->num_sub_words; i++) {
        row_encoded_words[i] = (codeword >> bit_pos) & ((1 << config->hamming_n) - 1);
        bit_pos += config->hamming_n;
    }
    
    // Extract column encoded words
    for (int i = 0; i < config->num_sub_words; i++) {
        col_encoded_words[i] = (codeword >> bit_pos) & ((1 << config->parity_n) - 1);
        bit_pos += config->parity_n;
    }
    
    // Decode each sub-word
    uint32_t decoded_sub_words[4];
    int error_detected = 0;
    
    for (int i = 0; i < config->num_sub_words; i++) {
        // Decode row (Hamming SECDED)
        decoded_sub_words[i] = decode_hamming(row_encoded_words[i], config);
        
        // Check for errors (simplified)
        if (row_encoded_words[i] != encode_hamming(decoded_sub_words[i], config)) {
            error_detected = 1;
        }
    }
    
    // Unpack decoded sub-words
    uint32_t decoded_data = unpack_data(decoded_sub_words, config);
    
    // Determine error type
    if (error_detected) {
        *error_type = 2; // detected
    } else {
        *error_type = 1; // corrected
    }
    
    return decoded_data;
}

// Test function
void test_product_code_ecc() {
    Vproduct_code_ecc* dut = new Vproduct_code_ecc();
    
    printf("=== Product Code ECC Test ===\n");
    
    // Test cases
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int data_width = 8;
    int pass_count = 0;
    int fail_count = 0;
    
    ProductCodeConfig* config = create_product_code_config(data_width);
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Calculate expected results (Python-like)
        uint32_t expected_codeword = encode_product_code_ecc(test_data, config);
        int expected_error_type;
        uint32_t expected_decoded_data = decode_product_code_ecc(expected_codeword, config, &expected_error_type);
        
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
            printf("ENCODE TEST %d: PASS (data=0x%02X, codeword=0x%08X)\n", 
                   i, test_data, dut->codeword_out);
            pass_count++;
        } else {
            printf("ENCODE TEST %d: FAIL (data=0x%02X, expected=0x%08X, got=0x%08X)\n", 
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
            printf("DECODE TEST %d: PASS (codeword=0x%08X, data=0x%02X, error_detected=%d, error_corrected=%d)\n", 
                   i, expected_codeword, dut->data_out, dut->error_detected, dut->error_corrected);
            pass_count++;
        } else {
            printf("DECODE TEST %d: FAIL (codeword=0x%08X, expected_data=0x%02X, got_data=0x%02X, expected_error_detected=%d, got_error_detected=%d, expected_error_corrected=%d, got_error_corrected=%d)\n", 
                   i, expected_codeword, expected_decoded_data, dut->data_out, expected_error_detected, dut->error_detected, expected_error_corrected, dut->error_corrected);
            fail_count++;
        }
        
        // Test error detection (corrupt one bit)
        uint32_t corrupted_codeword = expected_codeword ^ (1 << (i % 32)); // Corrupt one bit
        int corrupted_error_type;
        uint32_t corrupted_decoded_data = decode_product_code_ecc(corrupted_codeword, config, &corrupted_error_type);
        
        dut->codeword_in = corrupted_codeword;
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
        
        int corrupted_expected_error_detected = (corrupted_error_type == 2);
        int corrupted_expected_error_corrected = (corrupted_error_type == 1);
        
        if (dut->error_detected == corrupted_expected_error_detected &&
            dut->error_corrected == corrupted_expected_error_corrected) {
            printf("ERROR DETECTION TEST %d: PASS (corrupted_codeword=0x%08X, error_detected=%d, error_corrected=%d)\n", 
                   i, corrupted_codeword, dut->error_detected, dut->error_corrected);
            pass_count++;
        } else {
            printf("ERROR DETECTION TEST %d: FAIL (corrupted_codeword=0x%08X, expected_error_detected=%d, got_error_detected=%d, expected_error_corrected=%d, got_error_corrected=%d)\n", 
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
    
    free_product_code_config(config);
    delete dut;
}

int main() {
    test_product_code_ecc();
    return 0;
} 