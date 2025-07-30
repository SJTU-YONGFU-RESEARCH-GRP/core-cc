
#include "Vparity_tb.h"
#include "verilated.h"
#include <iostream>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vparity_tb* top = new Vparity_tb;
    
    // Run simulation until finish
    while (!Verilated::gotFinish()) {
        top->eval();
    }
    
    delete top;
    return 0;
}
