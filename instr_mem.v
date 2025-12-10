`default_nettype none

module instr_mem(
    input  wire [31:0] Address,
    output wire [31:0] Instruction
);

    reg [31:0] instrMem [0:255];

    initial begin
        $display("Loading instru.mem...");
        $readmemb("instr.mem", instrMem);

        $display("instrMem[0]  = %b", instrMem[0]);
        $display("instrMem[1]  = %b", instrMem[1]);
        $display("instrMem[2]  = %b", instrMem[2]);
        $display("instrMem[3]  = %b", instrMem[3]);
        $display("instrMem[4]  = %b", instrMem[4]);
        $display("instrMem[5]  = %b", instrMem[5]);
        $display("instrMem[6]  = %b", instrMem[6]);
        $display("instrMem[7]  = %b", instrMem[7]);
        $display("instrMem[8]  = %b", instrMem[8]);
        $display("instrMem[9]  = %b", instrMem[9]);
        $display("instrMem[10] = %b", instrMem[10]);
        $display("instrMem[11] = %b", instrMem[11]);
    end

    assign Instruction = instrMem[Address[9:2]];  // PC[9:2]

endmodule

`default_nettype wire
