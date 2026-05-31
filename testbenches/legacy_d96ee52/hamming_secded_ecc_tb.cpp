#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>
#include <time.h>

// Verilator generated header
#include "Vhamming_secded_ecc.h"
#include "verilated.h"
#include "ecc_test_utils.h"

// Configuration for Hamming SECDED codes
typedef struct {
    int n;  // Codeword length
    int k;  // Data length
    int parity_bits;
    int parity_positions[8];  // Max 8 parity bits for 128-bit data
    int data_positions[128];  // Max 128 data positions
} HammingConfig;

// Auto-detect DATA_WIDTH from the DUT
#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

// Helper macros for wide port access
#if DATA_WIDTH > 64
    #define SET_DATA_IN(dut, val) \
        do { \
            for(int w=0; w<MAX_WORDS && w*32 < DATA_WIDTH; w++) \
                (dut)->data_in[w] = (val).words[w]; \
        } while(0)
        
    #define GET_DATA_OUT(dut, val) \
        do { \
            (val).clear(); \
            for(int w=0; w<MAX_WORDS && w*32 < DATA_WIDTH; w++) \
                (val).words[w] = (dut)->data_out[w]; \
        } while(0)

    // Codeword is wider than data
    // Use sizeof to safely determine number of words
    #define SET_CODEWORD_IN(dut, val) \
        do { \
            int nwords = sizeof((dut)->codeword_in) / sizeof(uint32_t); \
            for(int w=0; w<nwords && w<MAX_WORDS; w++) \
                (dut)->codeword_in[w] = (val).words[w]; \
        } while(0)

    #define GET_CODEWORD_OUT(dut, val) \
        do { \
            (val).clear(); \
            int nwords = sizeof((dut)->codeword_out) / sizeof(uint32_t); \
            for(int w=0; w<nwords && w<MAX_WORDS; w++) \
                (val).words[w] = (dut)->codeword_out[w]; \
        } while(0)

#else
    // Scalar ports (QData = uint64_t or IData = uint32_t)
    #define SET_DATA_IN(dut, val) (dut)->data_in = to_u64(val)
    #define GET_DATA_OUT(dut, val) (val) = from_u64((dut)->data_out)
    
    // Codeword might be > 64 if DATA_WIDTH > 57 (approx)
    // For DATA_WIDTH=64, N=71. Verilator makes this WData (array).
    // So distinct check for codeword width may be needed.
    // Let's assume >64 implies WData for codeword too.
    
    #if DATA_WIDTH > 57
        #define SET_CODEWORD_IN(dut, val) \
            do { \
                for(int w=0; w<3; w++) (dut)->codeword_in[w] = (val).words[w]; \
            } while(0)
        #define GET_CODEWORD_OUT(dut, val) \
             do { \
                (val).clear(); \
                for(int w=0; w<3; w++) (val).words[w] = (dut)->codeword_out[w]; \
            } while(0)
    #else
        #define SET_CODEWORD_IN(dut, val) (dut)->codeword_in = to_u64(val)
        #define GET_CODEWORD_OUT(dut, val) (val) = from_u64((dut)->codeword_out)
    #endif

#endif

