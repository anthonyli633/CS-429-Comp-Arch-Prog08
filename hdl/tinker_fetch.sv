`timescale 1ns/1ps

module tinker_fetch(
    input clk,
    input reset,
    input redirect,
    input [63:0] redirect_target,
    output reg [63:0] pc
);
    always @(posedge clk) begin
        if (reset) begin
            pc <= 64'h0000_0000_0000_2000;
        end else if (redirect) begin
            pc <= redirect_target;
        end else begin
            pc <= pc + 64'd4;
        end
    end
endmodule
