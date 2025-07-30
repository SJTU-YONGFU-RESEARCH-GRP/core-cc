// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vhamming_secded_ecc__pch.h"

//============================================================
// Constructors

Vhamming_secded_ecc::Vhamming_secded_ecc(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vhamming_secded_ecc__Syms(contextp(), _vcname__, this)}
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

Vhamming_secded_ecc::Vhamming_secded_ecc(const char* _vcname__)
    : Vhamming_secded_ecc(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vhamming_secded_ecc::~Vhamming_secded_ecc() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vhamming_secded_ecc___024root___eval_debug_assertions(Vhamming_secded_ecc___024root* vlSelf);
#endif  // VL_DEBUG
void Vhamming_secded_ecc___024root___eval_static(Vhamming_secded_ecc___024root* vlSelf);
void Vhamming_secded_ecc___024root___eval_initial(Vhamming_secded_ecc___024root* vlSelf);
void Vhamming_secded_ecc___024root___eval_settle(Vhamming_secded_ecc___024root* vlSelf);
void Vhamming_secded_ecc___024root___eval(Vhamming_secded_ecc___024root* vlSelf);

void Vhamming_secded_ecc::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vhamming_secded_ecc::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vhamming_secded_ecc___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vhamming_secded_ecc___024root___eval_static(&(vlSymsp->TOP));
        Vhamming_secded_ecc___024root___eval_initial(&(vlSymsp->TOP));
        Vhamming_secded_ecc___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vhamming_secded_ecc___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vhamming_secded_ecc::eventsPending() { return false; }

uint64_t Vhamming_secded_ecc::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vhamming_secded_ecc::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vhamming_secded_ecc___024root___eval_final(Vhamming_secded_ecc___024root* vlSelf);

VL_ATTR_COLD void Vhamming_secded_ecc::final() {
    Vhamming_secded_ecc___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vhamming_secded_ecc::hierName() const { return vlSymsp->name(); }
const char* Vhamming_secded_ecc::modelName() const { return "Vhamming_secded_ecc"; }
unsigned Vhamming_secded_ecc::threads() const { return 1; }
void Vhamming_secded_ecc::prepareClone() const { contextp()->prepareClone(); }
void Vhamming_secded_ecc::atClone() const {
    contextp()->threadPoolpOnClone();
}
