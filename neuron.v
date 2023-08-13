module neuron (
    input clk, rst,
    input [7:0] weight_sum,
    input [7:0] state_in,
    output reg [8:0] state_out,
    output spike_out
    );
    
    assign spike_out = state_out[8] ? 1'b1 : 1'b0;

    always@(posedge clk) begin
        if(rst) begin
            state_out <= 8'b0;
        end else begin
            state_out <= state_in + weight_sum;
        end    
    end   
    
endmodule