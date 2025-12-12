`timescale 1ns / 1ps

module hexEncode(
    input [3:0] bin,
    output reg [7:0] hex
);
    always @(*) begin
        case (bin)
            4'b0000: hex = 8'b11000000; // 0
            4'b0001: hex = 8'b11111001; // 1
            4'b0010: hex = 8'b10100100; // 2
            4'b0011: hex = 8'b10110000; // 3
            4'b0100: hex = 8'b10011001; // 4
            4'b0101: hex = 8'b10010010; // 5
            4'b0110: hex = 8'b10000010; // 6
            4'b0111: hex = 8'b11111000; // 7
            4'b1000: hex = 8'b10000000; // 8
            4'b1001: hex = 8'b10011000; // 9
            4'b1010: hex = 8'b10001000; // A
            4'b1011: hex = 8'b10000011; // B
            4'b1100: hex = 8'b11000110; // C
            4'b1101: hex = 8'b10100001; // D
            4'b1110: hex = 8'b10000110; // E
            4'b1111: hex = 8'b10001110; // F
            default: hex = 8'b01111010; // Z
        endcase
    end
endmodule


module text_display(
    input [15:0] sw,
    input [3:0] btn,
    output [15:0] led,
    output [3:0] D0_AN,
    output [7:0] D0_SEG,
    input clk
);
    reg [31:0] count = 0;
    reg [3:0] switches;
    reg [3:0] anodes;

    always @(posedge clk) begin
        count <= count + 1;
        if (count == 100000) begin
            switches <= sw[3:0];
            anodes <= 4'b1110;
        end else if (count == 200000) begin
            switches <= sw[7:4];
            anodes <= 4'b1101;
        end else if (count == 300000) begin
            switches <= sw[11:8];
            anodes <= 4'b1011;
        end else if (count == 400000) begin
            switches <= sw[15:12];
            anodes <= 4'b0111;
            count <= 0;
        end
    end

    hexEncode e1 (
        .bin(switches),
        .hex(D0_SEG)
    );

    assign D0_AN = anodes;

endmodule
