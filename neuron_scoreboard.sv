`uvm_analysis_imp_decl(_before)
`uvm_analysis_imp_decl(_after)

class neuron_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(neuron_scoreboard)
    function new(string name="scoreboard", uvm_component parent=null);
		super.new(name, parent);

		transaction_before	= new("transaction_before");
		transaction_after	= new("transaction_after");
	endfunction: new

    uvm_analysis_export #(neuron_transaction) neu_export_before;
	uvm_analysis_export #(neuron_transaction) neu_export_after;

    uvm_tlm_analysis_fifo #(neuron_transaction) before_fifo;
	uvm_tlm_analysis_fifo #(neuron_transaction) after_fifo;

    neuron_transaction transaction_before;
	neuron_transaction transaction_after;

    virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		neu_export_before	= new("neu_export_before", this);
		neu_export_after	= new("neu_export_after", this);

        before_fifo		= new("before_fifo", this);
		after_fifo		= new("after_fifo", this);

	endfunction: build_phase

    function void connect_phase(uvm_phase phase);
		neu_export_before.connect(before_fifo.analysis_export);
		neu_export_after.connect(after_fifo.analysis_export);
	endfunction: connect_phase

    task run();
		forever begin
			before_fifo.get(transaction_before);
			after_fifo.get(transaction_after);
			
			compare();
		end
	endtask: run

	virtual function void compare();
		if(transaction_before.spike_out == transaction_after.spike_out && transaction_before.state_out == transaction_after.state_out) begin
			`uvm_info("compare", {"Test: OK!"}, UVM_LOW);
		end else begin
			`uvm_info("compare", {"Test: Fail!"}, UVM_LOW);
		end
	endfunction: compare
endclass: neuron_scoreboard
