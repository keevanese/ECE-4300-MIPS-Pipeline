// mux_wb.v
module mux_wb(
    input  [31:0] mem_Read_data,
    input  [31:0] mem_ALU_result,
    input         MemtoReg,     // 1 = load (use memory), 0 = ALU result
    output [31:0] wb_data
);
    assign wb_data = MemtoReg ? mem_Read_data : mem_ALU_result;
endmodule