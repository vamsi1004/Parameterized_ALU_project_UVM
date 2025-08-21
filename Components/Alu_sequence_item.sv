`include "defines.svh"
 `include "uvm_macros.svh"
  import uvm_pkg::*;

class alu_seq_item extends uvm_sequence_item;
  
  //`uvm_object_utils(alu_seq_item)
  
  function new(string name = "seq_item");
    super.new(name);
  endfunction 
  
  rand bit[`WIDTH-1 : 0] OPA;
  rand bit[`WIDTH-1 : 0] OPB;
  rand bit[`CMD_WIDTH-1 : 0] CMD;
  rand bit[1:0] INP_VALID;
  rand bit CIN;
  rand bit CE;
  rand bit MODE;
  bit [`WIDTH : 0] RES;
  bit ERR;
  bit COUT;
  bit G;
  bit E;
  bit L;
  bit OFLOW;
  
  `uvm_object_utils_begin(alu_seq_item)
  `uvm_field_int(OPA,UVM_ALL_ON)
  `uvm_field_int(OPB,UVM_ALL_ON)
  `uvm_field_int(CMD,UVM_ALL_ON)
  `uvm_field_int(MODE,UVM_ALL_ON)
  `uvm_field_int(INP_VALID,UVM_ALL_ON)
  `uvm_field_int(CIN,UVM_ALL_ON)
  `uvm_field_int(CE,UVM_ALL_ON)
  `uvm_field_int(CIN,UVM_ALL_ON)
  `uvm_field_int(RES,UVM_ALL_ON)
  `uvm_field_int(ERR,UVM_ALL_ON)
  `uvm_field_int(COUT,UVM_ALL_ON)
  `uvm_field_int(G,UVM_ALL_ON)
  `uvm_field_int(E,UVM_ALL_ON)
  `uvm_field_int(L,UVM_ALL_ON)
  `uvm_field_int(OFLOW,UVM_ALL_ON)
  `uvm_object_utils_end
  
  constraint a1{OPA == 1;OPB == 2;CE ==1;}
  
  
  
endclass
