// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vbasic_tb__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vbasic_tb::Vbasic_tb(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vbasic_tb__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vbasic_tb::Vbasic_tb(const char* _vcname__)
    : Vbasic_tb(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vbasic_tb::~Vbasic_tb() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vbasic_tb___024root___eval_debug_assertions(Vbasic_tb___024root* vlSelf);
#endif  // VL_DEBUG
void Vbasic_tb___024root___eval_static(Vbasic_tb___024root* vlSelf);
void Vbasic_tb___024root___eval_initial(Vbasic_tb___024root* vlSelf);
void Vbasic_tb___024root___eval_settle(Vbasic_tb___024root* vlSelf);
void Vbasic_tb___024root___eval(Vbasic_tb___024root* vlSelf);

void Vbasic_tb::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vbasic_tb::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vbasic_tb___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vbasic_tb___024root___eval_static(&(vlSymsp->TOP));
        Vbasic_tb___024root___eval_initial(&(vlSymsp->TOP));
        Vbasic_tb___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vbasic_tb___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vbasic_tb::eventsPending() { return false; }

uint64_t Vbasic_tb::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vbasic_tb::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vbasic_tb___024root___eval_final(Vbasic_tb___024root* vlSelf);

VL_ATTR_COLD void Vbasic_tb::final() {
    Vbasic_tb___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vbasic_tb::hierName() const { return vlSymsp->name(); }
const char* Vbasic_tb::modelName() const { return "Vbasic_tb"; }
unsigned Vbasic_tb::threads() const { return 1; }
void Vbasic_tb::prepareClone() const { contextp()->prepareClone(); }
void Vbasic_tb::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vbasic_tb::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vbasic_tb___024root__trace_decl_types(VerilatedVcd* tracep);

void Vbasic_tb___024root__trace_init_top(Vbasic_tb___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vbasic_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vbasic_tb___024root*>(voidSelf);
    Vbasic_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    Vbasic_tb___024root__trace_decl_types(tracep);
    Vbasic_tb___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vbasic_tb___024root__trace_register(Vbasic_tb___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vbasic_tb::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vbasic_tb::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vbasic_tb___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
