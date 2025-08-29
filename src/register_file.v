module register_file(
    input clk,
    input we3, 
    input [4:0] a1, a2, a3,
    input [31:0] wd3,
    output [31:0] rd1, rd2
);
    reg [31:0] RAM[31:0];

    assign rd1 = (a1 != 0) ? RAM[a1] : 0;
    assign rd2 = (a2 != 0) ? RAM[a2] : 0;

    always @(posedge clk) begin
        if (we3) begin
            RAM[a3] <= wd3;
        end
    end
endmodule