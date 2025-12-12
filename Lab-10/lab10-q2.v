`timescale 1ns / 1ps

module kHzclock(
    
    input[15:0] sw,
    input[3:0] btn,
    output[15:0] led,
    input clk
);

    reg [31:0]count = 0;
    reg [15:0]ledcounter = 0;

    always @(posedge clk) begin
        count = count + 1;
        if (count == 10000) begin
        ledcounter = ledcounter + 1;
        count = 0;
        end
    end

assign led[15:0] = ledcounter[15:0];
endmodule