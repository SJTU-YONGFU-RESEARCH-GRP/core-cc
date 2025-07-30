// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vbasic_tb.h for the primary calling header

#include "Vbasic_tb__pch.h"
#include "Vbasic_tb__Syms.h"
#include "Vbasic_tb___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vbasic_tb___024root___dump_triggers__act(Vbasic_tb___024root* vlSelf);
#endif  // VL_DEBUG

void Vbasic_tb___024root___eval_triggers__act(Vbasic_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root___eval_triggers__act\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vbasic_tb___024root___dump_triggers__act(vlSelf);
    }
#endif
}
