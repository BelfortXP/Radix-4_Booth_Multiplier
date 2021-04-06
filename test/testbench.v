module testbench;
      parameter width = 16;

      reg rst_n;
      reg clk;

      initial begin
            rst_n = 1'b0;
            clk  = 1'b0;
            #100;
            rst_n = 1'b1;
      end 

      always #1 clk = ~clk;

      reg  [width-1:0]   A;
      reg  [width-1:0]   B;
      wire [2*width-1:0] product;

      always @(posedge clk or rst_n) begin
            if(~rst_n) begin
                  A <= {width{1'b0}};
                  B <= {width{1'b0}};
            end
            else begin
                  if(&A) begin
                        A <= {width{1'b0}};
                        B <= B + 1'b1;
                        if(&B) begin
                              $display("Check finish value: A-%b, B-%b", A, B);
                              #1 $finish;
                        end
                  end
                  else begin
                        A <= A + 1'b1;
                  end
            end
      end

      reg [2*width-1:0] temp_pro;

      always @(A or B) begin
            #1 temp_pro = $signed(A) * $signed(B);
            if(temp_pro!=product) begin
                  $display("Value Error when A=%d, B=%d, pro=%d, temp=%d", $signed(A), $signed(B), $signed(product), $signed(temp_pro));
            end

            // $display("A=%d, B=%d, pro=%d, temp=%d", $signed(A), $signed(B), $signed(product), $signed(temp_pro));  
      end

      multiplier U_MULTIPLIER(
            .A     (A      ),
            .B     (B      ),
            .M     (product),
            .rst_n (rst_n  ),
            .clk   (clk    )
            );

      initial begin
            $vcdpluson;
      end

endmodule
