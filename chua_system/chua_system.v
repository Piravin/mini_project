module chua_system #(parameter N = 31) (input rst, clk);
    wire S;
    // system parameters
    reg [N+3:0] xi, zi, x0, z0;
    reg [N+1:0] yi, y0;
    
    // multiplexer outputs
    reg [N+3:0] m1, m2, m3;
    reg [N+1:0] m4;
           
    // adder/subtracter output
    reg [N+3:0] as1, as2, as3, as4, as5, as6, as7;
    
    // shifter output
    reg [N+3:0] s1, s2, s3, s4;
           
    // gate output
    wire g1, g2, g3, g4;
    
    initial
    begin
        x0 <= 32'b00111111111110011001100110011010;
        y0 <= 32'b00111111111110011001100110011010;
        z0 <= 32'b00111111000101000111101011100001;
    end
    
    // gate output equations    
    assign g1 = ~(xi[N+2] | xi[N+1] | xi[N]),
           g2 = xi[N+2] & xi[N+1] & xi[N],
           g3 = ~xi[N+2],
           g4 = ~(g1 | g2),
           S = g4;
    
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
            as7 = xi + zi;
            as6 = as7 - yi;
            s4 = as6 >> 4;
            as5 = s4 + yi; 
            m4 = as5;// Y(i+1)
            
            as4 = zi - yi;
            m3 = as4; // Z(i+1)
            
            s1 = xi >> 3;
            s2 = xi >> 2;
            m1 = S == 0 ? s1 : s2;
            as1 = g4 == 1 ? (m1 + {2'b00,S,S}) : (m1 - {2'b00,S,S});
            as2 = S == 1 ? (yi + as1) : (yi - as1);
            s3 = as2 >> 1;
            as3 = xi + s3;
            m2 = as3; // X(i+1)
            
            xi = m2;
            yi = m4;
            zi = m3;
            
        end
    end
endmodule