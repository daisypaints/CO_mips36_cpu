`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 11:14:36 AM
// Design Name: 
// Module Name: npc
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


module npc(
    input [31:0]         pc_cur,
    input [31:0]         ins,
    input [31:0]         busA,
    input [31:0]         jaddr,
    input                branch, jump,
    input                ZF,
    output reg[31:0]    pc_next
    );
    
    wire [5:0]op, func;
    wire [4:0]rt;
    wire [15:0]imm16;
    wire [25:0]target;
    wire [29:0]temp;
    wire [31:0]b_npc, n_npc, j_npc;//branch npc, normal npc, jump npc
    
    assign op = ins[31:26];
    assign func = ins[5:0];
    assign rt = ins[20:16];
    assign imm16 = ins[15:0];
    assign target = ins[25:0];
    
    /*ext #(16) signExt(
                      .extOp(1),
                      .din(imm16),
                      .dout(temp)
    );*/
    assign temp = {{14{imm16[15]}}, imm16};
    assign b_npc = pc_cur + {temp, 2'b00} + 4;//x4
    assign n_npc = pc_cur + 4;
    assign j_npc = {pc_cur[31:28], target, 2'b0};
    
    always@(*) 
        begin 
            case (op) 
                6'b000100 : pc_next = (ZF && branch)? b_npc : n_npc;//BEQ  =
                6'b000101 : pc_next = (!ZF && branch)? b_npc : n_npc;//BNE !=
                6'b000110 : pc_next = (branch && (busA==0 || busA[31]==1))? b_npc : n_npc;//BLEZ <=
                6'b000111 : pc_next = (branch && busA!=0 && busA[31]==0)? b_npc : n_npc;//BGTZ >
                6'b000010 : pc_next = (jump)? j_npc : n_npc;//J 
                6'b000011 : pc_next = (jump)? j_npc : n_npc;// JAL 
                6'b000001: //BGEZ BLTZ  >=  <
                    begin  
                        if(branch && rt==1)//BGEZ
                            pc_next = (busA==0 || busA[31]==0)? b_npc : n_npc;
                        else if(branch && rt==0)//BLTZ
                            pc_next = (busA!=0 && busA[31]==1)? b_npc : n_npc;
                    end
                6'b000000: pc_next = (func == 6'b001000 || func == 6'b001001)? jaddr : n_npc; //JR JALR
                default: pc_next = n_npc;
            endcase
        end
    
endmodule

