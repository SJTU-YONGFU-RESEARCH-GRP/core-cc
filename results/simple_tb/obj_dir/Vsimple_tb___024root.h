// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vsimple_tb.h for the primary calling header

#ifndef VERILATED_VSIMPLE_TB___024ROOT_H_
#define VERILATED_VSIMPLE_TB___024ROOT_H_  // guard

#include "verilated.h"


class Vsimple_tb__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vsimple_tb___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*7:0*/ simple_tb__DOT__data;
    CData/*0:0*/ __VactContinue;
    SData/*11:0*/ simple_tb__DOT__codeword;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*0:0*/, 1> __Vm_traceActivity;
    VlTriggerVec<0> __VactTriggered;
    VlTriggerVec<0> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vsimple_tb__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vsimple_tb___024root(Vsimple_tb__Syms* symsp, const char* v__name);
    ~Vsimple_tb___024root();
    VL_UNCOPYABLE(Vsimple_tb___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
