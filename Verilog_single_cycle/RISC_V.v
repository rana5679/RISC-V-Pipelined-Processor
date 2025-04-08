/*******************************************************************
*
* Module: module_name.v
* Project: Project_Name
* Author: name and email
* Description: put your description here
*
* Change history: ??/10/23 - Created Module; ????
                  27/10/2024 added new ALU and ImmGen, added WriteBack logic, added brnach CU, pc logic
                  // Nov 8: fixed guidlines and added comments
*
**********************************************************************/

`timescale 1ns / 1ps
`include "defines.v"

// input [1:0] ledSel, input [3:0] ssdSel, output [15:0] leds, output [12:0] ssd
// seeminglu unknown syntax error with an empty module: check after module definition
module RISC_V(
    input clk,
    input rst,
    input [1:0] ledSel,
    input [3:0] ssdSel, 
    output reg [15:0] leds, 
    output reg [12:0] ssd);

    wire isBranch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, cf, zf, vf, sf, branch, Jump;
    wire [1:0] ALUOp, WBSrc;
    wire [3:0] ALUSel;
    wire [4:0] shamt;
    wire [`PC] pc_next, target_pc, pc_out;
    reg [`PC] pc_in;
    wire [31:0] inst;
    wire [31:0] rs1, rs2 , imm, ALU_out, mem_out, alu_in_2, auipc_out;
    reg [31:0] write_data;
    
    
    
    // PC adder 1 (PC + 4)
    RCA #(.n(`PC_SIZE)) pc_next_adder (.A(pc_out), .B(4) , .out(pc_next)); 
    // PC adder 2 this computes the value for branch/ jal/ auipc
    RCA #(.n(`PC_SIZE)) target_adder (.A(pc_out), .B(imm) , .out(target_pc)); 
    // AUIPC adder
    RCA #(.n(32)) AUIPC_adder (.A({20'b0, pc_out}), .B(imm) , .out(auipc_out));
    
    //PC control (MUX) to determine input to pc
    always @* begin
        if(branch | `JAL) // if will branch or a jal instruction
            pc_in = target_pc;
         else if(inst[`IR_opcode] == `OPCODE_JALR) // if jalr
            pc_in = ALU_out;
         else // could make this into two cases for compression
            pc_in = pc_next;
         end
         

    // PC
    Register PC (.clk(clk), .rst(rst), .load(1'b1), .in(pc_in), .out(pc_out));
    
    // Branch control unit
    BranchCU BCU (.cf(cf), .zf(zf), .sf(sf), .vf(vf), .isBranch(isBranch), .func3(inst[`IR_funct3]), .branch(branch));
    
    // Instruction Memory: change if compressed
    // PC_W: PC word addressable
    InstMem IM(.addr(pc_out[`PC_W]),.data_out(inst));
    
    // Control Unit
     ControlUnit CU(.opcode(inst[`IR_opcode]), .isBranch(isBranch), .MemRead(MemRead), .MemtoReg(MemtoReg),
    .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .Jump(Jump), .WBSrc(WBSrc));

    // Register File
    RegFile RF (.clk(clk), .rst(rst), .RegWrite(RegWrite), .rs1_addr(inst[`IR_rs1]), .rs2_addr(inst[`IR_rs2]), .rd_addr(inst[`IR_rd]),
     .write_data(write_data),.rs1(rs1), .rs2(rs2));
     
    // immediate generator
    rv32_ImmGen immediate(.IR(inst),.Imm(imm));
    
    // ALU control 
    ALUcu alucu(.inst(inst),.ALUOp(ALUOp), .ALUSel(ALUSel));
   
    // ALUSrc
    assign alu_in_2 = (ALUSrc)? imm : rs2; 
    
    // Mux to determine shift amount based on whether its from an immediate or a register
    assign shamt = (inst[`IR_opcode] == `OPCODE_Arith_I)? inst[`IR_shamt]: rs2;
    
    // ALU
    prv32_ALU ALU(.a(rs1), .b(alu_in_2),.shamt(shamt),.r(ALU_out), .cf(cf), .zf(zf), .vf(vf), .sf(sf),.alufn(ALUSel)); // ALU
    
    // Data Memory
     DataMem DM (.clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .addr(ALU_out[11:0]), .data_in(rs2),.func3(inst[`IR_funct3]), .data_out(mem_out));
    
    // Write Back Mux
    always @* begin
    case (WBSrc)
    0: write_data = MemtoReg? mem_out: ALU_out; // data from WB reg
    1: write_data = imm; // LUI
    2: write_data = auipc_out; // AUIPC
    3: write_data = pc_next; // Jal/ Jalr
    endcase
    end
    
    // LED out: NEEDS TO BE MODIFIED
    always @ (*) begin
        case (ledSel)
            2'b00: leds = inst[15:0];
            2'b01: leds = inst[31:16];
            2'b10: leds = {2'b00,ALUSel,zf,zf & isBranch,isBranch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, Jump, WBSrc};
         endcase
    end
    
    // ssd out
    always @ (*) begin
        case (ssdSel)
            4'b0000: ssd = pc_out; 
            4'b0001: ssd = pc_next;
            4'b0010: ssd = target_pc;
            4'b0011: ssd = pc_in;
            4'b0100: ssd = rs1;
            4'b0101: ssd = rs2;
            4'b0110: ssd = write_data;
            4'b0111: ssd = imm;
            // add mux later
            4'b1001: ssd = alu_in_2;
            4'b1010: ssd = ALU_out;
            4'b1011: ssd = mem_out;
        endcase
    end
    
endmodule
