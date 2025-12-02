// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vhamming_secded_ecc.h for the primary calling header

#include "Vhamming_secded_ecc__pch.h"
#include "Vhamming_secded_ecc___024root.h"

VL_ATTR_COLD void Vhamming_secded_ecc___024root___eval_static(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vhamming_secded_ecc___024root___eval_initial(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = vlSelf->rst_n;
}

VL_ATTR_COLD void Vhamming_secded_ecc___024root___eval_final(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_final\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__stl(Vhamming_secded_ecc___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vhamming_secded_ecc___024root___eval_phase__stl(Vhamming_secded_ecc___024root* vlSelf);

VL_ATTR_COLD void Vhamming_secded_ecc___024root___eval_settle(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_settle\n"); );
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
            Vhamming_secded_ecc___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/hamming_secded_ecc.v", 5, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vhamming_secded_ecc___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelf->__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__stl(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

void Vhamming_secded_ecc___024root___ico_sequent__TOP__0(Vhamming_secded_ecc___024root* vlSelf);

VL_ATTR_COLD void Vhamming_secded_ecc___024root___eval_stl(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vhamming_secded_ecc___024root___ico_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vhamming_secded_ecc___024root___eval_triggers__stl(Vhamming_secded_ecc___024root* vlSelf);

VL_ATTR_COLD bool Vhamming_secded_ecc___024root___eval_phase__stl(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_phase__stl\n"); );
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vhamming_secded_ecc___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelf->__VstlTriggered.any();
    if (__VstlExecute) {
        Vhamming_secded_ecc___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__ico(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___dump_triggers__ico\n"); );
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
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__act(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___dump_triggers__act\n"); );
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
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__nba(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk or negedge rst_n)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vhamming_secded_ecc___024root___ctor_var_reset(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->rst_n = VL_RAND_RESET_I(1);
    vlSelf->encode_en = VL_RAND_RESET_I(1);
    vlSelf->decode_en = VL_RAND_RESET_I(1);
    vlSelf->data_in = VL_RAND_RESET_I(8);
    vlSelf->codeword_in = VL_RAND_RESET_I(32);
    vlSelf->codeword_out = VL_RAND_RESET_I(32);
    vlSelf->data_out = VL_RAND_RESET_I(8);
    vlSelf->error_detected = VL_RAND_RESET_I(1);
    vlSelf->error_corrected = VL_RAND_RESET_I(1);
    vlSelf->valid_out = VL_RAND_RESET_I(1);
    vlSelf->hamming_secded_ecc__DOT__syndrome = VL_RAND_RESET_I(12);
    vlSelf->hamming_secded_ecc__DOT__encoded_codeword = VL_RAND_RESET_I(12);
    vlSelf->hamming_secded_ecc__DOT__extracted_data = VL_RAND_RESET_I(8);
    vlSelf->hamming_secded_ecc__DOT__single_error = VL_RAND_RESET_I(1);
    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__syndrome = VL_RAND_RESET_I(4);
    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity = VL_RAND_RESET_I(4);
    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__actual_parity = VL_RAND_RESET_I(4);
    vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__Vfuncout = VL_RAND_RESET_I(4);
    vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword = VL_RAND_RESET_I(12);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = VL_RAND_RESET_I(1);
}
