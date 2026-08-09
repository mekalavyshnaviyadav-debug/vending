`timescale 1ns/1ps

module vending_machine_tb;

    reg clk;
    reg rst;
    reg coin5;
    reg coin10;

    wire dispense;
    wire change5;

    vending_machine dut (
        .clk(clk),
        .rst(rst),
        .coin5(coin5),
        .coin10(coin10),
        .dispense(dispense),
        .change5(change5)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        rst   = 1;
        coin5 = 0;
        coin10 = 0;

        // Reset
        #10;
        rst = 0;

        // Test 1: Insert 5 + 5
        @(negedge clk);
        coin5 = 1;

        @(negedge clk);
        coin5 = 0;

        @(negedge clk);
        coin5 = 1;

        @(negedge clk);
        coin5 = 0;

        // Test 2: Insert 10
        @(negedge clk);
        coin10 = 1;

        @(negedge clk);
        coin10 = 0;

        // Test 3: Insert 5 + 10
        @(negedge clk);
        coin5 = 1;

        @(negedge clk);
        coin5 = 0;

        @(negedge clk);
        coin10 = 1;

        @(negedge clk);
        coin10 = 0;

        #20;
        $finish;
    end

    always @(posedge clk) begin
        #1;
        $display(
            "Time=%0t | Coin5=%b | Coin10=%b | Dispense=%b | Change5=%b | State=%0d",
            $time,
            coin5,
            coin10,
            dispense,
            change5,
            dut.state
        );
    end

endmodule