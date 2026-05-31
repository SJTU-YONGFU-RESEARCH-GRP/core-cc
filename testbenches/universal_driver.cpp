#include <iostream>
#include <fstream>
#include <string>
#include <cstdint>
#include <cstdlib>

// Select DUT at compile time (-DTEST_PARITY, -DTEST_REPETITION, etc.)
#if defined(TEST_HAMMING_SEC)
    #include "Vhamming_sec_ecc.h"
    #define DUT_CLASS Vhamming_sec_ecc
    #define TARGET_MODULE "hamming_sec_ecc"
#elif defined(TEST_SECDED)
    #include "Vextended_hamming_secded_ecc.h"
    #define DUT_CLASS Vextended_hamming_secded_ecc
    #define TARGET_MODULE "extended_hamming_secded_ecc"
#elif defined(TEST_REPETITION)
    #include "Vrepetition_ecc.h"
    #define DUT_CLASS Vrepetition_ecc
    #define TARGET_MODULE "repetition_ecc"
#elif defined(TEST_CRC)
    #if defined(CRC_USE_COMB)
        #if DATA_WIDTH == 4
            #include "Vcrc_ecc_w4.h"
            #define DUT_CLASS Vcrc_ecc_w4
        #elif DATA_WIDTH == 8
            #include "Vcrc_ecc_w8.h"
            #define DUT_CLASS Vcrc_ecc_w8
        #elif DATA_WIDTH == 16
            #include "Vcrc_ecc_w16.h"
            #define DUT_CLASS Vcrc_ecc_w16
        #elif DATA_WIDTH == 32
            #include "Vcrc_ecc_w32.h"
            #define DUT_CLASS Vcrc_ecc_w32
        #elif DATA_WIDTH == 64
            #include "Vcrc_ecc_w64.h"
            #define DUT_CLASS Vcrc_ecc_w64
        #elif DATA_WIDTH == 128
            #include "Vcrc_ecc_w128.h"
            #define DUT_CLASS Vcrc_ecc_w128
        #else
            #error "CRC_USE_COMB requires DATA_WIDTH in {4,8,16,32,64,128}"
        #endif
    #else
        #include "Vcrc_ecc.h"
        #define DUT_CLASS Vcrc_ecc
    #endif
    #define TARGET_MODULE "crc_ecc"
#elif defined(TEST_BCH)
    #if defined(BCH_USE_WRAPPER)
        #include "Vbch_ecc.h"
        #define DUT_CLASS Vbch_ecc
    #elif DATA_WIDTH == 4
        #include "Vbch_ecc_w4.h"
        #define DUT_CLASS Vbch_ecc_w4
    #elif DATA_WIDTH == 8
        #include "Vbch_ecc_w8.h"
        #define DUT_CLASS Vbch_ecc_w8
    #elif DATA_WIDTH == 16
        #include "Vbch_ecc_w16.h"
        #define DUT_CLASS Vbch_ecc_w16
    #elif DATA_WIDTH == 32
        #include "Vbch_ecc_w32.h"
        #define DUT_CLASS Vbch_ecc_w32
    #elif DATA_WIDTH == 64
        #include "Vbch_ecc_w64.h"
        #define DUT_CLASS Vbch_ecc_w64
    #elif DATA_WIDTH == 128
        #include "Vbch_ecc_w128.h"
        #define DUT_CLASS Vbch_ecc_w128
    #else
        #include "Vbch_ecc.h"
        #define DUT_CLASS Vbch_ecc
    #endif
    #define TARGET_MODULE "bch_ecc"
#elif defined(TEST_RS)
    #if DATA_WIDTH == 4
        #include "Vreed_solomon_ecc_w4.h"
        #define DUT_CLASS Vreed_solomon_ecc_w4
    #elif DATA_WIDTH == 8
        #include "Vreed_solomon_ecc_w8.h"
        #define DUT_CLASS Vreed_solomon_ecc_w8
    #elif DATA_WIDTH == 16
        #include "Vreed_solomon_ecc_w16.h"
        #define DUT_CLASS Vreed_solomon_ecc_w16
    #elif DATA_WIDTH == 32
        #include "Vreed_solomon_ecc_w32.h"
        #define DUT_CLASS Vreed_solomon_ecc_w32
    #elif DATA_WIDTH == 64
        #include "Vreed_solomon_ecc_w64.h"
        #define DUT_CLASS Vreed_solomon_ecc_w64
    #elif DATA_WIDTH == 128
        #include "Vreed_solomon_ecc_w128.h"
        #define DUT_CLASS Vreed_solomon_ecc_w128
    #else
        #include "Vreed_solomon_ecc_w32.h"
        #define DUT_CLASS Vreed_solomon_ecc_w32
    #endif
    #define TARGET_MODULE "reed_solomon_ecc"
