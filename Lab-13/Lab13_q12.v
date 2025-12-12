`timescale 1ns / 1ps


// 7-Segment display
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



// 1-bit input sychronizer
module sync(
    input clk,
    input in,
    output reg out
);
    reg data;
    always @(negedge clk) data <= in;
    always @(posedge clk) out <= data;
endmodule

//4-gigit hex display multiplexer
module display4hex(
    input [15:0] in,
    input clk,
    output reg [3:0] digit_ena,
    output [7:0] seg
);

    reg [3:0] hexinput = 0;
    reg [1:0] digit = 0;

    reg [16:0] divcounter = 0;  // Enough bits for 100k cycles

    hexEncode encoder(hexinput, seg);

    always @(posedge clk) begin
        divcounter <= divcounter + 1;

        if (divcounter >= 100_000) begin
            divcounter <= 0;
            digit <= digit + 1;

            case (digit)
                2'd0: begin hexinput <= in[3:0];    digit_ena <= 4'b1110; end
                2'd1: begin hexinput <= in[7:4];    digit_ena <= 4'b1101; end
                2'd2: begin hexinput <= in[11:8];   digit_ena <= 4'b1011; end
                2'd3: begin hexinput <= in[15:12];  digit_ena <= 4'b0111; end
            endcase
        end
    end
endmodule


// Quadrature encoder(gray-code)
module QuadEncoder(
    input clk, a, b, reset,
    output [15:0] c
    );
    
    reg [1:0] state = 0;
    reg [15:0] count = 0;
    
    // reg [15:0] fullcount = 0;
    assign c = count;
    reg last_a, last_b;
    
    always @ (posedge clk) begin
        if (reset) count = 0;

        // States
        if (state[1] != b || state[0] != a) begin
            case (state)
                0: begin
                    if (a & ~b) begin
                        count = count + 1;
                        state = 2;
                    end
                    if (~a & b) begin
                        count = count - 1;
                        state = 1;
                    end
                end
                
                1: begin
                    if (~a & ~b) begin
                        count = count + 1;
                        state = 0;
                    end
                    if (a & b) begin
                        count = count - 1;
                        state = 3;
                    end
                end
                
                2: begin
                    if (~a & ~b) begin
                        count = count - 1;
                        state = 0;
                    end
                    if (a & b) begin
                        count = count + 1;
                        state = 3;
                    end
                end
                
                3: begin
                    if (a & ~b) begin
                        count = count - 1;
                        state = 2;
                    end
                    if (~a & b) begin
                        count = count + 1;
                        state = 1;
                    end
                end
            endcase
        end
    end                       
endmodule


// sw[0]  = a
// sw[15] = b
// btn[0] = Reset
module proto_QuadEncoder (
    input [15:0] sw, 
    input [3:0] btn,
    input clk,
    output [3:0] D0_AN,
    output [7:0] D0_SEG,
    output [15:0] led
);

    wire sw0, sw15;

    // Synchronize switch inputs
    sync syncA (.clk(clk), .in(sw[0]),  .out(sw0));
    sync syncB (.clk(clk), .in(sw[15]), .out(sw15));

    wire [15:0] count;

    // Quadrature decoder
    QuadEncoder QE(
        .clk(clk),
        .a(sw0),
        .b(sw15),
        .reset(btn[0]),
        .c(count)
    );

    // 7-segment display
    display4hex DISP(
        .in(count),
        .clk(clk),
        .digit_ena(D0_AN),
        .seg(D0_SEG)
    );

   assign led[0] = sw[0];
   assign led[15] = sw[15];

endmodule
