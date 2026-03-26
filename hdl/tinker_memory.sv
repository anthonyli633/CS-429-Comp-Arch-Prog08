`timescale 1ns/1ps

module tinker_memory #(
    parameter MEM_SIZE = 512 * 1024
) (
    input         clk,
    input  [63:0] inst_addr,
    output reg [31:0] inst_word,
    input  [63:0] data_addr,
    input  [63:0] data_write_data,
    input         data_write_en,
    output reg [63:0] data_read_data
);
    reg [7:0] bytes [0:MEM_SIZE-1];
    integer i;
    integer idx;

    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1)
            bytes[i] = 8'd0;
    end

    always @(*) begin
        idx = inst_addr;
        if ((idx >= 0) && (idx + 3 < MEM_SIZE)) begin
            inst_word = {bytes[idx + 3], bytes[idx + 2], bytes[idx + 1], bytes[idx + 0]};
        end else begin
            inst_word = 32'd0;
        end
    end

    always @(*) begin
        idx = data_addr;
        if ((idx >= 0) && (idx + 7 < MEM_SIZE)) begin
            data_read_data = {
                bytes[idx + 7], bytes[idx + 6], bytes[idx + 5], bytes[idx + 4],
                bytes[idx + 3], bytes[idx + 2], bytes[idx + 1], bytes[idx + 0]
            };
        end else begin
            data_read_data = 64'd0;
        end
    end

    always @(posedge clk) begin
        idx = data_addr;
        if (data_write_en && (idx >= 0) && (idx + 7 < MEM_SIZE)) begin
            bytes[idx + 0] <= data_write_data[7:0];
            bytes[idx + 1] <= data_write_data[15:8];
            bytes[idx + 2] <= data_write_data[23:16];
            bytes[idx + 3] <= data_write_data[31:24];
            bytes[idx + 4] <= data_write_data[39:32];
            bytes[idx + 5] <= data_write_data[47:40];
            bytes[idx + 6] <= data_write_data[55:48];
            bytes[idx + 7] <= data_write_data[63:56];
        end
    end
endmodule
