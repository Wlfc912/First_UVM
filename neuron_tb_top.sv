`include "neuron_pkg.sv"
`include "neuron_if.sv"
module neuron_tb_top;
    import uvm_pkg::*;

    neuron_if vif();

    neuron dut (vif.sig_clk,
                vif.sig_rst,
                vif.sig_weight_sum,
                vif.sig_state_in,
                vif.sig_state_out, 
                vif.sig_spike_out);

    initial begin
        uvm_resource_db#(virtual neuron_if)::set(.scope("ifs"), .name("neuron_if"), .val(vif));
        run_test("neuron_test");
    end

    initial begin
        vif.sig_clk = 1'b1;
    end

    always
        #5 vif.sig_clk = ~vif.sig_clk;

endmodule