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
    // CASE 1: MAX CAPACITY (15 * 15)
    A_in = 15; B_in = 15; 
    start = 1; #10 start = 0; // Pulse Start
    wait(done);               // Wait for finish
    
    if (result == 225) 
        $display("[PASS] Max Value: 15 * 15 = %d", result);
    else 
        $display("[FAIL] Max Value: 15 * 15 = %d (Expected 225)", result);
    
    #20;

    // CASE 2: LAZY ZERO (15 * 0)
    A_in = 15; B_in = 0; 
    start = 1; #10 start = 0;
    wait(done);
    
    if (result == 0) 
        $display("[PASS] Zero Test: 15 * 0 = %d", result);
    else 
        $display("[FAIL] Zero Test: 15 * 0 = %d (Expected 0)", result);

    #20;

    // CASE 3: TOGGLE STRESS (10 * 5)
    A_in = 10; B_in = 5; 
    start = 1; #10 start = 0;
    wait(done);
    
    if (result == 50) 
        $display("[PASS] Toggle Test: 10 * 5 = %d", result);
    else 
        $display("[FAIL] Toggle Test: 10 * 5 = %d (Expected 50)", result);

    #20;

    // CASE 4: RESET MID-FLIGHT (The Killer)
    $display("Testing Reset Mid-Flight...");
    
    A_in = 15; B_in = 2; 
    start = 1; 
    @(posedge clk); 
    start = 0;

    // Wait 3 clocks (Let the machine get busy)
    repeat(3) @(posedge clk);
    
    // User hits Reset!
    rst = 1;
    $display("!!! RESET ASSERTED !!!");
    #10;
    rst = 0;

    // Check if it died instantly
    #10;
    if (done == 0 && result == 0) 
        $display("[PASS] Design reset successfully mid-calculation.");
    else 
        $display("[FAIL] Design kept running! (Done=%b Result=%d)", done, result);
    
    
    // CASE 5: BACK-TO-BACK (Speed Test)
    $display("Testing Back-to-Back Execution...");
    A_in = 2; B_in = 2; @(posedge clk) start = 1; @(posedge clk) start = 0;
    wait(done); // First finish
    
    @(posedge clk); 
    @(posedge clk); 
    
    // IMMEDIATELY start the next one (No delay)
    A_in = 3; B_in = 3; @(posedge clk) start = 1; @(posedge clk) start = 0;
    wait(done); // Second finish
    
    if (result == 9) $display("[PASS] Back-to-Back worked.");
    else $display("[FAIL] Failed to restart immediately!");
    
    
	#10
    
    // CASE 6: STUCK START (The User Error)
    $display("Testing Stuck Start Button...");
    A_in = 2; B_in = 4; 
    start = 1; // HOLD IT HIGH!
    
    // Wait for done
    wait(done);
    if (result == 8) $display("[PASS] Calculation finished despite stuck button.");
    else $display("Calculation not finished");
    
    // Wait more... does it restart automatically? (It shouldn't!)
    #50; 
    if (done == 1) $display("[PASS] Correctly waiting for start release.");
    else $display("[FAIL] It restarted or glitched!");
    $finish;
  end

endmodule
