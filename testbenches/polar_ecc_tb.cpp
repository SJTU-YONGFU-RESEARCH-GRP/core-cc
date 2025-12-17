#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

// Verilator generated header
#include "Vpolar_ecc.h"
#include "verilated.h"

void test_polar_ecc() {
    Vpolar_ecc* dut = new Vpolar_ecc();
    
    printf("=== Polar ECC Test (Self-Check) ===\n");
    
    uint32_t test_cases[] = {0x00, 0x55, 0xAA, 0xFF, 0x12, 0x34, 0x56, 0x78};
    int num_tests = sizeof(test_cases) / sizeof(test_cases[0]);
    int pass_count = 0;
    int fail_count = 0;
    
    for (int i = 0; i < num_tests; i++) {
        uint32_t test_data = test_cases[i];
        
        // Reset
        dut->rst_n = 0; dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        dut->rst_n = 1; dut->eval();
        
        // 1. Test Encoding
        dut->encode_en = 1;
        dut->decode_en = 0;
        dut->data_in = test_data;
        
        dut->clk = 0; dut->eval();
        dut->clk = 1; dut->eval();
        
        uint32_t generated_codeword = dut->codeword_out;
        printf("TEST %d (Data 0x%02X) -> Encoded 0x%04X\n", i, test_data, generated_codeword);
        
        // 2. Test Decoding (Clean)
        dut->rst_n = 0; dut->eval(); dut->rst_n = 1; // Reset state
        dut->encode_en = 0;
        dut->decode_en = 1;
        dut->codeword_in = generated_codeword;
        
        int cycles = 0;
        dut->valid_out = 0;
        while (!dut->valid_out && cycles < 4000) { // Search might take cycles
             dut->clk = 0; dut->eval();
             dut->clk = 1; dut->eval();
             cycles++;
        }
        
        if (dut->data_out == test_data) {
             printf("  [PASS] Clean Decode: Got 0x%02X (Cycles: %d)\n", dut->data_out, cycles);
             pass_count++;
        } else {
             printf("  [FAIL] Clean Decode: Expected 0x%02X, Got 0x%02X\n", test_data, dut->data_out);
             fail_count++;
        }
        
        // 3. Test Error Correction
        uint32_t corrupted = generated_codeword ^ 1;
        dut->rst_n = 0; dut->eval(); dut->rst_n = 1;
        dut->codeword_in = corrupted;
        
        cycles = 0;
        dut->valid_out = 0;
        while (!dut->valid_out && cycles < 4000) {
             dut->clk = 0; dut->eval();
             dut->clk = 1; dut->eval();
             cycles++;
        }
        
        if (dut->data_out == test_data && dut->error_corrected) {
             printf("  [PASS] Error Correct: Recov 0x%02X, Corrected=1\n", dut->data_out);
             pass_count++;
        } else {
             printf("  [FAIL] Error Correct: Expected 0x%02X, Got 0x%02X, Corrected=%d\n", test_data, dut->data_out, dut->error_corrected);
             fail_count++;
        }
    }
    
    printf("=== Test Summary ===\n");
    printf("Passed: %d\n", pass_count);
    printf("Failed: %d\n", fail_count);
    
    if (fail_count == 0) printf("RESULT: PASS\n");
    else printf("RESULT: FAIL\n");
    
    delete dut;
}

int main() {
    test_polar_ecc();
    return 0;
}