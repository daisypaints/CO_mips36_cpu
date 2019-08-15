`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 05:01:53 PM
// Design Name: 
// Module Name: mips
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


module mips(
    input clk,
	input rst
    );
    
    wire [31:0]   ins;
    wire [31:0]   busA;
    wire [31:0]   busB;
    wire [31:0]   pc_cur;
    wire [31:0]   pc_next;
    wire [31:0]   result;
    wire [31:0]   DataOut;
    wire [31:0]   pc_ra;
    
    wire[3:0] ALUOp;
    wire[31:0] ExtOut;
    wire[25:0] JumpAddr;
    wire[15:0] imm;
    wire[5:0] op, func;
    wire[4:0]  rs, rt, rd, shamt;
    wire[4:0]  rW;
    wire[25:0] target;
    wire[31:0] in, dm_out;
    wire ZF, OF;
    wire branch, jump, regWr, memWr, Rtype, aluSrcA, aluSrcB, extOp;
    wire[3:0] ALUctr;
    wire[1:0] byte, memtoReg, regDst;
    
    assign op = ins[31:26];
    assign rs = ins[25:21];
    assign rt = ins[20:16];
    assign rd = ins[15:11];
    assign shamt = ins[10:6];
    assign func = ins[5:0];
    
    assign imm = ins[15:0];
    assign target = ins[25:0];
    
    assign pc_ra = pc_cur + 4'b0100;
    
    pc pc(
          .clk(clk),
          .rst(rst),
          .npc(pc_next),
          .pc(pc_cur)
        );
        
    npc npc(
            .pc_cur(pc_cur),
            .ins(ins),
            .busA(busA),
            .jaddr(busA),
            .branch(branch),
            .jump(jump),
            .ZF(ZF),
            .pc_next(pc_next)
    );
    
    im im(
          .iaddr(pc_cur[11:2]),
          .ins(ins)
    );
    
    ext ext(
            .extOp(extOp),
            .din(imm),
            .dout(ExtOut)
    );
    
    mux #(5) regDst_mux(
                        .a(rt),
                        .b(rd),
                        .c(31),
                        .d(31),
                        .ctrl(regDst),
                        .dout(rW)
    );
    
    mux #(32) memtoReg_mux(
            .a(result),
            .b(dm_out),
            .c(pc_ra),
            .ctrl(memtoReg),
            .dout(in)
    );
    
    regfile rf(
               .clk(clk),
               .wE(regWr),
               .rW(rW),
               .busW(in),
               .rA(rs),
               .rB(rt),
               .busA(busA),
               .busB(busB)
    );
    
    alu alu(
            .busA(busA),
            .busB(busB),
            .ALUop(ALUctr),
            .ALUsrcA(aluSrcA),
            .ALUsrcB(aluSrcB),
            .ext_out(ExtOut),
            .shamt(shamt),
            .OF(OF),
            .ZF(ZF),
            .Result(result)
    );
    
    dm dm(
          .clk(clk),
          .addr(result),
          .wE(memWr),
          .wd(busB),
          .byteExt(byte),
          .rd(dm_out)
    );
    
    ctrl ctrl(
              .ins(ins),
              .branch(branch),
              .jump(jump),
              .regDst(regDst),
              .regWr(regWr),
              .memWr(memWr),
              .memtoReg(memtoReg),
              .aluSrcA(aluSrcA),
              .aluSrcB(aluSrcB),
              .extOp(extOp),
              .Rtype(Rtype),
              .ALUctr(ALUctr),
              .byte(byte)
    );
    
endmodule

