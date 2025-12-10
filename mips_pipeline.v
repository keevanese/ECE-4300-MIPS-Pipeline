`timescale 1ns/1ps
`default_nettype none

module mips_pipeline(
    input  wire clk,
    input  wire rst
);

// ===============================
//  IF STAGE
// ===============================
wire [31:0] pc_next;
wire [31:0] pc_current;
wire [31:0] instr_IF;

// PC register
pc_reg PC (
    .clk     (clk),
    .rst     (rst),
    .pc_next (pc_next),
    .pc_out  (pc_current)
);

// Instruction memory
instr_mem IMEM (
    .Address     (pc_current),
    .Instruction (instr_IF)
);

// PC + 4
wire [31:0] pc_plus4 = pc_current + 32'd4;


// ===============================
//  IF/ID PIPELINE REGISTER
// ===============================
wire [31:0] instr_ID;
wire [31:0] pc_ID;

if_id_latch IF_ID (
    .clk       (clk),
    .rst       (rst),
    .instr_in  (instr_IF),
    .pc_in     (pc_plus4),
    .instr_out (instr_ID),
    .pc_out    (pc_ID)
);


// ===============================
//  ID STAGE
// ===============================
wire [5:0]  opcode = instr_ID[31:26];
wire [4:0]  rs     = instr_ID[25:21];
wire [4:0]  rt     = instr_ID[20:16];
wire [4:0]  rd     = instr_ID[15:11];
wire [15:0] imm    = instr_ID[15:0];

// control signals from CU
wire RegDst;
wire ALUSrc;
wire MemtoReg;
wire RegWrite;
wire MemRead;
wire MemWrite;
wire Branch;
wire [1:0] ALUOp;

// Control Unit (NEW interface)
control CU (
    .opcode   (opcode),
    .RegDst   (RegDst),
    .ALUSrc   (ALUSrc),
    .MemtoReg (MemtoReg),
    .RegWrite (RegWrite),
    .MemRead  (MemRead),
    .MemWrite (MemWrite),
    .Branch   (Branch),
    .ALUOp    (ALUOp)
);

// Register File
wire [31:0] rd1_ID;
wire [31:0] rd2_ID;
wire [31:0] r1_val;

regfile RF (
    .clk        (clk),
    .rst        (rst),
    .regwrite   (RegWrite_WB),   // write-back stage control
    .rs         (rs),
    .rt         (rt),
    .rd         (WriteReg_WB),
    .writedata  (WriteData_WB),
    .A_readdat1 (rd1_ID),
    .B_readdat2 (rd2_ID),
    .r1_val     (r1_val)
);

// Sign Extend
wire [31:0] imm_ext = {{16{imm[15]}}, imm};


// ===============================
//  ID/EX PIPELINE REGISTER
// ===============================
wire [31:0] rd1_EX;
wire [31:0] rd2_EX;
wire [31:0] imm_EX;
wire [4:0]  rs_EX;
wire [4:0]  rt_EX;
wire [4:0]  rd_EX;

wire RegDst_EX;
wire ALUSrc_EX;
wire MemtoReg_EX;
wire RegWrite_EX;
wire MemRead_EX;
wire MemWrite_EX;
wire Branch_EX;
wire [1:0] ALUOp_EX;

id_ex_latch ID_EX (
    .clk (clk),
    .rst (rst),

    .rd1_in (rd1_ID),
    .rd2_in (rd2_ID),
    .imm_in (imm_ext),
    .rs_in  (rs),
    .rt_in  (rt),
    .rd_in  (rd),

    .RegDst_in   (RegDst),
    .ALUSrc_in   (ALUSrc),
    .MemtoReg_in (MemtoReg),
    .RegWrite_in (RegWrite),
    .MemRead_in  (MemRead),
    .MemWrite_in (MemWrite),
    .Branch_in   (Branch),
    .ALUOp_in    (ALUOp),   // <-- ONLY THIS LINE. NO DUPLICATE.

    .rd1_out (rd1_EX),
    .rd2_out (rd2_EX),
    .imm_out (imm_EX),
    .rs_out  (rs_EX),
    .rt_out  (rt_EX),
    .rd_out  (rd_EX),

    .RegDst_out   (RegDst_EX),
    .ALUSrc_out   (ALUSrc_EX),
    .MemtoReg_out (MemtoReg_EX),
    .RegWrite_out (RegWrite_EX),
    .MemRead_out  (MemRead_EX),
    .MemWrite_out (MemWrite_EX),
    .Branch_out   (Branch_EX),
    .ALUOp_out    (ALUOp_EX)
);



