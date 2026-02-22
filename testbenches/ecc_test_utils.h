#ifndef ECC_TEST_UTILS_H
#define ECC_TEST_UTILS_H

#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <verilated.h>

// Max words needed. 128 bit data -> ~140 bit codeword. 
// Repetition(3) -> 128*3 = 384 bits.
// 384 bits / 32 = 12 words.
// Let's use 16 words (512 bits) to be safe for all codes.
#define MAX_WORDS 16

struct BitArray {
    uint32_t words[MAX_WORDS];

    BitArray() {
        memset(words, 0, sizeof(words));
    }

    void set_bit(int pos, int val) {
        if (pos >= MAX_WORDS * 32) return;
        if (val) words[pos / 32] |= (1U << (pos % 32));
        else     words[pos / 32] &= ~(1U << (pos % 32));
    }

    int get_bit(int pos) const {
        if (pos >= MAX_WORDS * 32) return 0;
        return (words[pos / 32] >> (pos % 32)) & 1;
    }

    void clear() {
        memset(words, 0, sizeof(words));
    }
    
    // Equality operator
    bool operator==(const BitArray& other) const {
        for(int i=0; i<MAX_WORDS; i++) {
            if(words[i] != other.words[i]) return false;
        }
        return true;
    }

    bool operator!=(const BitArray& other) const {
        return !(*this == other);
    }
};

// Helper to safely set wide ports
// Verilator uses IData (uint32_t) arrays sized to (BITS+31)/32
#define SET_WIDE_PORT(dut, port, val, bits) \
    do { \
        int nwords = (bits + 31) / 32; \
        for(int w=0; w<nwords && w<MAX_WORDS; w++) \
            (dut)->port[w] = (val).words[w]; \
    } while(0)

#define GET_WIDE_PORT(dut, port, val, bits) \
    do { \
        (val).clear(); \
        int nwords = (bits + 31) / 32; \
        for(int w=0; w<nwords && w<MAX_WORDS; w++) \
            (val).words[w] = (dut)->port[w]; \
    } while(0)

// Helper to convert plain uint64_t to BitArray (for small widths)
BitArray from_u64(uint64_t val) {
    BitArray ba;
    ba.words[0] = (uint32_t)val;
    ba.words[1] = (uint32_t)(val >> 32);
    return ba;
}

// Convert BitArray to uint64_t (lossy if > 64 bits)
uint64_t to_u64(const BitArray& ba) {
    return ((uint64_t)ba.words[1] << 32) | ba.words[0];
}

// Helpers for Verilator interaction
// Verilator uses IData (uint32_t) pointers for wide signals

// Set input: Valid whether signal is wide (array) or narrow (scalar)
// Templated to handle specific module types if needed, or generic void* approach
// But Verilator generates different signatures. 
// For scalar: `dut->in = val`
// For wide: `dut->in[0] = val` (it's an array)

// We will use macros or overloaded functions in the specific TB files, 
// OR simpler: assume we allow direct access in TB.
// This header just provides the BitArray logic.

#endif // ECC_TEST_UTILS_H
