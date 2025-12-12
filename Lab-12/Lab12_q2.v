`timescale 1ns / 1ps

module sync4(input clk, input [3:0] in, output reg [3:0] out);
    reg [3:0] unsafe;
    always @(posedge clk) begin
        unsafe <= in;
        out <= unsafe; //"out" should be safe
    end
endmodule

module btnToggle(input clk, input [3:0] in, output reg [3:0] btn_Change); 
    reg [3:0] btn_old;
    always @(posedge clk) begin 
        btn_old <= in;
        btn_Change <= in & ~btn_old;
    end
endmodule

module shift_register (
    input [15:0] SW,
    input [3:0] btn,
    output reg [2:0] RGB0,
    output reg [2:0] RGB1,
    input clk
);

    reg [2:0] state = 0;
    wire [3:0] btn_safe;
    sync4 s4 (clk, btn, btn_safe);
    wire [3:0] btn_Change;
    btnToggle bT (clk, btn_safe, btn_Change);
    reg unlocked = 0;

    always @(posedge clk) begin
        if (unlocked == 0) RGB1 <= 3'b001;
        if (unlocked == 1) RGB1 <= 3'b010;

        if (btn_Change) begin
            case (state)
                0: if (btn_Change[2]) begin
                        unlocked <= 0;
                        state <= 1;
                        RGB0 <= 3'b100;
                   end else begin 
                        unlocked <= 0;
                        state <= 1;
                        RGB0 <= 3'b001;
                   end

                1: if (btn_Change[3])
                        state <= 2; 
                   else begin
                        state <= 0;
                        RGB0 <= 3'b001;
                   end

                2: if (btn_Change[2])
                        state <= 3; 
                   else begin
                        state <= 0;
                        RGB0 <= 3'b001;
                   end


                3: if (btn_Change[0])
                        state <= 4; 
                   else begin
                        state <= 0;
                        RGB0 <= 3'b001;
                   end


                4: if (btn_Change[1])
                        state <= 5; 
                   else begin
                        state <= 0;
                        RGB0 <= 3'b001;
                   end

                5: if (btn_Change[0]) begin
                        unlocked <= 1;
                        RGB0 <= 3'b010;
                   end else begin 
                        state <= 0;
                        RGB0 <= 3'b001;
                   end

                default: RGB0 <= 3'b001;
            endcase
        end
    end
endmodule
