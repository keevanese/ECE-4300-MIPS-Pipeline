`timescale 1ns/1ps
`default_nettype none

module mips_pipeline_tb;

    // ------------------------------------------------------------
    // Parameters
    // ------------------------------------------------------------
    parameter MAX_CYCLES   = 80;
    parameter EXPECTED_R1  = 32'd12;
    parameter SHOW_WB_LOG  = 1;

    // ------------------------------------------------------------
    // DUT I/O + basic TB signals
    // ------------------------------------------------------------
    reg clk;
    reg rst;
    integer cycle;

    // Device Under Test
    mips_pipeline uut (
        .clk(clk),
        .rst(rst)
    );

    // Architectural state: register file r1
    wire [31:0] r1_val       = uut.r1_val;

    // Write-back stage
    wire        wb_RegWrite  = uut.RegWrite_WB;
    wire [4:0]  wb_WriteReg  = uut.WriteReg_WB;
    wire [31:0] wb_WriteData = uut.WriteData_WB;

    // IF stage: PC and fetched instruction
    wire [31:0] pc           = uut.pc_current;
    wire [31:0] instr        = uut.instr_IF;

    // ------------------------------------------------------------
    // Clock: 10 ns period
    // ------------------------------------------------------------
    always #5 clk = ~clk;

    // ------------------------------------------------------------
    // Reset + initialisation
    // ------------------------------------------------------------
    
    initial begin

        $dumpfile("mips_pipeline_tb.vcd");
        $dumpvars(0, mips_pipeline_tb);

        clk   = 1'b0;
        rst   = 1'b1;
        cycle = 0;

        // Hold reset for a short time
        #20 rst = 1'b0;

        $display("=== mips_pipeline testbench started ===");
    end

    // ------------------------------------------------------------
    // Cycle counter
    // ------------------------------------------------------------
    always @(posedge clk) begin
        if (rst)
            cycle <= 0;
        else
            cycle <= cycle + 1;
    end

    // ------------------------------------------------------------
    // Write-back monitor (for console + debugging)
    // ------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst && wb_RegWrite && SHOW_WB_LOG) begin
            $display("WB: cycle=%0d | PC=%08h instr=%08h | R%0d <= %0d (0x%08h)",
                     cycle, pc, instr,
                     wb_WriteReg, wb_WriteData, wb_WriteData);
        end
    end

    // ------------------------------------------------------------
    // Stop condition + self-check
    // ------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst && (cycle == MAX_CYCLES)) begin
            $display("=== Simulation finished at cycle %0d ===", cycle);
            $display("Final r1 value = %0d (0x%08h)", r1_val, r1_val);

            if (r1_val === EXPECTED_R1) begin
                $display("RESULT: PASS  (r1 == %0d)", EXPECTED_R1);
            end
            else begin
                $display("RESULT: FAIL  (expected r1 = %0d, got %0d)",
                         EXPECTED_R1, r1_val);
            end

            $finish;
        end
    end

endmodule

`default_nettype wire
