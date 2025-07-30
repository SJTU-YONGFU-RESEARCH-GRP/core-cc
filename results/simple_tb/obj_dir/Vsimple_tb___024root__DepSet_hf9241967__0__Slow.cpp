// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsimple_tb.h for the primary calling header

#include "Vsimple_tb__pch.h"
#include "Vsimple_tb___024root.h"

VL_ATTR_COLD void Vsimple_tb___024root___eval_static(Vsimple_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root___eval_static\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vsimple_tb___024root___eval_initial__TOP(Vsimple_tb___024root* vlSelf);
VL_ATTR_COLD void Vsimple_tb___024root____Vm_traceActivitySetAll(Vsimple_tb___024root* vlSelf);

VL_ATTR_COLD void Vsimple_tb___024root___eval_initial(Vsimple_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root___eval_initial\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vsimple_tb___024root___eval_initial__TOP(vlSelf);
    Vsimple_tb___024root____Vm_traceActivitySetAll(vlSelf);
}

VL_ATTR_COLD void Vsimple_tb___024root___eval_initial__TOP(Vsimple_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root___eval_initial__TOP\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VL_WRITEF_NX("data=00000001, codeword=000000000001\n",0);
    vlSelfRef.simple_tb__DOT__data = 0xaaU;
    vlSelfRef.simple_tb__DOT__codeword = 0xaaaU;
    VL_WRITEF_NX("data=10101010, codeword=101010101010\n",0);
    VL_FINISH_MT("/mnt/d/proj/ecc/testbenches/simple_tb.v", 18, "");
}

VL_ATTR_COLD void Vsimple_tb___024root___eval_final(Vsimple_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root___eval_final\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vsimple_tb___024root___eval_settle(Vsimple_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root___eval_settle\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsimple_tb___024root___dump_triggers__act(Vsimple_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root___dump_triggers__act\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vsimple_tb___024root___dump_triggers__nba(Vsimple_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root___dump_triggers__nba\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vsimple_tb___024root____Vm_traceActivitySetAll(Vsimple_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root____Vm_traceActivitySetAll\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
}

VL_ATTR_COLD void Vsimple_tb___024root___ctor_var_reset(Vsimple_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root___ctor_var_reset\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->simple_tb__DOT__data = VL_RAND_RESET_I(8);
    vlSelf->simple_tb__DOT__codeword = VL_RAND_RESET_I(12);
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
