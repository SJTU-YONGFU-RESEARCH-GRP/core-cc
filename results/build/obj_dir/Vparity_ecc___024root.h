// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vparity_ecc.h for the primary calling header

#ifndef VERILATED_VPARITY_ECC___024ROOT_H_
#define VERILATED_VPARITY_ECC___024ROOT_H_  // guard

#include "verilated.h"


class Vparity_ecc__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vparity_ecc___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst_n,0,0);
    VL_IN8(encode_en,0,0);
    VL_IN8(decode_en,0,0);
    VL_IN8(data_in,7,0);
    VL_OUT8(data_out,7,0);
    VL_OUT8(error_detected,0,0);
    VL_OUT8(valid_out,0,0);
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__rst_n__0;
    CData/*0:0*/ __VactContinue;
    VL_IN16(codeword_in,8,0);
    VL_OUT16(codeword_out,8,0);
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<2> __VactTriggered;
    VlTriggerVec<2> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vparity_ecc__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vparity_ecc___024root(Vparity_ecc__Syms* symsp, const char* v__name);
    ~Vparity_ecc___024root();
    VL_UNCOPYABLE(Vparity_ecc___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
