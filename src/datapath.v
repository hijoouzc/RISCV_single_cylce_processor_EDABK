module datapath(
    input           clk, reset,
    input  [1:0]    ResultSrc,
    input           PCSrc, ALUSrc,
    input           RegWrite,
    input  [1:0]    ImmSrc,
    input  [31:0]   Instr,
    input  [2:0]    ALUControl,
    input  [31:0]   ReadData,
    output reg [31:0]   PC,
    output          Zero,
    output [31:0]   ALUResult, WriteData
);

    wire [31:0] PCNext, PCPlus4, PCTarget;
    wire [31:0] ImmExt, SrcA, SrcB;
    wire [31:0] Result;

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 32'h00000000;
        else
            PC <= PCNext;
    end


    assign PCPlus4 = PC + 32'd4;
    assign PCTarget = PC + ImmExt;
    assign PCNext = (PCSrc) ? PCTarget : PCPlus4;

    register_file rf(.clk(clk), .we3(RegWrite), .a1(Instr[19:15]), .a2(Instr[24:20]),
                     .a3(Instr[11:7]), .wd3(Result), .rd1(SrcA), .rd2(WriteData));


    extend ext(.instr(Instr[31:7]), .immsrc(ImmSrc), .immext(ImmExt));

    assign SrcB = (ALUSrc) ? ImmExt : WriteData;

    alu alu(.srcA(SrcA), .srcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult), .Zero(Zero));
    
    assign Result = ResultSrc[1] ? PCPlus4 : (ResultSrc[0] ? ReadData : ALUResult);

endmodule