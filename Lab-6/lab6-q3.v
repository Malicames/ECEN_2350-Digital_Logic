`timescale 1ns / 1ps

module hexEncode(
    input [15:0] sw,    // Allow inputs for the switches
    input [3:0] btn,    // Allow inputs for the buttons
    output [3:0] D0_AN,
    output [7:0] D0_SEG,
    output reg [3:0] D1_AN,
    output reg [7:0] D1_SEG
    );

    wire [3:0] in;
    reg [7:0] out;

    // Disables left display
    assign D0_SEG = 8'b11111111;
    assign D0_AN = 4'b1111;

    // If a button is pressed output this nibble
    assign in = (btn[3]) ? sw[15:12] :
                (btn[2]) ? sw[11:8]  :
                (btn[1]) ? sw[7:4]   :
                           sw[3:0];   // Default configuration

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
            default: out = 8'b01111010; // Display "Z" for error
        endcase
    end

    // Outputs stuff to the display
    always @(*) begin
        D1_SEG = out;

        case (btn)
            4'b1000: D1_AN = 4'b0111; // BTN3
            4'b0100: D1_AN = 4'b1011; // BTN2
            4'b0010: D1_AN = 4'b1101; // BTN1
            4'b0001: D1_AN = 4'b1110; // BTN0
            default: D1_AN = 4'b1111; // Default output is off
        endcase
    end

endmodule
