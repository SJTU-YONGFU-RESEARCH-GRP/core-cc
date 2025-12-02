// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vbch_ecc.h for the primary calling header

#ifndef VERILATED_VBCH_ECC___024ROOT_H_
#define VERILATED_VBCH_ECC___024ROOT_H_  // guard

#include "verilated.h"


class Vbch_ecc__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vbch_ecc___024root final : public VerilatedModule {
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
    VL_IN16(codeword_in,14,0);
    VL_OUT16(codeword_out,14,0);
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vbch_ecc__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vbch_ecc___024root(Vbch_ecc__Syms* symsp, const char* v__name);
    ~Vbch_ecc___024root();
    VL_UNCOPYABLE(Vbch_ecc___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
