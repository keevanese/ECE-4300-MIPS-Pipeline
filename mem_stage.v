`default_nettype none

module mem_stage(
    input  wire        clk,
    input  wire [31:0] ALUResult,
    input  wire [31:0] WriteData,
    input  wire [4:0]  WriteReg,
    input  wire [1:0]  WBControl,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire        Branch,
    input  wire        Zero,

    output wire [31:0] ReadData,
    output wire [31:0] ALUResult_out,
    output wire [4:0]  WriteReg_out,
    output wire [1:0]  WBControl_out,
    output wire        PCSrc
);

    // internal wires
    wire [31:0] mem_read_data;
    wire [31:0] mem_ALU_result;
    wire [4:0]  mem_Write_reg;
    wire [1:0]  mem_control_wb;

    // AND gate for branch decision
    and_gate u_and (
        .m_ctlout(Branch),
        .zero    (Zero),
        .PCSrc   (PCSrc)
    );

    // Data memory
    data_memory u_dmem (
        .clk       (clk),
        .MemWrite  (MemWrite),
        .MemRead   (MemRead),
        .Address   (ALUResult),
        .Write_data(WriteData),
        .Read_data (mem_read_data)
    );

    // MEM/WB pipeline register
    mem_wb_latch u_memwb (
        .clk            (clk),
        .control_wb_in  (WBControl),
        .Read_data_in   (mem_read_data),
        .ALU_result_in  (ALUResult),
        .Write_reg_in   (WriteReg),

        .mem_control_wb (WBControl_out),
        .Read_data      (ReadData),
        .mem_ALU_result (ALUResult_out),
        .mem_Write_reg  (WriteReg_out)
    );

endmodule

`default_nettype wire
