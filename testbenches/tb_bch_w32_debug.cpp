// Cycle-accurate probe for single_err @ bit 27 (golden four-tuple vs Python oracle).
#include <cstdint>
#include <cstdio>

#include "Vbch_ecc_w32.h"
#include "Vbch_ecc_w32___024root.h"
#include "verilated.h"

static constexpr int N = 63;

static void tick(Vbch_ecc_w32 *dut) {
    dut->clk = 0;
    dut->eval();
    dut->clk = 1;
    dut->eval();
}

static uint8_t read_syn_reg0(Vbch_ecc_w32___024root *r) {
    return (uint8_t)r->bch_ecc_w32__DOT__syn_reg[0];
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    VerilatedContext ctx;
    Vbch_ecc_w32 dut{&ctx};
    auto *r = dut.rootp;

    const uint32_t data = 0xA5A5A5A5u;
    const int err_pos = 27;

    dut.rst_n = 0;
    dut.encode_en = 0;
    dut.decode_en = 0;
    for (int i = 0; i < 5; i++) tick(&dut);
    dut.rst_n = 1;
    tick(&dut);

    dut.encode_en = 1;
    dut.data_in = data;
    uint64_t cw = 0;
    for (int i = 0; i < 20; i++) {
        tick(&dut);
        if (dut.valid_out) {
            cw = dut.codeword_out & ((1ULL << N) - 1);
            dut.encode_en = 0;
            break;
        }
    }

    const uint64_t err_cw = cw ^ (1ULL << err_pos);
    dut.decode_en = 1;
    dut.codeword_in = err_cw;
    tick(&dut);
    dut.decode_en = 0;

    const uint64_t cw_in = dut.codeword_in & ((1ULL << N) - 1);
    uint8_t s1_at_decode = read_syn_reg0(r);
    std::printf("  syn_reg[1..3] at decode: %u %u %u (expect 23 15)\n",
                (unsigned)r->bch_ecc_w32__DOT__syn_reg[1],
                (unsigned)r->bch_ecc_w32__DOT__syn_reg[2],
                (unsigned)r->bch_ecc_w32__DOT__syn_reg[3]);
    uint8_t lambda1_at_chien = 0;
    int chien_root_pos = -1;
    int chien_root_count = 0;
    uint64_t err_mask_final = 0;
    int cycle = 1;
    int last_bm_step = -1;
    uint8_t last_busy = 0;
    uint8_t last_c1 = 0;

    for (int i = 0; i < 512; i++) {
        tick(&dut);
        cycle++;
        const uint8_t s1_now = read_syn_reg0(r);
        const uint8_t state = (uint8_t)r->bch_ecc_w32__DOT__state;
        const uint8_t bm_step = (uint8_t)r->bch_ecc_w32__DOT__bm_step;
        const uint8_t busy = (uint8_t)r->bch_ecc_w32__DOT__bm_c_busy;
        if (state == 1 && !busy && bm_step == 2 && last_bm_step == 1) {
            std::printf(
                "    [cyc %d] step2 start: d=%u syn[1]=%u syn[2]=%u c1=%u L=%u mreg=%u\n",
                cycle, (unsigned)r->bch_ecc_w32__DOT__bm_d_comb,
                (unsigned)r->bch_ecc_w32__DOT__syn_reg[1],
                (unsigned)r->bch_ecc_w32__DOT__syn_reg[2],
                (unsigned)r->bch_ecc_w32__DOT__bm_c[1],
                (unsigned)r->bch_ecc_w32__DOT__bm_L,
                (unsigned)r->bch_ecc_w32__DOT__bm_mreg);
        }
        if (state == 1 && last_busy && !busy && last_bm_step == 0) {
            std::printf("    [cyc %d] after step0 busy: bm_c[1]=%u coef_lat=%u bval=%u\n",
                        cycle, (unsigned)r->bch_ecc_w32__DOT__bm_c[1],
                        (unsigned)r->bch_ecc_w32__DOT__bm_coef_latched,
                        (unsigned)r->bch_ecc_w32__DOT__bm_bval);
        }
        const uint8_t c1 = (uint8_t)r->bch_ecc_w32__DOT__bm_c[1];
        if (state == 1 && c1 != last_c1) {
            std::printf(
                "    [cyc %d] bm_c[1] %u -> %u (step=%u L=%u busy=%u d=%u)\n", cycle,
                (unsigned)last_c1, (unsigned)c1, bm_step,
                (unsigned)r->bch_ecc_w32__DOT__bm_L, busy,
                (unsigned)r->bch_ecc_w32__DOT__bm_d_comb);
            last_c1 = c1;
        }
        last_busy = busy;
        last_bm_step = (int)bm_step;
        const uint8_t chien_pos = (uint8_t)r->bch_ecc_w32__DOT__chien_pos;
        const uint8_t chien_root = (uint8_t)r->bch_ecc_w32__DOT__chien_is_root;

        if (state == 2 && chien_root) {
            if (chien_root_pos < 0) chien_root_pos = (int)chien_pos;
            chien_root_count++;
            std::printf("    [cyc %d] CHIEN root @ pos=%u lambda_deg=%u\n", cycle, chien_pos,
                        (unsigned)r->bch_ecc_w32__DOT__lambda_deg);
        }
        if (state == 2 && lambda1_at_chien == 0) {
            lambda1_at_chien = (uint8_t)r->bch_ecc_w32__DOT__lambda[1];
            std::printf("    [cyc %d] enter CHIEN lambda0=%u lambda1=%u deg=%u\n", cycle,
                        (unsigned)r->bch_ecc_w32__DOT__lambda[0],
                        (unsigned)r->bch_ecc_w32__DOT__lambda[1],
                        (unsigned)r->bch_ecc_w32__DOT__lambda_deg);
        }
        if (dut.valid_out) {
            err_mask_final = r->bch_ecc_w32__DOT__err_mask;
            std::printf("  bm_c[1]=%u lambda[1]=%u lambda_deg=%u\n",
                        (unsigned)r->bch_ecc_w32__DOT__bm_c[1],
                        (unsigned)r->bch_ecc_w32__DOT__lambda[1],
                        (unsigned)r->bch_ecc_w32__DOT__lambda_deg);
            break;
        }
    }

    std::printf("=== single_err @ bit 27 (data=0x%08x) ===\n", data);
    std::printf("  encoded cw=0x%llx err_cw=0x%llx\n", (unsigned long long)cw,
                (unsigned long long)err_cw);
    std::printf("Python oracle expects: S1=14, lambda1=14, chien_pos@root=27, err_mask=0x%llx\n",
                (unsigned long long)(1ULL << err_pos));
    std::printf("RTL golden four-tuple:\n");
    std::printf("  codeword_in=0x%llx xor_err=0x%llx\n", (unsigned long long)cw_in,
                (unsigned long long)(cw_in ^ err_cw));
    std::printf("  1) syn_reg[0] (S1 latched): %u (expect 14)\n", s1_at_decode);
    std::printf("  2) lambda[1] (BM end, sampled on bm_step==9): %u\n", lambda1_at_chien);
    std::printf("  3) chien_pos when chien_is_root first high: %d (total roots=%d)\n",
                chien_root_pos, chien_root_count);
    std::printf("  4) err_mask @ valid_out: 0x%llx\n", (unsigned long long)err_mask_final);
    std::printf("  data_out=0x%08x (expect 0x%08x)\n", dut.data_out, data);
    std::printf("  syn_reg[0] at end: %u\n", read_syn_reg0(r));

    return 0;
}
