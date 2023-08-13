class neuron_monitor_before extends uvm_monitor;
// get the output from DUT and pass to the scoreboard
    `uvm_component_utils(neuron_monitor_before)
    function new(string name="neuron_monitor_before", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    uvm_analysis_port #(neuron_transaction) my_first_ap_before;
    virtual neuron_if vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_resource_db#(virtual neuron_if)::read_by_name (.scope("ifs"), .name("neuron_if"), .val(vif)));

        my_first_ap_before = new(.name("my_first_ap_before"), .parent(this));
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        neuron_transaction neu_tx = neuron_transaction::type_id::create(.name("neu_tx"), .contxt(get_full_name()));
        
        forever begin
            @(posedge vif.sig_clk) begin
                neu_tx.state_out = vif.sig_state_out;
                neu_tx.spike_out = vif.sig_spike_out;
             	`uvm_info("MON_BEF", $sformatf("The output: state = %0d, spike = %0d",neu_tx.state_out, neu_tx.spike_out), UVM_LOW)
                my_first_ap_before.write(neu_tx);
            end
        end
        
    endtask: run_phase
endclass: neuron_monitor_before



class neuron_monitor_after extends uvm_monitor;
// calculate and make a prediction and send to the scoreboard
    `uvm_component_utils(neuron_monitor_after)

    uvm_analysis_port #(neuron_transaction) my_first_ap_after;
    virtual neuron_if vif;
    neuron_transaction neu_tx;

    neuron_transaction neu_tx_cg;
    covergroup neuron_cg;
        ws: coverpoint neu_tx_cg.weight_sum;
        state_in: coverpoint neu_tx_cg.state_in;
        cross ws, state_in;
    endgroup: neuron_cg

    function new(string name="neuron_monitor_after", uvm_component parent=null);
        super.new(name, parent);
        neuron_cg = new;
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_resource_db#(virtual neuron_if)::read_by_name (.scope("ifs"), .name("neuron_if"), .val(vif)));

        my_first_ap_after = new(.name("my_first_ap_after"), .parent(this));
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);

        neu_tx = neuron_transaction::type_id::create(.name("neu_tx"), .contxt(get_full_name()));
        forever begin
            @(posedge vif.sig_clk) begin
                neu_tx.weight_sum = vif.sig_weight_sum;
                neu_tx.state_in = vif.sig_state_in;
              	neu_tx.rst = vif.sig_rst;
				`uvm_info("MON_AFT", $sformatf("The input: state = %0d, ws = %0d",neu_tx.state_in, neu_tx.weight_sum), UVM_LOW)
               
              	predictor();
                neu_tx_cg = neu_tx;

                neuron_cg.sample();
                my_first_ap_after.write(neu_tx);
            end
        end
        
    endtask: run_phase

    virtual function void predictor();
      if(neu_tx.rst) begin
        neu_tx.state_out = 9'd0;
        neu_tx.spike_out = 1'b0;
      end else begin
        neu_tx.state_out = neu_tx.state_in + neu_tx.weight_sum;
        neu_tx.spike_out = neu_tx.state_out > 9'd255 ? 1'b1 : 1'b0;
      end
    endfunction: predictor
endclass: neuron_monitor_after