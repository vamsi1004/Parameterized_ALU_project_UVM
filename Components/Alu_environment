`include "defines.svh"
class alu_environment extends uvm_env;
  
  `uvm_component_utils(alu_environment);
  
  alu_agent agent;
  alu_scoreboard scb;
  alu_subscriber sub;

  function new(string name = "", uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = alu_agent::type_id::create("agent",this);
    scb = alu_scoreboard::type_id::create("scb",this);
    sub = alu_subscriber::type_id::create("sub",this);
  endfunction 
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.mon.mon_port.connect(scb.tlm_mon_fifo.analysis_export);
    agent.mon.mon_port.connect(sub.mon_cov_port.analysis_export);
  endfunction
endclass
