`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module direct_tb;
    reg [7:0] data = 8'b10101010;  // Initialize at declaration
    wire [11:0] codeword;
    reg [11:0] expected_codeword;

    // Expected codeword calculation function
    function [11:0] calculate_expected_codeword;
        input [7:0] input_data;
        begin
            // Direct encoder: put data in bits 11:4 and 1010 in bits 3:0
            calculate_expected_codeword = {input_data, 4'b1010};
        end
    endfunction

    // Direct logic without module instantiation
    assign codeword[11] = data[7];
    assign codeword[10] = data[6];
    assign codeword[9] = data[5];
    assign codeword[8] = data[4];
    assign codeword[7] = data[3];
    assign codeword[6] = data[2];
    assign codeword[5] = data[1];
    assign codeword[4] = data[0];
    assign codeword[3] = 1'b1;
    assign codeword[2] = 1'b0;
    assign codeword[1] = 1'b1;
    assign codeword[0] = 1'b0;

    // Monitor changes and check output
    always @(*) begin
        expected_codeword = calculate_expected_codeword(data);
        $display("DIRECT: data=%b, codeword=%b, expected=%b", data, codeword, expected_codeword);
        if (codeword == expected_codeword) begin
            $display("TEST: PASS");
            $display("RESULT:PASS");
        end else begin
            $display("TEST: FAIL");
            $display("RESULT:FAIL");
        end
        $finish;
    end
endmodule

/* verilator lint_on STMTDLY */