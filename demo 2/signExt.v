`default_nettype none
module signExt(
    input [15:0] immediate, //16-bit in
    output [31:0] extended  //extended 32-bit out
    );

    assign extended = {{16{immediate[15]}}, immediate};

endmodule