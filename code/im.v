`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 11:14:36 AM
// Design Name: 
// Module Name: im
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


module im(
    input 	[11:2] iaddr,
	output 	[31:0] ins
    );
	reg	[31:0]	im	[1023:0];
	
	initial begin
        $readmemh("D:/cpu/test3.txt", im);
    end

    assign ins = im[iaddr[11:2]][31:0];
    
endmodule

