module top(
    input  wire        clk, reset,
    output wire [31:0] WriteData, DataAdr,
    output wire        MemWrite
);

    wire [31:0] PC, Instr, ReadData;
    // instantiate processor and memories
    riscvsingle rvsingle(
        .clk(clk), 
        .reset(reset), 
        .ReadData(ReadData),
        .Instr(Instr), 
        .PC(PC), 
        .MemWrite(MemWrite),
        .ALUResult(DataAdr), 
        .WriteData(WriteData)
    );
    imem imem(
        .a(PC),
        .rd(Instr)
    );
    dmem dmem(
        .clk(clk),
        .we(MemWrite),
        .a(DataAdr),
        .wd(WriteData),
        .rd(ReadData)
    );
endmodule