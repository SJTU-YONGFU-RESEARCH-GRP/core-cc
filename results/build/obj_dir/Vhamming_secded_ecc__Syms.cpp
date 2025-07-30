// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "Vhamming_secded_ecc__pch.h"
#include "Vhamming_secded_ecc.h"
#include "Vhamming_secded_ecc___024root.h"

// FUNCTIONS
Vhamming_secded_ecc__Syms::~Vhamming_secded_ecc__Syms()
{
}

Vhamming_secded_ecc__Syms::Vhamming_secded_ecc__Syms(VerilatedContext* contextp, const char* namep, Vhamming_secded_ecc* modelp)
    : VerilatedSyms{contextp}
    // Setup internal state of the Syms class
    , __Vm_modelp{modelp}
    // Setup module instances
    , TOP{this, namep}
{
        // Check resources
        Verilated::stackCheck(41);
    // Configure time unit / time precision
    _vm_contextp__->timeunit(-12);
    _vm_contextp__->timeprecision(-12);
    // Setup each module's pointers to their submodules
    // Setup each module's pointer back to symbol table (for public functions)
    TOP.__Vconfigure(true);
}
