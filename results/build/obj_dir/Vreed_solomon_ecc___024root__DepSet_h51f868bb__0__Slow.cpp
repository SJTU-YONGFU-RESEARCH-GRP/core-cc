// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vreed_solomon_ecc.h for the primary calling header

#include "Vreed_solomon_ecc__pch.h"
#include "Vreed_solomon_ecc___024root.h"

VL_ATTR_COLD void Vreed_solomon_ecc___024root___eval_static(Vreed_solomon_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreed_solomon_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreed_solomon_ecc___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vreed_solomon_ecc___024root___eval_initial(Vreed_solomon_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreed_solomon_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreed_solomon_ecc___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = vlSelf->rst_n;
}

VL_ATTR_COLD void Vreed_solomon_ecc___024root___eval_final(Vreed_solomon_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreed_solomon_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreed_solomon_ecc___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vreed_solomon_ecc___024root___eval_settle(Vreed_solomon_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreed_solomon_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreed_solomon_ecc___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vreed_solomon_ecc___024root___dump_triggers__act(Vreed_solomon_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreed_solomon_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreed_solomon_ecc___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk or negedge rst_n)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vreed_solomon_ecc___024root___dump_triggers__nba(Vreed_solomon_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreed_solomon_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreed_solomon_ecc___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk or negedge rst_n)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vreed_solomon_ecc___024root___ctor_var_reset(Vreed_solomon_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vreed_solomon_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreed_solomon_ecc___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->rst_n = VL_RAND_RESET_I(1);
    vlSelf->encode_en = VL_RAND_RESET_I(1);
    vlSelf->decode_en = VL_RAND_RESET_I(1);
    vlSelf->data_in = VL_RAND_RESET_I(8);
    vlSelf->codeword_in = VL_RAND_RESET_I(16);
    vlSelf->codeword_out = VL_RAND_RESET_I(16);
    vlSelf->data_out = VL_RAND_RESET_I(8);
    vlSelf->error_detected = VL_RAND_RESET_I(1);
    vlSelf->error_corrected = VL_RAND_RESET_I(1);
    vlSelf->valid_out = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = VL_RAND_RESET_I(1);
}