#else
    #include "Vparity_ecc.h"
    #define DUT_CLASS Vparity_ecc
    #define TARGET_MODULE "parity_ecc"
#endif

#include "verilated.h"
#include "ecc_test_utils.h"

#ifndef DATA_WIDTH
#define DATA_WIDTH 8
#endif

#ifndef REPETITION_FACTOR
#define REPETITION_FACTOR 3
#endif

#if defined(TEST_REPETITION)
    #define CODEWORD_USES_WIDE (DATA_WIDTH * REPETITION_FACTOR > 64)
#elif defined(TEST_PARITY)
    #define CODEWORD_USES_WIDE (DATA_WIDTH + 1 > 64)
#elif defined(TEST_CRC)
    #define CODEWORD_USES_WIDE (DATA_WIDTH + 8 > 64)
#elif defined(TEST_BCH)
    #if defined(BCH_USE_WRAPPER)
        #define CODEWORD_USES_WIDE 1
    #else
        #define CODEWORD_USES_WIDE (DATA_WIDTH > 32)
    #endif
#elif defined(TEST_RS)
    #define CODEWORD_USES_WIDE (DATA_WIDTH > 32)
#else
    #define CALC_SEC_WIDTH(dw) \
        ((dw) <= 2 ? 5 : (dw) <= 4 ? 7 : (dw) <= 8 ? 12 : (dw) <= 16 ? 21 : \
         (dw) <= 32 ? 38 : (dw) <= 64 ? 71 : 136)
    #if defined(TEST_SECDED)
        #define CODEWORD_USES_WIDE (CALC_SEC_WIDTH(DATA_WIDTH) + 1 > 64)
    #else
        #define CODEWORD_USES_WIDE (CALC_SEC_WIDTH(DATA_WIDTH) > 64)
    #endif
#endif

// Minimal JSON field extractor for our flat JSONL lines
static std::string get_json_val(const std::string& json, const std::string& key, bool is_string) {
    const std::string search = "\"" + key + "\":";
    size_t pos = json.find(search);
    if (pos == std::string::npos) return "";
    pos += search.length();
    while (pos < json.size() && json[pos] == ' ') pos++;

    if (is_string) {
        if (pos < json.size() && json[pos] == '"') pos++;
        size_t end = json.find('"', pos);
        if (end == std::string::npos) return "";
        return json.substr(pos, end - pos);
    }

    size_t end = json.find_first_of(",}", pos);
    if (end == std::string::npos) end = json.size();
    std::string val = json.substr(pos, end - pos);
    while (!val.empty() && val.back() == ' ') val.pop_back();
    return val;
}

static BitArray hex_to_bitarray(const std::string& hex_str) {
    BitArray ba;
    if (hex_str.size() < 3 || hex_str[0] != '0' ||
        (hex_str[1] != 'x' && hex_str[1] != 'X')) {
        return ba;
    }

    const std::string clean = hex_str.substr(2);
    const int len = static_cast<int>(clean.length());
    for (int i = 0; i < len; i++) {
        char c = clean[len - 1 - i];
        uint8_t nibble = 0;
        if (c >= '0' && c <= '9') nibble = static_cast<uint8_t>(c - '0');
        else if (c >= 'a' && c <= 'f') nibble = static_cast<uint8_t>(c - 'a' + 10);
        else if (c >= 'A' && c <= 'F') nibble = static_cast<uint8_t>(c - 'A' + 10);
        for (int b = 0; b < 4; b++) {
            ba.set_bit(i * 4 + b, (nibble >> b) & 1);
        }
    }
    return ba;
}

