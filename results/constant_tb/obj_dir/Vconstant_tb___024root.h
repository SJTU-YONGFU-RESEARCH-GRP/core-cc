// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vconstant_tb.h for the primary calling header

#ifndef VERILATED_VCONSTANT_TB___024ROOT_H_
#define VERILATED_VCONSTANT_TB___024ROOT_H_  // guard

#include "verilated.h"


class Vconstant_tb__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vconstant_tb___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    CData/*0:0*/ __VactContinue;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<0> __VactTriggered;
    VlTriggerVec<0> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vconstant_tb__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vconstant_tb___024root(Vconstant_tb__Syms* symsp, const char* v__name);
    ~Vconstant_tb___024root();
    VL_UNCOPYABLE(Vconstant_tb___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
