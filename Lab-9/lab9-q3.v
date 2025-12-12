`timescale 1ns / 1ps

module shift_register(
    input[15:0] sw,
    input[3:0] btn,
    output reg [15:0] led
);

    always @(posedge btn[0]) begin
        led[14:0] = led[15:1];
        led[15] = sw[15];
    end

endmodule