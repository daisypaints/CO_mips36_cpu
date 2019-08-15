`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 11:14:36 AM
// Design Name: 
// Module Name: ext
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


module ext #(parameter WIDTH = 16)(
    input           			extOp,
    input       [WIDTH - 1:0]	din,
	output reg  [31:0]			dout
    );
    
    always @ ( * )
        begin
            case (extOp)
                1'b0: dout = {{(32 - WIDTH){1'b0}}, din};// zero
                1'b1: dout = {{(32 - WIDTH){din[WIDTH - 1]}}, din};// sign
                default: dout = din;
            endcase
        end
        
endmodule

