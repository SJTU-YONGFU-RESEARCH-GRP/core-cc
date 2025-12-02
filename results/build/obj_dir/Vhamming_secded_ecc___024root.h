// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vhamming_secded_ecc.h for the primary calling header

#ifndef VERILATED_VHAMMING_SECDED_ECC___024ROOT_H_
#define VERILATED_VHAMMING_SECDED_ECC___024ROOT_H_  // guard

#include "verilated.h"


class Vhamming_secded_ecc__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vhamming_secded_ecc___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(rst_n,0,0);
    VL_IN8(encode_en,0,0);
    VL_IN8(decode_en,0,0);
    VL_IN8(data_in,7,0);
    VL_OUT8(data_out,7,0);
    VL_OUT8(error_detected,0,0);
    VL_OUT8(error_corrected,0,0);
    VL_OUT8(valid_out,0,0);
    CData/*7:0*/ hamming_secded_ecc__DOT__extracted_data;
    CData/*0:0*/ hamming_secded_ecc__DOT__single_error;
    CData/*3:0*/ hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__syndrome;
    CData/*3:0*/ hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__expected_parity;
    CData/*3:0*/ hamming_secded_ecc__DOT__calculate_syndrome__Vstatic__actual_parity;
    CData/*3:0*/ __Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__Vfuncout;
    CData/*0:0*/ __VstlFirstIteration;
    CData/*0:0*/ __VicoFirstIteration;
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __Vtrigprevexpr___TOP__rst_n__0;
    CData/*0:0*/ __VactContinue;
    SData/*11:0*/ hamming_secded_ecc__DOT__syndrome;
    SData/*11:0*/ hamming_secded_ecc__DOT__encoded_codeword;
    SData/*11:0*/ __Vfunc_hamming_secded_ecc__DOT__calculate_syndrome__1__codeword;
    VL_IN(codeword_in,31,0);
    VL_OUT(codeword_out,31,0);
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vhamming_secded_ecc__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vhamming_secded_ecc___024root(Vhamming_secded_ecc__Syms* symsp, const char* v__name);
    ~Vhamming_secded_ecc___024root();
    VL_UNCOPYABLE(Vhamming_secded_ecc___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
