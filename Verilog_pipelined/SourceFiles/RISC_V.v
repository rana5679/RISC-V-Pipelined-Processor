`timescale 1ns / 1ps
`include "defines.v"

// input [1:0] ledSel, input [3:0] ssdSel, output [15:0] leds, output [12:0] ssd
// seeminglu unknown syntax error with an empty module: check after module definition
module RISC_V(
    input clk,
    input rst,
    input [2:0] ledSel,
    input [4:0] ssdSel, 
    output reg [15:0] leds, 
    output reg [12:0] ssd);

    // Wire declarations [ordered by size and grouped by funtionality]
    
    reg ecall;
    wire stallA, stallB, stall, pc_load;
    wire isBranch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, cf, zf, vf, sf, branch, jump;
    wire func7, ID_EX_func7 ,EX_MEM_func7;
    wire forwardA, forwardB;
    wire [1:0] ALUOp, WBSrc, PCSrc;
    wire [2:0] signalAHAZ, signalBHAZ;
    wire [2:0] func3, ID_EX_func3, EX_MEM_func3;
    wire [3:0] MEM_WB_ctrl;
    wire [3:0] ALUSel;
    wire [4:0] shamt, sh_bits, ID_EX_sh_bits;
    wire [4:0] opcode, ID_EX_opcode, EX_MEM_opcode,MEM_WB_opcode;
    wire [4:0] rs1_addr, rs2_addr, rd_addr,ID_EX_rs1_addr, ID_EX_rs2_addr, ID_EX_rd_addr,
               EX_MEM_rs1_addr, EX_MEM_rs2_addr, EX_MEM_rd_addr, MEM_WB_rd_addr;
    wire [5:0] EX_MEM_ctrl;
    reg [8:0] ID_EX_ctrlTemp;
    wire [8:0] ID_EX_ctrl, ctrl; 
    wire [`PC] pc_next, target_pc, pc_out, IF_ID_pc, IF_ID_pc_next, ID_EX_pc, ID_EX_pc_next,
               EX_MEM_pc_next, MEM_WB_pc_next, mem_addr;
    reg [`PC] pc_in;
    wire [31:0] IF_ID_inst, ID_EX_inst;
    reg  [31:0] inst, data_mem_out;
    wire [31:0] auipc_out, EX_MEM_auipc_out, MEM_WB_auipc_out;
    wire [31:0] jalr_out;
    wire [31:0] rs1, rs2, ID_EX_rs1, ID_EX_rs2, EX_MEM_rs2;
    reg [31:0] rs2Temp, branchrs1, branchrs2;
    wire [31:0] imm, ID_EX_imm, EX_MEM_imm, MEM_WB_imm;
    reg [31:0] alu_in_1;
    wire [31:0] alu_in_2, ALU_out, EX_MEM_ALU_out, MEM_WB_ALU_out;
    wire [31:0] MEM_WB_data_mem_out, mem_out;
    reg [31:0] write_data; 

    

/********************************************************* IF stage *****************************************************/


    //PC control (MUX) to determine input to pc
    always @* begin
        case (PCSrc)
        0: // if jalr
             pc_in = jalr_out[`PC];
        1: // if will branch or a jal instruction
            pc_in = target_pc;
        default: // could make this into two cases for compression
            pc_in = pc_next;
        endcase
     end
    
         
    // PC load 
    always @(*) begin
        if(rst)
            ecall= 0;
        else if((inst == `ECALL))
            ecall  = 1;
    end
    
    // stall is initialized in ID stage
    assign pc_load =  ~(stall | ecall);

    // PC
    Register # (.n(`PC_SIZE)) PC (.clk(clk), .rst(rst), .load(pc_load), .in(pc_in), .out(pc_out));
    
    // PC adder 1 (PC + 4)
    RCA #(.n(`PC_SIZE)) pc_next_adder (.A(pc_out), .B(4) , .out(pc_next)); 
    
    // IF_ID register
    Register # (.n(52)) IF_ID (.clk(~clk),.rst(rst),.load(~stall),.in({pc_out, pc_next, inst}),
    .out({IF_ID_pc,IF_ID_pc_next, IF_ID_inst})
    );
    
    
/********************************************************* ID stage *****************************************************/

