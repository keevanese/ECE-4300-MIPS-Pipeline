// wb_stage.v
module WB(
    input  [31:0] mem_Read_data,
    input  [31:0] mem_ALU_result,
    input  [1:0]  mem_control_wb,   // {RegWrite, MemtoReg}
    output [31:0] WriteData,        // to ID register file write data
    output        RegWrite          // to ID register file RegWrite
);
    wire MemtoReg;

    assign RegWrite = mem_control_wb[1];
    assign MemtoReg = mem_control_wb[0];

    mux_wb u_mux (
        .mem_Read_data(mem_Read_data),
        .mem_ALU_result(mem_ALU_result),
        .MemtoReg(MemtoReg),
        .wb_data(WriteData)
    );
endmodule