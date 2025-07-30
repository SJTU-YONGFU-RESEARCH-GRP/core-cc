// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VCRC_ECC__SYMS_H_
#define VERILATED_VCRC_ECC__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "Vcrc_ecc.h"

// INCLUDE MODULE CLASSES
#include "Vcrc_ecc___024root.h"

// SYMS CLASS (contains all model state)
class alignas(VL_CACHE_LINE_BYTES)Vcrc_ecc__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    Vcrc_ecc* const __Vm_modelp;
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    Vcrc_ecc___024root             TOP;

    // CONSTRUCTORS
    Vcrc_ecc__Syms(VerilatedContext* contextp, const char* namep, Vcrc_ecc* modelp);
    ~Vcrc_ecc__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
};

#endif  // guard
