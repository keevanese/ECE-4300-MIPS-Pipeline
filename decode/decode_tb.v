`timescale 1ns/1ps
`default_nettype none
module decode_tb;

  // DUT inputs
  reg         clk = 0;
  reg         rst = 0;
  reg         wb_reg_write = 0;
  reg  [4:0]  wb_write_reg_location = 0;
  reg  [31:0] mem_wb_write_data = 0;
  reg  [31:0] if_id_instr = 0;
  reg  [31:0] if_id_npc   = 0;

  // DUT outputs
  wire [1:0]  id_ex_wb;
  wire [2:0]  id_ex_mem;
  wire [3:0]  id_ex_execute;
  wire [31:0] id_ex_npc;
  wire [31:0] id_ex_readdat1;
  wire [31:0] id_ex_readdat2;
  wire [31:0] id_ex_sign_ext;
  wire [4:0]  id_ex_instr_bits_20_16;
  wire [4:0]  id_ex_instr_bits_15_11;

  // Instantiate DUT
  decode dut(
    .clk(clk), .rst(rst),
    .wb_reg_write(wb_reg_write),
    .wb_write_reg_location(wb_write_reg_location),
    .mem_wb_write_data(mem_wb_write_data),
    .if_id_instr(if_id_instr),
    .if_id_npc(if_id_npc),
    .id_ex_wb(id_ex_wb),
    .id_ex_mem(id_ex_mem),
    .id_ex_execute(id_ex_execute),
    .id_ex_npc(id_ex_npc),
    .id_ex_readdat1(id_ex_readdat1),
    .id_ex_readdat2(id_ex_readdat2),
    .id_ex_sign_ext(id_ex_sign_ext),
    .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16),
    .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11)
  );

  // 100 MHz clock
  always #5 clk = ~clk;

  // Print a few key signals on every rising edge
  initial begin
    $display("time  ex mem wb | npc       rd1        rd2        signext   [20:16] [15:11]");
    forever begin
      @(posedge clk);
      $display("%4t  %b %b %b | %08x %08x %08x %08x   %2d      %2d",
        $time, id_ex_execute, id_ex_mem, id_ex_wb,
        id_ex_npc, id_ex_readdat1, id_ex_readdat2, id_ex_sign_ext,
        id_ex_instr_bits_20_16, id_ex_instr_bits_15_11);
    end
  end

  initial begin
    // waveform
    $dumpfile("decode.vcd");
    $dumpvars(0, decode_tb);

    // Reset
    rst = 1; repeat (2) @(posedge clk);
    rst = 0;

    // Preload two registers through the WB port so reads have known values
    // Write r1 = 0x11111111
    @(negedge clk);
    wb_reg_write = 1;
    wb_write_reg_location = 5'd1;
    mem_wb_write_data = 32'h11111111;
    @(posedge clk);  // wait one cycle

    @(negedge clk);
    wb_reg_write = 0;
    wb_write_reg_location = 5'd0;
    mem_wb_write_data = 32'd0;

    @(posedge clk);  // wait one cycle

    // Write r2 = 0x22222222
    @(negedge clk);
    wb_reg_write = 1;
    wb_write_reg_location = 5'd2;
    mem_wb_write_data = 32'h22222222;

    @(posedge clk); //wait one cycle

    @(negedge clk);
    wb_reg_write = 0;
    wb_write_reg_location = 5'd0;
    mem_wb_write_data = 32'd0;

    @(posedge clk);

    // R-format: add r3, r1, r2  (opcode=0)
    // [31:26]=0, rs=1, rt=2, rd=3, shamt=0, funct=0x20 (funct not used by decode)
    if_id_instr = {6'b000000, 5'd1, 5'd2, 5'd3, 5'd0, 6'h20};
    if_id_npc   = 32'h0000_1000;
    @(posedge clk);

    // LW r4, -8(r1)  (opcode=100011)
    if_id_instr = {6'b100011, 5'd1, 5'd4, 16'hFFF8};
    if_id_npc   = 32'h0000_1004;
    @(posedge clk);

    // SW r2, 16(r1)  (opcode=101011)
    if_id_instr = {6'b101011, 5'd1, 5'd2, 16'h0010};
    if_id_npc   = 32'h0000_1008;
    @(posedge clk);

    // BEQ r1, r2, +4 (opcode=000100)
    if_id_instr = {6'b000100, 5'd1, 5'd2, 16'h0004};
    if_id_npc   = 32'h0000_100C;
    @(posedge clk);

    // finish
    #10 $finish;
  end

endmodule
