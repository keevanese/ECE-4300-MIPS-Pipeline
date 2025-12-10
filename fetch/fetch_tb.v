`timescale 1ns/1ps

module fetch_tb;

    reg clk, rst;
    reg ex_mem_pc_src;
    reg [31:0] ex_mem_npc;
    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

    fetch uut(
        .clk(clk),
        .rst(rst),
        .ex_mem_pc_src(ex_mem_pc_src),
        .ex_mem_npc(ex_mem_npc),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        ex_mem_pc_src = 0;
        ex_mem_npc = 32'h00000000;

        $dumpfile("fetch.vcd");
        $dumpvars(0, fetch_tb);

        #10;
        rst = 0;

        #50;

        ex_mem_pc_src = 1;
        ex_mem_npc = 32'h00000020;  
        #10;
        ex_mem_pc_src = 0;

        #50;

        $finish;
    end

endmodule
