// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vbasic_tb__Syms.h"


void Vbasic_tb___024root__trace_chg_0_sub_0(Vbasic_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vbasic_tb___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root__trace_chg_0\n"); );
    // Init
    Vbasic_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vbasic_tb___024root*>(voidSelf);
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vbasic_tb___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vbasic_tb___024root__trace_chg_0_sub_0(Vbasic_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root__trace_chg_0_sub_0\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[0U]))) {
        bufp->chgSData(oldp+0,(vlSelfRef.basic_tb__DOT__expected_codeword),12);
    }
}

void Vbasic_tb___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root__trace_cleanup\n"); );
    // Init
    Vbasic_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vbasic_tb___024root*>(voidSelf);
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
}
