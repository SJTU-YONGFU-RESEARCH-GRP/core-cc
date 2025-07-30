// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vconstant_tb.h for the primary calling header

#include "Vconstant_tb__pch.h"
#include "Vconstant_tb___024root.h"

VL_ATTR_COLD void Vconstant_tb___024root___eval_static(Vconstant_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vconstant_tb___024root___eval_static\n"); );
    Vconstant_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vconstant_tb___024root___eval_initial__TOP(Vconstant_tb___024root* vlSelf);

VL_ATTR_COLD void Vconstant_tb___024root___eval_initial(Vconstant_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vconstant_tb___024root___eval_initial\n"); );
    Vconstant_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vconstant_tb___024root___eval_initial__TOP(vlSelf);
}

VL_ATTR_COLD void Vconstant_tb___024root___eval_initial__TOP(Vconstant_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vconstant_tb___024root___eval_initial__TOP\n"); );
    Vconstant_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    VL_WRITEF_NX("CONSTANT: data=10101010, codeword=101010101010, expected=101010101010\nTEST: PASS\nRESULT:PASS\n",0);
    VL_FINISH_MT("/mnt/d/proj/ecc/testbenches/constant_tb.v", 37, "");
}

VL_ATTR_COLD void Vconstant_tb___024root___eval_final(Vconstant_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vconstant_tb___024root___eval_final\n"); );
    Vconstant_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vconstant_tb___024root___eval_settle(Vconstant_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vconstant_tb___024root___eval_settle\n"); );
    Vconstant_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vconstant_tb___024root___dump_triggers__act(Vconstant_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vconstant_tb___024root___dump_triggers__act\n"); );
    Vconstant_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vconstant_tb___024root___dump_triggers__nba(Vconstant_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vconstant_tb___024root___dump_triggers__nba\n"); );
    Vconstant_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vconstant_tb___024root___ctor_var_reset(Vconstant_tb___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vconstant_tb___024root___ctor_var_reset\n"); );
    Vconstant_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}
