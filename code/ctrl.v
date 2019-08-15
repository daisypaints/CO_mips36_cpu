`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 11:14:36 AM
// Design Name: 
// Module Name: ctrl
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


module ctrl(
    input [31:0] ins,
    output wire branch,
    output wire jump,
    output wire[1:0] regDst,
    output wire regWr,
    output wire memWr,
    output wire[1:0] memtoReg,
    output wire aluSrcA, aluSrcB,
    output wire extOp,
    output wire Rtype,
    output wire[3:0] ALUctr,
    output wire[1:0] byte
    );
    
    wire [4:0]rs, rt, rd, shamt;
    wire [5:0]op, func;
    wire [15:0]imm; 
    wire [25:0]target;
    wire[3:0]ALUop, Raluop;
    
    assign op = ins[31:26];
    assign rs = ins[25:21];
    assign rt = ins[20:16];
    assign rd = ins[15:11];
    assign shamt = ins[10:6];
    assign func = ins[5:0];
    
    assign imm = ins[15:0];
    assign target = ins[25:0];
    
    assign Rtype = !op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]; 
       
    assign branch = (!op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0])|
                    (!op[5]&!op[4]&!op[3]&op[2]&!op[1]&op[0])|
                    (!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&op[0])|
                    (!op[5]&!op[4]&!op[3]&op[ 2]&op[1]&op[0])|
                    (!op[5]&!op[4]&!op[3]&op[2]&op[1]&!op[0]);
                    
    assign jump = (!op[5]&!op[4]&!op[3]&!op[2]&op[1]&!op[0])|
                  (!op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0]); 
    
    assign regDst[0] = Rtype;
    assign regDst[1] = (Rtype & (!func[5]&!func[4]&func[3]&!func[2]&!func[1]&func[0]))|
                        (!op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0]);
    
    assign regWr = Rtype|
                   (!op[5]&!op[4]&op[3]&!op[2]&!op[1]&op[0])|
                   (!op[5]&!op[4]&op[3]&!op[2]&op[1]&!op[0])|
                   (!op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0])|
                   (!op[5]&!op[4]&op[3]&op[2]&op[1]&op[0])|
                   (!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0])|
                   (!op[5]&!op[4]&op[3]&op[2]&op[1]&!op[0])|
                   (!op[5]&!op[4]&op[3]&op[2]&!op[1]&!op[0])|
                   (op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0])|
                   (op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0])|
                   (op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0])|
                   (!op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0])|
                   (!op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0]);
    
    assign memtoReg[0] = (op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0])|
                      (op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0])|
                      (op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0]); 
                           
    assign memtoReg[1] = (Rtype & (!func[5]&!func[4]&func[3]&!func[2]&!func[1]&func[0]))|
                         (!op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0]);
    
    assign memWr = (op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0])|
                   (op[5]&!op[4]&op[3]&!op[2]&!op[1]& !op[0]); 
    
    assign extOp = !((!op[5]&!op[4]&op[3]&op[2]&op[1]&op[0])|
                     (!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0])|
                     (!op[5]&!op[4]&op[3]&op[2]&op[1]&!op[0])|
                     (!op[5]&!op[4]&op[3]&op[2]&!op[1]&!op[0])
                    );
    
    assign aluSrcA =  Rtype&(
                     (!func[5]&!func[4]&!func[3]&!func[2]&!func[1]&!func[0])|
                     (!func[5]&!func[4]&!func[3]&!func[2]&func[1]&!func[0])|
                     (!func[5]&!func[4]&!func[3]&!func[2]&func[1]&func[0]));
    
    assign aluSrcB = !(Rtype|
                       (!op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0])|
                       (!op[5]&!op[4]&!op[3]&op[2]&!op[1]&op[0])|
                       (!op[5]&!op[4]&!op[3]&op[2]&op[1]&op[0])|
                       (!op[5]&!op[4]&!op[3]&op[2]&op[1]&!op[0])|
                       (!op[5]&!op[4]&!op[3]&!op[2]&!op[1]&op[0])
                       );
    
    assign ALUop[0] = (!op[5]&!op[4]&!op[3]&op[2]&!op[1]&!op[0])|
                      (!op[5]&!op[4]&!op[3]&op[2]&!op[1]&op[0])|
                      (!op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0])|
                      (!op[5]&!op[4]&op[3]&op[2 ]&!op[1]&!op[0])|
                      (!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0]);
    
    assign ALUop[1] = (!op[5]&!op[4]&op[3]&!op[2]&op[1]&!op[0])|
                      (!op[5]&!op[4]&op[3]&op[2]&!op[1]&!op[0])|
                      (!op[5]&!op[4]&op[3]&op[2]&op[1]&!op[0])|
                      (!op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0])|
                      (!op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0]);
    
    assign ALUop[2] = (!op[5]&!op[4]&op[3]&op[2]&!op[1]&op[0])|
                      (!op[5]&!op[4]&op[3]&op[2]&op[1]&!op[0])|
                      (!op[5]&!op[4]&op[3]&op[2]&op[1]&op[0])|
                      (!op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0]);
                      
    assign ALUop[3] = (!op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0])|
                      (!op[5]&!op[4]&op[3]&op[2]&op[1]&op[0])|
                      (!op[5]&!op[4]&op[3]&op[2]&op[1]&op[0])|
                      (!op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0]);
    
    //assign ALUop[4] = (!op[5]&!op[4]&op[3]&op[2]&op[1]&op[0]); //LUI
    
    assign Raluop[0] = (func[5]&!func[4]&!func[3]&!func[2]&func[1]&func[0])|
                       (func[5]&!func[4]&!func[3]&func[2]&!func[1]&!func[0])|
                       (func[5]&!func[4]&!func[3]&func[2]&!func[1]&func[0])|
                       (!func[5]&!func[4]&!func[3]&!func[2]&!func[1]&!func[0])|
                       (func[5]&!func[4]&func[3]&!func[2]&func[1]&func[0])|
                       (!func[5]&!func[4]&!func[3]&func[2]&!func[1]&!func[0])|
                       (!func[5]&!func[4]&!func[3]&!func[2]&func[1]&func[0])|
                       (!func[5]&!func[4]&!func[3]&func[2]&func[1]&func[0])|
                       (func[5]&!func[4]&!func[3]&!func[2]&func[1]&!func[0]);
    
    assign Raluop[1] = (func[5]&!func[4]&func[3]&!func[2]&func[1]&!func[0])|
                       (func[5]&!func[4]&!func[3]&func[2]&!func[1]&!func[0])|
                       (func[5]&!func[4]&!func[3]&func[2]&func[1]&!func[0])|
                       (!func[5]&!func[4]&!func[3]&!func[2]&!func[1]&!func[0])|
                       (!func[5]&!func[4]&!func[3]&func[2]&!func[1]&!func[0])|
                       (func[5]&!func[4]&!func[3]&!func[2]&!func[1]&!func[0])|
                       (func[5]&!func[4]&!func[3]&!func[2]&func[1]&!func[0]);
    
    assign Raluop[2] = (func[5]&!func[4]&!func[3]&func[2]&func[1]&func[0])|
                       (func[5]&!func[4]&!func[3]&func[2]&!func[1]&func[0])|
                       (func[5]&!func[4]&!func[3]&func[2]&func[1]&!func[0])|
                       (!func[5]&!func[4]&!func[3]&!func[2]&!func[1]&!func[0])|
                       (!func[5]&!func[4]&!func[3]&func[2]&!func[1]&!func[0])|
                       (!func[5]&!func[4]&!func[3]&!func[2]&func[1]&func[0])|
                       (!func[5]&!func[4]&!func[3]&func[2]&func[1]&func[0])|
                       (func[5]&!func[4]&!func[3]&!func[2]&!func[1]&!func[0])|
                       (func[5]&!func[4]&!func[3]&!func[2]&func[1]&!func[0]);
    
    assign Raluop[3] = (!func[5]&!func[4]&!func[3]&!func[2]&func[1]&!func[0])|
                       (func[5]&!func[4]&func[3]&!func[2]&func[1]&func[0])|
                       (!func[5]&!func[4]&!func[3]&!func[2]&func[1]&func[0])|
                       (!func[5]&!func[4]&!func[3]&func[2]&func[1]&func[0])|
                       (!func[5]&!func[4]&!func[3]&func[2]&func[1]&!func[0])|
                       (func[5]&!func[4]&!func[3]&!func[2]&!func[1]&!func[0])|
                       (func[5]&!func[4]&!func[3]&!func[2]&func[1]&!func[0]);
    
    //assign Raluop[4] = 0;
    
    assign ALUctr = (Rtype? Raluop : ALUop);
    
    assign byte[0] = (op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0])|
                        (op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0])|
                        (op[5]&!op[4]&!op[3]&!op[2]&!op[1]&!op[0]);
                        
    assign byte[1] = (op[5]&!op[4]&!op[3]&!op[2]&op[1]&op[0])|
                        (op[5]&!op[4]&op[3]&!op[2]&op[1]&op[0])|
                        (op[5]&!op[4]&op[3]&!op[2]&!op[1]&!op[0]);

     
endmodule

