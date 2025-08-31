module controller(
    input  wire [6:0] op,
    input  wire [2:0] funct3,
    input  wire       funct7b5,
    input  reg       BrEq, BrLT,
    output wire [1:0] ResultSrc,
    output wire       MemWrite,
    output reg        PCSrc,
    output wire       ALUSrc,
    output wire       RegWrite,
    output wire [1:0] ImmSrc,
    output wire [2:0] ALUControl
);
    wire [1:0] ALUOp;
    wire Branch;
    wire Jump;

    main_decoder md(
        .op(op),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp)
    );

    alu_decoder ad(
        .opb5(op[5]),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    always @(Branch, BrEq, BrLT) begin
        case (funct3)
            3'b000: PCSrc = Branch & BrEq;      // beq
            3'b001: PCSrc = Branch & ~BrEq;     // bne
            3'b100: PCSrc = Branch & BrLT;      // blt
            3'b101: PCSrc = Branch & ~BrLT;     // bge
            3'b110: PCSrc = Branch & BrLT;      // bltu
            3'b111: PCSrc = Branch & ~BrLT;     // bgeu

            default: PCSrc = 1'b0;
        endcase
        PCSrc = PCSrc | Jump; 
    end
endmodule
