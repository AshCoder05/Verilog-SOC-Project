module seq_multi_4b_tb;

    reg clk, rst, start;
    reg [3:0] A, B;
    wire [7:0] Z;
    wire done;

    seq_multi_4b dut (.clk(clk), .rst(rst), .start(start), .A(A), .B(B), .Z(Z), .done(done));

    always #5 clk = ~clk;

    initial begin
        $display("Sequential Multiplier Testbench (Verilog)");
        clk = 0; rst = 1; start = 0; A = 0; B = 0;
        #10 rst = 0;

        // Test 1
        A = 4'd3; B = 4'd5; start = 1;
        #10 start = 0;
        wait(done);
        $display("3 x 5 = %d", Z);

        // Test 2
        A = 4'd7; B = 4'd9; start = 1;
        #10 start = 0;
        wait(done);
        $display("7 x 9 = %d", Z);

        #20 $finish;
    end

endmodule
