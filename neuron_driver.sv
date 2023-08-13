class neuron_driver extends uvm_driver#(neuron_transaction);
    `uvm_component_utils(neuron_driver)

    virtual neuron_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_resource_db#(virtual neuron_if)::read_by_name
                (.scope("ifs"), .name("neuron_if"), .val(vif)));
    endfunction: build_phase

    task run_phase(uvm_phase phase);
        drive();
    endtask: run_phase

    virtual task drive();
        neuron_transaction neuron_tx;
        vif.sig_rst = 1'b0;
        vif.sig_weight_sum = 8'd0;
        vif.sig_state_in = 8'd0;

        forever begin
            seq_item_port.get_next_item(neuron_tx);
            
            @(posedge vif.sig_clk) begin
                vif.sig_rst = neuron_tx.rst;
                vif.sig_weight_sum = neuron_tx.weight_sum;
                vif.sig_state_in = neuron_tx.state_in;
            end
            seq_item_port.item_done();
        end

    endtask: drive

endclass: neuron_driver