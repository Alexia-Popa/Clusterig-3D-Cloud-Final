`timescale 1ns/1ps

module fcc_top #(
    parameter W       = 16,
    parameter LABEL_W = 16,
    parameter ROWS    = 30,
    parameter COLS    = 30,
    parameter ROW_W   = 8,
    parameter COL_W   = 5
)(
    input  wire clk,
    input  wire rst,

    input  wire in_valid,
    output wire in_ready,
    input  wire [ROW_W-1:0] in_row,
    input  wire [COL_W-1:0] in_col,
    input  wire signed [W-1:0] in_x,
    input  wire signed [W-1:0] in_y,
    input  wire signed [W-1:0] in_z,
    input  wire in_is_ground,

    output reg  out_valid,
    output reg  [ROW_W-1:0] out_row,
    output reg  [COL_W-1:0] out_col,
    output reg  [LABEL_W-1:0] out_label_root,
    output wire out_ready
);

    assign out_ready = 1'b1;

    reg done;
    assign in_ready = !done;

    reg dumping;
    reg [ROW_W-1:0] dump_row;
    reg [COL_W-1:0] dump_col;

    wire [LABEL_W-1:0] dump_label;
    wire dump_is_ground;

    fcc_point_memory #(
        .ROWS(ROWS),
        .COLS(COLS),
        .ROW_W(ROW_W),
        .COL_W(COL_W),
        .LABEL_W(LABEL_W)
    ) mem (
        .clk(clk),
        .we(in_valid && !in_is_ground),
        .wr_row(in_row),
        .wr_col(in_col),
        .wr_label({8'd0, in_row}),
        .wr_is_ground(in_is_ground),

        .rd_row(dump_row),
        .rd_col(dump_col),
        .rd_label(dump_label),
        .rd_is_ground(dump_is_ground)
    );

    always @(posedge clk) begin
        if (rst) begin
            done <= 0;
            dumping <= 0;
            dump_row <= 0;
            dump_col <= 0;
        end else begin
            if (in_valid && in_row == ROWS-1 && in_col == COLS-1)
                done <= 1;

            if (done && !dumping) begin
                dumping <= 1;
                dump_row <= 0;
                dump_col <= 0;
            end else if (dumping) begin
                if (dump_col == COLS-1) begin
                    dump_col <= 0;
                    dump_row <= dump_row + 1;
                end else begin
                    dump_col <= dump_col + 1;
                end

                if (dump_row == ROWS-1 && dump_col == COLS-1)
                    dumping <= 0;
            end
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            out_valid <= 0;
            out_row <= 0;
            out_col <= 0;
            out_label_root <= 0;
        end else if (dumping && !dump_is_ground) begin
            out_valid <= 1;
            out_row <= dump_row;
            out_col <= dump_col;
            out_label_root <= dump_label;
        end else begin
            out_valid <= 0;
        end
    end

endmodule
