module rand_gen (
    input             clk,
    output reg [31:0] rnd = ~0
);

  // The shifting feedback bit.
  wire feedback = rnd[31] ^ rnd[21] ^ rnd[1] ^ rnd[0];

  // On startup rnd may be zero which will cause it 
  // to stay forever in a zero loop.
  wire zero_loop = (rnd == 0);

  always @(posedge clk) begin
    if (zero_loop) begin
      rnd <= ~rnd;
    end else begin
      rnd <= {rnd[30:0], feedback};
    end
  end

endmodule
