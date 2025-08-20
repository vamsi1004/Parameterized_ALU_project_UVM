`include "defines.svh"
class alu_subscriber extends uvm_component;
  
  `uvm_component_utils(alu_subscriber)
  
  alu_seq_item mon;
  
  real cov_report;
  
  uvm_tlm_analysis_fifo #(alu_seq_item)mon_cov_port;
  
   covergroup cover_cg;
  Input_Valid : coverpoint mon.INP_VALID {
    bins vld[4] = {2'b00, 2'b01, 2'b10, 2'b11};
  }
  Command : coverpoint mon.CMD {
    bins cmd_first  = {[0 : (2**(`CMD_WIDTH/2))-1]};
    bins cmd_second = {[(2**(`CMD_WIDTH/2)) : (2**`CMD_WIDTH)-1]};
  }
  OperandA : coverpoint mon.OPA {
    bins zero      = {0};
    bins small_opa = {[1 : (2**(`WIDTH/2))-1]};
    bins large_opa = {[2**(`WIDTH/2) : (2**`WIDTH)-1]};
  }
  OperandB : coverpoint mon.OPB {
    bins zero      = {0};
    bins small_opb = {[1 : (2**(`WIDTH/2))-1]};
    bins large_opb = {[2**(`WIDTH/2) : (2**`WIDTH)-1]};
  }
  clock : coverpoint mon.CE {
    bins Clock_en[] = {1'b0, 1'b1};
  }
  carry_in : coverpoint mon.CIN {
    bins Carry_in[] = {1'b0, 1'b1};
  }
    Result:coverpoint mon.RES{
      bins res_first = {[0 : (((2**(`WIDTH+1))/2)-1)]};
      //bins res_last  = {[( (2**(`WIDTH+1)/2) : (2**(`WIDTH+1)-1) )]};
    }                                   
     OLOW:coverpoint mon.OFLOW{
       bins overflow[] = {0,1};
     }
     COUT:coverpoint mon.COUT{
        bins carry_out[] = {0,1};
     }
     Error:coverpoint mon.ERR{
        bins error[] = {0,1};
     }
     G:coverpoint mon.G{
       bins greater[] = {0,1};
     }
     E:coverpoint mon.E{
        bins Equal[] = {0,1};
     }
     L:coverpoint mon.L{
        bins Less[] = {0,1};
     }       
  AxB     : cross OperandA, OperandB;
  cmdxinp : cross Command, Input_Valid;

endgroup
  
   function new(string name = "",uvm_component parent);
    super.new(name,parent);
    cover_cg = new;
    mon_cov_port = new("mon_cov_port",this);
  endfunction 
  
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      mon_cov_port.get(mon);
      cover_cg.sample();
    end
  endtask
  
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov_report = cover_cg.get_coverage();
  endfunction 
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("[MONITOR] Coverage ------> %0.2f%%", cov_report),UVM_LOW);
  endfunction
                          
endclass
