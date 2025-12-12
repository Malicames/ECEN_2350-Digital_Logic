
module testbench_priorityEncoder8;
    reg  [7:0] b;
    wire [2:0] o;
    wire       v;
    integer    i;

    priorityEncoder8 pe1 (b, o, v);

    initial begin
        //Prints new line each time values change
        $monitor("6%d in: %b out: %b valid: %b", $time, b, o, v);  

        b = 0;
        #1;

        //This is what causes logic to be sequential # +number of time units
        //Because you set b to zero right before, input is 0 so valid should be false
        if (v) $display("WRONG (valid with zero input)");
        
        for (i = 1; i <= 255; i = i + 1) begin
            b = i;
            #1;

            //$display("in: %b out: %b valid: %b", b, o, v); (removed cause of $monitor)
            if (!v) $display("WRONG (valid with zero input)");
            if ((b >> o) != 8'b00000001) 
                $display("input %b gave output %b, v=%b", b, o, v);
        end

        $finish;
    end
endmodule

// above: shift of b >> o shifts input by value of output, should always result in 00000001
// regardless of all other bits after the greatest bit (priority encoder returns largest valid input value)