static void set_codeword_in(DUT_CLASS* dut, const BitArray& cw, int cw_width) {
#if CODEWORD_USES_WIDE
    SET_WIDE_PORT(dut, codeword_in, cw, cw_width);
#else
    (void)cw_width;
    dut->codeword_in = to_u64(cw);
#endif
}

#if DATA_WIDTH > 64
    #define SET_DATA_IN_PORT(dut, val) SET_WIDE_PORT(dut, data_in, val, DATA_WIDTH)
    #define GET_DATA_OUT_PORT(dut, val) GET_WIDE_PORT(dut, data_out, val, DATA_WIDTH)
#else
    #define SET_DATA_IN_PORT(dut, val) (dut)->data_in = to_u64(val)
    #define GET_DATA_OUT_PORT(dut, val) (val) = from_u64((dut)->data_out)
#endif

#if defined(TEST_BCH) && (DATA_WIDTH == 128)
    #define DECODE_MAX_CYCLES 2500
#elif defined(TEST_BCH) && (DATA_WIDTH == 64)
    #define DECODE_MAX_CYCLES 512
#elif defined(TEST_BCH) && (DATA_WIDTH == 32)
    #define DECODE_MAX_CYCLES 256
#elif defined(TEST_BCH) && (DATA_WIDTH == 16) && defined(BCH_FSM_DECODER)
    // BCH(31,16,t=3): BM ~2t + Chien n=31 + syndrome/handshake
    #define DECODE_MAX_CYCLES 256
#else
    #define DECODE_MAX_CYCLES 100
#endif

static void tick_cycle(DUT_CLASS* dut) {
    dut->clk = 0;
    dut->eval();
    dut->clk = 1;
    dut->eval();
}

#if defined(TEST_BCH) && \
    (DATA_WIDTH == 32 || DATA_WIDTH == 64 || DATA_WIDTH == 128 || \
     (DATA_WIDTH == 16 && defined(BCH_FSM_DECODER)))
// FSM decoder: pulse decode_en once, then poll valid_out.
static bool decode_until_valid(DUT_CLASS* dut, int* cycles_out) {
    dut->decode_en = 1;
    tick_cycle(dut);
    dut->decode_en = 0;

    for (int c = 1; c <= DECODE_MAX_CYCLES; c++) {
        tick_cycle(dut);
        if (dut->valid_out) {
            if (cycles_out) *cycles_out = c;
            return true;
        }
    }
    if (cycles_out) *cycles_out = DECODE_MAX_CYCLES;
    return false;
}
#else
// Combinational / single-cycle decode: hold decode_en while waiting for valid_out.
static bool decode_until_valid(DUT_CLASS* dut, int* cycles_out) {
    dut->decode_en = 1;
    for (int c = 1; c <= DECODE_MAX_CYCLES; c++) {
        tick_cycle(dut);
        if (dut->valid_out) {
            dut->decode_en = 0;
            if (cycles_out) *cycles_out = c;
            return true;
        }
    }
    dut->decode_en = 0;
    if (cycles_out) *cycles_out = DECODE_MAX_CYCLES;
    return false;
}
#endif

