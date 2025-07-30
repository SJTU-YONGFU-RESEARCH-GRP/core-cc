// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vbasic_tb__pch.h"
#include "Vbasic_tb.h"
#include "Vbasic_tb___024root.h"

// FUNCTIONS
Vbasic_tb__Syms::~Vbasic_tb__Syms()
{
}

Vbasic_tb__Syms::Vbasic_tb__Syms(VerilatedContext* contextp, const char* namep, Vbasic_tb* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
        // Check resources
        Verilated::stackCheck(11);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-9);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}
