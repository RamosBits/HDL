`timescale 1ns / 1ps

module tb_hello_logic;
    reg a;
    reg b;
    wire and_y;
    wire or_y;
    wire xor_y;
    wire nand_y;
    wire nor_y;

    integer i;

    hello_logic uut (
        .a(a),
        .b(b),
        .and_y(and_y),
        .or_y(or_y),
        .xor_y(xor_y),
        .nand_y(nand_y),
        .nor_y(nor_y)
    );

    initial begin
        $dumpfile("lab01_hello_logic.vcd");
        $dumpvars(0, tb_hello_logic);

        $display("a b | and or xor nand nor");
        $display("-------------------------");

        for (i = 0; i < 4; i = i + 1) begin
            {a, b} = i[1:0];
            #10;
            $display("%b %b |  %b   %b   %b   %b   %b", a, b, and_y, or_y, xor_y, nand_y, nor_y);
        end

        $finish;
    end
endmodule
