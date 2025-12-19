module kmeans_point_memory #(
    parameter N = 41
)(
    input clk,

    input  [5:0] raddr,          
    output [7:0] x, y, z,
    output [2:0] label,          

    input        we,
    input  [5:0] waddr,
    input  [2:0] wlabel
);

    reg [7:0] x_mem [0:N-1];
    reg [7:0] y_mem [0:N-1];
    reg [7:0] z_mem [0:N-1];
    reg [2:0] label_mem [0:N-1];

    integer i;
    initial begin

    x_mem[0]=10;  y_mem[0]=10;  z_mem[0]=10;
    x_mem[1]=13;  y_mem[1]=12;  z_mem[1]=9;
    x_mem[2]=8;   y_mem[2]=15;  z_mem[2]=11;
    x_mem[3]=12;  y_mem[3]=11;  z_mem[3]=13;
    x_mem[4]=9;   y_mem[4]=14;  z_mem[4]=8;

    x_mem[5]=50;  y_mem[5]=50;  z_mem[5]=50;
    x_mem[6]=52;  y_mem[6]=48;  z_mem[6]=53;
    x_mem[7]=48;  y_mem[7]=55;  z_mem[7]=49;
    x_mem[8]=51;  y_mem[8]=53;  z_mem[8]=52;
    x_mem[9]=49;  y_mem[9]=47;  z_mem[9]=48;


    x_mem[10]=90; y_mem[10]=20; z_mem[10]=70;
    x_mem[11]=88; y_mem[11]=23; z_mem[11]=72;
    x_mem[12]=93; y_mem[12]=18; z_mem[12]=68;
    x_mem[13]=91; y_mem[13]=21; z_mem[13]=74;
    x_mem[14]=87; y_mem[14]=19; z_mem[14]=69;

  
    x_mem[15]=20; y_mem[15]=80; z_mem[15]=30;
    x_mem[16]=22; y_mem[16]=78; z_mem[16]=33;
    x_mem[17]=18; y_mem[17]=83; z_mem[17]=28;
    x_mem[18]=21; y_mem[18]=81; z_mem[18]=31;
    x_mem[19]=19; y_mem[19]=79; z_mem[19]=29;


    x_mem[20]=70; y_mem[20]=70; z_mem[20]=20;
    x_mem[21]=72; y_mem[21]=68; z_mem[21]=25;
    x_mem[22]=68; y_mem[22]=75; z_mem[22]=18;
    x_mem[23]=71; y_mem[23]=69; z_mem[23]=22;
    x_mem[24]=69; y_mem[24]=73; z_mem[24]=21;

   
    x_mem[25]=40; y_mem[25]=10; z_mem[25]=90;
    x_mem[26]=42; y_mem[26]=12; z_mem[26]=88;
    x_mem[27]=38; y_mem[27]=9;  z_mem[27]=93;
    x_mem[28]=41; y_mem[28]=11; z_mem[28]=91;
    x_mem[29]=39; y_mem[29]=8;  z_mem[29]=89;


    x_mem[30]=100; y_mem[30]=100; z_mem[30]=100;
    x_mem[31]=102; y_mem[31]=98;  z_mem[31]=99;
    x_mem[32]=98;  y_mem[32]=101; z_mem[32]=103;
    x_mem[33]=101; y_mem[33]=99;  z_mem[33]=97;
    x_mem[34]=99;  y_mem[34]=102; z_mem[34]=101;

    // noise
    x_mem[35]=120; y_mem[35]=5;   z_mem[35]=90;
    x_mem[36]=30;  y_mem[36]=80;  z_mem[36]=10;
    x_mem[37]=5;   y_mem[37]=100; z_mem[37]=40;
    x_mem[38]=115; y_mem[38]=60;  z_mem[38]=20;
    x_mem[39]=60;  y_mem[39]=5;   z_mem[39]=120;

 
    x_mem[40]=55;  y_mem[40]=20;  z_mem[40]=115;
end

   
    assign x     = x_mem[raddr];
    assign y     = y_mem[raddr];
    assign z     = z_mem[raddr];
    assign label = label_mem[raddr];

  
    always @(posedge clk)
        if (we)
            label_mem[waddr] <= wlabel;

endmodule