void init_hamming_config(HammingConfig* config, int word_length) {
    if (word_length <= 4) {
        config->n = 7;  config->k = 4;  config->parity_bits = 3;
        config->parity_positions[0]=0; config->parity_positions[1]=1; config->parity_positions[2]=3;
    } else if (word_length <= 8) {
        config->n = 12;  config->k = 8;  config->parity_bits = 4;
        static const int pp[] = {0, 1, 3, 7};
        memcpy(config->parity_positions, pp, 4*sizeof(int));
    } else if (word_length <= 16) {
        config->n = 21;  config->k = 16;  config->parity_bits = 5;
        static const int pp[] = {0, 1, 3, 7, 15};
        memcpy(config->parity_positions, pp, 5*sizeof(int));
    } else if (word_length <= 32) {
        config->n = 38;  config->k = 32;  config->parity_bits = 6;
        static const int pp[] = {0, 1, 3, 7, 15, 31};
        memcpy(config->parity_positions, pp, 6*sizeof(int));
    } else if (word_length <= 64) {
        config->n = 71;  config->k = 64;  config->parity_bits = 7;
        static const int pp[] = {0, 1, 3, 7, 15, 31, 63};
        memcpy(config->parity_positions, pp, 7*sizeof(int));
    } else { // 128
        config->n = 137; config->k = 128; config->parity_bits = 9; // Not 8? log2(128+p+1). 128+8=136. 136 is not power of 2. Next is 256.
        // Wait. N = 2^r - 1.
        // For K=128.
        // 128 + r <= 2^r - 1.
        // r=8 -> 128+8 = 136 <= 255. Yes.
        // So Parity bits = 8? 
        // 0,1,3,7,15,31,63,127.
        // Code positions: 1, 2, 4, 8, 16, 32, 64, 128.
        // N = 128 + 8 = 136?
        // Wait, Extended Hamming usually adds one more.
        // Hamming(N,K).
        // If K=128.
        // bits: 1..M.
        // Parity at 1,2,4...
        // Last parity at 128.
        // So total length is at least 128 + parity bits.
        // If we have parity at 128, that covers position 128.
        // Data bits start filling empty slots.
        // Let's trust the calc:
        // P0 (1), P1 (2), P2 (4), P3 (8), P4 (16), P5 (32), P6 (64), P7 (128).
        // 8 parity bits.
        // Max index covered is 255.
        // We use slots 1..K+r.
        // Total bits = 128 + 8 = 136.
        // Wait, standard Hamming is (2^r-1, 2^r-1-r).
        // (255, 247).
        // We shorten it to (136, 128).
        // Yes.
        // But what about parameter logic? 
        // Python code says: r = 0; while (1<<r) < (n + r + 1): r += 1
        // For k=128:
        // r=7, 128 < 128+7+1 (136). Fail.
        // r=8, 256 >= 128+8+1 = 137. Pass.
        // So r=8.
        config->parity_bits = 8;
        config->n = config->k + config->parity_bits;
        static const int pp[] = {0, 1, 3, 7, 15, 31, 63, 127};
        memcpy(config->parity_positions, pp, 8*sizeof(int));
    }

    // Calculate data positions
    int idx = 0;
    for (int i = 0; i < config->n; i++) {
        int is_parity = 0;
        for (int p = 0; p < config->parity_bits; p++) {
            if (i == config->parity_positions[p]) { is_parity = 1; break; }
        }
        if (!is_parity) {
            config->data_positions[idx++] = i;
        }
    }
}

BitArray extract_data(const BitArray& codeword, HammingConfig* config) {
    BitArray data;
    for (int i = 0; i < config->k; i++) {
        data.set_bit(i, codeword.get_bit(config->data_positions[i]));
    }
    return data;
}

BitArray insert_data(const BitArray& data_val, HammingConfig* config) {
    BitArray codeword;
    for (int i = 0; i < config->k; i++) {
        codeword.set_bit(config->data_positions[i], data_val.get_bit(i));
    }
    return codeword;
}

BitArray calculate_parity(const BitArray& codeword, HammingConfig* config) {
    BitArray parity;
    for (int i = 0; i < config->parity_bits; i++) {
        int p = 0;
        for (int j = 0; j < config->n; j++) {
            // Check if bit j participates in parity i
            // Logic: (j+1) has bit i set
            if (j != config->parity_positions[i] && codeword.get_bit(j)) {
                if ((j + 1) & (1 << i)) {
                    p ^= 1;
                }
            }
        }
        parity.set_bit(config->parity_positions[i], p);
    }
    return parity;
}

BitArray encode_hamming(const BitArray& data_val, HammingConfig* config) {
    BitArray codeword = insert_data(data_val, config);
    BitArray parity = calculate_parity(codeword, config);
    
    // Merge parity
    for(int i=0; i<config->parity_bits; i++) {
        int pos = config->parity_positions[i];
        codeword.set_bit(pos, parity.get_bit(pos));
    }
    return codeword;
}

uint32_t calculate_syndrome(const BitArray& codeword, HammingConfig* config) {
    uint32_t syndrome = 0;
    for (int i = 0; i < config->parity_bits; i++) {
        int expected = 0;
        for (int j = 0; j < config->n; j++) {
            if (j != config->parity_positions[i] && codeword.get_bit(j)) {
                if ((j + 1) & (1 << i)) {
                    expected ^= 1;
                }
            }
        }
        int actual = codeword.get_bit(config->parity_positions[i]);
        if (expected != actual) {
            syndrome |= (1 << i);
        }
    }
    return syndrome;
}

