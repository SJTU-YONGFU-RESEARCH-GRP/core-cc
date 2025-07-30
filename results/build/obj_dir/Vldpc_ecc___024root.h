// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vldpc_ecc.h for the primary calling header

#ifndef VERILATED_VLDPC_ECC___024ROOT_H_
#define VERILATED_VLDPC_ECC___024ROOT_H_  // guard

#include "verilated.h"


class Vldpc_ecc__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vldpc_ecc___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst_n,0,0);
    VL_IN8(encode_en,0,0);
    VL_IN8(decode_en,0,0);
    VL_IN8(data_in,7,0);
    VL_OUT8(data_out,7,0);
    VL_OUT8(error_detected,0,0);
    VL_OUT8(error_corrected,0,0);
    VL_OUT8(valid_out,0,0);
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__rst_n__0;
    CData/*0:0*/ __VactContinue;
    VL_IN16(codeword_in,15,0);
    VL_OUT16(codeword_out,15,0);
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vldpc_ecc__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vldpc_ecc___024root(Vldpc_ecc__Syms* symsp, const char* v__name);
    ~Vldpc_ecc___024root();
    VL_UNCOPYABLE(Vldpc_ecc___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
