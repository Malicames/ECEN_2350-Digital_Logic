`timescale 1ns / 1ps

module hertzclock(
    input[15:0] sw,
    input[3:0] btn,
    output[15:0] led,
    input clk
);

    reg [31:0]count = 0;
    reg ledout = 1;

    always @(posedge clk) begin
        count = count + 1;
        if (count == 50000000) begin
        ledout <= ~ledout;
        count = 0;
        end
    end
    
assign led[0] = ledout;
endmodule
