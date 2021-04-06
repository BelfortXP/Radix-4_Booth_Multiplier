module booth_16x16(
      input  wire [15:0] i_multa,
      input  wire [15:0] i_multb,
      output wire [17:0] o_pp1  ,
      output wire [17:0] o_pp2  ,
      output wire [17:0] o_pp3  ,
      output wire [17:0] o_pp4  ,
      output wire [17:0] o_pp5  ,
      output wire [17:0] o_pp6  ,
      output wire [17:0] o_pp7  ,
      output wire [17:0] o_pp8  ,
      output wire [17:0] o_pp9 
      );

      // sign bit extend
      wire [1:0] sig_exta = {2{i_multa[15]}};
      wire [1:0] sig_extb = {2{i_multb[15]}};

      // 6 = 4'b0110, -6 = 4'b1010, ~(0110) + 1 = 1010, ~(1010) + 1 = 0110, complement code can be neg value
      // generat -x, -2x, 2x for Booth encoding
      wire [17:0] x     = {sig_exta, i_multa};
      wire [17:0] x_c   = ~x + 1;   // -x
      wire [17:0] xm2   = x << 1;   // 2*x
      wire [17:0] x_cm2 = x_c << 1; // -2*x

      //        18 17         [16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1]     0  
      //        |---|          |------------------------------------|      |
      // extended sign bits              orignal operator             appended bit for encoding
      wire [18:0] y     =  {sig_extb, i_multb, 1'b0};

      // calculating partial product based on Booth Radix-4 encoding
      wire [17:0] pp[8:0];
      generate
            genvar i;
            for(i=0; i<18; i=i+2)
            begin : GEN_PP
                  assign pp[i/2] = (y[i+2:i] == 3'b001 || y[i+2:i] == 3'b010) ? x     :
                                   (y[i+2:i] == 3'b101 || y[i+2:i] == 3'b110) ? x_c   :
                                   (y[i+2:i] == 3'b011                      ) ? xm2   :
                                   (y[i+2:i] == 3'b100                      ) ? x_cm2 : 18'b0;
            end
      endgenerate

      assign o_pp1   = pp[0];
      assign o_pp2   = pp[1];
      assign o_pp3   = pp[2];
      assign o_pp4   = pp[3];
      assign o_pp5   = pp[4];
      assign o_pp6   = pp[5];
      assign o_pp7   = pp[6];
      assign o_pp8   = pp[7];
      assign o_pp9   = pp[8];

endmodule