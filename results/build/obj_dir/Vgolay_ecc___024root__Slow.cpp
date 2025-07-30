// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vgolay_ecc.h for the primary calling header

#include "Vgolay_ecc__pch.h"
#include "Vgolay_ecc__Syms.h"
#include "Vgolay_ecc___024root.h"

void Vgolay_ecc___024root___ctor_var_reset(Vgolay_ecc___024root* vlSelf);

Vgolay_ecc___024root::Vgolay_ecc___024root(Vgolay_ecc__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vgolay_ecc___024root___ctor_var_reset(this);
}

void Vgolay_ecc___024root::__Vconfigure(bool first) {
    (void)first;  // Prevent unused variable warning
}

Vgolay_ecc___024root::~Vgolay_ecc___024root() {
}
