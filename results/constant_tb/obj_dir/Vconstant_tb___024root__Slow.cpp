// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vconstant_tb.h for the primary calling header

#include "Vconstant_tb__pch.h"
#include "Vconstant_tb__Syms.h"
#include "Vconstant_tb___024root.h"

void Vconstant_tb___024root___ctor_var_reset(Vconstant_tb___024root* vlSelf);

Vconstant_tb___024root::Vconstant_tb___024root(Vconstant_tb__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vconstant_tb___024root___ctor_var_reset(this);
}

void Vconstant_tb___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vconstant_tb___024root::~Vconstant_tb___024root() {
}
