`timescale 1ns / 1ps

module school_zone_controller(
    input clk,
    input reset,
    input ped_request,
    input school_zone,
    output reg [2:0] main_light,
    output reg [2:0] side_light,
    output reg walk_light,
    output reg school_warning,
    output [2:0] state_dbg,
    output [3:0] timer_dbg
);
    localparam RED = 3'b100;
    localparam YELLOW = 3'b010;
    localparam GREEN = 3'b001;

    localparam MAIN_GREEN = 3'd0;
    localparam MAIN_YELLOW = 3'd1;
    localparam ALL_RED_TO_SIDE = 3'd2;
    localparam SIDE_GREEN = 3'd3;
    localparam SIDE_YELLOW = 3'd4;
    localparam ALL_RED_TO_MAIN = 3'd5;

    localparam MAIN_GREEN_NORMAL_TICKS = 4'd8;
    localparam MAIN_GREEN_PED_TICKS = 4'd3;
    localparam YELLOW_TICKS = 4'd2;
    localparam ALL_RED_TICKS = 4'd1;
    localparam SIDE_GREEN_NORMAL_TICKS = 4'd4;
    localparam SIDE_GREEN_SCHOOL_TICKS = 4'd7;

    reg [2:0] state;
    reg [3:0] timer;
    reg [3:0] limit;
    reg ped_pending;

    assign state_dbg = state;
    assign timer_dbg = timer;

    always @(*) begin
        main_light = RED;
        side_light = RED;
        walk_light = 1'b0;
        school_warning = school_zone;
        limit = YELLOW_TICKS;

        case (state)
            MAIN_GREEN: begin
                main_light = GREEN;
                side_light = RED;
                limit = (ped_pending || ped_request) ?
                    MAIN_GREEN_PED_TICKS : MAIN_GREEN_NORMAL_TICKS;
            end
            MAIN_YELLOW: begin
                main_light = YELLOW;
                side_light = RED;
                limit = YELLOW_TICKS;
            end
            ALL_RED_TO_SIDE: begin
                main_light = RED;
                side_light = RED;
                limit = ALL_RED_TICKS;
            end
            SIDE_GREEN: begin
                main_light = RED;
                side_light = GREEN;
                walk_light = 1'b1;
                limit = school_zone ?
                    SIDE_GREEN_SCHOOL_TICKS : SIDE_GREEN_NORMAL_TICKS;
            end
            SIDE_YELLOW: begin
                main_light = RED;
                side_light = YELLOW;
                limit = YELLOW_TICKS;
            end
            ALL_RED_TO_MAIN: begin
                main_light = RED;
                side_light = RED;
                limit = ALL_RED_TICKS;
            end
            default: begin
                main_light = GREEN;
                side_light = RED;
                limit = MAIN_GREEN_NORMAL_TICKS;
            end
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= MAIN_GREEN;
            timer <= 4'd0;
            ped_pending <= 1'b0;
        end else begin
            if (ped_request) begin
                ped_pending <= 1'b1;
            end

            if (timer >= limit - 4'd1) begin
                timer <= 4'd0;
                case (state)
                    MAIN_GREEN: state <= MAIN_YELLOW;
                    MAIN_YELLOW: state <= ALL_RED_TO_SIDE;
                    ALL_RED_TO_SIDE: state <= SIDE_GREEN;
                    SIDE_GREEN: begin
                        state <= SIDE_YELLOW;
                        ped_pending <= 1'b0;
                    end
                    SIDE_YELLOW: state <= ALL_RED_TO_MAIN;
                    ALL_RED_TO_MAIN: state <= MAIN_GREEN;
                    default: state <= MAIN_GREEN;
                endcase
            end else begin
                timer <= timer + 4'd1;
            end
        end
    end
endmodule
