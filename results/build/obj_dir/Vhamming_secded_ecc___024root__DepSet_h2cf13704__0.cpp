// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vhamming_secded_ecc.h for the primary calling header

#include "Vhamming_secded_ecc__pch.h"
#include "Vhamming_secded_ecc___024root.h"

VL_INLINE_OPT void Vhamming_secded_ecc___024root___ico_sequent__TOP__0(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___ico_sequent__TOP__0\n"); );
    // Init
    CData/*3:0*/ hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity;
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity = 0;
    SData/*11:0*/ hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword;
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword = 0;
    CData/*7:0*/ hamming_secded_ecc__DOT__extract_data__Vstatic__data;
    hamming_secded_ecc__DOT__extract_data__Vstatic__data = 0;
    CData/*3:0*/ hamming_secded_ecc__DOT__parity_bits;
    hamming_secded_ecc__DOT__parity_bits = 0;
    CData/*0:0*/ hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0;
    hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0 = 0;
    CData/*3:0*/ __Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__Vfuncout;
    __Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__Vfuncout = 0;
    CData/*7:0*/ __Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data;
    __Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data = 0;
    CData/*7:0*/ __Vfunc_hamming_secded_ecc__DOT__extract_data__2__Vfuncout;
    __Vfunc_hamming_secded_ecc__DOT__extract_data__2__Vfuncout = 0;
    SData/*11:0*/ __Vfunc_hamming_secded_ecc__DOT__extract_data__2__codeword;
    __Vfunc_hamming_secded_ecc__DOT__extract_data__2__codeword = 0;
    // Body
    __Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data 
        = vlSelf->data_in;
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword = 0U;
    hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0 
        = (1U & (IData)(__Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data));
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword 
        = ((0xffbU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword)) 
           | ((IData)(hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0) 
              << 2U));
    hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0 
        = (1U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data) 
                 >> 1U));
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword 
        = ((0xfefU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword)) 
           | ((IData)(hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0) 
              << 4U));
    hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0 
        = (1U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data) 
                 >> 2U));
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword 
        = ((0xfdfU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword)) 
           | ((IData)(hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0) 
              << 5U));
    hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0 
        = (1U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data) 
                 >> 3U));
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword 
        = ((0xfbfU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword)) 
           | ((IData)(hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0) 
              << 6U));
    hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0 
        = (1U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data) 
                 >> 4U));
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword 
        = ((0xeffU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword)) 
           | ((IData)(hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0) 
              << 8U));
    hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0 
        = (1U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data) 
                 >> 5U));
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword 
        = ((0xdffU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword)) 
           | ((IData)(hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0) 
              << 9U));
    hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0 
        = (1U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data) 
                 >> 6U));
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword 
        = ((0xbffU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword)) 
           | ((IData)(hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0) 
              << 0xaU));
    hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0 
        = (1U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__data) 
                 >> 7U));
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword 
        = ((0x7ffU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword)) 
           | ((IData)(hamming_secded_ecc__DOT____Vlvbound_he0c963f4__0) 
              << 0xbU));
    hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity = 0U;
    if ((4U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xeU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (1U & (~ (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity))));
    }
    if ((0x10U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xeU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (1U & (~ (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity))));
    }
    if ((0x40U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xeU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (1U & (~ (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity))));
    }
    if ((0x100U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xeU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (1U & (~ (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity))));
    }
    if ((0x400U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xeU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (1U & (~ (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity))));
    }
    if ((4U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xdU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (2U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 1U)) << 1U)));
    }
    if ((0x20U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xdU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (2U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 1U)) << 1U)));
    }
    if ((0x40U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xdU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (2U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 1U)) << 1U)));
    }
    if ((0x200U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xdU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (2U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 1U)) << 1U)));
    }
    if ((0x400U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xdU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (2U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 1U)) << 1U)));
    }
    if ((0x10U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xbU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (4U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 2U)) << 2U)));
    }
    if ((0x20U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xbU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (4U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 2U)) << 2U)));
    }
    if ((0x40U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xbU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (4U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 2U)) << 2U)));
    }
    if ((0x800U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((0xbU & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (4U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 2U)) << 2U)));
    }
    if ((0x100U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((7U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (8U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 3U)) << 3U)));
    }
    if ((0x200U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((7U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (8U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 3U)) << 3U)));
    }
    if ((0x400U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((7U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (8U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 3U)) << 3U)));
    }
    if ((0x800U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__temp_codeword))) {
        hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity 
            = ((7U & (IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity)) 
               | (8U & ((~ ((IData)(hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity) 
                            >> 3U)) << 3U)));
    }
    __Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__Vfuncout 
        = hamming_secded_ecc__DOT__calculate_parity__Vstatic__parity;
    hamming_secded_ecc__DOT__parity_bits = __Vfunc_hamming_secded_ecc__DOT__calculate_parity__0__Vfuncout;
    vlSelf->hamming_secded_ecc__DOT__syndrome = VL_EXTEND_II(12,4, 
                                                             ([&]() {
                vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword 
                    = (0xfffU & vlSelf->codeword_in);
                vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__actual_parity 
                    = ((8U & ((IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword) 
                              >> 4U)) | ((4U & ((IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword) 
                                                >> 1U)) 
                                         | (3U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))));
                vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity = 0U;
                if ((4U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xeU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (1U & (~ (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity))));
                }
                if ((0x10U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xeU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (1U & (~ (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity))));
                }
                if ((0x40U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xeU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (1U & (~ (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity))));
                }
                if ((0x100U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xeU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (1U & (~ (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity))));
                }
                if ((0x400U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xeU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (1U & (~ (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity))));
                }
                if ((4U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xdU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (2U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 1U)) << 1U)));
                }
                if ((0x20U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xdU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (2U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 1U)) << 1U)));
                }
                if ((0x40U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xdU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (2U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 1U)) << 1U)));
                }
                if ((0x200U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xdU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (2U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 1U)) << 1U)));
                }
                if ((0x400U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xdU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (2U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 1U)) << 1U)));
                }
                if ((0x10U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xbU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (4U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 2U)) << 2U)));
                }
                if ((0x20U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xbU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (4U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 2U)) << 2U)));
                }
                if ((0x40U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xbU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (4U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 2U)) << 2U)));
                }
                if ((0x800U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((0xbU & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (4U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 2U)) << 2U)));
                }
                if ((0x100U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((7U & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (8U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 3U)) << 3U)));
                }
                if ((0x200U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((7U & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (8U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 3U)) << 3U)));
                }
                if ((0x400U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((7U & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (8U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 3U)) << 3U)));
                }
                if ((0x800U & (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword))) {
                    vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity 
                        = ((7U & (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity)) 
                           | (8U & ((~ ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                                        >> 3U)) << 3U)));
                }
                vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__syndrome 
                    = ((IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity) 
                       ^ (IData)(vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__actual_parity));
                vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__Vfuncout 
                    = vlSelf->hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__syndrome;
            }(), (IData)(vlSelf->__Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__Vfuncout)));
    vlSelf->hamming_secded_ecc__DOT__encoded_codeword = 0U;
    vlSelf->hamming_secded_ecc__DOT__encoded_codeword 
        = ((0xffbU & (IData)(vlSelf->hamming_secded_ecc__DOT__encoded_codeword)) 
           | (4U & ((IData)(vlSelf->data_in) << 2U)));
    vlSelf->hamming_secded_ecc__DOT__encoded_codeword 
        = ((0xf8fU & (IData)(vlSelf->hamming_secded_ecc__DOT__encoded_codeword)) 
           | (0x70U & ((IData)(vlSelf->data_in) << 3U)));
    vlSelf->hamming_secded_ecc__DOT__encoded_codeword 
        = ((0xffU & (IData)(vlSelf->hamming_secded_ecc__DOT__encoded_codeword)) 
           | (0xf00U & ((IData)(vlSelf->data_in) << 4U)));
    vlSelf->hamming_secded_ecc__DOT__encoded_codeword 
        = ((0xffcU & (IData)(vlSelf->hamming_secded_ecc__DOT__encoded_codeword)) 
           | (3U & (IData)(hamming_secded_ecc__DOT__parity_bits)));
    vlSelf->hamming_secded_ecc__DOT__encoded_codeword 
        = ((0xff7U & (IData)(vlSelf->hamming_secded_ecc__DOT__encoded_codeword)) 
           | (8U & ((IData)(hamming_secded_ecc__DOT__parity_bits) 
                    << 1U)));
    vlSelf->hamming_secded_ecc__DOT__encoded_codeword 
        = ((0xf7fU & (IData)(vlSelf->hamming_secded_ecc__DOT__encoded_codeword)) 
           | (0x80U & ((IData)(hamming_secded_ecc__DOT__parity_bits) 
                       << 4U)));
    vlSelf->hamming_secded_ecc__DOT__single_error = 
        ((0U < (IData)(vlSelf->hamming_secded_ecc__DOT__syndrome)) 
         & (0xcU >= (IData)(vlSelf->hamming_secded_ecc__DOT__syndrome)));
    __Vfunc_hamming_secded_ecc__DOT__extract_data__2__codeword 
        = (0xfffU & ((IData)(vlSelf->hamming_secded_ecc__DOT__single_error)
                      ? (vlSelf->codeword_in ^ VL_SHIFTL_III(32,32,32, (IData)(1U), 
                                                             ((IData)(vlSelf->hamming_secded_ecc__DOT__syndrome) 
                                                              - (IData)(1U))))
                      : vlSelf->codeword_in));
    hamming_secded_ecc__DOT__extract_data__Vstatic__data = 0U;
    hamming_secded_ecc__DOT__extract_data__Vstatic__data 
        = ((0xf8U & (IData)(hamming_secded_ecc__DOT__extract_data__Vstatic__data)) 
           | ((4U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__extract_data__2__codeword) 
                     >> 3U)) | ((2U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__extract_data__2__codeword) 
                                       >> 3U)) | (1U 
                                                  & ((IData)(__Vfunc_hamming_secded_ecc__DOT__extract_data__2__codeword) 
                                                     >> 2U)))));
    hamming_secded_ecc__DOT__extract_data__Vstatic__data 
        = ((0xc7U & (IData)(hamming_secded_ecc__DOT__extract_data__Vstatic__data)) 
           | ((0x20U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__extract_data__2__codeword) 
                        >> 4U)) | ((0x10U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__extract_data__2__codeword) 
                                             >> 4U)) 
                                   | (8U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__extract_data__2__codeword) 
                                            >> 3U)))));
    hamming_secded_ecc__DOT__extract_data__Vstatic__data 
        = ((0x3fU & (IData)(hamming_secded_ecc__DOT__extract_data__Vstatic__data)) 
           | (0xc0U & ((IData)(__Vfunc_hamming_secded_ecc__DOT__extract_data__2__codeword) 
                       >> 4U)));
    __Vfunc_hamming_secded_ecc__DOT__extract_data__2__Vfuncout 
        = hamming_secded_ecc__DOT__extract_data__Vstatic__data;
    vlSelf->hamming_secded_ecc__DOT__extracted_data 
        = __Vfunc_hamming_secded_ecc__DOT__extract_data__2__Vfuncout;
}

