module alu(
    input [31:0] srcA, srcB,
    input [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg Zero
);

    always @(srcA, srcB, ALUControl) begin
        case (ALUControl)
            3'b000: ALUResult = srcA + srcB; // ADD
            3'b001: ALUResult = srcA - srcB; // SUB
            3'b010: ALUResult = srcA & srcB; // AND
            3'b011: ALUResult = srcA | srcB; // OR
            3'b100: ALUResult = srcA < srcB; // Set less than
            3'b101: ALUResult = srcA << srcB; // Shift left logical
            3'b110: ALUResult = srcA >> srcB; // Shift right logical
            3'b111: ALUResult = srcA >>> srcB; // Shift right arithmetic
            default: ALUResult = 32'b0;
        endcase
        Zero = (ALUResult == 32'b0);
    end

endmodule
