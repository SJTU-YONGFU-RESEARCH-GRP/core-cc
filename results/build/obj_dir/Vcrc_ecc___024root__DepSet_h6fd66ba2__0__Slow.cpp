// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcrc_ecc.h for the primary calling header

#include "Vcrc_ecc__pch.h"
#include "Vcrc_ecc__Syms.h"
#include "Vcrc_ecc___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcrc_ecc___024root___dump_triggers__stl(Vcrc_ecc___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vcrc_ecc___024root___eval_triggers__stl(Vcrc_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_triggers__stl\n"); );
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered.setBit(0U, (IData)(vlSelfRef.__VstlFirstIteration));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vcrc_ecc___024root___dump_triggers__stl(vlSelf);
    }
#endif
}
