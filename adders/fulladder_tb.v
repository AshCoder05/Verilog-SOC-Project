// Testbench for Full Adder
`timescale 1ns/1ps

module fulladder_tb;
  reg a, b, cin;
  wire sum, cout;

  // DUT instantiation (make sure you have a module "fa" in design.sv)
  fulladder uut (a, b, cin, sum, cout);

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, fa_test);   // dump only this module’s signals

    $display("A B Cin| Sum Cout");
    $display("-----------------");

    a=0; b=0; cin=0; #10; $display("%b %b  %b |  %b   %b", a,b,cin,sum,cout);
    a=0; b=0; cin=1; #10; $display("%b %b  %b |  %b   %b", a,b,cin,sum,cout);
    a=0; b=1; cin=0; #10; $display("%b %b  %b |  %b   %b", a,b,cin,sum,cout);
    a=0; b=1; cin=1; #10; $display("%b %b  %b |  %b   %b", a,b,cin,sum,cout);
    a=1; b=0; cin=0; #10; $display("%b %b  %b |  %b   %b", a,b,cin,sum,cout);
    a=1; b=0; cin=1; #10; $display("%b %b  %b |  %b   %b", a,b,cin,sum,cout);
    a=1; b=1; cin=0; #10; $display("%b %b  %b |  %b   %b", a,b,cin,sum,cout);
    a=1; b=1; cin=1; #10; $display("%b %b  %b |  %b   %b", a,b,cin,sum,cout);

    #10;
    $finish;   
  end
endmodule
