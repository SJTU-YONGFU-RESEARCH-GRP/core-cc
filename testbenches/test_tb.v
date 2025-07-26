`timescale 1ns/1ps

/* verilator lint_off STMTDLY */

module test_tb;
    reg [7:0] data;
    wire [11:0] codeword;
    reg [11:0] expected_codeword;

    // Expected codeword calculation function
    function [11:0] calculate_expected_codeword;
        input [7:0] input_data;
        begin
            // Test encoder: put data in bits 11:4 and 1010 in bits 3:0
            calculate_expected_codeword = {input_data, 4'b1010};
        end
    endfunction

    test_encoder enc (
        .data_in(data),
        .codeword(codeword)
    );

    initial begin
        data = 8'b10101010;
    end

    // Monitor changes and check output
    always @(*) begin
        expected_codeword = calculate_expected_codeword(data);
        $display("TEST: data=%b, codeword=%b, expected=%b", data, codeword, expected_codeword);
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