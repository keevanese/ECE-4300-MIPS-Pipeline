`default_nettype none

module data_memory(
    input  wire        clk,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire [31:0] Address,
    input  wire [31:0] Write_data,
    output wire [31:0] Read_data
);

    reg [31:0] mem [0:255];

    initial begin
        $readmemb("data.mem", mem, 0, 5);

        // DEBUG: prove it loaded correctly
        $display("=== data_memory loaded from data1.mem ===");
        $display("mem[0]=%b", mem[0]);
        $display("mem[1]=%b", mem[1]);
        $display("mem[2]=%b", mem[2]);
        $display("mem[3]=%b", mem[3]);
        $display("mem[4]=%b", mem[4]);
        $display("mem[5]=%b", mem[5]);
    end

    always @(posedge clk) begin
        if (MemWrite)
            mem[Address[9:2]] <= Write_data;   // word index
    end

    assign Read_data = MemRead ? mem[Address[9:2]] : 32'b0;

endmodule

`default_nettype wire
