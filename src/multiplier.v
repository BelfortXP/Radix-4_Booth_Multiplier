module multiplier(A, B, M, clk, rst_n);
      parameter width = 16;
      input                     clk, rst_n;
      input  wire [width-1:0]   A, B;
      output wire [2*width-1:0] M;

      wire [17:0] pp1, pp2, pp3, pp4, pp5, pp6, pp7, pp8, pp9;
      wire [31:0] final_p;

      booth_16x16 U_BOOTH_16X16(
            .i_multa (A  ),
            .i_multb (B  ),
            .o_pp1   (pp1),
            .o_pp2   (pp2),
            .o_pp3   (pp3),
            .o_pp4   (pp4),
            .o_pp5   (pp5),
            .o_pp6   (pp6),
            .o_pp7   (pp7),
            .o_pp8   (pp8),
            .o_pp9   (pp9) 
            );

      wtree_16x16 U_WTREE_16X16(
            .pp1     (pp1  ),
            .pp2     (pp2  ),
            .pp3     (pp3  ),
            .pp4     (pp4  ),
            .pp5     (pp5  ),
            .pp6     (pp6  ),
            .pp7     (pp7  ),
            .pp8     (pp8  ),
            .pp9     (pp9  ),
            .final_p (M    )
            );

      assign M = rst_n? final_p : 32'b0;

endmodule
