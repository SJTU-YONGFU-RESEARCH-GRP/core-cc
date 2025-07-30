// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vconstant_tb.h for the primary calling header

#include "Vconstant_tb__pch.h"
#include "Vconstant_tb__Syms.h"
#include "Vconstant_tb___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vconstant_tb___024root___dump_triggers__act(Vconstant_tb___024root* vlSelf);
#endif  // VL_DEBUG

void Vconstant_tb___024root___eval_triggers__act(Vconstant_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vconstant_tb___024root___eval_triggers__act\n"); );
    Vconstant_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vconstant_tb___024root___dump_triggers__act(vlSelf);
    }
#endif
}
