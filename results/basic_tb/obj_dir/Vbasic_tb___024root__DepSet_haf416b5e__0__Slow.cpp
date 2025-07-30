// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vbasic_tb.h for the primary calling header

#include "Vbasic_tb__pch.h"
#include "Vbasic_tb___024root.h"

VL_ATTR_COLD void Vbasic_tb___024root___eval_static(Vbasic_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root___eval_static\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vbasic_tb___024root___eval_initial__TOP(Vbasic_tb___024root* vlSelf);
VL_ATTR_COLD void Vbasic_tb___024root____Vm_traceActivitySetAll(Vbasic_tb___024root* vlSelf);

VL_ATTR_COLD void Vbasic_tb___024root___eval_initial(Vbasic_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root___eval_initial\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vbasic_tb___024root___eval_initial__TOP(vlSelf);
    Vbasic_tb___024root____Vm_traceActivitySetAll(vlSelf);
}

VL_ATTR_COLD void Vbasic_tb___024root___eval_initial__TOP(Vbasic_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root___eval_initial__TOP\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.basic_tb__DOT__expected_codeword = 0xaaaU;
    VL_WRITEF_NX("BASIC: data=10101010, codeword=101010101010, expected=101010101010\nTEST: PASS\nRESULT:PASS\n",0);
    VL_FINISH_MT("/mnt/d/proj/ecc/testbenches/basic_tb.v", 37, "");
}

VL_ATTR_COLD void Vbasic_tb___024root___eval_final(Vbasic_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root___eval_final\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vbasic_tb___024root___eval_settle(Vbasic_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root___eval_settle\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vbasic_tb___024root___dump_triggers__act(Vbasic_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root___dump_triggers__act\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vbasic_tb___024root___dump_triggers__nba(Vbasic_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root___dump_triggers__nba\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vbasic_tb___024root____Vm_traceActivitySetAll(Vbasic_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root____Vm_traceActivitySetAll\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
}

VL_ATTR_COLD void Vbasic_tb___024root___ctor_var_reset(Vbasic_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root___ctor_var_reset\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->basic_tb__DOT__expected_codeword = VL_RAND_RESET_I(12);
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
