class neuron_test extends uvm_test;
		`uvm_component_utils(neuron_test)

		neuron_env neu_env;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction: new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			neu_env = neuron_env::type_id::create(.name("neu_env"), .parent(this));
		endfunction: build_phase

		task run_phase(uvm_phase phase);
			neuron_sequence neu_seq;

			phase.raise_objection(.obj(this));
				neu_seq = neuron_sequence::type_id::create(.name("neu_seq"), .contxt(get_full_name()));
				assert(neu_seq.randomize());
				neu_seq.start(neu_env.neu_agent.neu_seqr);
			phase.drop_objection(.obj(this));
		endtask: run_phase
endclass: neuron_test