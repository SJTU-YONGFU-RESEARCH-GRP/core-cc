`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module parity_tb;
    reg [7:0] data;
    wire parity;
    reg expected_parity;

    // Expected parity calculation function
    function calculate_expected_parity;
        input [7:0] input_data;
        begin
            // Odd parity: if number of 1s is odd, parity=0; if even, parity=1
            calculate_expected_parity = ~^input_data; // XOR all bits and invert
        end
    endfunction

    parity_encoder uut (.data_in(data), .parity_out(parity));

    // Single test block
    initial begin
        // Test 1: Check parity calculation
        data = 8'b10101010;
        #1; // Wait for combinational logic to settle
        
        // Calculate expected parity
        expected_parity = calculate_expected_parity(data);
        
        $display("TEST1 - Parity Check: DATA=%b PARITY=%b EXPECTED=%b", data, parity, expected_parity);

        // Compare with expected result
        if (parity == expected_parity) begin
            $display("TEST1: PASS");
        end else begin
            $display("TEST1: FAIL");
        end

        // Test 2: Check with different data
        data = 8'b11111111;
        #1; // Wait for combinational logic to settle
        
        expected_parity = calculate_expected_parity(data);
        $display("TEST2 - Different Data: DATA=%b PARITY=%b EXPECTED=%b", data, parity, expected_parity);

        // Compare with expected result
        if (parity == expected_parity) begin
            $display("TEST2: PASS");
            $display("RESULT:PASS");
        end else begin
            $display("TEST2: FAIL");
            $display("RESULT:FAIL");
        end

        $finish;
    end
endmodule

/* verilator lint_on STMTDLY */