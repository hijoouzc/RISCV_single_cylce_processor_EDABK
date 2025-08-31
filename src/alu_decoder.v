module alu_decoder(
    input wire       opb5, 
    input wire [2:0] funct3,
    input wire       funct7b5, 
    input wire [1:0] ALUOp,
    output reg [2:0] ALUControl
);
    wire RtypeSub;
    assign RtypeSub = funct7b5 & opb5; // TRUE for R–type subtract

    always @(funct3 or ALUOp or RtypeSub) begin
        case(ALUOp)
            2'b00: ALUControl = 3'b000; // addition
            2'b01: ALUControl = 3'b001; // subtraction
            default: begin
                case(funct3) // R-type hoặc I-type ALU
                    3'b000: begin
                        if (RtypeSub)
                            ALUControl = 3'b001; // sub
                        else
                            ALUControl = 3'b000; // add, addi
                    end
                    3'b111: ALUControl = 3'b010; // and, andi
                    3'b110: ALUControl = 3'b011; // or, ori
                    3'b010: ALUControl = 3'b100; // slt, slti
                    3'b001: ALUControl = 3'b101; // sll
                    3'b101: begin
                        if (funct7b5)
                            ALUControl = 3'b111; // sra
                        else
                            ALUControl = 3'b110; // srl
                    end
                    default: ALUControl = 3'b000;
                endcase
            end
        endcase
    end
endmodule