void Vhamming_secded_ecc___024root___eval_ico(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_ico\n"); );
    // Body
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        Vhamming_secded_ecc___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vhamming_secded_ecc___024root___eval_triggers__ico(Vhamming_secded_ecc___024root* vlSelf);

bool Vhamming_secded_ecc___024root___eval_phase__ico(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_phase__ico\n"); );
    // Init
    CData/*0:0*/ __VicoExecute;
    // Body
    Vhamming_secded_ecc___024root___eval_triggers__ico(vlSelf);
    __VicoExecute = vlSelf->__VicoTriggered.any();
    if (__VicoExecute) {
        Vhamming_secded_ecc___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vhamming_secded_ecc___024root___eval_act(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vhamming_secded_ecc___024root___nba_sequent__TOP__0(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___nba_sequent__TOP__0\n"); );
    // Body
    vlSelf->valid_out = ((IData)(vlSelf->rst_n) && (IData)(vlSelf->encode_en));
    if (vlSelf->rst_n) {
        if (vlSelf->encode_en) {
            vlSelf->codeword_out = vlSelf->hamming_secded_ecc__DOT__encoded_codeword;
        }
        if (vlSelf->decode_en) {
            vlSelf->data_out = vlSelf->hamming_secded_ecc__DOT__extracted_data;
            vlSelf->error_corrected = vlSelf->hamming_secded_ecc__DOT__single_error;
            vlSelf->error_detected = (0U != (IData)(vlSelf->hamming_secded_ecc__DOT__syndrome));
        }
    } else {
        vlSelf->codeword_out = 0U;
        vlSelf->data_out = 0U;
        vlSelf->error_corrected = 0U;
        vlSelf->error_detected = 0U;
    }
}

void Vhamming_secded_ecc___024root___eval_nba(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vhamming_secded_ecc___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vhamming_secded_ecc___024root___eval_triggers__act(Vhamming_secded_ecc___024root* vlSelf);

bool Vhamming_secded_ecc___024root___eval_phase__act(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_phase__act\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    CData/*0:0*/ __VactExecute;
    // Body
    Vhamming_secded_ecc___024root___eval_triggers__act(vlSelf);
    __VactExecute = vlSelf->__VactTriggered.any();
    if (__VactExecute) {
        __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
        vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
        Vhamming_secded_ecc___024root___eval_act(vlSelf);
    }
    return (__VactExecute);
}

bool Vhamming_secded_ecc___024root___eval_phase__nba(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_phase__nba\n"); );
    // Init
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = vlSelf->__VnbaTriggered.any();
    if (__VnbaExecute) {
        Vhamming_secded_ecc___024root___eval_nba(vlSelf);
        vlSelf->__VnbaTriggered.clear();
    }
    return (__VnbaExecute);
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__ico(Vhamming_secded_ecc___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__nba(Vhamming_secded_ecc___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vhamming_secded_ecc___024root___dump_triggers__act(Vhamming_secded_ecc___024root* vlSelf);
#endif  // VL_DEBUG

void Vhamming_secded_ecc___024root___eval(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval\n"); );
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
            Vhamming_secded_ecc___024root___dump_triggers__ico(vlSelf);
#endif
            VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/hamming_secded_ecc.v", 5, "", "Input combinational region did not converge.");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        __VicoContinue = 0U;
        if (Vhamming_secded_ecc___024root___eval_phase__ico(vlSelf)) {
            __VicoContinue = 1U;
        }
        vlSelf->__VicoFirstIteration = 0U;
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
            Vhamming_secded_ecc___024root___dump_triggers__nba(vlSelf);
#endif
            VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/hamming_secded_ecc.v", 5, "", "NBA region did not converge.");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        __VnbaContinue = 0U;
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                Vhamming_secded_ecc___024root___dump_triggers__act(vlSelf);
#endif
                VL_FATAL_MT("/home/cylinder/projects/core-cc/verilogs/hamming_secded_ecc.v", 5, "", "Active region did not converge.");
            }
            vlSelf->__VactIterCount = ((IData)(1U) 
                                       + vlSelf->__VactIterCount);
            vlSelf->__VactContinue = 0U;
            if (Vhamming_secded_ecc___024root___eval_phase__act(vlSelf)) {
                vlSelf->__VactContinue = 1U;
            }
        }
        if (Vhamming_secded_ecc___024root___eval_phase__nba(vlSelf)) {
            __VnbaContinue = 1U;
        }
    }
}

#ifdef VL_DEBUG
void Vhamming_secded_ecc___024root___eval_debug_assertions(Vhamming_secded_ecc___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vhamming_secded_ecc__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vhamming_secded_ecc___024root___eval_debug_assertions\n"); );
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
