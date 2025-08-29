module testbench();

    // Inputs to DUT
    reg clk;
    reg reset;

    // Outputs from DUT
    wire [31:0] WriteData;
    wire [31:0] DataAdr;
    wire        MemWrite;

    // Instantiate device to be tested
    top dut (
            .clk(clk),
            .reset(reset),
            .WriteData(WriteData),
            .DataAdr(DataAdr),
            .MemWrite(MemWrite)
    );

    // Initialize test
    initial begin
        reset <= 1;
        #22;
        reset <= 0;
    end

    // Generate clock to sequence tests
    always begin
        clk <= 1;
        #5;
        clk <= 0;
        #5;
    end

    // Check results
    always @(negedge clk) begin
        if (MemWrite) begin
            if (DataAdr == 100 && WriteData == 25) begin
                $display("Simulation succeeded");
                $stop;
            end else if (DataAdr != 96) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end

endmodule