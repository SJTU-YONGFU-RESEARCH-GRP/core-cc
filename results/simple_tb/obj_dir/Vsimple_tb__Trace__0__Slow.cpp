// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vsimple_tb__Syms.h"


VL_ATTR_COLD void Vsimple_tb___024root__trace_init_sub__TOP__0(Vsimple_tb___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root__trace_init_sub__TOP__0\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->pushPrefix("simple_tb", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+1,0,"data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+2,0,"codeword",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 11,0);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vsimple_tb___024root__trace_init_top(Vsimple_tb___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root__trace_init_top\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vsimple_tb___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vsimple_tb___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vsimple_tb___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vsimple_tb___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vsimple_tb___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vsimple_tb___024root__trace_register(Vsimple_tb___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root__trace_register\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vsimple_tb___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vsimple_tb___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vsimple_tb___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vsimple_tb___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vsimple_tb___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root__trace_const_0\n"); );
    // Init
    Vsimple_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsimple_tb___024root*>(voidSelf);
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
}

VL_ATTR_COLD void Vsimple_tb___024root__trace_full_0_sub_0(Vsimple_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vsimple_tb___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root__trace_full_0\n"); );
    // Init
    Vsimple_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vsimple_tb___024root*>(voidSelf);
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vsimple_tb___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vsimple_tb___024root__trace_full_0_sub_0(Vsimple_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimple_tb___024root__trace_full_0_sub_0\n"); );
    Vsimple_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullCData(oldp+1,(vlSelfRef.simple_tb__DOT__data),8);
    bufp->fullSData(oldp+2,(vlSelfRef.simple_tb__DOT__codeword),12);
}