static bool vector_matches_filter(
    const std::string& module_name,
    int vector_dw,
    const std::string& line) {
    if (module_name != TARGET_MODULE || vector_dw != DATA_WIDTH) {
        return false;
    }

#if defined(TEST_REPETITION)
    std::string rep_str = get_json_val(line, "repetition_factor", false);
    if (!rep_str.empty()) {
        int vector_rep = std::stoi(rep_str);
        if (vector_rep != REPETITION_FACTOR) return false;
    }
#endif

    return true;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    const char* dataset_env = std::getenv("CORE_CC_DATASET");
    std::string dataset_path = dataset_env ? dataset_env : "../dataset/core_cc_vectors.jsonl";

    std::ifstream infile(dataset_path);
    if (!infile.is_open()) {
        dataset_path = "dataset/core_cc_vectors.jsonl";
        infile.open(dataset_path);
    }
    if (!infile.is_open()) {
        std::cerr << "ERROR: cannot open dataset: " << dataset_path << std::endl;
        return 1;
    }

    DUT_CLASS* dut = new DUT_CLASS();

    std::cout << "\n==================================================" << std::endl;
    std::cout << " CORE-CC Universal Driver" << std::endl;
    std::cout << " Target: " << TARGET_MODULE << " (DATA_WIDTH=" << DATA_WIDTH;
#if defined(TEST_REPETITION)
    std::cout << ", REPETITION_FACTOR=" << REPETITION_FACTOR;
#endif
    std::cout << ")" << std::endl;
    std::cout << " Dataset: " << dataset_path << std::endl;
    std::cout << "==================================================" << std::endl;

    std::string line;
    int pass_count = 0;
    int fail_count = 0;
    int skipped_count = 0;
    int timeout_count = 0;

    while (std::getline(infile, line)) {
        if (line.empty()) continue;

        const std::string module_name = get_json_val(line, "module", true);
        const int vector_dw = std::stoi(get_json_val(line, "data_width", false));
        const int vector_cw = std::stoi(get_json_val(line, "codeword_width", false));

        if (!vector_matches_filter(module_name, vector_dw, line)) {
            skipped_count++;
            continue;
        }

        const std::string test_desc = get_json_val(line, "test_case", true);
        const BitArray data_in = hex_to_bitarray(get_json_val(line, "data_in", true));
        const BitArray codeword_in = hex_to_bitarray(get_json_val(line, "codeword_in", true));
        const BitArray exp_data_out = hex_to_bitarray(get_json_val(line, "exp_data_out", true));
        const int exp_detect = std::stoi(get_json_val(line, "exp_error_detected", false));
        const int exp_correct = std::stoi(get_json_val(line, "exp_error_corrected", false));

        dut->rst_n = 0;
        dut->eval();
        dut->rst_n = 1;
        dut->eval();

        dut->encode_en = 0;
        SET_DATA_IN_PORT(dut, data_in);
        set_codeword_in(dut, codeword_in, vector_cw);

        int decode_cycles = 0;
        const bool result_valid = decode_until_valid(dut, &decode_cycles);
        if (!result_valid) {
            timeout_count++;
            fail_count++;
            std::cout << "FAIL (timeout): " << test_desc << std::endl;
            std::cout << "  valid_out not asserted within " << DECODE_MAX_CYCLES
                      << " cycles" << std::endl;
            continue;
        }

        BitArray actual_data_out;
        GET_DATA_OUT_PORT(dut, actual_data_out);
        const int actual_detect = dut->error_detected;
#if defined(TEST_PARITY) || defined(TEST_CRC)
        const int actual_correct = 0;
#else
        const int actual_correct = dut->error_corrected;
#endif

        const bool passed = (actual_data_out == exp_data_out) &&
                            (actual_detect == exp_detect) &&
                            (actual_correct == exp_correct);

        if (passed) {
            pass_count++;
        } else {
            fail_count++;
            std::cout << "FAIL: " << test_desc << std::endl;
            std::cout << "  expected data_out=" << get_json_val(line, "exp_data_out", true)
                      << " det=" << exp_detect << " cor=" << exp_correct << std::endl;
            std::cout << "  actual   data_out=0x";
#if DATA_WIDTH > 64
            for (int w = (DATA_WIDTH + 31) / 32 - 1; w >= 0; w--) {
                std::cout << std::hex << actual_data_out.words[w];
            }
#else
            std::cout << std::hex << to_u64(actual_data_out);
#endif
            std::cout << std::dec << " det=" << actual_detect
                      << " cor=" << actual_correct << std::endl;
        }
    }

    std::cout << "--------------------------------------------------" << std::endl;
    std::cout << " Results: " << pass_count << " PASS, " << fail_count << " FAIL, "
              << skipped_count << " skipped";
    if (timeout_count > 0) {
        std::cout << ", " << timeout_count << " decode timeouts";
    }
    std::cout << std::endl;

    if (fail_count == 0 && pass_count > 0) {
        std::cout << " RESULT: PASS" << std::endl;
    } else {
        std::cout << " RESULT: FAIL" << std::endl;
    }
    std::cout << "==================================================\n" << std::endl;

    delete dut;
    return (fail_count == 0 && pass_count > 0) ? 0 : 1;
}
