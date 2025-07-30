// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdirect_tb.h for the primary calling header

#include "Vdirect_tb__pch.h"
#include "Vdirect_tb___024root.h"

VL_ATTR_COLD void Vdirect_tb___024root___eval_static(Vdirect_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdirect_tb___024root___eval_static\n"); );
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vdirect_tb___024root___eval_initial__TOP(Vdirect_tb___024root* vlSelf);
VL_ATTR_COLD void Vdirect_tb___024root____Vm_traceActivitySetAll(Vdirect_tb___024root* vlSelf);

VL_ATTR_COLD void Vdirect_tb___024root___eval_initial(Vdirect_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdirect_tb___024root___eval_initial\n"); );
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vdirect_tb___024root___eval_initial__TOP(vlSelf);
    Vdirect_tb___024root____Vm_traceActivitySetAll(vlSelf);
}

VL_ATTR_COLD void Vdirect_tb___024root___eval_initial__TOP(Vdirect_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdirect_tb___024root___eval_initial__TOP\n"); );
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.direct_tb__DOT__expected_codeword = 0xaaaU;
    VL_WRITEF_NX("DIRECT: data=10101010, codeword=101010101010, expected=101010101010\nTEST: PASS\nRESULT:PASS\n",0);
    VL_FINISH_MT("/mnt/d/proj/ecc/testbenches/direct_tb.v", 44, "");
}

VL_ATTR_COLD void Vdirect_tb___024root___eval_final(Vdirect_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdirect_tb___024root___eval_final\n"); );
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vdirect_tb___024root___eval_settle(Vdirect_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdirect_tb___024root___eval_settle\n"); );
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vdirect_tb___024root___dump_triggers__act(Vdirect_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdirect_tb___024root___dump_triggers__act\n"); );
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vdirect_tb___024root___dump_triggers__nba(Vdirect_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdirect_tb___024root___dump_triggers__nba\n"); );
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vdirect_tb___024root____Vm_traceActivitySetAll(Vdirect_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdirect_tb___024root____Vm_traceActivitySetAll\n"); );
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
}

VL_ATTR_COLD void Vdirect_tb___024root___ctor_var_reset(Vdirect_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdirect_tb___024root___ctor_var_reset\n"); );
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->direct_tb__DOT__expected_codeword = VL_RAND_RESET_I(12);
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
