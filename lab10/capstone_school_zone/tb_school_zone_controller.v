`timescale 1ns / 1ps

module tb_school_zone_controller;
    reg clk;
    reg reset;
    reg ped_request;
    reg school_zone;
    wire [2:0] main_light;
    wire [2:0] side_light;
    wire walk_light;
    wire school_warning;
    wire [2:0] state_dbg;
    wire [3:0] timer_dbg;
    wire safe;

    assign safe = !(main_light == 3'b001 && side_light == 3'b001);

    school_zone_controller uut (
        .clk(clk),
        .reset(reset),
        .ped_request(ped_request),
        .school_zone(school_zone),
        .main_light(main_light),
        .side_light(side_light),
        .walk_light(walk_light),
        .school_warning(school_warning),
        .state_dbg(state_dbg),
        .timer_dbg(timer_dbg)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("school_zone_controller.vcd");
        $dumpvars(0, tb_school_zone_controller);

        $display("time reset ped school state timer main side walk warn safe");
        $monitor("%4t   %b    %b     %b     %d     %d   %b  %b   %b    %b    %b",
            $time, reset, ped_request, school_zone, state_dbg, timer_dbg,
            main_light, side_light, walk_light, school_warning, safe);

        reset = 1'b1;
        ped_request = 1'b0;
        school_zone = 1'b0;
        #12;

        reset = 1'b0;
        #190;

        ped_request = 1'b1;
        #20;
        ped_request = 1'b0;
        #90;

        school_zone = 1'b1;
        #70;

        ped_request = 1'b1;
        #10;
        ped_request = 1'b0;
        #80;

        reset = 1'b1;
        #10;
        reset = 1'b0;
        school_zone = 1'b0;
        #60;

        $finish;
    end
endmodule
