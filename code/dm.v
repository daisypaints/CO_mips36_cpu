`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 11:14:36 AM
// Design Name: 
// Module Name: dm
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


module dm(
    input 			    clk,
	input 	[11:0] 	    addr,
	input          	    wE,
	input 	[31:0]  	wd,
	input 	[1:0]	    byteExt,
	output  reg	[31:0] 	rd
    );
    
    reg [31:0] dm [1023:0];
    
    wire [1:0]  byteSel;
    wire [9:0]  wAddr;
    
    reg [7:0]   byteIn;
    reg [31:0]  temp;
    
    assign byteSel 	= addr[1:0] ^ 2'b11;//select È¡·´
    assign wAddr   = addr[11:2];
    
    always @ (*)
        begin
            if (byteExt == 2'b01 || byteExt == 2'b00)
            begin// lb
                case (byteSel)
                    2'b00: byteIn <= dm[wAddr][7:0];
                    2'b01: byteIn <= dm[wAddr][15:8];
                    2'b10: byteIn <= dm[wAddr][23:16];
                    2'b11: byteIn <= dm[wAddr][31:24];
                endcase
                case (byteExt)// Embedded extender.
                    2'b00: rd <= {{24{1'b0}}, byteIn};// zero lbu
                    2'b01: rd <= {{24{byteIn[7]}}, byteIn};// sign lb
                endcase
            end else begin
                rd = dm[wAddr][31:0];// lw
            end
        end
    
    always @ ( posedge clk )
        begin// Write
            if (wE)
            begin
                if (byteExt == 2'b10)
                begin// sb
                    temp = dm[wAddr][31:0];
                    case (byteSel)
                        2'b00: temp[7:0]      = wd[7:0];
                        2'b01: temp[15:8]     = wd[7:0];
                        2'b10: temp[23:16]    = wd[7:0];
                        2'b11: temp[31:24]    = wd[7:0];
                    endcase
                    dm[wAddr][31:0] = temp[31:0];
                end else begin// sw
                    dm[wAddr][31:0] = wd[31:0];
                end
            end
        end
        
endmodule
