module mux(
    output wire [31:0] y,//output of mux
    input wire [31:0] a,b, // input a=1'b1, b=1'b0
    input wire sel// select, single bit
    );
    
    //if sel = 1, then y = a
    // if sel = 0, then y = b
    assign y = sel ? a: b; //the type after assign must be WIRE
endmodule //mux