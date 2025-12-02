// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrepetition_ecc.h for the primary calling header

#include "Vrepetition_ecc__pch.h"
#include "Vrepetition_ecc__Syms.h"
#include "Vrepetition_ecc___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vrepetition_ecc___024root___dump_triggers__stl(Vrepetition_ecc___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vrepetition_ecc___024root___eval_triggers__stl(Vrepetition_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrepetition_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrepetition_ecc___024root___eval_triggers__stl\n"); );
    // Body
    vlSelf->__VstlTriggered.set(0U, (IData)(vlSelf->__VstlFirstIteration));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vrepetition_ecc___024root___dump_triggers__stl(vlSelf);
    }
#endif
}
