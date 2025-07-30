// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsimple_tb.h for the primary calling header

#include "Vsimple_tb__pch.h"
#include "Vsimple_tb__Syms.h"
#include "Vsimple_tb___024root.h"

void Vsimple_tb___024root___ctor_var_reset(Vsimple_tb___024root* vlSelf);

Vsimple_tb___024root::Vsimple_tb___024root(Vsimple_tb__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vsimple_tb___024root___ctor_var_reset(this);
}

void Vsimple_tb___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vsimple_tb___024root::~Vsimple_tb___024root() {
}
