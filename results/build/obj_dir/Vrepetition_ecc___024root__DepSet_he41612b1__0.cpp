// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrepetition_ecc.h for the primary calling header

#include "Vrepetition_ecc__pch.h"
#include "Vrepetition_ecc___024root.h"

void Vrepetition_ecc___024root___ico_sequent__TOP__0(Vrepetition_ecc___024root* vlSelf);

void Vrepetition_ecc___024root___eval_ico(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_ico\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VicoTriggered.word(0U))) {
        Vrepetition_ecc___024root___ico_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vrepetition_ecc___024root___ico_sequent__TOP__0(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___ico_sequent__TOP__0\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count 
        = (1U & vlSelfRef.codeword_in);
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 1U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 2U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count 
        = (1U & (vlSelfRef.codeword_in >> 3U));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 4U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 5U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count 
        = (1U & (vlSelfRef.codeword_in >> 6U));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 7U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 8U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count 
        = (1U & (vlSelfRef.codeword_in >> 9U));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 0xaU))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 0xbU))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count 
        = (1U & (vlSelfRef.codeword_in >> 0xcU));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 0xdU))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 0xeU))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count 
        = (1U & (vlSelfRef.codeword_in >> 0xfU));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 0x10U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 0x11U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count 
        = (1U & (vlSelfRef.codeword_in >> 0x12U));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 0x13U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 0x14U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count 
        = (1U & (vlSelfRef.codeword_in >> 0x15U));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 0x16U))));
    vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count) 
                 + (1U & (vlSelfRef.codeword_in >> 0x17U))));
}

void Vrepetition_ecc___024root___eval_triggers__ico(Vrepetition_ecc___024root* vlSelf);

bool Vrepetition_ecc___024root___eval_phase__ico(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_phase__ico\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vrepetition_ecc___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelfRef.__VicoTriggered.any();
    if (__VicoExecute) {
        Vrepetition_ecc___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vrepetition_ecc___024root___eval_act(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_act\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vrepetition_ecc___024root___nba_sequent__TOP__0(Vrepetition_ecc___024root* vlSelf);

void Vrepetition_ecc___024root___eval_nba(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_nba\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((3ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vrepetition_ecc___024root___nba_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vrepetition_ecc___024root___nba_sequent__TOP__0(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___nba_sequent__TOP__0\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.valid_out = ((IData)(vlSelfRef.rst_n) 
                           && ((IData)(vlSelfRef.encode_en) 
                               || (IData)(vlSelfRef.decode_en)));
    if (vlSelfRef.rst_n) {
        if (vlSelfRef.encode_en) {
            vlSelfRef.error_detected = 0U;
            vlSelfRef.error_corrected = 0U;
            vlSelfRef.codeword_out = ((((0xe00000U 
                                         & ((- (IData)(
                                                       (1U 
                                                        & ((IData)(vlSelfRef.data_in) 
                                                           >> 7U)))) 
                                            << 0x15U)) 
                                        | (0x1c0000U 
                                           & ((- (IData)(
                                                         (1U 
                                                          & ((IData)(vlSelfRef.data_in) 
                                                             >> 6U)))) 
                                              << 0x12U))) 
                                       | ((0x38000U 
                                           & ((- (IData)(
                                                         (1U 
                                                          & ((IData)(vlSelfRef.data_in) 
                                                             >> 5U)))) 
                                              << 0xfU)) 
                                          | (0x7000U 
                                             & ((- (IData)(
                                                           (1U 
                                                            & ((IData)(vlSelfRef.data_in) 
                                                               >> 4U)))) 
                                                << 0xcU)))) 
                                      | (((0xe00U & 
                                           ((- (IData)(
                                                       (1U 
                                                        & ((IData)(vlSelfRef.data_in) 
                                                           >> 3U)))) 
                                            << 9U)) 
                                          | (0x1c0U 
                                             & ((- (IData)(
                                                           (1U 
                                                            & ((IData)(vlSelfRef.data_in) 
                                                               >> 2U)))) 
                                                << 6U))) 
                                         | ((0x38U 
                                             & ((- (IData)(
                                                           (1U 
                                                            & ((IData)(vlSelfRef.data_in) 
                                                               >> 1U)))) 
                                                << 3U)) 
                                            | (7U & 
                                               (- (IData)(
                                                          (1U 
                                                           & (IData)(vlSelfRef.data_in))))))));
            vlSelfRef.data_out = 0U;
        } else if (vlSelfRef.decode_en) {
            vlSelfRef.error_detected = 0U;
            vlSelfRef.error_corrected = 1U;
            vlSelfRef.codeword_out = 0U;
            vlSelfRef.data_out = (((((1U < (IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count)) 
                                     << 7U) | ((1U 
                                                < (IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count)) 
                                               << 6U)) 
                                   | (((1U < (IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count)) 
                                       << 5U) | ((1U 
                                                  < (IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count)) 
                                                 << 4U))) 
                                  | ((((1U < (IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count)) 
                                       << 3U) | ((1U 
                                                  < (IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count)) 
                                                 << 2U)) 
                                     | (((1U < (IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count)) 
                                         << 1U) | (1U 
                                                   < (IData)(vlSelfRef.repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count)))));
        }
    } else {
        vlSelfRef.error_detected = 0U;
        vlSelfRef.error_corrected = 0U;
        vlSelfRef.codeword_out = 0U;
        vlSelfRef.data_out = 0U;
    }
}

void Vrepetition_ecc___024root___eval_triggers__act(Vrepetition_ecc___024root* vlSelf);

bool Vrepetition_ecc___024root___eval_phase__act(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_phase__act\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<2> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vrepetition_ecc___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vrepetition_ecc___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vrepetition_ecc___024root___eval_phase__nba(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_phase__nba\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vrepetition_ecc___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vrepetition_ecc___024root___dump_triggers__ico(Vrepetition_ecc___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vrepetition_ecc___024root___dump_triggers__nba(Vrepetition_ecc___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vrepetition_ecc___024root___dump_triggers__act(Vrepetition_ecc___024root* vlSelf);
#endif  // VL_DEBUG

void Vrepetition_ecc___024root___eval(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VicoIterCount;
    CData/*0:0*/ __VicoContinue;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VicoIterCount = 0U;
    vlSelfRef.__VicoFirstIteration = 1U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        if (VL_UNLIKELY(((0x64U < __VicoIterCount)))) {
#ifdef VL_DEBUG
            Vrepetition_ecc___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("/mnt/d/proj/ecc/verilogs/repetition_ecc.v", 1, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vrepetition_ecc___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelfRef.__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY(((0x64U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vrepetition_ecc___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("/mnt/d/proj/ecc/verilogs/repetition_ecc.v", 1, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY(((0x64U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vrepetition_ecc___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("/mnt/d/proj/ecc/verilogs/repetition_ecc.v", 1, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vrepetition_ecc___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vrepetition_ecc___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vrepetition_ecc___024root___eval_debug_assertions(Vrepetition_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_debug_assertions\n"); );
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk & 0xfeU)))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY(((vlSelfRef.rst_n & 0xfeU)))) {
        Verilated::overWidthError("rst_n");}
    if (VL_UNLIKELY(((vlSelfRef.encode_en & 0xfeU)))) {
        Verilated::overWidthError("encode_en");}
    if (VL_UNLIKELY(((vlSelfRef.decode_en & 0xfeU)))) {
        Verilated::overWidthError("decode_en");}
    if (VL_UNLIKELY(((vlSelfRef.codeword_in & 0xff000000U)))) {
        Verilated::overWidthError("codeword_in");}
}
#endif  // VL_DEBUG
