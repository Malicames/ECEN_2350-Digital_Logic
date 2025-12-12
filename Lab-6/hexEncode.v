// ***This is the most important and reused module in this class***
// Also look at your constraints file if you encounter errors, specifically during BitStream generation
// Some constraint files have slightly different variable names, like "mclk" instead of "clk" or "D0_an" instead of "D0_AN"
`timescale 1ns / 1ps

module hexEncode(
    input [15:0] sw,
    output reg [3:0] D0_AN,
    output reg [7:0] D0_SEG,
    output [3:0] D1_AN,
    output [7:0] D1_SEG
    );

    wire [3:0] in;
    reg [7:0] out;

    assign in = sw[3:0];                // Use lower 4 bits as hex input
    assign D1_SEG = 8'b11111111;        // Turns off D1 display
    assign D1_AN  = 4'b1111;            // Turns off all digits of D1

    // You can also choose to do this in hex instead of binary but I personally find binary is easier to read 
    always @(*) begin
        case (in)
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
            4'b1010: out = 8'b10001000; // A
            4'b1011: out = 8'b10000011; // B
            4'b1100: out = 8'b11000110; // C
            4'b1101: out = 8'b10100001; // D
            4'b1110: out = 8'b10000110; // E
            4'b1111: out = 8'b10001110; // F
            default: out = 8'b01111010; // "Z" for "error" (Be sure to change this since the Boolean Board can't actually display "Z")
        endcase
    end

    always @(*) begin
        D0_SEG = out;                   // Outputs stuff to the display
        D0_AN = 4'b1110;                // Only use the rightmost display
    end

endmodule
