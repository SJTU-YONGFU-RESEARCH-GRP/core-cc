// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VHAMMING_SECDED_ECC__SYMS_H_
#define VERILATED_VHAMMING_SECDED_ECC__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vhamming_secded_ecc.h"

// INCLUDE MODULE CLASSES
#include "Vhamming_secded_ecc___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vhamming_secded_ecc__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vhamming_secded_ecc* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vhamming_secded_ecc___024root  TOP;

    // CONSTRUCTORS
    Vhamming_secded_ecc__Syms(VerilatedContext* contextp, const char* namep, Vhamming_secded_ecc* modelp);
    ~Vhamming_secded_ecc__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
