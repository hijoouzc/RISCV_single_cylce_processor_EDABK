module imem(
    input  wire [31:0] a,

    output wire [31:0] rd
);
    reg [31:0] RAM[63:0];
    initial
        $readmemh("E:/Thiet ke so EDABK/RISC V/Single Cycle Processor/riscvtest.txt",RAM);
    assign rd = RAM[a[31:2]]; // word aligned
endmodule
	
