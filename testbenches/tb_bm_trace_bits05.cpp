// Cycle-accurate BM trace for w32 2-error bits 0,5 (compare with trace_bm_w32.py).
#include <cstdint>
#include <cstdio>

#include "Vbch_ecc_w32.h"
#include "Vbch_ecc_w32___024root.h"
#include "verilated.h"

static void tick(Vbch_ecc_w32 *dut) {
    dut->clk = 0;
    dut->eval();
    dut->clk = 1;
    dut->eval();
}

static void print_c(const char *tag, Vbch_ecc_w32___024root *r) {
    std::printf("    %s bm_c[0..5]=[%u,%u,%u,%u,%u,%u] bm_b[0..3]=[%u,%u,%u,%u]\n",
                tag,
                (unsigned)r->bch_ecc_w32__DOT__bm_c[0],
                (unsigned)r->bch_ecc_w32__DOT__bm_c[1],
                (unsigned)r->bch_ecc_w32__DOT__bm_c[2],
                (unsigned)r->bch_ecc_w32__DOT__bm_c[3],
                (unsigned)r->bch_ecc_w32__DOT__bm_c[4],
                (unsigned)r->bch_ecc_w32__DOT__bm_c[5],
                (unsigned)r->bch_ecc_w32__DOT__bm_b[0],
                (unsigned)r->bch_ecc_w32__DOT__bm_b[1],
                (unsigned)r->bch_ecc_w32__DOT__bm_b[2],
                (unsigned)r->bch_ecc_w32__DOT__bm_b[3]);
}

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vbch_ecc_w32 dut;
    auto *r = dut.rootp;

    const uint64_t cw_err = 0x9C6CCA604A12C9ULL;

    dut.rst_n = 0;
    dut.encode_en = 0;
    dut.decode_en = 0;
    for (int i = 0; i < 5; i++) tick(&dut);
    dut.rst_n = 1;
    tick(&dut);

    dut.decode_en = 1;
    dut.codeword_in = cw_err;
    tick(&dut);
    dut.decode_en = 0;

    std::printf("=== RTL BM trace (2-error bits 0,5) ===\n");
    std::printf("syn_reg[0..3]=[%u,%u,%u,%u]\n",
                (unsigned)r->bch_ecc_w32__DOT__syn_reg[0],
                (unsigned)r->bch_ecc_w32__DOT__syn_reg[1],
                (unsigned)r->bch_ecc_w32__DOT__syn_reg[2],
                (unsigned)r->bch_ecc_w32__DOT__syn_reg[3]);

    int cycle = 1;
    uint8_t last_step = 255;
    uint8_t last_busy = 0;

    for (int i = 0; i < 400; i++) {
        tick(&dut);
        cycle++;
        const uint8_t state = (uint8_t)r->bch_ecc_w32__DOT__state;
        const uint8_t step = (uint8_t)r->bch_ecc_w32__DOT__bm_step;
        const uint8_t busy = (uint8_t)r->bch_ecc_w32__DOT__bm_c_busy;

        if (state == 1) {
            if (step != last_step || busy != last_busy) {
                std::printf("[cyc %3d] BM step=%u busy=%u d=%u L=%u mreg=%u bval=%u coef_lat=%u\n",
                            cycle, step, busy,
                            (unsigned)r->bch_ecc_w32__DOT__bm_d_comb,
                            (unsigned)r->bch_ecc_w32__DOT__bm_L,
                            (unsigned)r->bch_ecc_w32__DOT__bm_mreg,
                            (unsigned)r->bch_ecc_w32__DOT__bm_bval,
                            (unsigned)r->bch_ecc_w32__DOT__bm_coef_latched);
                print_c("       ", r);
                last_step = step;
                last_busy = busy;
            }
        } else if (state == 2) {
            std::printf("[cyc %3d] CHIEN pos=%u lambda=[%u,%u,%u,%u,%u,%u] deg=%u\n",
                        cycle, (unsigned)r->bch_ecc_w32__DOT__chien_pos,
                        (unsigned)r->bch_ecc_w32__DOT__lambda[0],
                        (unsigned)r->bch_ecc_w32__DOT__lambda[1],
                        (unsigned)r->bch_ecc_w32__DOT__lambda[2],
                        (unsigned)r->bch_ecc_w32__DOT__lambda[3],
                        (unsigned)r->bch_ecc_w32__DOT__lambda[4],
                        (unsigned)r->bch_ecc_w32__DOT__lambda[5],
                        (unsigned)r->bch_ecc_w32__DOT__lambda_deg);
            break;
        } else if (state == 3 && dut.valid_out) {
            std::printf("[cyc %3d] DONE data_out=0x%08x det=%d cor=%d err_mask=0x%llx\n",
                        cycle, dut.data_out, dut.error_detected, dut.error_corrected,
                        (unsigned long long)r->bch_ecc_w32__DOT__err_mask);
            break;
        }
    }
    return 0;
}
