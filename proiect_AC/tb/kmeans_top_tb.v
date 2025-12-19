module kmeans_top_tb;

    reg clk = 0;
    reg rst = 1;
    wire done;
    integer f;
    integer i;

    kmeans_top DUT (
        .clk(clk),
        .rst(rst),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        // puncte test (41)
         DUT.PM.x_mem[0]  = 10;  DUT.PM.y_mem[0]  = 10;  DUT.PM.z_mem[0]  = 10;
         DUT.PM.x_mem[1]  = 13;  DUT.PM.y_mem[1]  = 12;  DUT.PM.z_mem[1]  = 9;
        DUT.PM.x_mem[2]  = 8;   DUT.PM.y_mem[2]  = 15;  DUT.PM.z_mem[2]  = 11;
        DUT.PM.x_mem[3]  = 12;  DUT.PM.y_mem[3]  = 11;  DUT.PM.z_mem[3]  = 13;
        DUT.PM.x_mem[4]  = 9;   DUT.PM.y_mem[4]  = 14;  DUT.PM.z_mem[4]  = 8;

        // CLUSTER 2
        DUT.PM.x_mem[5]  = 50; DUT.PM.y_mem[5]  = 50; DUT.PM.z_mem[5]  = 50;
        DUT.PM.x_mem[6]  = 52; DUT.PM.y_mem[6]  = 48; DUT.PM.z_mem[6]  = 53;
        DUT.PM.x_mem[7]  = 48; DUT.PM.y_mem[7]  = 55; DUT.PM.z_mem[7]  = 49;
        DUT.PM.x_mem[8]  = 51; DUT.PM.y_mem[8]  = 53; DUT.PM.z_mem[8]  = 52;
        DUT.PM.x_mem[9]  = 49; DUT.PM.y_mem[9]  = 47; DUT.PM.z_mem[9]  = 48;

        // CLUSTER 3
        DUT.PM.x_mem[10] = 90; DUT.PM.y_mem[10] = 20; DUT.PM.z_mem[10] = 70;
        DUT.PM.x_mem[11] = 88; DUT.PM.y_mem[11] = 23; DUT.PM.z_mem[11] = 72;
        DUT.PM.x_mem[12] = 93; DUT.PM.y_mem[12] = 18; DUT.PM.z_mem[12] = 68;
        DUT.PM.x_mem[13] = 91; DUT.PM.y_mem[13] = 21; DUT.PM.z_mem[13] = 74;
        DUT.PM.x_mem[14] = 87; DUT.PM.y_mem[14] = 19; DUT.PM.z_mem[14] = 69;

        // CLUSTER 4
        DUT.PM.x_mem[15] = 20; DUT.PM.y_mem[15] = 80; DUT.PM.z_mem[15] = 30;
        DUT.PM.x_mem[16] = 22; DUT.PM.y_mem[16] = 78; DUT.PM.z_mem[16] = 33;
        DUT.PM.x_mem[17] = 18; DUT.PM.y_mem[17] = 83; DUT.PM.z_mem[17] = 28;
        DUT.PM.x_mem[18] = 21; DUT.PM.y_mem[18] = 81; DUT.PM.z_mem[18] = 31;
        DUT.PM.x_mem[19] = 19; DUT.PM.y_mem[19] = 79; DUT.PM.z_mem[19] = 29;

        // CLUSTER 5
        DUT.PM.x_mem[20] = 70; DUT.PM.y_mem[20] = 70; DUT.PM.z_mem[20] = 20;
        DUT.PM.x_mem[21] = 72; DUT.PM.y_mem[21] = 68; DUT.PM.z_mem[21] = 25;
        DUT.PM.x_mem[22] = 68; DUT.PM.y_mem[22] = 75; DUT.PM.z_mem[22] = 18;
        DUT.PM.x_mem[23] = 71; DUT.PM.y_mem[23] = 69; DUT.PM.z_mem[23] = 22;
        DUT.PM.x_mem[24] = 69; DUT.PM.y_mem[24] = 73; DUT.PM.z_mem[24] = 21;

        // CLUSTER 6
        DUT.PM.x_mem[25] = 40; DUT.PM.y_mem[25] = 10; DUT.PM.z_mem[25] = 90;
        DUT.PM.x_mem[26] = 42; DUT.PM.y_mem[26] = 12; DUT.PM.z_mem[26] = 88;
        DUT.PM.x_mem[27] = 38; DUT.PM.y_mem[27] = 9;  DUT.PM.z_mem[27] = 93;
        DUT.PM.x_mem[28] = 41; DUT.PM.y_mem[28] = 11; DUT.PM.z_mem[28] = 91;
        DUT.PM.x_mem[29] = 39; DUT.PM.y_mem[29] = 8;  DUT.PM.z_mem[29] = 89;

        // CLUSTER 7
        DUT.PM.x_mem[30] = 100; DUT.PM.y_mem[30] = 100; DUT.PM.z_mem[30] = 100;
        DUT.PM.x_mem[31] = 102; DUT.PM.y_mem[31] = 98;  DUT.PM.z_mem[31] = 99;
        DUT.PM.x_mem[32] = 98;  DUT.PM.y_mem[32] = 101; DUT.PM.z_mem[32] = 103;
        DUT.PM.x_mem[33] = 101; DUT.PM.y_mem[33] = 99;  DUT.PM.z_mem[33] = 97;
        DUT.PM.x_mem[34] = 99;  DUT.PM.y_mem[34] = 102; DUT.PM.z_mem[34] = 101;

        // NOISE
        DUT.PM.x_mem[35] = 120; DUT.PM.y_mem[35] = 5;   DUT.PM.z_mem[35] = 90;
        DUT.PM.x_mem[36] = 30;  DUT.PM.y_mem[36] = 80;  DUT.PM.z_mem[36] = 10;
        DUT.PM.x_mem[37] = 5;   DUT.PM.y_mem[37] = 100; DUT.PM.z_mem[37] = 40;
        DUT.PM.x_mem[38] = 115; DUT.PM.y_mem[38] = 60;  DUT.PM.z_mem[38] = 20;
        DUT.PM.x_mem[39] = 60;  DUT.PM.y_mem[39] = 5;   DUT.PM.z_mem[39] = 120;
        DUT.PM.x_mem[40] = 55;  DUT.PM.y_mem[40] = 20;  DUT.PM.z_mem[40] = 115;


        #20 rst = 0;
        wait(done);

        f = $fopen("clusters_out.txt", "w");
        $fwrite(f, "x y z label\n");
        for (i = 0; i < 41; i = i + 1) begin
            $fwrite(f, "%0d %0d %0d %0d\n",
                DUT.PM.x_mem[i],
                DUT.PM.y_mem[i],
                DUT.PM.z_mem[i],
                DUT.PM.label_mem[i]);
        end
        $fclose(f);

        $display("K-means done – clusters_out.txt generated");
        #20 $finish;
    end
endmodule
