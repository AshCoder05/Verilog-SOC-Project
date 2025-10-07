// Half Adder

module half_adder(input a, b, output s0, c0); 
  assign s0 = a ^ b;
  assign c0 = a & b;
endmodule

// Full Adder
module full_adder(input a, b, cin, output s0, c0);
  assign s0 = a ^ b ^ cin;
  assign c0 = (a & b) | (b & cin) | (a & cin);
endmodule


// 4x4 Array Multiplier
module array_multiplier(input [3:0] A, B, output [7:0] Z);

  // Partial Products: 4 rows × 4 columns
  // Each p[i] is a 4-bit vector (B dimension)
  wire [3:0] p [3:0]; 

  // Sum and Carry intermediate wires
  wire s02, c02;
  wire s03, c03;
  wire s12, c12;
  wire s13, c13;
  wire s22, c22;
  wire s23, c23;
  wire c01, c11, c21, c31, c32;

  // --- Partial Product Generation ---
  genvar g;
  generate
    for(g = 0; g < 4; g = g + 1) begin : GEN_PP
      assign p[g][0] = A[g] & B[0];
      assign p[g][1] = A[g] & B[1];
      assign p[g][2] = A[g] & B[2];
      assign p[g][3] = A[g] & B[3];
    end
  endgenerate

  // --- Column 0 ---
  assign Z[0] = p[0][0];

  // --- Column 1 ---
  half_adder h0(p[0][1], p[1][0], Z[1], c01);

  // --- Column 2 ---
  half_adder h1(p[1][1], p[2][0], s02, c02);
  half_adder h2(p[2][1], p[3][0], s03, c03);
  full_adder f0(p[0][2], c01, s02, Z[2], c11);
  full_adder f1(p[1][2], c02, s03, s12, c12);
  full_adder f2(p[2][2], c03, p[3][1], s13, c13);

  // --- Column 3 ---
  full_adder f3(p[0][3], c11, s12, Z[3], c21);
  full_adder f4(p[1][3], c12, s13, s22, c22);
  full_adder f5(p[2][3], c13, p[3][2], s23, c23);

  // --- Column 4, 5, 6, 7 ---
  half_adder h3(c21, s22, Z[4], c31);
  full_adder f6(c31, c22, s23, Z[5], c32);
  full_adder f7(c32, c23, p[3][3], Z[6], Z[7]);

endmodule
