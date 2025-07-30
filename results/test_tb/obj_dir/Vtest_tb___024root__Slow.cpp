// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtest_tb.h for the primary calling header

#include "Vtest_tb__pch.h"
#include "Vtest_tb__Syms.h"
#include "Vtest_tb___024root.h"

void Vtest_tb___024root___ctor_var_reset(Vtest_tb___024root* vlSelf);

Vtest_tb___024root::Vtest_tb___024root(Vtest_tb__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtest_tb___024root___ctor_var_reset(this);
}

void Vtest_tb___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vtest_tb___024root::~Vtest_tb___024root() {
}