// ===============================
//  EX STAGE
// ===============================
wire [31:0] ALU_in2      = (ALUSrc_EX) ? imm_EX : rd2_EX;
wire [31:0] ALUResult_EX;
wire        Zero_EX;
wire [3:0] ALUCtrl_EX;

alu_control ALUCTRL (
    .ALUOp   (ALUOp_EX),
    .funct   (imm_EX[5:0]),
    .ALUCtrl (ALUCtrl_EX)
);

alu alu_unit (
    .A        (rd1_EX),
    .B        (ALU_in2),
    .ALUCtrl  (ALUCtrl_EX),
    .Result(ALUResult_EX),
    .Zero     (Zero_EX)
);

// Write register mux (rt vs rd)
wire [4:0] WriteReg_EX = (RegDst_EX) ? rd_EX : rt_EX;


// ===============================
//  EX/MEM PIPELINE REGISTER
// ===============================
wire [31:0] ALUResult_MEM;
wire [31:0] rd2_MEM;
wire [4:0]  WriteReg_MEM;
wire [1:0]  WBControl_MEM;
wire        MemRead_MEM;
wire        MemWrite_MEM;
wire        Branch_MEM;
wire        Zero_MEM;

ex_mem_latch EX_MEM (
    .clk (clk),

    .ALUResult_in (ALUResult_EX),
    .rd2_in       (rd2_EX),
    .WriteReg_in  (WriteReg_EX),
    .RegWrite_in  (RegWrite_EX),
    .MemtoReg_in  (MemtoReg_EX),
    .MemRead_in   (MemRead_EX),
    .MemWrite_in  (MemWrite_EX),
    .Branch_in    (Branch_EX),
    .Zero_in      (Zero_EX),

    .ALUResult_out (ALUResult_MEM),
    .rd2_out       (rd2_MEM),
    .WriteReg_out  (WriteReg_MEM),
    .WBControl_out (WBControl_MEM),
    .MemRead_out   (MemRead_MEM),
    .MemWrite_out  (MemWrite_MEM),
    .Branch_out    (Branch_MEM),
    .Zero_out      (Zero_MEM)
);


// ===============================
//  MEM STAGE
// ===============================
wire [31:0] ReadData_MEM;
wire [31:0] ALUResult_WB;
wire [4:0]  WriteReg_WB;
wire [1:0]  WBControl_WB;
wire        PCSrc;

mem_stage MEMS (
    .clk           (clk),
    .ALUResult     (ALUResult_MEM),
    .WriteData     (rd2_MEM),
    .WriteReg      (WriteReg_MEM),
    .WBControl     (WBControl_MEM),
    .MemWrite      (MemWrite_MEM),
    .MemRead       (MemRead_MEM),
    .Branch        (Branch_MEM),
    .Zero          (Zero_MEM),

    .ReadData      (ReadData_MEM),
    .ALUResult_out (ALUResult_WB),
    .WriteReg_out  (WriteReg_WB),
    .WBControl_out (WBControl_WB),
    .PCSrc         (PCSrc)
);


// ===============================
//  WB STAGE
// ===============================
wire [31:0] WriteData_WB;
wire        RegWrite_WB;

WB WB_STAGE (
    .mem_Read_data   (ReadData_MEM),
    .mem_ALU_result  (ALUResult_WB),
    .mem_control_wb  (WBControl_WB),
    .WriteData       (WriteData_WB),
    .RegWrite        (RegWrite_WB)
);


// ===============================
//  PC UPDATE (Branch or PC+4)
// ===============================
assign pc_next = (PCSrc)
               ? (pc_ID + (imm_ext << 2))
               : pc_plus4;



endmodule
`default_nettype wire
