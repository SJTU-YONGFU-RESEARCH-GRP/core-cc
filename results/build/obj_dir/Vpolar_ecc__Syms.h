// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VPOLAR_ECC__SYMS_H_
#define VERILATED_VPOLAR_ECC__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vpolar_ecc.h"

// INCLUDE MODULE CLASSES
#include "Vpolar_ecc___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vpolar_ecc__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vpolar_ecc* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vpolar_ecc___024root           TOP;

    // CONSTRUCTORS
    Vpolar_ecc__Syms(VerilatedContext* contextp, const char* namep, Vpolar_ecc* modelp);
    ~Vpolar_ecc__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
