class alu_test extends uvm_test;
  
  alu_environment env;
  
  virtual_sequence v_seq;
  `uvm_component_utils(alu_test)
  
  function new(string name = "alu_test", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    print();
    env = alu_environment::type_id::create("env",this);
  endfunction
  
  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    v_seq = virtual_sequence::type_id::create("seq1",this);
    v_seq.seqA = env.agent.seq;
    repeat(1) begin
    v_seq.start(null);
    end
    phase.drop_objection(this);

  endtask 
  
endclass
