module negate(input [3:0] in, output [3:0] out);
    
    assign out = ~in + 4'b0001;
    
endmodule

