module lorenz_system(input clk, rst);
    parameter N = 31;
    
    // adder/subtractor outputs
    reg [N+2:0] as1, as2, as3, as4, as5, as6;
    
    // mux outputs
    reg [N+2:0] m1, m3;
    reg [N+1:0] m2;
    
    // shifter outputs
    reg [N+2:0] s1, s2, s4;
    reg [N+1:0] s3;
    
    // system parameters
    reg [N+2:0] yi, zi, y0, z0;
    reg [N+1:0] xi, x0;
    
    // gate outputs
    wire g1;
    assign g1 = ~xi[N];
    
    initial
    begin
        x0 <= 32'b10111111100011110101110000101001;
        y0 <= 32'b10111111110111010111000010100100;
        z0 <= 32'b10111110100001010001111010111000;
    end
    
    always @ (posedge(clk) or posedge(rst))
    begin
        if (rst)
        begin
            xi <= x0;
            yi <= y0;
            zi <= z0;
        end
        else
        begin
            as6 = zi - 32'b00111111000000000000000000000000;
            s4 = as6 >> 4;
            as5 = g1 == 1 ? (yi + zi) : (yi - zi);
            m3 = as5; // Y(i+1)
            
            as4 = yi - xi;
            s3 = as4 >> 5;
            as3 = s3 + xi;
            m2 = as3; // X(i+1)
            
            s2 = zi >> 2;
            as1 = g1 == 1 ? (s2 + xi) : (s2 - xi);
            s1 = as1 >> 4;
            as2 = zi - s1;
            m1 = as2; // Z(i+1)
            
            xi = m2;
            yi = m3;
            zi = m1;
        end
    end
endmodule