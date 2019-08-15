`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 11:14:36 AM
// Design Name: 
// Module Name: test
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


module test();

    reg clk, rst;
    
    initial
        begin
            clk = 0;
            rst = 1;
            #20
            rst = 0;
        end

    always
        begin
            #10;
            clk = ~clk;
        end
        
    mips mips(
              .clk(clk),
              .rst(rst)
    );
    
endmodule

