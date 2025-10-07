module array_multiplier_tb;
  reg [3:0] A, B;
  wire [7:0] P;
  
  array_multiplier am(A, B, P);
  
  initial begin
    $monitor("Time=%0d: A=%0d (%b), B=%0d (%b) --> P=%0d (%b)", 
             $time, A, A, B, B, P, P);
    
    // Initial condition
    A = 0; B = 0; #3; 
    
    // Test cases
    A = 1; B = 0; #3;   // Expected: 0
    A = 7; B = 5; #3;   // Expected: 35 (00100011)
    A = 8; B = 9; #3;   // Expected: 72 (01001000)
    A = 15; B = 15; #3; // Expected: 225 (11100001)
    
    // Simple Self-Check
    if (P == (15 * 15))
      $display("Self-Check Passed: 15 * 15 = %0d", P);
    else
      $display("Self-Check FAILED: Expected 225, Got %0d", P);
    
    $finish;
  end
endmodule
