// Lightweight bring-up TB for repaired bch_ecc_w32 FSM (not universal driver).
#include <cstdint>
#include <cstdio>
#include <cstdlib>

#include "Vbch_ecc_w32.h"
#include "verilated.h"

static constexpr int N = 63;
static constexpr int WIDTH = 32;
static constexpr int PARITY = 27;

static void tick(Vbch_ecc_w32 *dut) {
    dut->clk = 0;
    dut->eval();
    dut->clk = 1;
    dut->eval();
}

static void reset(Vbch_ecc_w32 *dut) {
    dut->rst_n = 0;
    dut->encode_en = 0;
    dut->decode_en = 0;
    dut->data_in = 0;
    dut->codeword_in = 0;
    for (int i = 0; i < 5; i++) tick(dut);
    dut->rst_n = 1;
    tick(dut);
}

static void set_codeword(Vbch_ecc_w32 *dut, uint64_t cw) {
    dut->codeword_in = cw & ((1ULL << N) - 1);
}

static uint64_t get_codeword(Vbch_ecc_w32 *dut) {
    return dut->codeword_out & ((1ULL << N) - 1);
}

static bool encode_cycle(Vbch_ecc_w32 *dut, uint32_t data, uint64_t *cw_out, int *cycles) {
    dut->encode_en = 1;
    dut->decode_en = 0;
    dut->data_in = data;
    *cycles = 0;
    for (int i = 0; i < 20; i++) {
        tick(dut);
        (*cycles)++;
        if (dut->valid_out) {
            dut->encode_en = 0;
            *cw_out = get_codeword(dut);
            return true;
        }
    }
    dut->encode_en = 0;
    return false;
}

static bool decode_until_valid(Vbch_ecc_w32 *dut, uint64_t cw_in, uint32_t *data_out,
                               int *det, int *cor, int *cycles) {
    dut->encode_en = 0;
    dut->decode_en = 1;
    set_codeword(dut, cw_in);
    tick(dut);
    dut->decode_en = 0;
    *cycles = 1;
    for (int i = 0; i < 512; i++) {
        tick(dut);
        (*cycles)++;
        if (dut->valid_out) {
            *data_out = dut->data_out;
            *det = dut->error_detected;
            *cor = dut->error_corrected;
            return true;
        }
    }
    return false;
}

static int run_case(const char *name, uint32_t data, int err_pos, int err_count) {
    VerilatedContext ctx;
    Vbch_ecc_w32 dut{&ctx};

    reset(&dut);
    uint64_t cw = 0;
    int enc_cyc = 0;
    if (!encode_cycle(&dut, data, &cw, &enc_cyc)) {
        std::printf("FAIL %s: encode timeout\n", name);
        return 1;
    }

    uint64_t err_cw = cw;
    for (int e = 0; e < err_count; e++) {
        int p = (err_count == 1) ? err_pos : (err_pos + e);
        err_cw ^= (1ULL << p);
    }

    uint32_t dout = 0;
    int det = 0, cor = 0, dec_cyc = 0;
    if (!decode_until_valid(&dut, err_cw, &dout, &det, &cor, &dec_cyc)) {
        std::printf("FAIL %s: decode timeout (enc=%d)\n", name, enc_cyc);
        return 1;
    }

    bool ok = (dout == data) && (err_count == 0 ? !det : det) && (err_count == 0 ? !cor : cor);
    std::printf("%s %s: data=0x%08x out=0x%08x det=%d cor=%d enc_cyc=%d dec_cyc=%d\n",
                ok ? "PASS" : "FAIL", name, data, dout, det, cor, enc_cyc, dec_cyc);
    return ok ? 0 : 1;
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    int fails = 0;

    fails += run_case("encode0_nodec", 0, 0, 0);
    fails += run_case("data123_noerr", 0x12345678u, 0, 0);
    fails += run_case("single_err_p10", 0x12345678u, 10, 1);
    fails += run_case("single_err_p0", 0xDEADBEEFu, 0, 1);
    fails += run_case("single_err_p27", 0xA5A5A5A5u, 27, 1);  // data bit 0
    fails += run_case("single_err_p62", 0xA5A5A5A5u, 62, 1);  // padding bit (data unaffected)

    if (fails == 0) {
        std::printf("\nAll FSM bring-up cases passed.\n");
        return 0;
    }
    std::printf("\n%d case(s) failed.\n", fails);
    return 1;
}
