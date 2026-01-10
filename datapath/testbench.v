module testbench;

  reg clk, rst, ld_regs, add_en, shift_en;
  reg [3:0] multiplier_in, multiplicand_in;
  wire q0;
  wire [7:0] product_out;

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

  initial begin
    clk = 0;
    forever #5 clk = ~clk; 
  end

  initial begin
    $dumpfile("dump.vcd");       
    $dumpvars(0, testbench);     
    rst = 1; ld_regs = 0; add_en = 0; shift_en = 0;
    multiplier_in = 4'b1011;   
    multiplicand_in = 4'b0101; 
    #15;
    rst = 0;
    #15;
    ld_regs = 1;
    #10;
    ld_regs = 0; 
    add_en = 1;
    #10;
    add_en = 0;
    shift_en = 1;
    #10;
    shift_en = 0;
    #50;
    $finish;
  end
endmodule
