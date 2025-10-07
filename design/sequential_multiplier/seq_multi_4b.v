module seq_multi_4b (
    input  clk,
    input  rst,
    input  start,
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] Z,
    output done
);

    // Control signals
    wire ld_a, ld_b, ld_q;
    wire shift_en, add_en, reset_count;
    // Status signals
    wire q_lsb, count_done;

    // Minimal ordered instantiation

    // Control Unit
    ControlUnit cu (clk, rst, start, q_lsb, count_done,
                    ld_a, ld_b, ld_q, shift_en, add_en, reset_count, done);

    // Datapath
    Datapath dp (clk, rst, A, B,
                 ld_a, ld_b, ld_q, shift_en, add_en, reset_count,
                 q_lsb, count_done, Z);

endmodule
