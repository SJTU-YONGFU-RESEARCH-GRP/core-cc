// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vhamming_secded_ecc.h for the primary calling header

#include "Vhamming_secded_ecc__pch.h"
#include "Vhamming_secded_ecc___024root.h"

void Vhamming_secded_ecc___024root___ico_sequent__TOP__0(Vhamming_secded_ecc___024root* vlSelf);

void Vhamming_secded_ecc___024root___eval_ico(Vhamming_secded_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_ico\n"); );
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VicoTriggered.word(0U))) {
        Vhamming_secded_ecc___024root___ico_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vhamming_secded_ecc___024root___ico_sequent__TOP__0(Vhamming_secded_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___ico_sequent__TOP__0\n"); );
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit;
    hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit = 0;
    CData/*0:0*/ hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit;
    hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit = 0;
    CData/*0:0*/ hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit;
    hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit = 0;
    CData/*0:0*/ hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit;
    hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit = 0;
    // Body
    vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__0__KET____DOT__parity_bit 
        = (1U & ((IData)(vlSelfRef.data_in) >> 2U));
    vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__0__KET____DOT__parity_bit 
        = (1U & ((IData)(vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__0__KET____DOT__parity_bit) 
                 ^ ((IData)(vlSelfRef.data_in) >> 4U)));
    vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__0__KET____DOT__parity_bit 
        = (1U & ((IData)(vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__0__KET____DOT__parity_bit) 
                 ^ ((IData)(vlSelfRef.data_in) >> 6U)));
    vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__1__KET____DOT__parity_bit 
        = (1U & ((IData)(vlSelfRef.data_in) >> 2U));
    vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__1__KET____DOT__parity_bit 
        = (1U & ((IData)(vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__1__KET____DOT__parity_bit) 
                 ^ ((IData)(vlSelfRef.data_in) >> 5U)));
    vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__1__KET____DOT__parity_bit 
        = (1U & ((IData)(vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__1__KET____DOT__parity_bit) 
                 ^ ((IData)(vlSelfRef.data_in) >> 6U)));
    vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__2__KET____DOT__parity_bit 
        = (1U & ((IData)(vlSelfRef.data_in) >> 3U));
    vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__2__KET____DOT__parity_bit 
        = (1U & ((IData)(vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__2__KET____DOT__parity_bit) 
                 ^ ((IData)(vlSelfRef.data_in) >> 4U)));
    vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__2__KET____DOT__parity_bit 
        = (1U & ((IData)(vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__2__KET____DOT__parity_bit) 
                 ^ ((IData)(vlSelfRef.data_in) >> 5U)));
    vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__2__KET____DOT__parity_bit 
        = (1U & ((IData)(vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__2__KET____DOT__parity_bit) 
                 ^ ((IData)(vlSelfRef.data_in) >> 6U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit 
        = (1U & (vlSelfRef.codeword_in >> 2U));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 4U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 6U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 8U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 0xaU)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit 
        = (1U & (vlSelfRef.codeword_in >> 2U));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 5U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 6U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 9U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 0xaU)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit 
        = (1U & (vlSelfRef.codeword_in >> 3U));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 4U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 5U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 6U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 0xbU)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit 
        = (1U & (vlSelfRef.codeword_in >> 7U));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 8U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 9U)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 0xaU)));
    hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit 
        = (1U & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit) 
                 ^ (vlSelfRef.codeword_in >> 0xbU)));
    vlSelfRef.hamming_secded_ecc__DOT__syndrome = (
                                                   (0xff0U 
                                                    & (IData)(vlSelfRef.hamming_secded_ecc__DOT__syndrome)) 
                                                   | (((8U 
                                                        & (((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__3__KET____DOT__syndrome_bit) 
                                                            << 3U) 
                                                           ^ 
                                                           (0xfffffff8U 
                                                            & vlSelfRef.codeword_in))) 
                                                       | (4U 
                                                          & (((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__2__KET____DOT__syndrome_bit) 
                                                              << 2U) 
                                                             ^ 
                                                             (0xfffffffcU 
                                                              & vlSelfRef.codeword_in)))) 
                                                      | ((2U 
                                                          & (((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__1__KET____DOT__syndrome_bit) 
                                                              << 1U) 
                                                             ^ 
                                                             (0xfffffffeU 
                                                              & vlSelfRef.codeword_in))) 
                                                         | (1U 
                                                            & ((IData)(hamming_secded_ecc__DOT__syndrome_gen__BRA__0__KET____DOT__syndrome_bit) 
                                                               ^ vlSelfRef.codeword_in)))));
    vlSelfRef.hamming_secded_ecc__DOT__single_error 
        = ((0U != (IData)(vlSelfRef.hamming_secded_ecc__DOT__syndrome)) 
           & (0xcU >= (IData)(vlSelfRef.hamming_secded_ecc__DOT__syndrome)));
}

