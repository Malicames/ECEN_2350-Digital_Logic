`timescale 1ns / 1ps

module timer(input [3:0] bin, input period, output reg [7:0] hex);
    always @(*) begin
        if (period == 0) begin
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
                default: hex = 8'b01111010; // "Z" for error
            endcase
        end

        if (period == 1) begin
                case (bin)
                    4'b0000: hex = 8'b11000000;
                    4'b0001: hex = 8'b11111001;
                    4'b0010: hex = 8'b10100100;
                    4'b0011: hex = 8'b10110000;
                    4'b0100: hex = 8'b10011001;
                    4'b0101: hex = 8'b10010010;
                    4'b0110: hex = 8'b10000010;
                    4'b0111: hex = 8'b11111000;
                    4'b1000: hex = 8'b10000000;
                    4'b1001: hex = 8'b10011000;
                    4'b1010: hex = 8'b10001000;
                    4'b1011: hex = 8'b10000011;
                    4'b1100: hex = 8'b11000100;
                    4'b1101: hex = 8'b10100001;
                    4'b1110: hex = 8'b10000110;
                    4'b1111: hex = 8'b10001110;
                    default: hex = 8'b01111111;
                endcase
                if (period == 1'b1)
                hex[7] = 1'b0;    //Decimal place on (Active low)
            end
        end
endmodule

module text_display(
    input [15:0] sw,
    input [3:0] btn,
    output [15:0] led,
    output [3:0] D0_AN,
    output [3:0] D1_AN,
    output [7:0] D0_SEG,
    output [7:0] D1_SEG,
    input clk
);

    reg [15:0] inc = 4'b0000;
    reg [3:0] inc2 = 4'b0000;
    reg [3:0] inc3 = 4'b0000;
    reg [3:0] inc4 = 4'b0000;

    reg [31:0] count = 0;
    reg [31:0] count2 = 0;
    reg [31:0] count3 = 0;
    reg [31:0] count4 = 0;
    reg [31:0] count5 = 0;

    reg [15:0] ledcounter = 0;
    reg [3:0]  switches = 0;
    reg [3:0]  anodes   = 0;

    reg period = 1'b0;
    
    //Will pause or unpause the timer when pressed
    reg pauseToggle = 1'b1;
       always @(negedge btn[1]) begin 
            pauseToggle = ~pauseToggle;
        end

    always @(posedge clk) begin
        count  = count  + 1;
        if(pauseToggle == 1) begin
            count2 = count2 + 1;
            count3 = count3 + 1;
            count4 = count4 + 1;
            count5 = count5 + 1;
        end 
        
       //Will reset the timer
       if(btn[0] == 1) begin
            inc[15:0] = 0;
       end

        if (count2 == 100000) begin
            inc[15:12] = inc[15:12] + 4'b0001;
            if (inc[15:12] == 4'b1010) begin 
                inc[15:12] = 4'b0000; 
            end
            count2 = 0;
        end

        if (count3 == 1000000) begin
            inc[11:8] = inc[11:8] + 4'b0001;
            if (inc[11:8] == 4'b1010) begin 
                inc[11:8] = 4'b0000; 
            end
            count3 = 0;
        end

        if (count4 == 10000000) begin
            inc[7:4] = inc[7:4] + 4'b0001;
            if (inc[7:4] == 4'b1010) begin 
                inc[7:4] = 4'b0000; 
            end
            count4 = 0;
        end

        if (count5 == 100000000) begin
            inc[3:0] = inc[3:0] + 1;
            if (inc[3:0] == 4'b1010) begin 
                inc[3:0] = 4'b0000; 
            end
            count5 = 0;
        end

        //Doubled the speed of the display refreshing to prevent interference 
        if (count == 50000) begin
            ledcounter = ledcounter + 1;
            switches[3:0] = inc[15:12];
            anodes[3:0] = 4'b1110;
            period = 1'b0;
        end

        if (count == 100000) begin
            ledcounter = ledcounter + 1;
            switches[3:0] = inc[11:8];
            anodes[3:0] = 4'b1101;
            period = 1'b0;
        end

        if (count == 150000) begin
            ledcounter = ledcounter + 1;
            switches[3:0] = inc[7:4];
            anodes[3:0] = 4'b1011;
            period = 1'b0;
        end

        if (count == 200000) begin
            ledcounter = ledcounter + 1;
            switches[3:0] = inc[3:0];
            anodes[3:0] = 4'b0111;
            count = 0;
            period = 1'b1;
        end
    end

timer e1 (switches, period, D1_SEG);

    assign D1_AN = anodes;
    assign led = 16'b0; //Turns LEDs off

endmodule
