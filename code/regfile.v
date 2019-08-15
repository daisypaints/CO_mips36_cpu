`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 04:58:33 PM
// Design Name: 
// Module Name: regfile
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


module regfile(
    input 			clk,
    input 	        wE,
    input 	[4:0] 	rW,
    input 	[31:0] 	busW,
	input 	[4:0] 	rA,
	input 	[4:0]   rB,
	output 	[31:0] 	busA,
	output 	[31:0] 	busB
    );
    
    reg		[31:0] 	register[0:31];
    integer i;
    
       initial
        begin
            for(i = 0; i < 32; i=i+1)
            register[i] <= 0;    
        end 
    
        assign busA = (rA != 0)? register[rA]: 0;
        assign busB = (rB != 0)? register[rB]: 0;
    
        always @ ( posedge clk )
        begin
            if (wE && (rW != 0))
            begin
                register[rW] = busW;
            end
        end
    
endmodule
