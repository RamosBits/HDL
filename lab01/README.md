# Lab 01: Verilog Environment and First Simulation

## Objective

Confirm that VS Code, Icarus Verilog, and VaporView are ready. You will simulate a tiny combinational circuit and inspect the waveform.

## Theory

A Verilog module describes hardware. A testbench applies input changes over simulated time. `$dumpfile` and `$dumpvars` create a VCD waveform file for VaporView in VS Code.

## Files

- `hello_logic.v`: design under test
- `tb_hello_logic.v`: testbench

## Commands

```bash
iverilog -o sim.out hello_logic.v tb_hello_logic.v
vvp sim.out
code lab01_hello_logic.vcd
# fallbacks:
surfer lab01_hello_logic.vcd
gtkwave lab01_hello_logic.vcd
```

## Waveform Checklist

- Add `a`, `b`, `and_y`, `or_y`, and `xor_y`.
- Confirm outputs change immediately after each input change.
- Compare the waveform with the console truth table.

## Challenge

Add `nand_y` and `nor_y` outputs to the module and testbench.
