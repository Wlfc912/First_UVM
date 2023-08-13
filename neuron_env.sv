class neuron_env extends uvm_env;
	`uvm_component_utils(neuron_env)

	neuron_agent neu_agent;
	neuron_scoreboard neu_sb;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		neu_agent	= neuron_agent::type_id::create(.name("neu_agent"), .parent(this));
		neu_sb		= neuron_scoreboard::type_id::create(.name("neu_sb"), .parent(this));
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		neu_agent.first_agent_ap_before.connect(neu_sb.neu_export_before);
		neu_agent.first_agent_ap_after.connect(neu_sb.neu_export_after);
	endfunction: connect_phase
endclass: neuron_env