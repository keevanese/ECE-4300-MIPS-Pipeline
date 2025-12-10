// data_memory.v
module data_memory(
    input         clk,
    input         MemWrite,
    input         MemRead,
    input  [31:0] Address,
    input  [31:0] Write_data,
    output [31:0] Read_data
);
    // 256 x 32-bit memory
    reg [31:0] mem [0:255];

    // initialize from data.mem (binary or hex, depending on your file)
    initial begin
        $readmemb("data.mem", mem, 0, 5);   // or $readmemh if your file is hex
    end

    // write on clock edge
    always @(posedge clk) begin
        if (MemWrite)
            mem[Address[9:2]] <= Write_data; 
            // using bits [9:2] for word index (256 words)
    end

    // combinational read
    assign Read_data = (MemRead) ? mem[Address[9:2]] : 32'b0;

endmodule