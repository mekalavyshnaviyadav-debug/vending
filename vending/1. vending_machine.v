module vending_machine (
    input  wire       clk,
    input  wire       rst,

    input  wire       coin5,   // 5-unit coin
    input  wire       coin10,  // 10-unit coin

    output reg        dispense,
    output reg        change5
);

    // States represent the amount inserted
    parameter S0  = 2'b00;  // 0
    parameter S5  = 2'b01;  // 5
    parameter S10 = 2'b10;  // 10

    reg [1:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state and output logic
    always @(*) begin

        next_state = state;
        dispense   = 1'b0;
        change5    = 1'b0;

        case (state)

            // No money inserted
            S0: begin
                if (coin10) begin
                    dispense = 1'b1;
                    next_state = S0;
                end
                else if (coin5) begin
                    next_state = S5;
                end
            end

            // 5 units inserted
            S5: begin
                if (coin5) begin
                    dispense = 1'b1;
                    next_state = S0;
                end
                else if (coin10) begin
                    dispense = 1'b1;
                    change5 = 1'b1;
                    next_state = S0;
                end
            end

            // 10 units inserted
            S10: begin
                dispense = 1'b1;
                next_state = S0;
            end

            default: begin
                next_state = S0;
            end

        endcase
    end

endmodule