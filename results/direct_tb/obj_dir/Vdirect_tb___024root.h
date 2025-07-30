// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vdirect_tb.h for the primary calling header

#ifndef VERILATED_VDIRECT_TB___024ROOT_H_
#define VERILATED_VDIRECT_TB___024ROOT_H_  // guard

#include "verilated.h"


class Vdirect_tb__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vdirect_tb___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ __VactContinue;
    SData/*11:0*/ direct_tb__DOT__expected_codeword;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*0:0*/, 1> __Vm_traceActivity;
    VlTriggerVec<0> __VactTriggered;
    VlTriggerVec<0> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vdirect_tb__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vdirect_tb___024root(Vdirect_tb__Syms* symsp, const char* v__name);
    ~Vdirect_tb___024root();
    VL_UNCOPYABLE(Vdirect_tb___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
