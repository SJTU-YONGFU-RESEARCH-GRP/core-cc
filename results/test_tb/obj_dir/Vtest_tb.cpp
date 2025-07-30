// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vtest_tb__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vtest_tb::Vtest_tb(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vtest_tb__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vtest_tb::Vtest_tb(const char* _vcname__)
    : Vtest_tb(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vtest_tb::~Vtest_tb() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vtest_tb___024root___eval_debug_assertions(Vtest_tb___024root* vlSelf);
#endif  // VL_DEBUG
void Vtest_tb___024root___eval_static(Vtest_tb___024root* vlSelf);
void Vtest_tb___024root___eval_initial(Vtest_tb___024root* vlSelf);
void Vtest_tb___024root___eval_settle(Vtest_tb___024root* vlSelf);
void Vtest_tb___024root___eval(Vtest_tb___024root* vlSelf);

void Vtest_tb::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vtest_tb::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vtest_tb___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vtest_tb___024root___eval_static(&(vlSymsp->TOP));
        Vtest_tb___024root___eval_initial(&(vlSymsp->TOP));
        Vtest_tb___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vtest_tb___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vtest_tb::eventsPending() { return false; }

uint64_t Vtest_tb::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vtest_tb::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vtest_tb___024root___eval_final(Vtest_tb___024root* vlSelf);

VL_ATTR_COLD void Vtest_tb::final() {
    Vtest_tb___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vtest_tb::hierName() const { return vlSymsp->name(); }
const char* Vtest_tb::modelName() const { return "Vtest_tb"; }
unsigned Vtest_tb::threads() const { return 1; }
void Vtest_tb::prepareClone() const { contextp()->prepareClone(); }
void Vtest_tb::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vtest_tb::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vtest_tb___024root__trace_decl_types(VerilatedVcd* tracep);

void Vtest_tb___024root__trace_init_top(Vtest_tb___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vtest_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtest_tb___024root*>(voidSelf);
    Vtest_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    Vtest_tb___024root__trace_decl_types(tracep);
    Vtest_tb___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vtest_tb___024root__trace_register(Vtest_tb___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vtest_tb::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vtest_tb::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vtest_tb___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
