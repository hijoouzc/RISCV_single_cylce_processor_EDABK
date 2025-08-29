module riscvsingle(
        input           clk, reset,
        input  [31:0]   ReadData,
        input  [31:0]   Instr,
        output [31:0]   PC,
        output          MemWrite,
        output [31:0]   ALUResult, WriteData
);

 wire ALUSrc, RegWrite, Zero, PCSrc;
 wire [1:0] ResultSrc, ImmSrc;
 wire [2:0] ALUControl;

 controller ctrl(
    .op(Instr[6:0]),
    .funct3(Instr[14:12]),
    .funct7b5(Instr[30]),
    .Zero(Zero),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .PCSrc(PCSrc),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUControl(ALUControl)
);

datapath dp(
    .clk(clk),
    .reset(reset),
    .ResultSrc(ResultSrc),
    .PCSrc(PCSrc),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .Instr(Instr),
    .ALUControl(ALUControl),
    .ReadData(ReadData),
    .Zero(Zero),
    .PC(PC),
    .ALUResult(ALUResult),
    .WriteData(WriteData)
);
endmodule