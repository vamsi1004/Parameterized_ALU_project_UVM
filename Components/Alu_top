`timescale 1ns/1ns

`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "alu_pkg.sv"
`include "alu_interface.sv"
//`include "design.sv"

module top;

  import uvm_pkg::*;
  import a_pkg::*;
  
  bit clk;
  bit reset;
  
  always #5 clk = ~clk;
  
  initial 
    begin
      reset = 1;
      #5 reset = 0;
    end
  
  
  alu_interface intf(clk,reset);
  
  ALU_DESIGN DUT(.INP_VALID(intf.INP_VALID), .OPA(intf.OPA), .OPB(intf.OPB), .CIN(intf.CIN), .CMD(intf.CMD), .COUT(intf.COUT), .OFLOW(intf.OFLOW), .RES(intf.RES), .G(intf.G), .E(intf.E), .L(intf.L), .CLK(clk), .ERR(intf.ERR), .CE(intf.CE), .MODE(intf.MODE), .RST(reset));
  
  
  initial 
    begin 
      uvm_config_db #(virtual alu_interface)::set(null,"*","password",intf);
      $dumpfile("dump.vcd");
	$dumpvars;
    end
  
  initial 
    begin 
      run_test("alu_test");
      #1000 $finish;
    end
  
endmodule
