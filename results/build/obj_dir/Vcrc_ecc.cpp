// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vcrc_ecc__pch.h"

//============================================================
// Constructors

Vcrc_ecc::Vcrc_ecc(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vcrc_ecc__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst_n{vlSymsp->TOP.rst_n}
    , encode_en{vlSymsp->TOP.encode_en}
    , decode_en{vlSymsp->TOP.decode_en}
    , data_in{vlSymsp->TOP.data_in}
    , data_out{vlSymsp->TOP.data_out}
    , error_detected{vlSymsp->TOP.error_detected}
    , error_corrected{vlSymsp->TOP.error_corrected}
    , valid_out{vlSymsp->TOP.valid_out}
    , codeword_in{vlSymsp->TOP.codeword_in}
    , codeword_out{vlSymsp->TOP.codeword_out}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vcrc_ecc::Vcrc_ecc(const char* _vcname__)
    : Vcrc_ecc(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vcrc_ecc::~Vcrc_ecc() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vcrc_ecc___024root___eval_debug_assertions(Vcrc_ecc___024root* vlSelf);
#endif  // VL_DEBUG
void Vcrc_ecc___024root___eval_static(Vcrc_ecc___024root* vlSelf);
void Vcrc_ecc___024root___eval_initial(Vcrc_ecc___024root* vlSelf);
void Vcrc_ecc___024root___eval_settle(Vcrc_ecc___024root* vlSelf);
void Vcrc_ecc___024root___eval(Vcrc_ecc___024root* vlSelf);

void Vcrc_ecc::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vcrc_ecc::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vcrc_ecc___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vcrc_ecc___024root___eval_static(&(vlSymsp->TOP));
        Vcrc_ecc___024root___eval_initial(&(vlSymsp->TOP));
        Vcrc_ecc___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vcrc_ecc___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vcrc_ecc::eventsPending() { return false; }

uint64_t Vcrc_ecc::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vcrc_ecc::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vcrc_ecc___024root___eval_final(Vcrc_ecc___024root* vlSelf);

VL_ATTR_COLD void Vcrc_ecc::final() {
    Vcrc_ecc___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vcrc_ecc::hierName() const { return vlSymsp->name(); }
const char* Vcrc_ecc::modelName() const { return "Vcrc_ecc"; }
unsigned Vcrc_ecc::threads() const { return 1; }
void Vcrc_ecc::prepareClone() const { contextp()->prepareClone(); }
void Vcrc_ecc::atClone() const {
    contextp()->threadPoolpOnClone();
}
