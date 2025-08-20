
`include "defines.svh"
class alu_agent extends uvm_agent;
  alu_sequencer seq;
  alu_driver drv;
  alu_monitor mon;
  
  `uvm_component_utils(alu_agent);
  
  function new(string name = "",uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
    seq = alu_sequencer::type_id::create("seq",this);
    drv = alu_driver::type_id::create("drv",this);
    end
    mon = alu_monitor::type_id::create("mon",this);
  endfunction 
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seq.seq_item_export);
    end
  endfunction
endclass
