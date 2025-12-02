// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vrepetition_ecc.h for the primary calling header

#ifndef VERILATED_VREPETITION_ECC___024ROOT_H_
#define VERILATED_VREPETITION_ECC___024ROOT_H_  // guard

#include "verilated.h"


class Vrepetition_ecc__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vrepetition_ecc___024root final : public VerilatedModule {
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
    CData/*1:0*/ repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count;
    CData/*1:0*/ repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count;
    CData/*1:0*/ repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count;
    CData/*1:0*/ repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count;
    CData/*1:0*/ repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count;
    CData/*1:0*/ repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count;
    CData/*1:0*/ repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count;
    CData/*1:0*/ repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VicoFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__rst_n__0;
    CData/*0:0*/ __VactContinue;
    VL_IN(codeword_in,23,0);
    VL_OUT(codeword_out,23,0);
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vrepetition_ecc__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vrepetition_ecc___024root(Vrepetition_ecc__Syms* symsp, const char* v__name);
    ~Vrepetition_ecc___024root();
    VL_UNCOPYABLE(Vrepetition_ecc___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
