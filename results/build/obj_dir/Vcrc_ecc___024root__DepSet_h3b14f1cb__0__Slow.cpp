// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcrc_ecc.h for the primary calling header

#include "Vcrc_ecc__pch.h"
#include "Vcrc_ecc___024root.h"

VL_ATTR_COLD void Vcrc_ecc___024root___eval_static(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vcrc_ecc___024root___eval_initial(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = vlSelf->rst_n;
}

VL_ATTR_COLD void Vcrc_ecc___024root___eval_final(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_final\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcrc_ecc___024root___dump_triggers__stl(Vcrc_ecc___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vcrc_ecc___024root___eval_phase__stl(Vcrc_ecc___024root* vlSelf);

VL_ATTR_COLD void Vcrc_ecc___024root___eval_settle(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_settle\n"); );
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelf->__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY((0x64U < __VstlIterCount))) {
#ifdef VL_DEBUG
            Vcrc_ecc___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/crc_ecc.v", 3, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vcrc_ecc___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelf->__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcrc_ecc___024root___dump_triggers__stl(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

void Vcrc_ecc___024root___ico_sequent__TOP__0(Vcrc_ecc___024root* vlSelf);

VL_ATTR_COLD void Vcrc_ecc___024root___eval_stl(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vcrc_ecc___024root___ico_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vcrc_ecc___024root___eval_triggers__stl(Vcrc_ecc___024root* vlSelf);

VL_ATTR_COLD bool Vcrc_ecc___024root___eval_phase__stl(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_phase__stl\n"); );
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vcrc_ecc___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelf->__VstlTriggered.any();
    if (__VstlExecute) {
        Vcrc_ecc___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcrc_ecc___024root___dump_triggers__ico(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VicoTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcrc_ecc___024root___dump_triggers__act(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___dump_triggers__act\n"); );
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
VL_ATTR_COLD void Vcrc_ecc___024root___dump_triggers__nba(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk or negedge rst_n)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcrc_ecc___024root___ctor_var_reset(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___ctor_var_reset\n"); );
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
    vlSelf->crc_ecc__DOT__calculated_crc = VL_RAND_RESET_I(8);
    vlSelf->crc_ecc__DOT__crc_mismatch = VL_RAND_RESET_I(1);
    vlSelf->crc_ecc__DOT__check_crc__Vstatic__crc = VL_RAND_RESET_I(8);
    vlSelf->crc_ecc__DOT__check_crc__Vstatic__data_part = VL_RAND_RESET_I(8);
    vlSelf->crc_ecc__DOT__check_crc__Vstatic__crc_part = VL_RAND_RESET_I(8);
    vlSelf->__Vfunc_crc_ecc__DOT__check_crc__1__Vfuncout = VL_RAND_RESET_I(1);
    vlSelf->__Vfunc_crc_ecc__DOT__check_crc__1__codeword = VL_RAND_RESET_I(16);
    vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__Vfuncout = VL_RAND_RESET_I(8);
    vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__data = VL_RAND_RESET_I(8);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = VL_RAND_RESET_I(1);
}
