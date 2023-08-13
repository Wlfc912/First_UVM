class neuron_agent extends uvm_agent;
    `uvm_component_utils(neuron_agent)
    uvm_analysis_port#(neuron_transaction) first_agent_ap_before;
    uvm_analysis_port#(neuron_transaction) first_agent_ap_after;
    
    function new(string name="neuron_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    neuron_sequencer            neu_seqr;
    neuron_driver               neu_drvr;
    neuron_monitor_before       neu_mon_before;
    neuron_monitor_after        neu_mon_after;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        first_agent_ap_before = new(.name("first_agent_ap_before"), .parent(this));
        first_agent_ap_after = new(.name("first_agent_ap_after"), .parent(this));

        neu_seqr = neuron_sequencer::type_id::create(.name("neu_seqr"), .parent(this));
        neu_drvr = neuron_driver::type_id::create(.name("neu_dvrv"), .parent(this));
        neu_mon_before = neuron_monitor_before::type_id::create(.name("neu_mon_before"), .parent(this));
        neu_mon_after = neuron_monitor_after::type_id::create(.name("neu_mon_after"), .parent(this));
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        neu_drvr.seq_item_port.connect(neu_seqr.seq_item_export);
        neu_mon_before.my_first_ap_before.connect(first_agent_ap_before);
        neu_mon_after.my_first_ap_after.connect(first_agent_ap_after);

    endfunction: connect_phase

endclass: neuron_agent