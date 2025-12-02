// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vldpc_ecc__pch.h"

//============================================================
// Constructors

Vldpc_ecc::Vldpc_ecc(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vldpc_ecc__Syms(contextp(), _vcname__, this)}
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

Vldpc_ecc::Vldpc_ecc(const char* _vcname__)
    : Vldpc_ecc(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vldpc_ecc::~Vldpc_ecc() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vldpc_ecc___024root___eval_debug_assertions(Vldpc_ecc___024root* vlSelf);
#endif  // VL_DEBUG
void Vldpc_ecc___024root___eval_static(Vldpc_ecc___024root* vlSelf);
void Vldpc_ecc___024root___eval_initial(Vldpc_ecc___024root* vlSelf);
void Vldpc_ecc___024root___eval_settle(Vldpc_ecc___024root* vlSelf);
void Vldpc_ecc___024root___eval(Vldpc_ecc___024root* vlSelf);

void Vldpc_ecc::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vldpc_ecc::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vldpc_ecc___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vldpc_ecc___024root___eval_static(&(vlSymsp->TOP));
        Vldpc_ecc___024root___eval_initial(&(vlSymsp->TOP));
        Vldpc_ecc___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vldpc_ecc___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vldpc_ecc::eventsPending() { return false; }

uint64_t Vldpc_ecc::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vldpc_ecc::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vldpc_ecc___024root___eval_final(Vldpc_ecc___024root* vlSelf);

VL_ATTR_COLD void Vldpc_ecc::final() {
    Vldpc_ecc___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vldpc_ecc::hierName() const { return vlSymsp->name(); }
const char* Vldpc_ecc::modelName() const { return "Vldpc_ecc"; }
unsigned Vldpc_ecc::threads() const { return 1; }
void Vldpc_ecc::prepareClone() const { contextp()->prepareClone(); }
void Vldpc_ecc::atClone() const {
    contextp()->threadPoolpOnClone();
}

//============================================================
// Trace configuration

VL_ATTR_COLD void Vldpc_ecc::trace(VerilatedVcdC* tfp, int levels, int options) {
    vl_fatal(__FILE__, __LINE__, __FILE__,"'Vldpc_ecc::trace()' called on model that was Verilated without --trace option");
}
