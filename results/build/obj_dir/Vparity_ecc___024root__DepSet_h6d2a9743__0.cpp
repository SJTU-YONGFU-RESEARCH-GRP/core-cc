// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vparity_ecc.h for the primary calling header

#include "Vparity_ecc__pch.h"
#include "Vparity_ecc___024root.h"

void Vparity_ecc___024root___eval_act(Vparity_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vparity_ecc___024root___nba_sequent__TOP__0(Vparity_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___nba_sequent__TOP__0\n"); );
    // Body
    vlSelf->valid_out = ((IData)(vlSelf->rst_n) && (IData)(vlSelf->encode_en));
    if (vlSelf->rst_n) {
        if (vlSelf->decode_en) {
            vlSelf->data_out = (0xffU & ((IData)(vlSelf->codeword_in) 
                                         >> 1U));
            vlSelf->error_detected = ((1U & (IData)(vlSelf->codeword_in)) 
                                      != (1U & VL_REDXOR_8(vlSelf->data_in)));
        }
        if (vlSelf->encode_en) {
            vlSelf->codeword_out = (((IData)(vlSelf->data_in) 
                                     << 1U) | (1U & 
                                               VL_REDXOR_8(vlSelf->data_in)));
        }
    } else {
        vlSelf->data_out = 0U;
        vlSelf->codeword_out = 0U;
        vlSelf->error_detected = 0U;
    }
}

void Vparity_ecc___024root___eval_nba(Vparity_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vparity_ecc___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vparity_ecc___024root___eval_triggers__act(Vparity_ecc___024root* vlSelf);

bool Vparity_ecc___024root___eval_phase__act(Vparity_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vparity_ecc___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vparity_ecc___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vparity_ecc___024root___eval_phase__nba(Vparity_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vparity_ecc___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
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
    if (false && vlSelf) {}  // Prevent unused
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vparity_ecc___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/parity_ecc.v", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vparity_ecc___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/parity_ecc.v", 3, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vparity_ecc___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vparity_ecc___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vparity_ecc___024root___eval_debug_assertions(Vparity_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vparity_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vparity_ecc___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst_n & 0xfeU))) {
        Verilated::overWidthError("rst_n");}
    if (VL_UNLIKELY((vlSelf->encode_en & 0xfeU))) {
        Verilated::overWidthError("encode_en");}
    if (VL_UNLIKELY((vlSelf->decode_en & 0xfeU))) {
        Verilated::overWidthError("decode_en");}
    if (VL_UNLIKELY((vlSelf->codeword_in & 0xfe00U))) {
        Verilated::overWidthError("codeword_in");}
}
#endif  // VL_DEBUG
