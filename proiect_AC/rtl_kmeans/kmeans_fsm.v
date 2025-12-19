module kmeans_fsm_k7 #(
    parameter N    = 41,
    parameter ITER = 20
    
)(
    input clk,
    input rst,

    input [17:0] d0, d1, d2, d3, d4, d5, d6,
    input [7:0]  x, y, z,

    output reg [5:0] idx,

    output reg        we,
    output reg [5:0]  waddr,
    output reg [2:0]  wlabel,

    output reg [15:0] sumx0, sumx1, sumx2, sumx3, sumx4, sumx5, sumx6,
    output reg [15:0] sumy0, sumy1, sumy2, sumy3, sumy4, sumy5, sumy6,
    output reg [15:0] sumz0, sumz1, sumz2, sumz3, sumz4, sumz5, sumz6,
    output reg [5:0]  cnt0,  cnt1,  cnt2,  cnt3,  cnt4,  cnt5,  cnt6,

    output reg update_centroids,
    output reg done
);

    // ================= STATES =================
    localparam SET_ADDR = 2'd0;
    localparam LATCH    = 2'd1;
    localparam APPLY    = 2'd2;
    localparam UPDATE   = 2'd3;

    reg [1:0] state;
    reg [5:0] i;
    reg [5:0] iter;

    reg [7:0] x_r, y_r, z_r;
    reg [5:0] idx_r;
    reg [2:0] lbl_r;

    // ================= MIN DISTANCE (COMBINATIONAL) =================
    reg [2:0]  min_lbl;
    reg [17:0] min_d;

    always @(*) begin
        min_lbl = 3'd0;
        min_d   = d0;

        if (d1 < min_d) begin min_d = d1; min_lbl = 3'd1; end
        if (d2 < min_d) begin min_d = d2; min_lbl = 3'd2; end
        if (d3 < min_d) begin min_d = d3; min_lbl = 3'd3; end
        if (d4 < min_d) begin min_d = d4; min_lbl = 3'd4; end
        if (d5 < min_d) begin min_d = d5; min_lbl = 3'd5; end
        if (d6 < min_d) begin min_d = d6; min_lbl = 3'd6; end
    end

    // ================= FSM =================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= SET_ADDR;
            i     <= 0;
            iter  <= 0;
            done  <= 0;

            idx <= 0;
            we  <= 0;
            update_centroids <= 0;

            sumx0<=0; sumx1<=0; sumx2<=0; sumx3<=0; sumx4<=0; sumx5<=0; sumx6<=0;
            sumy0<=0; sumy1<=0; sumy2<=0; sumy3<=0; sumy4<=0; sumy5<=0; sumy6<=0;
            sumz0<=0; sumz1<=0; sumz2<=0; sumz3<=0; sumz4<=0; sumz5<=0; sumz6<=0;
            cnt0<=0;  cnt1<=0;  cnt2<=0;  cnt3<=0;  cnt4<=0;  cnt5<=0;  cnt6<=0;

        end else if (!done) begin
            we <= 0;
            update_centroids <= 0;

            case (state)

            // -------------------------------
            SET_ADDR: begin
                idx <= i;
                state <= LATCH;
            end

            // -------------------------------
            LATCH: begin
                x_r   <= x;
                y_r   <= y;
                z_r   <= z;
                idx_r <= i;
                lbl_r <= min_lbl;  
                state <= APPLY;
            end

            // -------------------------------
            APPLY: begin
                we     <= 1;
                waddr  <= idx_r;
                wlabel <= lbl_r;

                case (lbl_r)
                    3'd0: begin sumx0<=sumx0+x_r; sumy0<=sumy0+y_r; sumz0<=sumz0+z_r; cnt0<=cnt0+1; end
                    3'd1: begin sumx1<=sumx1+x_r; sumy1<=sumy1+y_r; sumz1<=sumz1+z_r; cnt1<=cnt1+1; end
                    3'd2: begin sumx2<=sumx2+x_r; sumy2<=sumy2+y_r; sumz2<=sumz2+z_r; cnt2<=cnt2+1; end
                    3'd3: begin sumx3<=sumx3+x_r; sumy3<=sumy3+y_r; sumz3<=sumz3+z_r; cnt3<=cnt3+1; end
                    3'd4: begin sumx4<=sumx4+x_r; sumy4<=sumy4+y_r; sumz4<=sumz4+z_r; cnt4<=cnt4+1; end
                    3'd5: begin sumx5<=sumx5+x_r; sumy5<=sumy5+y_r; sumz5<=sumz5+z_r; cnt5<=cnt5+1; end
                    3'd6: begin sumx6<=sumx6+x_r; sumy6<=sumy6+y_r; sumz6<=sumz6+z_r; cnt6<=cnt6+1; end
                endcase

                if (i == N-1) begin
                    i <= 0;
                    state <= UPDATE;
                end else begin
                    i <= i + 1;
                    state <= SET_ADDR;
                end
            end

            // -------------------------------
            UPDATE: begin
                update_centroids <= 1;

                if (iter == ITER-1) begin
                    done <= 1;
                end else begin
                    iter <= iter + 1;

                    sumx0<=0; sumx1<=0; sumx2<=0; sumx3<=0; sumx4<=0; sumx5<=0; sumx6<=0;
                    sumy0<=0; sumy1<=0; sumy2<=0; sumy3<=0; sumy4<=0; sumy5<=0; sumy6<=0;
                    sumz0<=0; sumz1<=0; sumz2<=0; sumz3<=0; sumz4<=0; sumz5<=0; sumz6<=0;
                    cnt0<=0;  cnt1<=0;  cnt2<=0;  cnt3<=0;  cnt4<=0;  cnt5<=0;  cnt6<=0;

                    state <= SET_ADDR;
                end
            end

            endcase
        end
    end
endmodule
