// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vpolar_ecc.h for the primary calling header

#include "Vpolar_ecc__pch.h"
#include "Vpolar_ecc__Syms.h"
#include "Vpolar_ecc___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vpolar_ecc___024root___dump_triggers__act(Vpolar_ecc___024root* vlSelf);
#endif  // VL_DEBUG

void Vpolar_ecc___024root___eval_triggers__act(Vpolar_ecc___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vpolar_ecc___024root___eval_triggers__act\n"); );
    Vpolar_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered.setBit(0U, ((IData)(vlSelfRef.clk) 
                                          & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__0))));
    vlSelfRef.__VactTriggered.setBit(1U, ((~ (IData)(vlSelfRef.rst_n)) 
                                          & (IData)(vlSelfRef.__Vtrigprevexpr___TOP__rst_n__0)));
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
    vlSelfRef.__Vtrigprevexpr___TOP__rst_n__0 = vlSelfRef.rst_n;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vpolar_ecc___024root___dump_triggers__act(vlSelf);
    }
#endif
}
