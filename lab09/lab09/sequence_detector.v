`timescale 1ns / 1ps

module sequence_detector_1101(
    input clk,
    input reset,
    input bit_in,
    output reg detected
);
    localparam S_RESET = 3'd0;
    localparam S_1 = 3'd1;
    localparam S_11 = 3'd2;
    localparam S_110 = 3'd3;
    localparam S_1101 = 3'd4;

    reg [2:0] state;
    reg [2:0] next_state;

    always @(*) begin
        case (state)
            S_RESET: next_state = bit_in ? S_1 : S_RESET;
            S_1: next_state = bit_in ? S_11 : S_RESET;
            S_11: next_state = bit_in ? S_11 : S_110;
            S_110: next_state = bit_in ? S_1101 : S_RESET;
            S_1101: next_state = bit_in ? S_11 : S_RESET;
            default: next_state = S_RESET;
        endcase
    end

    always @(*) begin
        detected = (state == S_1101);
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S_RESET;
        end else begin
            state <= next_state;
        end
    end
endmodule
