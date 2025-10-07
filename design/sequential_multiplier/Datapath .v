module Datapath (
    input clk, rst,
    input [3:0] A, B,
    input ld_a, ld_b, ld_q,
    input shift_en, add_en, reset_count,
    output q_lsb, count_done,
    output [7:0] Z
);

    reg [3:0] reg_A;
    reg [3:0] reg_Q;
    reg [3:0] reg_M;
    reg [2:0] count;
    wire [4:0] adder_sum;

    assign adder_sum = reg_A + reg_M;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_A <= 4'b0;
            reg_Q <= 4'b0;
            reg_M <= 4'b0;
            count <= 3'b0;
        end else begin
            if (ld_a) reg_A <= 4'b0;
            if (ld_b) reg_M <= B;
            if (ld_q) reg_Q <= A;

            if (add_en)
                reg_A <= adder_sum[3:0];

            if (shift_en) begin
                {reg_A, reg_Q} <= {adder_sum[4], reg_A, reg_Q} >> 1;
                count <= count + 1;
            end

            if (reset_count)
                count <= 3'b0;
        end
    end

    assign q_lsb = reg_Q[0];
    assign count_done = (count == 3'd4);
    assign Z = {reg_A, reg_Q};

endmodule
