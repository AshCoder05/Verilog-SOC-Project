// Code your testbench here
// or browse Examples
module testbench;

  reg clk, rst, ld_regs, add_en, shift_en;
  reg [3:0] multiplier_in, multiplicand_in;
  wire q0;
  wire [7:0] product_out;

  // Connect your Datapath
  datapath dut (
    .clk(clk),
    .rst(rst),
    .ld_regs(ld_regs),
    .add_en(add_en),
    .shift_en(shift_en),
    .multiplier_in(multiplier_in),
    .multiplicand_in(multiplicand_in),
    .q0(q0),
    .product_out(product_out)
  );

  // Create a Clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end

  // Test Sequence
  initial begin
    // --- THIS IS THE CRITICAL FIX ---
    $dumpfile("dump.vcd");       // Create the file
    $dumpvars(0, testbench);     // Dump ALL variables inside 'testbench' module
    // --------------------------------

    // 1. Initialize
    rst = 1; ld_regs = 0; add_en = 0; shift_en = 0;
    multiplier_in = 4'b1011;   
    multiplicand_in = 4'b0101; 
    #15; // Wait a bit

    // 2. Release Reset
    rst = 0;
    #15;

    // 3. Load Registers
    ld_regs = 1;
    #10;
    ld_regs = 0; 
    
    // 4. Do an ADD
    add_en = 1;
    #10;
    add_en = 0;

    // 5. Do a SHIFT
    shift_en = 1;
    #10;
    shift_en = 0;

    #50; // Wait for waves to settle
    $finish;
  end
endmodule
