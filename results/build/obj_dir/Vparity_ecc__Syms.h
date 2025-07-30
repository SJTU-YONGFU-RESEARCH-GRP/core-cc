// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VPARITY_ECC__SYMS_H_
#define VERILATED_VPARITY_ECC__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vparity_ecc.h"

// INCLUDE MODULE CLASSES
#include "Vparity_ecc___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vparity_ecc__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vparity_ecc* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vparity_ecc___024root          TOP;

    // CONSTRUCTORS
    Vparity_ecc__Syms(VerilatedContext* contextp, const char* namep, Vparity_ecc* modelp);
    ~Vparity_ecc__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
