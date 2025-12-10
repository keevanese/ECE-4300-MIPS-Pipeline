// and_gate.v
module and_gate(
    input  m_ctlout,   // Branch control from EX/MEM latch
    input  zero,       // Zero flag from ALU
    output PCSrc       // branch decision
);
    assign PCSrc = m_ctlout & zero;
endmodule