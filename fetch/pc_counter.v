module pc(
    input wire clk, rst,
    input wire [31:0] pc_in,
    output reg [31:0] pc_out
);

    parameter [31:0] RESET_VECTOR = 32'h0000_0000;

    always @(posedge clk) begin
        if(rst)
            pc_out <= RESET_VECTOR;
        else
            pc_out <= pc_in; //hold
    end
endmodule
