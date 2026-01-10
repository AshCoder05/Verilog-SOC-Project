module datapath (
    input wire clk,
    input wire rst,
    input wire ld_regs,   
    input wire add_en,   
    input wire shift_en,  
    input wire [3:0] multiplier_in,   
    input wire [3:0] multiplicand_in, 
    output wire q0,       
    output wire [7:0] product_out
);

    reg [3:0] M;
    reg [3:0] Q;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
   
            A <= 0;
            M <= 0;
            Q <= 0;
        end 
        else if (ld_regs) begin
            M <= multiplicand_in;
            Q <= multiplier_in;
            A <= 0; 
        end 
        else begin
            if (add_en) begin
                A <= A + M;
            end
            if (shift_en) begin
     
                {A, Q} <= {A, Q} >> 1;
            end
        end
    end
    assign q0 = Q[0];        
    assign product_out = {A[3:0], Q}; 

endmodule
