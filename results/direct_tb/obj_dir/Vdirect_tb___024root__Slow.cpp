// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdirect_tb.h for the primary calling header

#include "Vdirect_tb__pch.h"
#include "Vdirect_tb__Syms.h"
#include "Vdirect_tb___024root.h"

void Vdirect_tb___024root___ctor_var_reset(Vdirect_tb___024root* vlSelf);

Vdirect_tb___024root::Vdirect_tb___024root(Vdirect_tb__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vdirect_tb___024root___ctor_var_reset(this);
}

void Vdirect_tb___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vdirect_tb___024root::~Vdirect_tb___024root() {
}
