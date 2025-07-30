// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtest_tb.h for the primary calling header

#include "Vtest_tb__pch.h"
#include "Vtest_tb__Syms.h"
#include "Vtest_tb___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_tb___024root___dump_triggers__act(Vtest_tb___024root* vlSelf);
#endif  // VL_DEBUG

void Vtest_tb___024root___eval_triggers__act(Vtest_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_tb___024root___eval_triggers__act\n"); );
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtest_tb___024root___dump_triggers__act(vlSelf);
    }
#endif
}
