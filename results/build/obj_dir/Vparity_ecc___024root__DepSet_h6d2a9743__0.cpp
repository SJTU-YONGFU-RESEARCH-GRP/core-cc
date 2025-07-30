// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vparity_ecc.h for the primary calling header

#include "Vparity_ecc__pch.h"
#include "Vparity_ecc___024root.h"

void Vparity_ecc___024root___eval_act(Vparity_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval_act\n"); );
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

void Vparity_ecc___024root___nba_sequent__TOP__0(Vparity_ecc___024root* vlSelf);

void Vparity_ecc___024root___eval_nba(Vparity_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval_nba\n"); );
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((3ULL & vlSelfRef.__VnbaTriggered.word(0U))) {
        Vparity_ecc___024root___nba_sequent__TOP__0(vlSelf);
    }
}

VL_INLINE_OPT void Vparity_ecc___024root___nba_sequent__TOP__0(Vparity_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___nba_sequent__TOP__0\n"); );
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.valid_out = ((IData)(vlSelfRef.rst_n) 
                           && (IData)(vlSelfRef.encode_en));
    if (vlSelfRef.rst_n) {
        if (vlSelfRef.encode_en) {
            vlSelfRef.codeword_out = (((IData)(vlSelfRef.data_in) 
                                       << 1U) | (1U 
                                                 & VL_REDXOR_8(vlSelfRef.data_in)));
        }
        if (vlSelfRef.decode_en) {
            vlSelfRef.data_out = (0xffU & ((IData)(vlSelfRef.codeword_in) 
                                           >> 1U));
            vlSelfRef.error_detected = ((1U & (IData)(vlSelfRef.codeword_in)) 
                                        != (1U & VL_REDXOR_8(vlSelfRef.data_in)));
        }
    } else {
        vlSelfRef.codeword_out = 0U;
        vlSelfRef.data_out = 0U;
        vlSelfRef.error_detected = 0U;
    }
}

void Vparity_ecc___024root___eval_triggers__act(Vparity_ecc___024root* vlSelf);

bool Vparity_ecc___024root___eval_phase__act(Vparity_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval_phase__act\n"); );
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    VlTriggerVec<2> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vparity_ecc___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelfRef.__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelfRef.__VactTriggered, vlSelfRef.__VnbaTriggered);
        vlSelfRef.__VnbaTriggered.thisOr(vlSelfRef.__VactTriggered);
        Vparity_ecc___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vparity_ecc___024root___eval_phase__nba(Vparity_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval_phase__nba\n"); );
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelfRef.__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vparity_ecc___024root___eval_nba(vlSelf);
        vlSelfRef.__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vparity_ecc___024root___dump_triggers__nba(Vparity_ecc___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vparity_ecc___024root___dump_triggers__act(Vparity_ecc___024root* vlSelf);
#endif  // VL_DEBUG

void Vparity_ecc___024root___eval(Vparity_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval\n"); );
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY(((0x64U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vparity_ecc___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("/mnt/d/proj/ecc/verilogs/parity_ecc.v", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelfRef.__VactIterCount = 0U;
        vlSelfRef.__VactContinue = 1U;
        while (vlSelfRef.__VactContinue) {
            if (VL_UNLIKELY(((0x64U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vparity_ecc___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("/mnt/d/proj/ecc/verilogs/parity_ecc.v", 3, "", "Active region did not converge.");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactContinue = 0U;
            if (Vparity_ecc___024root___eval_phase__act(vlSelf)) {
                vlSelfRef.__VactContinue = 1U;
            }
        }
        if (Vparity_ecc___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vparity_ecc___024root___eval_debug_assertions(Vparity_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval_debug_assertions\n"); );
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
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
    if (VL_UNLIKELY(((vlSelfRef.codeword_in & 0xfe00U)))) {
        Verilated::overWidthError("codeword_in");}
}
#endif  // VL_DEBUG
