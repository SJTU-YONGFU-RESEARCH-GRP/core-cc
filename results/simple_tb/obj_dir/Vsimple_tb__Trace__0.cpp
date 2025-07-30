// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vsimple_tb__Syms.h"


void Vsimple_tb___024root__trace_chg_0_sub_0(Vsimple_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vsimple_tb___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root__trace_chg_0\n"); );
    // Init
    Vsimple_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsimple_tb___024root*>(voidSelf);
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vsimple_tb___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vsimple_tb___024root__trace_chg_0_sub_0(Vsimple_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root__trace_chg_0_sub_0\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[0U]))) {
        bufp->chgCData(oldp+0,(vlSelfRef.simple_tb__DOT__data),8);
        bufp->chgSData(oldp+1,(vlSelfRef.simple_tb__DOT__codeword),12);
    }
}

void Vsimple_tb___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root__trace_cleanup\n"); );
    // Init
    Vsimple_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsimple_tb___024root*>(voidSelf);
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
}