// some assigns for readability purposes
    assign sh_bits = IF_ID_inst[`IR_shamt];
    assign func3 = IF_ID_inst[`IR_funct3];
    assign func7 = IF_ID_inst[30];    
    assign opcode = IF_ID_inst[`IR_opcode];
    assign rs1_addr = IF_ID_inst[`IR_rs1];
    assign rs2_addr = IF_ID_inst[`IR_rs2];
    assign rd_addr = IF_ID_inst[`IR_rd];
    assign ctrl = {ALUSrc, ALUOp, MemRead, MemWrite, WBSrc, MemtoReg, RegWrite};
    
    // Control Unit
         ControlUnit CU(.opcode(IF_ID_inst[`IR_opcode]), .isBranch(isBranch), .MemRead(MemRead), .MemtoReg(MemtoReg),
        .ALUOp(ALUOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .jump(jump), .WBSrc(WBSrc));
    
    // Register File
    RegFile RF (.clk(~clk), .rst(rst), .RegWrite(MEM_WB_ctrl[0]), .rs1_addr(rs1_addr), .rs2_addr(rs2_addr), 
    .rd_addr(MEM_WB_rd_addr), .write_data(write_data),.rs1(rs1), .rs2(rs2));
         
    // immediate generator
    rv32_ImmGen immediate(.IR(IF_ID_inst),.Imm(imm));
    
    // To handel the forwarding for the branch control and jalr adder
   ID_HazardUnit IDHU(.jump(jump), .isBranch(isBranch),.rs1_addr(rs1_addr),.rs2_addr(rs2_addr), .EX_MEM_rd_addr(EX_MEM_rd_addr),
   .EX_MEM_opcode(EX_MEM_opcode), .stallA(stallA), .stallB(stallB), .signalA(signalAHAZ),.signalB(signalBHAZ)
   );
    
    // Branching logic
    // MUX to decide control hazard handling for rs1
        always @(*) begin
            case(signalAHAZ)
                1: branchrs1 = EX_MEM_ALU_out;
                2: branchrs1 = EX_MEM_imm;
                3: branchrs1 = EX_MEM_auipc_out; 
                4: branchrs1 = EX_MEM_pc_next;
                default: branchrs1 = rs1;
            endcase
        end
      // MUX to decide control hazard handling for rs2
   always @(*) begin
            case(signalBHAZ)
                1: branchrs2 = EX_MEM_ALU_out;
                2: branchrs2 = EX_MEM_imm;
                3: branchrs2 = EX_MEM_auipc_out;
                4: branchrs2 = EX_MEM_pc_next;
                default: branchrs2 = rs2;
            endcase
    end
      
      // stall on either stallA or stallB   
      assign stall = stallA | stallB;
      
      // if there's a stall, turn the latest instruction into a bubble (nop)
          always @(*) begin
                  if(stall | ecall) 
                      ID_EX_ctrlTemp = 0;
                  else
                      ID_EX_ctrlTemp = ctrl;
               end

              
     // Flag unit for branch outcome
     FlagUnit Flags(.a(branchrs1), .b(branchrs2), .cf(cf), .zf(zf), .vf(vf), .sf(sf));
     
      // Branch control unit
     BranchCU BCU (.cf(cf), .zf(zf), .sf(sf), .vf(vf), .isBranch(isBranch),
     .func3(func3), .branch(branch));
    
    // PC Control Unit to determine selection unit (PCSrc) for PC input
    PCCU PCControl(.branch(branch), .opcode(opcode), .PCSrc(PCSrc));
    
    // PC adder to compute the value for branch/ jal
    RCA #(.n(`PC_SIZE)) target_adder (.A(IF_ID_pc), .B(imm) , .out(target_pc)); 
    
    // PC adder to compute the value for jalr
    RCA #(.n(32)) jalr_adder (.A(branchrs1), .B(imm) , .out(jalr_out));
    
   
   // ID_EX register
    Register # (.n(186)) ID_EX (.clk(clk),.rst(rst),.load(1'b1),
    .in({IF_ID_pc, IF_ID_pc_next, ID_EX_ctrlTemp, rs1_addr, rs2_addr, rd_addr , rs1, rs2, 
    imm, func3, func7, sh_bits, opcode, IF_ID_inst}), 
    .out({ID_EX_pc, ID_EX_pc_next, ID_EX_ctrl,
    ID_EX_rs1_addr, ID_EX_rs2_addr, ID_EX_rd_addr, ID_EX_rs1, ID_EX_rs2, ID_EX_imm, 
    ID_EX_func3, ID_EX_func7, ID_EX_sh_bits, ID_EX_opcode, ID_EX_inst})
    );
    
    
