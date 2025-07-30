// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtest_tb.h for the primary calling header

#include "Vtest_tb__pch.h"
#include "Vtest_tb___024root.h"

VL_ATTR_COLD void Vtest_tb___024root___eval_static(Vtest_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_tb___024root___eval_static\n"); );
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtest_tb___024root___eval_initial__TOP(Vtest_tb___024root* vlSelf);
VL_ATTR_COLD void Vtest_tb___024root____Vm_traceActivitySetAll(Vtest_tb___024root* vlSelf);

VL_ATTR_COLD void Vtest_tb___024root___eval_initial(Vtest_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_tb___024root___eval_initial\n"); );
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtest_tb___024root___eval_initial__TOP(vlSelf);
    Vtest_tb___024root____Vm_traceActivitySetAll(vlSelf);
}

VL_ATTR_COLD void Vtest_tb___024root___eval_initial__TOP(Vtest_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_tb___024root___eval_initial__TOP\n"); );
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.test_tb__DOT__expected_codeword = 0xaaaU;
    VL_WRITEF_NX("TEST: data=10101010, codeword=101010101010, expected=101010101010\nTEST: PASS\nRESULT:PASS\n",0);
    VL_FINISH_MT("/mnt/d/proj/ecc/testbenches/test_tb.v", 39, "");
}

VL_ATTR_COLD void Vtest_tb___024root___eval_final(Vtest_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_tb___024root___eval_final\n"); );
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtest_tb___024root___eval_settle(Vtest_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_tb___024root___eval_settle\n"); );
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_tb___024root___dump_triggers__act(Vtest_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_tb___024root___dump_triggers__act\n"); );
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtest_tb___024root___dump_triggers__nba(Vtest_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_tb___024root___dump_triggers__nba\n"); );
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtest_tb___024root____Vm_traceActivitySetAll(Vtest_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_tb___024root____Vm_traceActivitySetAll\n"); );
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
}

VL_ATTR_COLD void Vtest_tb___024root___ctor_var_reset(Vtest_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtest_tb___024root___ctor_var_reset\n"); );
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->test_tb__DOT__expected_codeword = VL_RAND_RESET_I(12);
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
