`timescale 1ns/1ps

module fcc_top_tb;

  // ================= CLOCK & RESET =================
  reg clk = 0;
  reg rst = 1;
  always #5 clk = ~clk;

  // ================= PARAMETRI =================
  localparam W       = 16;
  localparam ROWS    = 64;
  localparam COLS    = 900;    // trebuie sa corespunda cu prepare_lidar.py
  localparam COL_W   = 10;     // log2(900) ~ 10
  localparam LABEL_W = 16;

  // ================= DUT INPUTS =================
  reg  in_valid;
  wire in_ready;
  reg  [7:0]          in_row;
  reg  [COL_W-1:0]    in_col;
  reg  signed [W-1:0] in_x, in_y, in_z;
  reg  in_is_ground;

  // ================= DUT OUTPUTS =================
  wire out_valid;
  wire out_ready;
  wire [7:0]         out_row;
  wire [COL_W-1:0]   out_col;
  wire [LABEL_W-1:0] out_label_root;

  // ================= FILES =================
  integer fd_in;
  integer fd_out;
  integer out_cnt;

  // ================= RANGE IMAGE =================
  reg signed [W-1:0] img_x [0:ROWS-1][0:COLS-1];
  reg signed [W-1:0] img_y [0:ROWS-1][0:COLS-1];
  reg signed [W-1:0] img_z [0:ROWS-1][0:COLS-1];

  integer r, c;
  integer tr, tc;
  integer ret;
  reg signed [W-1:0] tx, ty, tz;

  integer sent;

  // ================= DUT =================
  fcc_top #(
    .W(W),
    .LABEL_W(LABEL_W),
    .COLS(COLS),
    .COL_W(COL_W),
    .UF_MAX_LABELS(4096),

    // praguri (poti regla dupa nevoie)
    .EPS_H2(40'd250000), // ~0.5m daca unitatile sunt "mm"
    .EPS_V2(40'd90000)   // ~0.3m
  ) dut (
    .clk(clk),
    .rst(rst),

    .in_valid(in_valid),
    .in_ready(in_ready),
    .in_row(in_row),
    .in_col(in_col),
    .in_x(in_x),
    .in_y(in_y),
    .in_z(in_z),
    .in_is_ground(in_is_ground),

    .out_valid(out_valid),
    .out_ready(out_ready),
    .out_row(out_row),
    .out_col(out_col),
    .out_label_root(out_label_root)
  );

  // out_ready: tinem mereu gata sa primim
  assign out_ready = 1'b1;

  // ================= INITIAL =================
  initial begin
    in_valid = 0;
    out_cnt  = 0;
    sent     = 0;

    // init range image (0)
    for (r = 0; r < ROWS; r = r + 1)
      for (c = 0; c < COLS; c = c + 1) begin
        img_x[r][c] = 0;
        img_y[r][c] = 0;
        img_z[r][c] = 0;
      end

    // ===== load prepared lidar stream =====
    $display("[FCC] Loading lidar_stream_prepared.txt...");
    fd_in = $fopen("../data/lidar_stream_prepared.txt", "r");
    if (fd_in == 0) begin
      $display("[ERROR] Cannot open ../data/lidar_stream_prepared.txt");
      $finish;
    end

    // Format asteptat: row col x y z
    while (!$feof(fd_in)) begin
      ret = $fscanf(fd_in, "%d %d %d %d %d",
                    tr, tc, tx, ty, tz);
      if (ret == 5 && tr < ROWS && tc < COLS) begin
        img_x[tr][tc] = tx;
        img_y[tr][tc] = ty;
        img_z[tr][tc] = tz;
      end
    end
    $fclose(fd_in);

    // ===== output file =====
    fd_out = $fopen("fcc_clusters_out.txt", "w");
    if (fd_out == 0) begin
      $display("[ERROR] Cannot open fcc_clusters_out.txt for writing!");
      $finish;
    end

    // reset
    #30 rst = 0;

    // ===== send ONLY max 300 non-zero points =====
    for (r = 0; r < 5; r = r + 1) begin
      for (c = 0; c < 60; c = c + 1) begin
        if (sent < 300) begin
          if (img_x[r][c] != 0 || img_y[r][c] != 0 || img_z[r][c] != 0) begin
            @(posedge clk);
            in_valid <= 1'b1;
            in_row   <= r[7:0];
            in_col   <= c[COL_W-1:0];
            in_x     <= img_x[r][c];
            in_y     <= img_y[r][c];
            in_z     <= img_z[r][c];
            in_is_ground <= 1'b0;
            sent = sent + 1;
          end
        end
      end
    end

    @(posedge clk);
    in_valid <= 0;

    $display("[FCC] Sent points: %0d", sent);

    // asteptam sa scoata rezultate
    repeat (60000) @(posedge clk);

    $display("[FCC] DONE");
    $display("[FCC] Points written: %0d", out_cnt);
    $fclose(fd_out);
    $finish;
  end

  // ================= OUTPUT =================
  always @(posedge clk) begin
    if (out_valid) begin
      // scriem doar puncte reale (nu 0,0,0)
      if (img_x[out_row][out_col] != 0 ||
          img_y[out_row][out_col] != 0 ||
          img_z[out_row][out_col] != 0) begin

        out_cnt = out_cnt + 1;
        $fwrite(fd_out, "%0d %0d %0d %0d\n",
          img_x[out_row][out_col],
          img_y[out_row][out_col],
          img_z[out_row][out_col],
          out_label_root
        );
      end
    end
  end

endmodule
