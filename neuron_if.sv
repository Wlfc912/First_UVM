interface neuron_if;
    logic sig_clk;
    logic sig_rst;
    logic [7:0] sig_weight_sum;
    logic [7:0] sig_state_in;
    
    logic [8:0] sig_state_out;
    logic sig_spike_out;
endinterface: neuron_if 