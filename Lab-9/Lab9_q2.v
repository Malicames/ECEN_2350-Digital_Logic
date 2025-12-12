module testbench;
    reg C, D;
    wire Q, Qn;
        ff dut(.c(C), .d(D), .q(Q), .qn(Qn));
        always #10 C = ~C;
        initial begin
    $dumpfile ("dump.vcd");
    $dumpvars(1);
        $monitor("%6d: C=%b, D=%b, Q=%b, Qn=%b", $time, C, D, Q,Qn);
            C = 0;
            D = 0;
            #20 D = 1;
            #4 D = 0;
            #2 D = 1;
            #9 D = 0;
            #25 $finish;
        end
endmodule

