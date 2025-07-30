// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vdirect_tb__pch.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vdirect_tb::Vdirect_tb(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vdirect_tb__Syms(contextp(), _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
    contextp()->traceBaseModelCbAdd(
        [this](VerilatedTraceBaseC* tfp, int levels, int options) { traceBaseModel(tfp, levels, options); });
}

Vdirect_tb::Vdirect_tb(const char* _vcname__)
    : Vdirect_tb(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vdirect_tb::~Vdirect_tb() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vdirect_tb___024root___eval_debug_assertions(Vdirect_tb___024root* vlSelf);
#endif  // VL_DEBUG
void Vdirect_tb___024root___eval_static(Vdirect_tb___024root* vlSelf);
void Vdirect_tb___024root___eval_initial(Vdirect_tb___024root* vlSelf);
void Vdirect_tb___024root___eval_settle(Vdirect_tb___024root* vlSelf);
void Vdirect_tb___024root___eval(Vdirect_tb___024root* vlSelf);

void Vdirect_tb::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vdirect_tb::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vdirect_tb___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vdirect_tb___024root___eval_static(&(vlSymsp->TOP));
        Vdirect_tb___024root___eval_initial(&(vlSymsp->TOP));
        Vdirect_tb___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vdirect_tb___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vdirect_tb::eventsPending() { return false; }

uint64_t Vdirect_tb::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vdirect_tb::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vdirect_tb___024root___eval_final(Vdirect_tb___024root* vlSelf);

VL_ATTR_COLD void Vdirect_tb::final() {
    Vdirect_tb___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vdirect_tb::hierName() const { return vlSymsp->name(); }
const char* Vdirect_tb::modelName() const { return "Vdirect_tb"; }
unsigned Vdirect_tb::threads() const { return 1; }
void Vdirect_tb::prepareClone() const { contextp()->prepareClone(); }
void Vdirect_tb::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vdirect_tb::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vdirect_tb___024root__trace_decl_types(VerilatedVcd* tracep);

void Vdirect_tb___024root__trace_init_top(Vdirect_tb___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vdirect_tb___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdirect_tb___024root*>(voidSelf);
    Vdirect_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->pushPrefix(std::string{vlSymsp->name()}, VerilatedTracePrefixType::SCOPE_MODULE);
    Vdirect_tb___024root__trace_decl_types(tracep);
    Vdirect_tb___024root__trace_init_top(vlSelf, tracep);
    tracep->popPrefix();
}

VL_ATTR_COLD void Vdirect_tb___024root__trace_register(Vdirect_tb___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vdirect_tb::traceBaseModel(VerilatedTraceBaseC* tfp, int levels, int options) {
    (void)levels; (void)options;
    VerilatedVcdC* const stfp = dynamic_cast<VerilatedVcdC*>(tfp);
    if (VL_UNLIKELY(!stfp)) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vdirect_tb::trace()' called on non-VerilatedVcdC object;"
            " use --trace-fst with VerilatedFst object, and --trace-vcd with VerilatedVcd object");
    }
    stfp->spTrace()->addModel(this);
    stfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vdirect_tb___024root__trace_register(&(vlSymsp->TOP), stfp->spTrace());
}
