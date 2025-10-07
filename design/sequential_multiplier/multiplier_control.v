module ControlUnit (
    input clk, rst,
    input start,
    input q_lsb,
    input count_done,
    output reg ld_a, ld_b, ld_q,
    output reg shift_en, add_en, reset_count,
    output reg done
);

    reg [1:0] current_state, next_state;

    parameter S_IDLE  = 2'd0;
    parameter S_LOAD  = 2'd1;
    parameter S_SHIFT = 2'd2;
    parameter S_DONE  = 2'd3;

    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= S_IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            S_IDLE:  if (start) next_state = S_LOAD;
            S_LOAD:  next_state = S_SHIFT;
            S_SHIFT: if (count_done) next_state = S_DONE;
            S_DONE:  if (!start) next_state = S_IDLE;
        endcase
    end

    always @(*) begin
        ld_a = 0; ld_b = 0; ld_q = 0;
        shift_en = 0; add_en = 0; reset_count = 0; done = 0;

        case (current_state)
            S_LOAD: begin
                ld_a = 1; ld_b = 1; ld_q = 1; reset_count = 1;
            end
            S_SHIFT: begin
                if (q_lsb) add_en = 1;
                shift_en = 1;
            end
            S_DONE: done = 1;
        endcase
    end

endmodule
