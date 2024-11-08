`timescale 1ns / 1ps

module DataMem(input clk, MemRead, MemWrite, input [11:0] addr, input [31:0] data_in,input [2:0] func3 ,output reg [31:0] data_out);
reg [7:0] mem [0:4*(1024-1)];

// synchronous writing
always @ (posedge clk) begin
   if(MemWrite)
       case(func3)
        0: mem[addr] = data_in[7:0];
        1: begin
         mem[addr] = data_in[7:0];
         mem[addr + 1] = data_in[15:8];
        end
        2: begin
         mem[addr] = data_in[7:0];
         mem[addr + 1] = data_in[15:8];
         mem[addr + 2] = data_in[23:16];
         mem[addr + 3] = data_in[31:24];
        end    
        endcase 
end

 //asynchronous reading
 //can't say always @ MemRead because this means the always block will be executed as long as MemRead "changes"
always @(*) begin
    if(MemRead)
        case(func3)
        0: data_out = {{24{mem[addr][7]}},mem[addr]};
        1: data_out = {{16{mem[addr + 1][7]}}, mem[addr + 1],mem[addr]};
        2: data_out = {mem[addr + 3],mem[addr + 2],mem[addr + 1],mem[addr]};
        4: data_out = {{24{1'b0}},mem[addr]};
        5: data_out = {{16{1'b0}}, mem[addr + 1],mem[addr]};
       endcase
end

//initial begin
////    mem[0]=8'd10;
////    mem[1]=8'd19;
////    mem[2]=8'd28;
////    mem[3]=8'd20;
////    mem[4]=8'd1;
    
//end

//assign data_out = MemRead? mem[addr]:data_out;
endmodule
