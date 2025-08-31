module datapath(
    input  wire         clk, reset,
    input  wire [1:0]   ResultSrc,
    input  wire         PCSrc, ALUSrc,
    input  wire         RegWrite,
    input  reg  [1:0]   ImmSrc,
    input  reg  [31:0]  Instr,
    input  wire [2:0]   ALUControl,
    input  wire [31:0]  ReadData,
    output reg  [31:0]  PC,
    output wire         BrEq, BrLT,
    output wire [31:0]  ALUResult, WriteData
);

    wire [31:0] PCNext, PCPlus4, PCTarget;
    reg [31:0] ImmExt;
    wire [31:0] SrcA, SrcB;
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


    // extend ext(.instr(Instr[31:7]), .immsrc(ImmSrc), .immext(ImmExt));

    always @(Instr or ImmSrc) begin
        case(ImmSrc)
    // I−type
    2'b00: ImmExt = {{20{Instr[31]}}, Instr[31:20]};
    // S−type (stores)
    2'b01: ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
    // B−type (branches)
    2'b10: ImmExt = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
    // J−type (jal)
    2'b11: ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
        endcase
    end


    assign SrcB = (ALUSrc) ? ImmExt : WriteData;

    alu alu(.srcA(SrcA), .srcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult), .BrEq(BrEq), .BrLT(BrLT));

    assign Result = ResultSrc[1] ? PCPlus4 : (ResultSrc[0] ? ReadData : ALUResult);

endmodule