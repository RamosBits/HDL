`timescale 1ns / 1ps

module counter_divider #(
    parameter TERMINAL_COUNT = 4'd7
)(
    input clk,
    input reset,
    output reg [3:0] count,
    output reg slow_clk
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'd0;
            slow_clk <= 1'b0;
        end else if (count == TERMINAL_COUNT) begin
            count <= 4'd0;
            slow_clk <= ~slow_clk;
        end else begin
            count <= count + 4'd1;
        end
    end
endmodule
