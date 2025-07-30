
#include "Vtest_tb.h"
#include "verilated.h"
#include <iostream>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vtest_tb* top = new Vtest_tb;
    
    // Run simulation until finish
    while (!Verilated::gotFinish()) {
        top->eval();
    }
    
    delete top;
    return 0;
}
