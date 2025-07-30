
#include "Vhamming_simple_tb.h"
#include "verilated.h"
#include <iostream>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vhamming_simple_tb* top = new Vhamming_simple_tb;
    
    // Run simulation until finish
    while (!Verilated::gotFinish()) {
        top->eval();
    }
    
    delete top;
    return 0;
}
