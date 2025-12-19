module kmeans_top #(
    parameter N    = 41,
    parameter ITER = 20         
)(
    input  clk,
    input  rst,
    output done
);

    // ================= INDEX + PUNCT =================
    wire [5:0] idx;
    wire [7:0] x, y, z;

    // ================= LABEL WRITE =================
    wire        we;
    wire [5:0]  waddr;
    wire [2:0]  wlabel;

    // ================= CENTROIZI =================
    reg [7:0] cx0, cy0, cz0;
    reg [7:0] cx1, cy1, cz1;
    reg [7:0] cx2, cy2, cz2;
    reg [7:0] cx3, cy3, cz3;
    reg [7:0] cx4, cy4, cz4;
    reg [7:0] cx5, cy5, cz5;
    reg [7:0] cx6, cy6, cz6;


    wire [17:0] d0, d1, d2, d3, d4, d5, d6;


    wire [15:0] sumx0, sumx1, sumx2, sumx3, sumx4, sumx5, sumx6;
    wire [15:0] sumy0, sumy1, sumy2, sumy3, sumy4, sumy5, sumy6;
    wire [15:0] sumz0, sumz1, sumz2, sumz3, sumz4, sumz5, sumz6;
    wire [5:0]  cnt0,  cnt1,  cnt2,  cnt3,  cnt4,  cnt5,  cnt6;

    wire update_centroids;

    // ================= INIT CENTROIZI =================
    initial begin
        cx0=10;  cy0=10;  cz0=10;
        cx1=50;  cy1=50;  cz1=50;
        cx2=90;  cy2=20;  cz2=70;
        cx3=20;  cy3=80;  cz3=30;
        cx4=70;  cy4=70;  cz4=20;
        cx5=40;  cy5=10;  cz5=90;
        cx6=100; cy6=100; cz6=100;
    end

    // ================= MEMORIE PUNCTE =================
    kmeans_point_memory #(N) PM (
        .clk(clk),
        .raddr(idx),
        .x(x), .y(y), .z(z),
        .label(),
        .we(we),
        .waddr(waddr),
        .wlabel(wlabel)
    );

    // ================= DISTANCE UNITS =================
    kmeans_distance_unit DU0 (x,y,z,cx0,cy0,cz0,d0);
    kmeans_distance_unit DU1 (x,y,z,cx1,cy1,cz1,d1);
    kmeans_distance_unit DU2 (x,y,z,cx2,cy2,cz2,d2);
    kmeans_distance_unit DU3 (x,y,z,cx3,cy3,cz3,d3);
    kmeans_distance_unit DU4 (x,y,z,cx4,cy4,cz4,d4);
    kmeans_distance_unit DU5 (x,y,z,cx5,cy5,cz5,d5);
    kmeans_distance_unit DU6 (x,y,z,cx6,cy6,cz6,d6);

    // ================= FSM =================
    kmeans_fsm_k7 #(N, ITER) FSM (
        .clk(clk),
        .rst(rst),

        .d0(d0), .d1(d1), .d2(d2),
        .d3(d3), .d4(d4), .d5(d5), .d6(d6),

        .x(x), .y(y), .z(z),
        .idx(idx),

        .we(we),
        .waddr(waddr),
        .wlabel(wlabel),

        .sumx0(sumx0), .sumx1(sumx1), .sumx2(sumx2),
        .sumx3(sumx3), .sumx4(sumx4), .sumx5(sumx5), .sumx6(sumx6),

        .sumy0(sumy0), .sumy1(sumy1), .sumy2(sumy2),
        .sumy3(sumy3), .sumy4(sumy4), .sumy5(sumy5), .sumy6(sumy6),

        .sumz0(sumz0), .sumz1(sumz1), .sumz2(sumz2),
        .sumz3(sumz3), .sumz4(sumz4), .sumz5(sumz5), .sumz6(sumz6),

        .cnt0(cnt0), .cnt1(cnt1), .cnt2(cnt2),
        .cnt3(cnt3), .cnt4(cnt4), .cnt5(cnt5), .cnt6(cnt6),

        .update_centroids(update_centroids),
        .done(done)
    );

    // ================= UPDATE CENTROIZI (CU RE-SEED) =================
    always @(posedge clk) begin
        if (update_centroids) begin
            if (cnt0) cx0<=sumx0/cnt0; else cx0<=10;
            if (cnt1) cx1<=sumx1/cnt1; else cx1<=50;
            if (cnt2) cx2<=sumx2/cnt2; else cx2<=90;
            if (cnt3) cx3<=sumx3/cnt3; else cx3<=20;
            if (cnt4) cx4<=sumx4/cnt4; else cx4<=70;
            if (cnt5) cx5<=sumx5/cnt5; else cx5<=40;
            if (cnt6) cx6<=sumx6/cnt6; else cx6<=120;

            if (cnt0) cy0<=sumy0/cnt0; else cy0<=10;
            if (cnt1) cy1<=sumy1/cnt1; else cy1<=50;
            if (cnt2) cy2<=sumy2/cnt2; else cy2<=20;
            if (cnt3) cy3<=sumy3/cnt3; else cy3<=80;
            if (cnt4) cy4<=sumy4/cnt4; else cy4<=70;
            if (cnt5) cy5<=sumy5/cnt5; else cy5<=10;
            if (cnt6) cy6<=sumy6/cnt6; else cy6<=5;

            if (cnt0) cz0<=sumz0/cnt0; else cz0<=10;
            if (cnt1) cz1<=sumz1/cnt1; else cz1<=50;
            if (cnt2) cz2<=sumz2/cnt2; else cz2<=70;
            if (cnt3) cz3<=sumz3/cnt3; else cz3<=30;
            if (cnt4) cz4<=sumz4/cnt4; else cz4<=20;
            if (cnt5) cz5<=sumz5/cnt5; else cz5<=90;
            if (cnt6) cz6<=sumz6/cnt6; else cz6<=90;
        end
    end

endmodule
