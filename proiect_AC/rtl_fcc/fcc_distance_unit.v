`timescale 1ns/1ps

module fcc_distance_unit #(
  parameter W = 16
)(
  input  wire                clk,
  input  wire                rst,
  input  wire                in_valid,

  input  wire signed [W-1:0] ax,
  input  wire signed [W-1:0] ay,
  input  wire signed [W-1:0] az,

  input  wire signed [W-1:0] bx,
  input  wire signed [W-1:0] by,
  input  wire signed [W-1:0] bz,

  output reg                 out_valid,
  output reg  [39:0]         dist2
);

  // ================= STAGE 1 =================
  reg signed [16:0] dx1;
  reg signed [16:0] dy1;
  reg signed [16:0] dz1;

  // ================= STAGE 2 =================
  reg [33:0] dx2;
  reg [33:0] dy2;
  reg [33:0] dz2;

  always @(posedge clk) begin
    if (rst) begin
      dx1 <= 17'd0;
      dy1 <= 17'd0;
      dz1 <= 17'd0;

      dx2 <= 34'd0;
      dy2 <= 34'd0;
      dz2 <= 34'd0;

      dist2 <= 40'd0;
      out_valid <= 1'b0;
    end else begin
      // stage 1: diferențe
      dx1 <= ax - bx;
      dy1 <= ay - by;
      dz1 <= az - bz;

      // stage 2: pătrate
      dx2 <= dx1 * dx1;
      dy2 <= dy1 * dy1;
      dz2 <= dz1 * dz1;

      // stage 3: sumă
      dist2 <= dx2 + dy2 + dz2;
      out_valid <= in_valid;
    end
  end

endmodule
