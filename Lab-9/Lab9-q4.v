`timescale 1ns / 1ps

module calculator(
    input[15:0] sw,
    input[3:0] btn,
    output [15:0] led
);

reg [15:0] A;
reg [15:0] B;

    always @(posedge btn[0]) begin  // Value for A
       A = sw[15:0];
    end
    
    always @(posedge btn[1]) begin  // Value for B
       B = sw[15:0];
    end
    
    assign led[15:0] = A + B;       // Value of A + B

endmodule
