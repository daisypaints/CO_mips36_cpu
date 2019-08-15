`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2019 11:14:36 AM
// Design Name: 
// Module Name: alu
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


module alu(
    input[31:0]      busA, busB,
    input[3:0]       ALUop,
    input            ALUsrcA, ALUsrcB,
    input   [31:0]   ext_out,
    input   [4:0]    shamt,
    output reg       OF = 0, ZF,
    output reg[31:0] Result
    );
    reg [31:0]   temp;
    wire         cout;
    wire[31:0]   result;
    
    wire [31:0] A;
    wire [31:0] B;

    assign A = (ALUsrcA ? shamt : busA);
    assign B = (ALUsrcB ? ext_out : busB);
    
    always @(*)
        begin
            case(ALUop)
                4'b0000: Result <= A + B;   //addu
                4'b0001: Result <= A - B;  //subu
                4'b0010: Result <= ($signed(A) < $signed(B))? 1: 0;   //slt
                4'b0011: Result <= A & B;    //and
                4'b0100: Result <= ~(A | B);       //nor
                4'b0101: Result <= A | B;    //or
                4'b0110: Result <= A ^ B;    //xor
                4'b0111: Result <= B << A;   //sll sllv
                4'b1000: Result <= B >> A;  //srl srlv
                4'b1001: Result <= (A < B)? 1: 0;   //sltu
                //4'b1010:jr
                //4'b1011:jalr
                4'b1100: Result <= {B[15:0], 16'd0}; //lui 
                4'b1101: Result <= $signed(B) >>> A;    //sra srav
                4'b1110: assign temp = B;   //add
                4'b1111: assign temp = ~B;  //sub
            endcase
        end
        
    assign {cout, result} = A + temp;
    
    always @( * )
        begin
            if(ALUop == 4'b1110 || ALUop == 4'b1111)
                begin
                    Result = result;
                    OF = cout ^ (cout*2 + result[31] - A[31] - temp[31]);
                end

            ZF = (Result == 32'b0)? 1:0;
        end

endmodule

