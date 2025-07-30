// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtest_tb.h for the primary calling header

#ifndef VERILATED_VTEST_TB___024ROOT_H_
#define VERILATED_VTEST_TB___024ROOT_H_  // guard

#include "verilated.h"


class Vtest_tb__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vtest_tb___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ __VactContinue;
    SData/*11:0*/ test_tb__DOT__expected_codeword;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<CData/*0:0*/, 1> __Vm_traceActivity;
    VlTriggerVec<0> __VactTriggered;
    VlTriggerVec<0> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vtest_tb__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vtest_tb___024root(Vtest_tb__Syms* symsp, const char* v__name);
    ~Vtest_tb___024root();
    VL_UNCOPYABLE(Vtest_tb___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
