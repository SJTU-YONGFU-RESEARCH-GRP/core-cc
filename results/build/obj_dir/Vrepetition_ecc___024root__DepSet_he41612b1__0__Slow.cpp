// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrepetition_ecc.h for the primary calling header

#include "Vrepetition_ecc__pch.h"
#include "Vrepetition_ecc___024root.h"

VL_ATTR_COLD void Vrepetition_ecc___024root___eval_static(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_static\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
    vlSelfRef.__Vtrigprevexpr___TOP__rst_n__0 = vlSelfRef.rst_n;
}

VL_ATTR_COLD void Vrepetition_ecc___024root___eval_initial(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_initial\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vrepetition_ecc___024root___eval_final(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_final\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vrepetition_ecc___024root___dump_triggers__stl(Vrepetition_ecc___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vrepetition_ecc___024root___eval_phase__stl(Vrepetition_ecc___024root* vlSelf);

VL_ATTR_COLD void Vrepetition_ecc___024root___eval_settle(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_settle\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VstlIterCount;
    CData/*0:0*/ __VstlContinue;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        if (VL_UNLIKELY(((0x64U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vrepetition_ecc___024root___dump_triggers__stl(vlSelf);
#endif
            VL_FATAL_MT("/mnt/d/proj/ecc/verilogs/repetition_ecc.v", 1, "", "Settle region did not converge.");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        __VstlContinue = 0U;
        if (Vrepetition_ecc___024root___eval_phase__stl(vlSelf)) {
            __VstlContinue = 1U;
        }
        vlSelfRef.__VstlFirstIteration = 0U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vrepetition_ecc___024root___dump_triggers__stl(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___dump_triggers__stl\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VstlTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

void Vrepetition_ecc___024root___ico_sequent__TOP__0(Vrepetition_ecc___024root* vlSelf);

VL_ATTR_COLD void Vrepetition_ecc___024root___eval_stl(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_stl\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered.word(0U))) {
        Vrepetition_ecc___024root___ico_sequent__TOP__0(vlSelf);
    }
}

VL_ATTR_COLD void Vrepetition_ecc___024root___eval_triggers__stl(Vrepetition_ecc___024root* vlSelf);

VL_ATTR_COLD bool Vrepetition_ecc___024root___eval_phase__stl(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_phase__stl\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VstlExecute;
    // Body
    Vrepetition_ecc___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = vlSelfRef.__VstlTriggered.any();
    if (__VstlExecute) {
        Vrepetition_ecc___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vrepetition_ecc___024root___dump_triggers__ico(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___dump_triggers__ico\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VicoTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VicoTriggered.word(0U))) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vrepetition_ecc___024root___dump_triggers__act(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___dump_triggers__act\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VactTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
    if ((2ULL & vlSelfRef.__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 1 is active: @(negedge rst_n)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vrepetition_ecc___024root___dump_triggers__nba(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___dump_triggers__nba\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1U & (~ vlSelfRef.__VnbaTriggered.any()))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
    if ((2ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 1 is active: @(negedge rst_n)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vrepetition_ecc___024root___ctor_var_reset(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___ctor_var_reset\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->rst_n = VL_RAND_RESET_I(1);
    vlSelf->encode_en = VL_RAND_RESET_I(1);
    vlSelf->decode_en = VL_RAND_RESET_I(1);
    vlSelf->data_in = VL_RAND_RESET_I(8);
    vlSelf->codeword_in = VL_RAND_RESET_I(24);
    vlSelf->codeword_out = VL_RAND_RESET_I(24);
    vlSelf->data_out = VL_RAND_RESET_I(8);
    vlSelf->error_detected = VL_RAND_RESET_I(1);
    vlSelf->error_corrected = VL_RAND_RESET_I(1);
    vlSelf->valid_out = VL_RAND_RESET_I(1);
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count = VL_RAND_RESET_I(2);
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count = VL_RAND_RESET_I(2);
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count = VL_RAND_RESET_I(2);
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count = VL_RAND_RESET_I(2);
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count = VL_RAND_RESET_I(2);
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count = VL_RAND_RESET_I(2);
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count = VL_RAND_RESET_I(2);
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count = VL_RAND_RESET_I(2);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigprevexpr___TOP__rst_n__0 = VL_RAND_RESET_I(1);
}
