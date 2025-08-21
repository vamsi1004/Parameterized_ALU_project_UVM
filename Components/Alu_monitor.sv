`include "defines.svh"
class alu_monitor extends uvm_monitor;
  
  virtual alu_interface vif;
  
  uvm_analysis_port #(alu_seq_item) mon_port;
  
  alu_seq_item seq_item;
  
  `uvm_component_utils(alu_monitor)
  
  function new(string name = "alu_monitor", uvm_component parent);
    super.new(name,parent);
    seq_item = new;
    mon_port = new("mon_port",this);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual alu_interface)::get(this,"","password",vif))
      `uvm_fatal("NO VIF",$sformatf("ERROR"));
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
   forever begin
    recieve();
    end
  endtask
  
  task recieve();
    @(posedge vif.mon_cb);
    seq_item.RES = vif.RES;
    seq_item.COUT = vif.COUT;
    seq_item.ERR = vif.ERR;
    seq_item.OFLOW = vif.OFLOW;
    seq_item.G = vif.G;
    seq_item.E = vif.E;
    seq_item.L = vif.L;
    seq_item.OPA = vif.OPA;
    seq_item.OPB = vif.OPB;
    seq_item.CMD = vif.CMD;
    seq_item.INP_VALID = vif.INP_VALID;
    seq_item.CE = vif.CE;
    seq_item.MODE = vif.MODE;
    seq_item.CIN = vif.CIN;
    
    mon_port.write(seq_item);
    `uvm_info("MONITOR PRINT",$sformatf("printed"),UVM_LOW);
    seq_item.print();
  endtask
  
endclass
