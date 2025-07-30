// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vreed_solomon_ecc.h for the primary calling header

#include "Vreed_solomon_ecc__pch.h"
#include "Vreed_solomon_ecc__Syms.h"
#include "Vreed_solomon_ecc___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vreed_solomon_ecc___024root___dump_triggers__stl(Vreed_solomon_ecc___024root* vlSelf);
#endif  // VL_DEBUG

VL_ATTR_COLD void Vreed_solomon_ecc___024root___eval_triggers__stl(Vreed_solomon_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vreed_solomon_ecc___024root___eval_triggers__stl\n"); );
    Vreed_solomon_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered.setBit(0U, (IData)(vlSelfRef.__VstlFirstIteration));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vreed_solomon_ecc___024root___dump_triggers__stl(vlSelf);
    }
#endif
}
