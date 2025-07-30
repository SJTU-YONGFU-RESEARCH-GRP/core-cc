// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vpolar_ecc__pch.h"

//============================================================
// Constructors

Vpolar_ecc::Vpolar_ecc(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vpolar_ecc__Syms(contextp(), _vcname__, this)}
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

Vpolar_ecc::Vpolar_ecc(const char* _vcname__)
    : Vpolar_ecc(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vpolar_ecc::~Vpolar_ecc() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vpolar_ecc___024root___eval_debug_assertions(Vpolar_ecc___024root* vlSelf);
#endif  // VL_DEBUG
void Vpolar_ecc___024root___eval_static(Vpolar_ecc___024root* vlSelf);
void Vpolar_ecc___024root___eval_initial(Vpolar_ecc___024root* vlSelf);
void Vpolar_ecc___024root___eval_settle(Vpolar_ecc___024root* vlSelf);
void Vpolar_ecc___024root___eval(Vpolar_ecc___024root* vlSelf);

void Vpolar_ecc::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vpolar_ecc::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vpolar_ecc___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vpolar_ecc___024root___eval_static(&(vlSymsp->TOP));
        Vpolar_ecc___024root___eval_initial(&(vlSymsp->TOP));
        Vpolar_ecc___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vpolar_ecc___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vpolar_ecc::eventsPending() { return false; }

uint64_t Vpolar_ecc::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vpolar_ecc::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vpolar_ecc___024root___eval_final(Vpolar_ecc___024root* vlSelf);

VL_ATTR_COLD void Vpolar_ecc::final() {
    Vpolar_ecc___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vpolar_ecc::hierName() const { return vlSymsp->name(); }
const char* Vpolar_ecc::modelName() const { return "Vpolar_ecc"; }
unsigned Vpolar_ecc::threads() const { return 1; }
void Vpolar_ecc::prepareClone() const { contextp()->prepareClone(); }
void Vpolar_ecc::atClone() const {
    contextp()->threadPoolpOnClone();
}
