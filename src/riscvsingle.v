module riscvsingle(
        input  wire        clk, reset,
        input  wire [31:0] ReadData,
        input  wire [31:0] Instr,
        output wire [31:0] PC,
        output wire        MemWrite,
        output wire [31:0] ALUResult,
        output wire [31:0] WriteData
);

 wire ALUSrc, RegWrite, BrEq, BrLT, PCSrc;
 wire [1:0] ResultSrc, ImmSrc;
 wire [2:0] ALUControl;

 controller ctrl(
    .op(Instr[6:0]),
    .funct3(Instr[14:12]),
    .funct7b5(Instr[30]),
    .BrEq(BrEq), .BrLT(BrLT),
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
    .BrEq(BrEq), .BrLT(BrLT),
    .PC(PC),
    .ALUResult(ALUResult),
    .WriteData(WriteData)
);
endmodule