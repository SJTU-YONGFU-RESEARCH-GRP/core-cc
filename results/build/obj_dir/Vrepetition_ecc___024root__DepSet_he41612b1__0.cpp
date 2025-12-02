// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrepetition_ecc.h for the primary calling header

#include "Vrepetition_ecc__pch.h"
#include "Vrepetition_ecc___024root.h"

VL_INLINE_OPT void Vrepetition_ecc___024root___ico_sequent__TOP__0(Vrepetition_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___ico_sequent__TOP__0\n"); );
    // Body
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count 
        = (1U & vlSelf->codeword_in);
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 1U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 2U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count 
        = (1U & (vlSelf->codeword_in >> 3U));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 4U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 5U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count 
        = (1U & (vlSelf->codeword_in >> 6U));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 7U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 8U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count 
        = (1U & (vlSelf->codeword_in >> 9U));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 0xaU))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 0xbU))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count 
        = (1U & (vlSelf->codeword_in >> 0xcU));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 0xdU))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 0xeU))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count 
        = (1U & (vlSelf->codeword_in >> 0xfU));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 0x10U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 0x11U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count 
        = (1U & (vlSelf->codeword_in >> 0x12U));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 0x13U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 0x14U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count 
        = (1U & (vlSelf->codeword_in >> 0x15U));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 0x16U))));
    vlSelf->repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count 
        = (3U & ((IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count) 
                 + (1U & (vlSelf->codeword_in >> 0x17U))));
}

void Vrepetition_ecc___024root___eval_ico(Vrepetition_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_ico\n"); );
    // Body
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        Vrepetition_ecc___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vrepetition_ecc___024root___eval_triggers__ico(Vrepetition_ecc___024root* vlSelf);

bool Vrepetition_ecc___024root___eval_phase__ico(Vrepetition_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_phase__ico\n"); );
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vrepetition_ecc___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelf->__VicoTriggered.any();
    if (__VicoExecute) {
        Vrepetition_ecc___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vrepetition_ecc___024root___eval_act(Vrepetition_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vrepetition_ecc___024root___nba_sequent__TOP__0(Vrepetition_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___nba_sequent__TOP__0\n"); );
    // Body
    if (vlSelf->rst_n) {
        if (vlSelf->encode_en) {
            vlSelf->error_corrected = 0U;
            vlSelf->error_detected = 0U;
            vlSelf->codeword_out = ((0xe00000U & ((- (IData)(
                                                             (1U 
                                                              & ((IData)(vlSelf->data_in) 
                                                                 >> 7U)))) 
                                                  << 0x15U)) 
                                    | ((0x1c0000U & 
                                        ((- (IData)(
                                                    (1U 
                                                     & ((IData)(vlSelf->data_in) 
                                                        >> 6U)))) 
                                         << 0x12U)) 
                                       | ((0x38000U 
                                           & ((- (IData)(
                                                         (1U 
                                                          & ((IData)(vlSelf->data_in) 
                                                             >> 5U)))) 
                                              << 0xfU)) 
                                          | ((0x7000U 
                                              & ((- (IData)(
                                                            (1U 
                                                             & ((IData)(vlSelf->data_in) 
                                                                >> 4U)))) 
                                                 << 0xcU)) 
                                             | ((0xe00U 
                                                 & ((- (IData)(
                                                               (1U 
                                                                & ((IData)(vlSelf->data_in) 
                                                                   >> 3U)))) 
                                                    << 9U)) 
                                                | ((0x1c0U 
                                                    & ((- (IData)(
                                                                  (1U 
                                                                   & ((IData)(vlSelf->data_in) 
                                                                      >> 2U)))) 
                                                       << 6U)) 
                                                   | ((0x38U 
                                                       & ((- (IData)(
                                                                     (1U 
                                                                      & ((IData)(vlSelf->data_in) 
                                                                         >> 1U)))) 
                                                          << 3U)) 
                                                      | (7U 
                                                         & (- (IData)(
                                                                      (1U 
                                                                       & (IData)(vlSelf->data_in))))))))))));
            vlSelf->data_out = 0U;
        } else if (vlSelf->decode_en) {
            vlSelf->error_corrected = 0U;
            vlSelf->error_detected = 0U;
            vlSelf->codeword_out = 0U;
            vlSelf->data_out = (((1U < (IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__7__KET____DOT__ones_count)) 
                                 << 7U) | (((1U < (IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__6__KET____DOT__ones_count)) 
                                            << 6U) 
                                           | (((1U 
                                                < (IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__5__KET____DOT__ones_count)) 
                                               << 5U) 
                                              | (((1U 
                                                   < (IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__4__KET____DOT__ones_count)) 
                                                  << 4U) 
                                                 | (((1U 
                                                      < (IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__3__KET____DOT__ones_count)) 
                                                     << 3U) 
                                                    | (((1U 
                                                         < (IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__2__KET____DOT__ones_count)) 
                                                        << 2U) 
                                                       | (((1U 
                                                            < (IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__1__KET____DOT__ones_count)) 
                                                           << 1U) 
                                                          | (1U 
                                                             < (IData)(vlSelf->repetition_ecc__DOT__decode_gen__BRA__0__KET____DOT__ones_count)))))))));
        }
    } else {
        vlSelf->error_corrected = 0U;
        vlSelf->error_detected = 0U;
        vlSelf->codeword_out = 0U;
        vlSelf->data_out = 0U;
    }
    vlSelf->valid_out = ((IData)(vlSelf->rst_n) && 
                         ((IData)(vlSelf->encode_en) 
                          || (IData)(vlSelf->decode_en)));
}

void Vrepetition_ecc___024root___eval_nba(Vrepetition_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vrepetition_ecc___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vrepetition_ecc___024root___eval_triggers__act(Vrepetition_ecc___024root* vlSelf);

bool Vrepetition_ecc___024root___eval_phase__act(Vrepetition_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vrepetition_ecc___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vrepetition_ecc___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vrepetition_ecc___024root___eval_phase__nba(Vrepetition_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vrepetition_ecc___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
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
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VicoIterCount;
    CData/*0:0*/ __VicoContinue;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VicoIterCount = 0U;
    vlSelf->__VicoFirstIteration = 1U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        if (VL_UNLIKELY((0x64U < __VicoIterCount))) {
#ifdef VL_DEBUG
            Vrepetition_ecc___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/repetition_ecc.v", 1, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vrepetition_ecc___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelf->__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vrepetition_ecc___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/repetition_ecc.v", 1, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vrepetition_ecc___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/repetition_ecc.v", 1, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vrepetition_ecc___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vrepetition_ecc___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vrepetition_ecc___024root___eval_debug_assertions(Vrepetition_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst_n & 0xfeU))) {
        Verilated::overWidthError("rst_n");}
    if (VL_UNLIKELY((vlSelf->encode_en & 0xfeU))) {
        Verilated::overWidthError("encode_en");}
    if (VL_UNLIKELY((vlSelf->decode_en & 0xfeU))) {
        Verilated::overWidthError("decode_en");}
    if (VL_UNLIKELY((vlSelf->codeword_in & 0xff000000U))) {
        Verilated::overWidthError("codeword_in");}
}
#endif  // VL_DEBUG
