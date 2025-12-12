module ff (input c,d, output q, qn);
        wire w1, w2, w3, w4;
    
    nand #1 (w2, w3, w1);
    nand #1 (w1, w2, c);
    nand #1 (w4, w1, c, w3);
    nand #1 (w3, w4, d);
    nand #1 (q, w1, qn);
    nand #1 (qn, q, w4);
endmodule
