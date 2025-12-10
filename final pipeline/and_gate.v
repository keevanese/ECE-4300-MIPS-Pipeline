`default_nettype none

module and_gate(
    input  wire m_ctlout,   // Branch control from EX/MEM latch
    input  wire zero,       // Zero flag from ALU
    output wire PCSrc       // branch decision
);
    assign PCSrc = m_ctlout & zero;
endmodule

`default_nettype wire
