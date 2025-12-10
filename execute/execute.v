`timescale 1ns / 1ps
/*
Execute Stage: This uses the outputs of Fetch and Decode Stages as well as combining the modules: adder, bottom_mux(5-bit), alu_control, alu, top_mux (32-bit),
and ex_mem.
*/
module execute(
    input  wire        clk,
    input  wire [1:0]  ctlwb_in,
    input  wire [1:0]  ctlm_in,
    input  wire [31:0] npc,
    input  wire [31:0] rdata1,
    input  wire [31:0] rdata2,
    input  wire [31:0] s_extend,
    input  wire [4:0]  instr_2016,
    input  wire [4:0]  instr_1511,
    input  wire [1:0]  alu_op,
    input  wire [5:0]  funct,
    input  wire        alusrc,
    input  wire        regdst,

    output wire [1:0]  ctlwb_out,
    output wire [1:0]  ctlm_out,
    output wire [31:0] adder_out,
    output wire [31:0] alu_result_out,
    output wire [31:0] rdata2_out,
    output wire [4:0]  muxout_out
);

    // Internal wires
    wire [31:0] adder_result;
    wire [31:0] alu_b;          // ALU second operand
    wire [31:0] alu_result;
    wire [2:0]  alu_ctrl;
    wire [4:0]  muxout;

    // 1) Branch target: npc + sign-extended immediate
    adder u_adder (
        .add_in1(npc),
        .add_in2(s_extend),
        .add_out(adder_result)
    );

    // 2) bottom_mux chooses destination register (rd vs rt)
    bottom_mux u_bottom_mux (
        .y(muxout),
        .a(instr_1511),   // rd
        .b(instr_2016),   // rt
        .sel(regdst)
    );

    // 3) alu_control generates ALU operation from alu_op and funct
    alu_control u_alu_control (
        .funct(funct),
        .aluop(alu_op),
        .select(alu_ctrl)
    );

    // 4) top_mux selects ALU second operand (rdata2 vs immediate)
    top_mux u_top_mux (
        .y(alu_b),
        .a(s_extend),
        .b(rdata2),
        .alusrc(alusrc)
    );

    // 5) ALU does the arithmetic/logic
    wire zero;  // not used in this testbench but produced by ALU
    alu u_alu (
        .a(rdata1),
        .b(alu_b),
        .control(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );

    // 6) ex_mem latch: pipeline register between EX and MEM
    ex_mem u_ex_mem (
        .clk(clk),
        .ctlwb_in(ctlwb_in),
        .ctlm_in(ctlm_in),
        .adder_in(adder_result),
        .alu_in(alu_result),
        .rdata2_in(rdata2),
        .mux_in(muxout),

        .ctlwb_out(ctlwb_out),
        .ctlm_out(ctlm_out),
        .adder_out(adder_out),
        .alu_result_out(alu_result_out),
        .rdata2_out(rdata2_out),
        .muxout_out(muxout_out)
    );

endmodule