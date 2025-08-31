module register_file(
    input wire         clk,
    input wire         we3, 
    input wire  [4:0]  a1, a2, a3,
    input wire  [31:0] wd3,
    output wire [31:0] rd1, rd2
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