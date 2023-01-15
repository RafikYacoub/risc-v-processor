

// Module Name: registers
// Authors: Mohamed Ali

module registers #(parameter n = 32)(
    input load,clk,rst,
    input [n-1:0]d,
    output [n-1:0] q
    );
    
    wire[n-1:0] out;
    //MUX multiplexer(q,d,load,out);
    //wire clk_del;
    //assign #1 clk_del = clk;
    genvar i;
    generate
        for(i=0;i<n;i=i+1)
            begin
                MUX #(1) multiplexer (q[i],d[i],load,out[i]);
                DFF flipflop(out[i],clk,rst,q[i]);
            end
    endgenerate 
    
    
endmodule
