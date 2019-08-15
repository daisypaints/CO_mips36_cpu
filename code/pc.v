`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 11:14:36 AM
// Design Name: 
// Module Name: pc
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


module pc (
    input 		        clk,
	input 		        rst,
	input       [31:0]  npc,
    output reg	[31:0]	pc
	);

	always @ ( posedge clk )
	   begin
	       if (rst)
	           pc <= 32'h00003000;
		   else
		       pc <= npc;
	   end
	   
endmodule

