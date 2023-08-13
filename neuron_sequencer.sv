class neuron_transaction extends uvm_sequence_item;
    rand bit rst;
    rand bit [7:0] weight_sum;
    rand bit [7:0] state_in;
    rand bit [8:0] state_out;
    rand bit spike_out;

    function new (string name = "neuron_transaction");
        super.new(name);
    endfunction: new

    `uvm_object_utils_begin(neuron_transaction)
        `uvm_field_int(rst, UVM_ALL_ON)
        `uvm_field_int(weight_sum, UVM_ALL_ON)
        `uvm_field_int(state_in, UVM_ALL_ON)
        `uvm_field_int(state_out, UVM_ALL_ON)
        `uvm_field_int(spike_out, UVM_ALL_ON)
    `uvm_object_utils_end
endclass: neuron_transaction

class neuron_sequence extends uvm_sequence#(neuron_transaction);
    `uvm_object_utils(neuron_sequence)

    function new (string name = "neuron_sequence");
        super.new(name);
    endfunction: new

    task body();
        neuron_transaction neuron_tx;

        repeat(15) begin
            neuron_tx = neuron_transaction::type_id::create(.name("neuron_tx"), .contxt(get_full_name()));

            start_item(neuron_tx);
                assert(neuron_tx.randomize());
            finish_item(neuron_tx);
        end
    endtask:body
endclass: neuron_sequence

//create a basic sequencer with the default API
typedef uvm_sequencer#(neuron_transaction) neuron_sequencer;