/********************************************************* EX stage *****************************************************/

    // Forwarding unit
    ForwardingUnit FU(.ID_EX_rs1_addr(ID_EX_rs1_addr), .ID_EX_rs2_addr(ID_EX_rs2_addr),
    .MEM_WB_rd_addr(MEM_WB_rd_addr),.MEM_WB_RegWrite(MEM_WB_ctrl[0]),.forwardA(forwardA),.forwardB(forwardB));
    
     // Fowarding MUX for rs1
    always @* begin
        case(forwardA)
        2'b0: alu_in_1 = ID_EX_rs1;
        2'b1: alu_in_1 = write_data;
        endcase
    end
    
    // Fowarding MUX for rs2
    // Note that we change the ID_EX_rs2 value, then add the alu mux afterwards, hence the rs2Temp
     always @* begin
        case(forwardB)
        2'b0: rs2Temp = ID_EX_rs2;
        2'b1: rs2Temp = write_data;
        endcase
    end
    
    // ALU control 
    ALUcu alucu(.inst(ID_EX_inst),.ALUOp(ID_EX_ctrl[7:6]), .ALUSel(ALUSel));
    
     // ALUSrc
    assign alu_in_2 = (ID_EX_ctrl[8])? ID_EX_imm : rs2Temp; 
    
    // Mux to determine shift amount based on whether its from an immediate or a register
    assign shamt = (ID_EX_opcode == `OPCODE_Arith_I)? ID_EX_sh_bits: ID_EX_rs2;
    
    // ALU
    prv32_ALU ALU(.a(alu_in_1), .b(alu_in_2),.shamt(shamt),.r(ALU_out),.alufn(ALUSel));

    // AUIPC adder
    RCA #(.n(32)) AUIPC_adder (.A({`PC_LEFT'b0, ID_EX_pc}), .B(ID_EX_imm) , .out(auipc_out));
    
 
    // EX_MEM register
    Register # (.n(157)) EX_MEM (.clk(~clk),.rst(rst),.load(1'b1),
    .in({ID_EX_pc_next, ID_EX_ctrl[5:0], ID_EX_rd_addr, ID_EX_func3, ALU_out, rs2Temp, ID_EX_opcode,
     ID_EX_imm, auipc_out}),
    .out({EX_MEM_pc_next, EX_MEM_ctrl, EX_MEM_rd_addr, EX_MEM_func3, EX_MEM_ALU_out, EX_MEM_rs2, 
    EX_MEM_opcode, EX_MEM_imm, EX_MEM_auipc_out})
    );
    
   
 /********************************************************* MEM stage *****************************************************/
    
    // MUX for picking either the instruction address or data address as input to the memory
    assign mem_addr = (clk)? pc_out : EX_MEM_ALU_out[`PC];
    
    // combined memory
    Memory mem(.clk(clk),.MemRead(EX_MEM_ctrl[5]), .MemWrite(EX_MEM_ctrl[4]),.addr(mem_addr), 
   .data_in(EX_MEM_rs2),.func3(EX_MEM_func3),.data_out(mem_out)
    );
    
    // selecting whether the output is for the instruction address or the data  
    always @(*) begin
        if(clk) inst = mem_out;
        else
            if(EX_MEM_ctrl[5])
                data_mem_out = mem_out;        
    end


// MEM_WB register    
    Register # (.n(152)) MEM_WB (.clk(clk),.rst(rst),.load(1'b1),
    .in({EX_MEM_pc_next, EX_MEM_ctrl[3:0], EX_MEM_rd_addr, EX_MEM_imm, EX_MEM_ALU_out, data_mem_out, 
    EX_MEM_auipc_out,EX_MEM_opcode}),
    .out({MEM_WB_pc_next, MEM_WB_ctrl, MEM_WB_rd_addr, MEM_WB_imm, MEM_WB_ALU_out, MEM_WB_data_mem_out,
    MEM_WB_auipc_out,MEM_WB_opcode})
    );
    

/********************************************************* WB stage *****************************************************/
    
    // Write Back Mux
    always @* begin
    case (MEM_WB_ctrl[3:2])
    0: write_data = MEM_WB_ctrl[1]? MEM_WB_data_mem_out: MEM_WB_ALU_out; // data from WB reg
    1: write_data = MEM_WB_imm; // LUI
    2: write_data = MEM_WB_auipc_out; // AUIPC
    3: write_data = {`PC_LEFT'b0, MEM_WB_pc_next}; // Jal/ Jalr
    endcase
    end
    

/********************************************************* FPGA output *****************************************************/    
    
    
    // LED out: NEEDS TO BE MODIFIED
    // Ask the dr what to change in this
    always @ (*) begin
        case (ledSel)
            3'b000: leds = inst[15:0];
            3'b001: leds = inst[31:16];
            3'b010: leds = {6'b0, ID_EX_ctrlTemp};
            3'b011: leds = {6'b0, ID_EX_ctrl};
            3'b100: leds = {10'b0, EX_MEM_ctrl};
            3'b101: leds = {12'b0, MEM_WB_ctrl};
            3'b110: leds = {4'b0, isBranch, forwardA, forwardB, stallA, stallB, signalAHAZ, signalBHAZ, branch, jump, pc_load, PCSrc};
            // can add different options for the controls of each stage [ID, EX, MEM, WB]
         endcase
    end
    
    // ssd out
    /*
    pc cout, pc in, wite data, rd_addr, mem_out, what else?
    */
    always @ (*) begin
        case (ssdSel)
            4'b0000: ssd = pc_out; 
            4'b0001: ssd = pc_next;
            4'b0010: ssd = target_pc;
            4'b0011: ssd = pc_in;
            4'b0100: ssd = mem_addr;
            4'b0101: ssd = mem_out;
            4'b0110: ssd = data_mem_out;
            4'b0111: ssd = EX_MEM_rs2 ;
            4'b1000: ssd = MEM_WB_rd_addr;
            4'b1001: ssd = write_data;
        endcase
    end
    
endmodule
