`timescale 1ns/1ps

module constant_tb;
    reg [7:0] data;
    wire [11:0] codeword;
    reg [11:0] expected_codeword;

    // Expected codeword calculation function
    function [11:0] calculate_expected_codeword;
        input [7:0] input_data;
        begin
            // Constant encoder: always output the same pattern regardless of input
            calculate_expected_codeword = 12'b101010101010;
        end
    endfunction

    constant_encoder enc (
        .data_in(data),
        .codeword(codeword)
    );

    initial begin
        data = 8'b10101010;
    end

    // Monitor changes and check output
    always @(*) begin
        expected_codeword = calculate_expected_codeword(data);
        $display("CONSTANT: data=%b, codeword=%b, expected=%b", data, codeword, expected_codeword);
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