void Vhamming_secded_ecc___024root___eval_triggers__ico(Vhamming_secded_ecc___024root* vlSelf);

bool Vhamming_secded_ecc___024root___eval_phase__ico(Vhamming_secded_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_phase__ico\n"); );
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vhamming_secded_ecc___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelfRef.__VicoTriggered.any();
    if (__VicoExecute) {
        Vhamming_secded_ecc___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vhamming_secded_ecc___024root___eval_act(Vhamming_secded_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_act\n"); );
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vhamming_secded_ecc___024root___nba_sequent__TOP__0(Vhamming_secded_ecc___024root* vlSelf);

void Vhamming_secded_ecc___024root___eval_nba(Vhamming_secded_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_nba\n"); );
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((3ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vhamming_secded_ecc___024root___nba_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vhamming_secded_ecc___024root___nba_sequent__TOP__0(Vhamming_secded_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___nba_sequent__TOP__0\n"); );
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.valid_out = ((IData)(vlSelfRef.rst_n) 
                           && (IData)(vlSelfRef.encode_en));
    if (vlSelfRef.rst_n) {
        if (vlSelfRef.decode_en) {
            vlSelfRef.error_corrected = vlSelfRef.hamming_secded_ecc__DOT__single_error;
            vlSelfRef.error_detected = (0U != (IData)(vlSelfRef.hamming_secded_ecc__DOT__syndrome));
            vlSelfRef.data_out = (0xffU & (((IData)(vlSelfRef.hamming_secded_ecc__DOT__single_error)
                                             ? (vlSelfRef.codeword_in 
                                                ^ VL_SHIFTL_III(32,32,32, (IData)(1U), 
                                                                ((IData)(vlSelfRef.hamming_secded_ecc__DOT__syndrome) 
                                                                 - (IData)(1U))))
                                             : vlSelfRef.codeword_in) 
                                           >> 4U));
        }
        if (vlSelfRef.encode_en) {
            vlSelfRef.codeword_out = (((IData)(vlSelfRef.data_in) 
                                       << 4U) | (((8U 
                                                   & ((IData)(vlSelfRef.data_in) 
                                                      >> 4U)) 
                                                  | ((IData)(vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__2__KET____DOT__parity_bit) 
                                                     << 2U)) 
                                                 | (((IData)(vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__1__KET____DOT__parity_bit) 
                                                     << 1U) 
                                                    | (IData)(vlSelfRef.hamming_secded_ecc__DOT__parity_gen__BRA__0__KET____DOT__parity_bit))));
        }
    } else {
        vlSelfRef.error_corrected = 0U;
        vlSelfRef.error_detected = 0U;
        vlSelfRef.codeword_out = 0U;
        vlSelfRef.data_out = 0U;
    }
}

void Vhamming_secded_ecc___024root___eval_triggers__act(Vhamming_secded_ecc___024root* vlSelf);

bool Vhamming_secded_ecc___024root___eval_phase__act(Vhamming_secded_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_phase__act\n"); );
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<2> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vhamming_secded_ecc___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vhamming_secded_ecc___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vhamming_secded_ecc___024root___eval_phase__nba(Vhamming_secded_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_phase__nba\n"); );
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vhamming_secded_ecc___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__ico(Vhamming_secded_ecc___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__nba(Vhamming_secded_ecc___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__act(Vhamming_secded_ecc___024root* vlSelf);
#endif  // VL_DEBUG

void Vhamming_secded_ecc___024root___eval(Vhamming_secded_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval\n"); );
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
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
            Vhamming_secded_ecc___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("/mnt/d/proj/ecc/verilogs/hamming_secded_ecc.v", 5, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vhamming_secded_ecc___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelfRef.__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY(((0x64U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vhamming_secded_ecc___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("/mnt/d/proj/ecc/verilogs/hamming_secded_ecc.v", 5, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY(((0x64U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vhamming_secded_ecc___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("/mnt/d/proj/ecc/verilogs/hamming_secded_ecc.v", 5, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vhamming_secded_ecc___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vhamming_secded_ecc___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vhamming_secded_ecc___024root___eval_debug_assertions(Vhamming_secded_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_debug_assertions\n"); );
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
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
}
#endif  // VL_DEBUG
