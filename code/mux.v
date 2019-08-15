`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 11:14:36 AM
// Design Name: 
// Module Name: mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux #(parameter WIDTH = 32)(
    input 	[WIDTH - 1:0] 	    a,
	input 	[WIDTH - 1:0] 	    b,
	input 	[WIDTH - 1:0]	    c,
	input 	[WIDTH - 1:0] 	    d,
	input 	[1:0]	            ctrl,
	output 	reg [WIDTH - 1:0]	dout
    );
    
    always @ ( * ) begin
        case (ctrl)
            2'b00: dout = a;
            2'b01: dout = b;
            2'b10: dout = c;
            2'b11: dout = d;
        endcase
    end
endmodule//Mux


