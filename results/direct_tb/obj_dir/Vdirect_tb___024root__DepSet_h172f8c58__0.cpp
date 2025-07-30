// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdirect_tb.h for the primary calling header

#include "Vdirect_tb__pch.h"
#include "Vdirect_tb__Syms.h"
#include "Vdirect_tb___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vdirect_tb___024root___dump_triggers__act(Vdirect_tb___024root* vlSelf);
#endif  // VL_DEBUG

void Vdirect_tb___024root___eval_triggers__act(Vdirect_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdirect_tb___024root___eval_triggers__act\n"); );
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vdirect_tb___024root___dump_triggers__act(vlSelf);
    }
#endif
}
