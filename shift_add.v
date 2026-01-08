// Code your design here
module datapath (
    // Standard inputs
    input wire clk,
    input wire rst,
    
    // Commands from the Controller (your teammate)
    input wire ld_regs,   // "Load the numbers now"
    input wire add_en,    // "Add M to A now"
    input wire shift_en,  // "Shift everything right now"
    
    // Data inputs
    input wire [3:0] multiplier_in,   // The number to multiply
    input wire [3:0] multiplicand_in, // The number to be multiplied
    
    // Status signals to the Controller
    output wire q0,       // The decision bit (Are we adding or not?)
    
    // Final Result Output
    output wire [7:0] product_out // The final answer (2x width of inputs)
);

    // INTERNAL REGISTERS
    // A = Accumulator (stores the running total)
    // M = Multiplicand (stores one of the input numbers)
    // Q = Multiplier (stores the other input number and shifts)
    reg [4:0] A; // 5 bits to handle carry overflow
    reg [3:0] M;
    reg [3:0] Q;

    // LOGIC
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset everything to 0
            A <= 0;
            M <= 0;
            Q <= 0;
        end 
        else if (ld_regs) begin
            // Load the initial values
            M <= multiplicand_in;
            Q <= multiplier_in;
            A <= 0; // Clear accumulator at start
        end 
        else begin
            // OPERATION 1: ADD
            if (add_en) begin
                A <= A + M;
            end
            
            // OPERATION 2: SHIFT
            // We shift A and Q together as one big unit
            if (shift_en) begin
                // Concatenation operator {} joins A and Q
                // >> 1 shifts the whole thing right by 1 bit
                {A, Q} <= {A, Q} >> 1;
            end
        end
    end

    // CONNECT OUTPUTS
    assign q0 = Q[0];           // Send the LSB of Q to the controller
    assign product_out = {A[3:0], Q}; // The result is A combined with Q

endmodule
