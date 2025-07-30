// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vparity_ecc__pch.h"

//============================================================
// Constructors

Vparity_ecc::Vparity_ecc(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vparity_ecc__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst_n{vlSymsp->TOP.rst_n}
    , encode_en{vlSymsp->TOP.encode_en}
    , decode_en{vlSymsp->TOP.decode_en}
    , data_in{vlSymsp->TOP.data_in}
    , data_out{vlSymsp->TOP.data_out}
    , error_detected{vlSymsp->TOP.error_detected}
    , valid_out{vlSymsp->TOP.valid_out}
    , codeword_in{vlSymsp->TOP.codeword_in}
    , codeword_out{vlSymsp->TOP.codeword_out}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vparity_ecc::Vparity_ecc(const char* _vcname__)
    : Vparity_ecc(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vparity_ecc::~Vparity_ecc() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vparity_ecc___024root___eval_debug_assertions(Vparity_ecc___024root* vlSelf);
#endif  // VL_DEBUG
void Vparity_ecc___024root___eval_static(Vparity_ecc___024root* vlSelf);
void Vparity_ecc___024root___eval_initial(Vparity_ecc___024root* vlSelf);
void Vparity_ecc___024root___eval_settle(Vparity_ecc___024root* vlSelf);
void Vparity_ecc___024root___eval(Vparity_ecc___024root* vlSelf);

void Vparity_ecc::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vparity_ecc::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vparity_ecc___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vparity_ecc___024root___eval_static(&(vlSymsp->TOP));
        Vparity_ecc___024root___eval_initial(&(vlSymsp->TOP));
        Vparity_ecc___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vparity_ecc___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vparity_ecc::eventsPending() { return false; }

uint64_t Vparity_ecc::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vparity_ecc::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vparity_ecc___024root___eval_final(Vparity_ecc___024root* vlSelf);

VL_ATTR_COLD void Vparity_ecc::final() {
    Vparity_ecc___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vparity_ecc::hierName() const { return vlSymsp->name(); }
const char* Vparity_ecc::modelName() const { return "Vparity_ecc"; }
unsigned Vparity_ecc::threads() const { return 1; }
void Vparity_ecc::prepareClone() const { contextp()->prepareClone(); }
void Vparity_ecc::atClone() const {
    contextp()->threadPoolpOnClone();
}
