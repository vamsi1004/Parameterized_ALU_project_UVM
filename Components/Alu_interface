`include "defines.svh"

interface alu_interface(input logic clk,reset);
  logic [`WIDTH-1 : 0] OPA;
  logic [`WIDTH-1 : 0] OPB;
  logic [`CMD_WIDTH-1 : 0] CMD;
  logic [1:0]INP_VALID;
  logic CIN;
  logic CE;
  logic MODE;
  logic [`WIDTH : 0]RES;
  logic ERR;
  logic COUT;
  logic G;
  logic E;
  logic L;
  logic OFLOW;
  
  clocking drv_cb @(posedge clk);
    default input #0 output #0;
    output OPA;
    output OPB;
    output CMD;
    output INP_VALID;
    output CIN;
    output CE;
    output MODE;
  endclocking 
  
  clocking mon_cb  @(posedge clk);
    default input #0 output #0;
    input RES;
    input COUT;
    input ERR;
    input OFLOW;
    input G;
    input E;
    input L;
    input OPA;
    input OPB;
    input CMD;
    input INP_VALID;
    input CIN;
    input CE;
    input MODE;
  endclocking 
  
    clocking ref_cb @(posedge clk);
    default input #0 output #0;
    input OPA;
    input OPB;
    input CMD;
    input INP_VALID;
    input CIN;
    input CE;
    input MODE;
  endclocking 
  
  modport drv(clocking drv_cb,input clk,reset);
  modport mon(clocking mon_cb,input clk,reset);
  modport Ref(clocking ref_cb,input clk,reset);
  
   property prop1;
    @(posedge clk)
    INP_VALID == 2'b11 |-> !$isunknown(OPA) && !$isunknown(OPB);
  endproperty
    assert property (prop1)
    else $error("OPA/OPB unknown when IN_VALID == 2'b11");

  property prop2;
    @(posedge clk)
    CE |-> !$isunknown(CMD) && !$isunknown(OPA) && !$isunknown(OPB) && !$isunknown(INP_VALID) && !$isunknown(MODE);
  endproperty
    assert property (prop2)
    else $error("CMD or operands unknown when CE is high");

  property prop3;
    @(posedge clk)
    CMD < (2**`CMD_WIDTH);
  endproperty
    assert property (prop3)
    else $error("CMD out of range!");

  property prop4;
    @(posedge clk)
    (MODE==1 ) |-> (CMD inside {0,1,2,3,4,5,6,7,8,9,10});
  endproperty
    assert property (prop4)
    else $error("Invalid CMD used in MODE=1");

  property prop5;
    @(posedge clk)
    (MODE==0 ) |-> (CMD inside {0,1,2,3,4,5,6,7,8,9,10,11,12,13});
  endproperty
    assert property (prop5)
    else $error("Invalid CMD used in MODE=0");

  property prop6;
    @(posedge clk)
    reset |-> (RES==0 && ERR==0 && COUT==0 && OFLOW==0 && G==0 && E==0 && L==0);
  endproperty
    assert property (prop6)
    else $error("Outputs not cleared on reset");
       
endinterface  
      

