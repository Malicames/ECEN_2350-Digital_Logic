//Look at your constraints file if you encounter errors, specifically during BitStream generation
//Some constraint files have slightly different variable names, like "mclk" instead of "clk" or "D0_an" instead of "D0_AN"
`timescale 1ns / 1ps

module numbers(
    input  [15:0] sw,
    output reg [3:0] D1_AN,
    output reg [7:0] D1_SEG,
    output reg [3:0] D0_AN,
    output reg [7:0] D0_SEG
);

    // Only uses last 4 bits on the boolean board
    wire [3:0] in  = sw[3:0];
    wire sign = in[3];       // MSB is the sign bit
    wire [3:0] abs_in;       // Absolute value
    reg  [7:0] out;          // 7-segment value for number

    // If negative, take two's complement
    assign abs_in = sign ? (~in + 4'b0001) : in;

    always @(*) begin
        case (abs_in)
            4'b0000: out = 8'b11000000; // 0
            4'b0001: out = 8'b11111001; // 1
            4'b0010: out = 8'b10100100; // 2
            4'b0011: out = 8'b10110000; // 3
            4'b0100: out = 8'b10011001; // 4
            4'b0101: out = 8'b10010010; // 5
            4'b0110: out = 8'b10000010; // 6
            4'b0111: out = 8'b11111000; // 7
            4'b1000: out = 8'b10000000; // 8
            4'b1001: out = 8'b10011000; // 9
            default: out = 8'b01111010; // Z (error)
        endcase
    end

    always @(*) begin
        // Rightmost display: show the number
        D1_SEG = out;
        D1_AN  = 4'b1110;

        // If negative show dash, else turn off left display
        if (sign) begin
            D0_SEG = 8'b10111111; // Dash
            D0_AN  = 4'b1110;
        end else begin
            D0_SEG = 8'b11111111; // Off
            D0_AN  = 4'b1110;
        end
    end

endmodule

