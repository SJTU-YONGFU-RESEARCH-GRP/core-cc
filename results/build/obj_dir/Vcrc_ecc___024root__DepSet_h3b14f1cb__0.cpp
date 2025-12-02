// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vcrc_ecc.h for the primary calling header

#include "Vcrc_ecc__pch.h"
#include "Vcrc_ecc___024root.h"

VL_INLINE_OPT void Vcrc_ecc___024root___ico_sequent__TOP__0(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___ico_sequent__TOP__0\n"); );
    // Init
    CData/*7:0*/ crc_ecc__DOT__calculate_crc__Vstatic__crc;
    crc_ecc__DOT__calculate_crc__Vstatic__crc = 0;
    CData/*7:0*/ __Vfunc_crc_ecc__DOT__calculate_crc__0__Vfuncout;
    __Vfunc_crc_ecc__DOT__calculate_crc__0__Vfuncout = 0;
    CData/*7:0*/ __Vfunc_crc_ecc__DOT__calculate_crc__0__data;
    __Vfunc_crc_ecc__DOT__calculate_crc__0__data = 0;
    // Body
    __Vfunc_crc_ecc__DOT__calculate_crc__0__data = vlSelf->data_in;
    crc_ecc__DOT__calculate_crc__Vstatic__crc = 0U;
    if ((1U & (IData)(__Vfunc_crc_ecc__DOT__calculate_crc__0__data))) {
        crc_ecc__DOT__calculate_crc__Vstatic__crc = 
            (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
    }
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    if ((2U & (IData)(__Vfunc_crc_ecc__DOT__calculate_crc__0__data))) {
        crc_ecc__DOT__calculate_crc__Vstatic__crc = 
            (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
    }
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    if ((4U & (IData)(__Vfunc_crc_ecc__DOT__calculate_crc__0__data))) {
        crc_ecc__DOT__calculate_crc__Vstatic__crc = 
            (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
    }
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    if ((8U & (IData)(__Vfunc_crc_ecc__DOT__calculate_crc__0__data))) {
        crc_ecc__DOT__calculate_crc__Vstatic__crc = 
            (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
    }
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    if ((0x10U & (IData)(__Vfunc_crc_ecc__DOT__calculate_crc__0__data))) {
        crc_ecc__DOT__calculate_crc__Vstatic__crc = 
            (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
    }
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    if ((0x20U & (IData)(__Vfunc_crc_ecc__DOT__calculate_crc__0__data))) {
        crc_ecc__DOT__calculate_crc__Vstatic__crc = 
            (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
    }
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    if ((0x40U & (IData)(__Vfunc_crc_ecc__DOT__calculate_crc__0__data))) {
        crc_ecc__DOT__calculate_crc__Vstatic__crc = 
            (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
    }
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    if ((0x80U & (IData)(__Vfunc_crc_ecc__DOT__calculate_crc__0__data))) {
        crc_ecc__DOT__calculate_crc__Vstatic__crc = 
            (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
    }
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    crc_ecc__DOT__calculate_crc__Vstatic__crc = (0xffU 
                                                 & ((0x80U 
                                                     & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                                     ? 
                                                    (7U 
                                                     ^ 
                                                     VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                                     : 
                                                    VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
    __Vfunc_crc_ecc__DOT__calculate_crc__0__Vfuncout 
        = crc_ecc__DOT__calculate_crc__Vstatic__crc;
    vlSelf->crc_ecc__DOT__calculated_crc = __Vfunc_crc_ecc__DOT__calculate_crc__0__Vfuncout;
    vlSelf->crc_ecc__DOT__crc_mismatch = (1U & (~ ([&]() {
                    vlSelf->__Vfunc_crc_ecc__DOT__check_crc__1__codeword 
                        = vlSelf->codeword_in;
                    vlSelf->crc_ecc__DOT__check_crc__Vstatic__data_part 
                        = (0xffU & (IData)(vlSelf->__Vfunc_crc_ecc__DOT__check_crc__1__codeword));
                    vlSelf->crc_ecc__DOT__check_crc__Vstatic__crc_part 
                        = (0xffU & ((IData)(vlSelf->__Vfunc_crc_ecc__DOT__check_crc__1__codeword) 
                                    >> 8U));
                    vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__data 
                        = vlSelf->crc_ecc__DOT__check_crc__Vstatic__data_part;
                    crc_ecc__DOT__calculate_crc__Vstatic__crc = 0U;
                    if ((1U & (IData)(vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__data))) {
                        crc_ecc__DOT__calculate_crc__Vstatic__crc 
                            = (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
                    }
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    if ((2U & (IData)(vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__data))) {
                        crc_ecc__DOT__calculate_crc__Vstatic__crc 
                            = (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
                    }
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    if ((4U & (IData)(vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__data))) {
                        crc_ecc__DOT__calculate_crc__Vstatic__crc 
                            = (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
                    }
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    if ((8U & (IData)(vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__data))) {
                        crc_ecc__DOT__calculate_crc__Vstatic__crc 
                            = (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
                    }
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    if ((0x10U & (IData)(vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__data))) {
                        crc_ecc__DOT__calculate_crc__Vstatic__crc 
                            = (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
                    }
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    if ((0x20U & (IData)(vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__data))) {
                        crc_ecc__DOT__calculate_crc__Vstatic__crc 
                            = (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
                    }
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    if ((0x40U & (IData)(vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__data))) {
                        crc_ecc__DOT__calculate_crc__Vstatic__crc 
                            = (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
                    }
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    if ((0x80U & (IData)(vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__data))) {
                        crc_ecc__DOT__calculate_crc__Vstatic__crc 
                            = (0x80U ^ (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc));
                    }
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    crc_ecc__DOT__calculate_crc__Vstatic__crc 
                        = (0xffU & ((0x80U & (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc))
                                     ? (7U ^ VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U))
                                     : VL_SHIFTL_III(8,8,32, (IData)(crc_ecc__DOT__calculate_crc__Vstatic__crc), 1U)));
                    vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__Vfuncout 
                        = crc_ecc__DOT__calculate_crc__Vstatic__crc;
                    vlSelf->crc_ecc__DOT__check_crc__Vstatic__crc 
                        = vlSelf->__Vfunc_crc_ecc__DOT__calculate_crc__2__Vfuncout;
                    vlSelf->__Vfunc_crc_ecc__DOT__check_crc__1__Vfuncout 
                        = ((IData)(vlSelf->crc_ecc__DOT__check_crc__Vstatic__crc) 
                           == (IData)(vlSelf->crc_ecc__DOT__check_crc__Vstatic__crc_part));
                }(), (IData)(vlSelf->__Vfunc_crc_ecc__DOT__check_crc__1__Vfuncout))));
}

void Vcrc_ecc___024root___eval_ico(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_ico\n"); );
    // Body
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        Vcrc_ecc___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vcrc_ecc___024root___eval_triggers__ico(Vcrc_ecc___024root* vlSelf);

bool Vcrc_ecc___024root___eval_phase__ico(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_phase__ico\n"); );
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vcrc_ecc___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelf->__VicoTriggered.any();
    if (__VicoExecute) {
        Vcrc_ecc___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vcrc_ecc___024root___eval_act(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vcrc_ecc___024root___nba_sequent__TOP__0(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___nba_sequent__TOP__0\n"); );
    // Body
    vlSelf->valid_out = ((IData)(vlSelf->rst_n) && (IData)(vlSelf->encode_en));
    if (vlSelf->rst_n) {
        if (vlSelf->decode_en) {
            vlSelf->data_out = (0xffU & (IData)(vlSelf->codeword_in));
            vlSelf->error_corrected = vlSelf->crc_ecc__DOT__crc_mismatch;
            vlSelf->error_detected = vlSelf->crc_ecc__DOT__crc_mismatch;
        }
        if (vlSelf->encode_en) {
            vlSelf->codeword_out = (((IData)(vlSelf->crc_ecc__DOT__calculated_crc) 
                                     << 8U) | (IData)(vlSelf->data_in));
        }
    } else {
        vlSelf->data_out = 0U;
        vlSelf->codeword_out = 0U;
        vlSelf->error_corrected = 0U;
        vlSelf->error_detected = 0U;
    }
}

void Vcrc_ecc___024root___eval_nba(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vcrc_ecc___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vcrc_ecc___024root___eval_triggers__act(Vcrc_ecc___024root* vlSelf);

bool Vcrc_ecc___024root___eval_phase__act(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vcrc_ecc___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vcrc_ecc___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vcrc_ecc___024root___eval_phase__nba(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vcrc_ecc___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vcrc_ecc___024root___dump_triggers__ico(Vcrc_ecc___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vcrc_ecc___024root___dump_triggers__nba(Vcrc_ecc___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vcrc_ecc___024root___dump_triggers__act(Vcrc_ecc___024root* vlSelf);
#endif  // VL_DEBUG

void Vcrc_ecc___024root___eval(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval\n"); );
    // Init
    IData/*31:0*/ __VicoIterCount;
    CData/*0:0*/ __VicoContinue;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VicoIterCount = 0U;
    vlSelf->__VicoFirstIteration = 1U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        if (VL_UNLIKELY((0x64U < __VicoIterCount))) {
#ifdef VL_DEBUG
            Vcrc_ecc___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/crc_ecc.v", 3, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vcrc_ecc___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelf->__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vcrc_ecc___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/crc_ecc.v", 3, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vcrc_ecc___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/crc_ecc.v", 3, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vcrc_ecc___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vcrc_ecc___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vcrc_ecc___024root___eval_debug_assertions(Vcrc_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vcrc_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vcrc_ecc___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst_n & 0xfeU))) {
        Verilated::overWidthError("rst_n");}
    if (VL_UNLIKELY((vlSelf->encode_en & 0xfeU))) {
        Verilated::overWidthError("encode_en");}
    if (VL_UNLIKELY((vlSelf->decode_en & 0xfeU))) {
        Verilated::overWidthError("decode_en");}
}
#endif  // VL_DEBUG