BitArray decode_hamming(const BitArray& codeword, HammingConfig* config, int* error_type) {
    uint32_t syndrome = calculate_syndrome(codeword, config);
    
    if (syndrome == 0) {
        *error_type = 0; // No error
        return extract_data(codeword, config);
    } else if ((int)syndrome <= config->n) {
        // Single bit error
        BitArray corrected = codeword;
        int bit_idx = syndrome - 1;
        corrected.set_bit(bit_idx, !corrected.get_bit(bit_idx));
        
        *error_type = 1; // Corrected
        return extract_data(corrected, config);
    } else {
        *error_type = 2; // Detected
        return extract_data(codeword, config);
    }
}

void test_hamming_secded_ecc() {
    Vhamming_secded_ecc* dut = new Vhamming_secded_ecc();
    
    int data_width = DATA_WIDTH;
    
    printf("=== Hamming SECDED ECC Test (DATA_WIDTH=%d) ===\n", data_width);
    
    HammingConfig config;
    init_hamming_config(&config, data_width);
    
    // Generate random test cases
    const int NUM_TESTS = 20;
    srand(12345);
    
    int pass_count = 0;
    int fail_count = 0;
    int max_encode_cycles = 0;
    int max_decode_cycles = 0;
    
    for (int i = 0; i < NUM_TESTS; i++) {
        BitArray test_data;
        // Fill random data
        for(int w=0; w<MAX_WORDS; w++) test_data.words[w] = rand() | (rand()<<16);
        // Mask unused bits
        for(int b=data_width; b<MAX_WORDS*32; b++) test_data.set_bit(b, 0);
        
        BitArray expected_codeword = encode_hamming(test_data, &config);
        
        // Reset
        dut->rst_n = 0; dut->eval();
        dut->rst_n = 1; dut->eval();
        
        // Encode
        dut->encode_en = 1; dut->decode_en = 0;
        SET_DATA_IN(dut, test_data);
        int encode_cycles = 0;
        do {
            dut->clk = 0; dut->eval();
            dut->clk = 1; dut->eval();
            encode_cycles++;
        } while (!dut->valid_out && encode_cycles < 100);
        if (encode_cycles > max_encode_cycles) max_encode_cycles = encode_cycles;
        
        BitArray dut_codeword;
        GET_CODEWORD_OUT(dut, dut_codeword);
        
        if (dut_codeword == expected_codeword) {
            pass_count++;
        } else {
            printf("ENCODE FAIL Test %d\n", i);
            fail_count++;
        }
        
        // Decode
        dut->encode_en = 0; dut->decode_en = 1;
        SET_CODEWORD_IN(dut, expected_codeword);
        int decode_cycles = 0;
        do {
            dut->clk = 0; dut->eval();
            dut->clk = 1; dut->eval();
            decode_cycles++;
        } while (!dut->valid_out && decode_cycles < 100);
        if (decode_cycles > max_decode_cycles) max_decode_cycles = decode_cycles;
        
        BitArray dut_data;
        GET_DATA_OUT(dut, dut_data);
        
        if (dut_data == test_data && !dut->error_detected) {
            pass_count++;
        } else {
            printf("DECODE FAIL Test %d\n", i);
            fail_count++;
        }
        
        // Single Error
        BitArray corrupted = expected_codeword;
        int err_pos = rand() % config.n;
        corrupted.set_bit(err_pos, !corrupted.get_bit(err_pos));
        
        SET_CODEWORD_IN(dut, corrupted);
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        
        GET_DATA_OUT(dut, dut_data);
        
        if (dut_data == test_data && dut->error_corrected) {
            pass_count++;
        } else {
            printf("CORRECT FAIL Test %d\n", i);
            fail_count++;
        }
    }
    
    printf("Passed: %d, Failed: %d\n", pass_count, fail_count);
    if (fail_count == 0) printf("RESULT: PASS\n");
    else printf("RESULT: FAIL\n");
    printf("ENCODE_CYCLES=%d\n", max_encode_cycles);
    printf("DECODE_CYCLES=%d\n", max_decode_cycles);
    
    delete dut;
}

int main() {
    test_hamming_secded_ecc();
    return 0;
}