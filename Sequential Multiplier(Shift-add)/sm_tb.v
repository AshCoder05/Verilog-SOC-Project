module tb_top;

  reg clk, rst, start;
  reg [3:0] A_in, B_in;
  wire [7:0] result;
  wire done;

  sequential_multiplier_top uut (
    .clk(clk), .rst(rst), .start(start),
    .A_in(A_in), .B_in(B_in),
    .result(result), .done(done)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

  initial begin
    // --- RESET ---
    rst = 1; start = 0; A_in = 0; B_in = 0;
    #20 rst = 0;
    #20;

    // --- TEST 1: 3 x 2 ---
    $display("Testing 3 * 2...");
    A_in = 3; B_in = 2;   // Set numbers
    start = 1;            // Trigger start
    #10 start = 0;        // Turn off start
    wait(done);           // Wait for machine to finish
    $display("Result: %d (Expected 6)", result);
    
    #20;

    //TEST 2: 5 x 5
    $display("Testing 5 * 5...");
    A_in = 5; B_in = 5;   // New numbers
    start = 1;            // Trigger start again
    #10 start = 0;
    wait(done);           // Wait again
    $display("Result: %d (Expected 25)", result);

    #20;

    // TEST 3: 15 x 0 
    $display("Testing 15 * 0...");
    A_in = 15; B_in = 0;  // New numbers
    start = 1;
    #10 start = 0;
    wait(done);
    $display("Result: %d (Expected 0)", result);

    #20;
    $display("DONE.");
    $finish;
  end

endmodule
