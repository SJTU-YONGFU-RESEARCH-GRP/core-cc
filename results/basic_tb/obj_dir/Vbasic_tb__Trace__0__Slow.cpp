// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vbasic_tb__Syms.h"


VL_ATTR_COLD void Vbasic_tb___024root__trace_init_sub__TOP__0(Vbasic_tb___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root__trace_init_sub__TOP__0\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->pushPrefix("basic_tb", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+2,0,"data",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+3,0,"codeword",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 11,0);
    tracep->declBus(c+1,0,"expected_codeword",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 11,0);
    tracep->pushPrefix("enc", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+2,0,"data_in",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 7,0);
    tracep->declBus(c+3,0,"codeword",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 11,0);
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vbasic_tb___024root__trace_init_top(Vbasic_tb___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root__trace_init_top\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vbasic_tb___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vbasic_tb___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vbasic_tb___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vbasic_tb___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vbasic_tb___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vbasic_tb___024root__trace_register(Vbasic_tb___024root* vlSelf, VerilatedVcd* tracep) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root__trace_register\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    tracep->addConstCb(&Vbasic_tb___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vbasic_tb___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vbasic_tb___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vbasic_tb___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vbasic_tb___024root__trace_const_0_sub_0(Vbasic_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vbasic_tb___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root__trace_const_0\n"); );
    // Init
    Vbasic_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vbasic_tb___024root*>(voidSelf);
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vbasic_tb___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vbasic_tb___024root__trace_const_0_sub_0(Vbasic_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root__trace_const_0_sub_0\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullCData(oldp+2,(0xaaU),8);
    bufp->fullSData(oldp+3,(0xaaaU),12);
}

VL_ATTR_COLD void Vbasic_tb___024root__trace_full_0_sub_0(Vbasic_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vbasic_tb___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root__trace_full_0\n"); );
    // Init
    Vbasic_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vbasic_tb___024root*>(voidSelf);
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vbasic_tb___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vbasic_tb___024root__trace_full_0_sub_0(Vbasic_tb___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vbasic_tb___024root__trace_full_0_sub_0\n"); );
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullSData(oldp+1,(vlSelfRef.basic_tb__DOT__expected_codeword),12);
}
