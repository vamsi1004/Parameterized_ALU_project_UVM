`include "defines.svh"
class alu_scoreboard extends uvm_scoreboard;
  
  virtual alu_interface vif;
  
  alu_seq_item mon_item;
  alu_seq_item exp_item;
      
    int found = 0;
  
  localparam rot_bits = $clog2(`WIDTH);
  logic [rot_bits-1:0] rot_val;
  
  `uvm_component_utils(alu_scoreboard)
  
  uvm_tlm_analysis_fifo #(alu_seq_item) tlm_mon_fifo;
  
  function new(string name  = "", uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tlm_mon_fifo = new("tlm_mon_fifo",this);
    if( !uvm_config_db #(virtual alu_interface)::get(this,"","password",vif))
      `uvm_fatal("NO VIF",$sformatf("ERROR"));
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
     forever begin // 8
      tlm_mon_fifo.get(mon_item);
       $cast(exp_item, mon_item.clone());
       compute_val(mon_item, exp_item);
       `uvm_info ("EXPECTED",$sformatf("expected output is"),UVM_LOW);
       exp_item.print();
      
       if (mon_item.RES !== exp_item.RES) begin
        `uvm_error(get_full_name(),
          $sformatf("RES mismatch. CMD=%0d MODE=%0b IN_VALID=%0b OPA=%0h OPB=%0h | EXPECTED RES=%0h ACTUAL RES=%0h",
                    mon_item.CMD, mon_item.MODE, mon_item.INP_VALID, mon_item.OPA, mon_item.OPB,
                    exp_item.RES, mon_item.RES));
      end

      if (mon_item.ERR !== exp_item.ERR) begin
        `uvm_error(get_full_name(),
          $sformatf("ERR mismatch. CMD=%0d OPA=%0h OPB=%0h | EXPECTED ERR=%0b ACTUAL ERR=%0b",
                    mon_item.CMD, mon_item.OPA, mon_item.OPB, exp_item.ERR, mon_item.ERR));
      end

      if (mon_item.COUT !== exp_item.COUT) begin
        `uvm_error(get_full_name(),
          $sformatf("COUT mismatch. CMD=%0d OPA=%0h OPB=%0h | EXPECTED COUT=%0b ACTUAL COUT=%0b",
                    mon_item.CMD, mon_item.OPA, mon_item.OPB, exp_item.COUT, mon_item.COUT));
      end

      if (mon_item.OFLOW !== exp_item.OFLOW) begin
        `uvm_error(get_full_name(),
          $sformatf("OFLOW mismatch. CMD=%0d OPA=%0h OPB=%0h | EXPECTED OFLOW=%0b ACTUAL OFLOW=%0b",
                    mon_item.CMD, mon_item.OPA, mon_item.OPB, exp_item.OFLOW, mon_item.OFLOW));
      end

      if (mon_item.G !== exp_item.G) begin
        `uvm_error(get_full_name(),
          $sformatf("G mismatch. CMD=%0d OPA=%0h OPB=%0h | EXPECTED G=%0b ACTUAL G=%0b",
                    mon_item.CMD, mon_item.OPA, mon_item.OPB, exp_item.G, mon_item.G));
      end
      if (mon_item.E !== exp_item.E) begin
        `uvm_error(get_full_name(),
          $sformatf("E mismatch. CMD=%0d OPA=%0h OPB=%0h | EXPECTED E=%0b ACTUAL E=%0b",
                    mon_item.CMD, mon_item.OPA, mon_item.OPB, exp_item.E, mon_item.E));
      end
      if (mon_item.L !== exp_item.L) begin
        `uvm_error(get_full_name(),
          $sformatf("L mismatch. CMD=%0d OPA=%0h OPB=%0h | EXPECTED L=%0b ACTUAL L=%0b",
                    mon_item.CMD, mon_item.OPA, mon_item.OPB, exp_item.L, mon_item.L));
      end

      if ((mon_item.RES === exp_item.RES) &&
          (mon_item.ERR === exp_item.ERR) &&
          (mon_item.COUT === exp_item.COUT) &&
          (mon_item.OFLOW === exp_item.OFLOW) &&
          (mon_item.G === exp_item.G) &s&
          (mon_item.E === exp_item.E) &&
          (mon_item.L === exp_item.L)) begin
        `uvm_info(get_full_name(), $sformatf("PASS CMD=%0d OPA=%0h OPB=%0h RES=%0h", mon_item.CMD, mon_item.OPA, mon_item.OPB, mon_item.RES), UVM_LOW)
      end  
    end//8
  endtask 
  
  task compute_val(alu_seq_item drv, alu_seq_item exp);
    
    exp.RES = `WIDTH'bz;
    exp.COUT = 1'bz;
    exp.ERR =  1'bz;
    exp.OFLOW = 1'bz;
    exp.G = 1'bz;
    exp.E = 1'bz;
    exp.L = 1'bz;
    

    if (drv.MODE == 1 && !(drv.CMD inside {0,1,2,3,4,5,6,7,8,9,10}) || drv.MODE && !(drv.CMD inside {0,1,2,3,4,5,6,7,8,9,10,11,12,13})) exp.ERR = 1;

    else if((drv.MODE == 1 && (drv.CMD inside {0,1,2,3,8,9,10}) || drv.MODE && (drv.CMD inside {0,1,2,3,4,5,12,13})) && (drv.INP_VALID == 2'b10 || drv.INP_VALID == 2'b01))begin//10
      repeat(16) begin //9
        @(posedge vif.ref_cb)
        if(drv.INP_VALID == 2'b11)
          begin //8
          found = 1;
          break;
          end //8
      end //9
      if(!found) 
           begin 
             exp.ERR = 1;
           end
    end //10
    
        
    
    if(drv.CE == 1)
      begin //1
        if(drv.MODE == 1)
          begin //3
            case(drv.CMD)
              0:begin
                exp.RES = drv.OPA + drv.OPB;
                exp.COUT = exp.RES[`WIDTH];
              end
              1:begin 
                exp.RES = drv.OPA - drv.OPB;
                exp.OFLOW = (drv.OPA < drv.OPB) ? 1 : 0;
              end
              2:begin 
                exp.RES = drv.OPA + drv.OPB + drv.CIN;
                exp.COUT = exp.RES[`WIDTH];
              end
              3:begin 
                exp.RES = drv.OPA - drv.OPB - drv.CIN;
                exp.OFLOW = (drv.OPA < drv.OPB) ? 1 : 0;
              end
              4:begin 
                if(drv.INP_VALID == 2'b11 || drv.INP_VALID == 2'b01)
                  begin
                    exp.RES = drv.OPA + 1;
                    exp.COUT = exp.RES[`WIDTH];
                  end
                else
                  exp.ERR = 1;
              end
              5:begin 
                if(drv.INP_VALID == 2'b11 || drv.INP_VALID == 2'b01)
                  begin
                    exp.RES = drv.OPA - 1;
                    exp.OFLOW = (drv.OPA < 1) ? 1 : 0;
                  end
                else
                  exp.ERR = 1;
              end 
              6:begin 
                if(drv.INP_VALID == 2'b11 || drv.INP_VALID == 2'b10)
                  begin
                    exp.RES = drv.OPB + 1;
                    exp.COUT = exp.RES[`WIDTH];
                  end
                else
                  exp.ERR = 1;
              end
              7:begin 
                if(drv.INP_VALID == 2'b11 || drv.INP_VALID == 2'b10)
                  begin
                    exp.RES = drv.OPB - 1;
                    exp.OFLOW = (drv.OPB < 1) ? 1 : 0;
                  end
                else
                  exp.ERR = 1;
              end 
              8:begin 
                if(drv.OPA > drv.OPB) exp.G = 1;
                else if(drv.OPA == drv.OPB) exp.E = 1;
                else exp.L = 1;
              end
              9:begin 
                exp.RES = (drv.OPA + 1)*(drv.OPB + 1);
              end 
              10:begin 
                exp.RES = (drv.OPA << 1)*(drv.OPB);
              end
            endcase
          end //3
             
              
        else if(drv.MODE == 0)
          begin //4
            case(drv.CMD)
              0:begin 
                exp.RES = {1'b0,(drv.OPA & drv.OPB)};
              end
              1:begin 
                exp.RES = {1'b0,~(drv.OPA & drv.OPB)};
              end
              2:begin 
                exp.RES = {1'b0,(drv.OPA | drv.OPB)};
              end
              3:begin 
                exp.RES = {1'b0,~(drv.OPA | drv.OPB)};
              end
              4:begin 
                exp.RES = {1'b0,(drv.OPA ^ drv.OPB)};
              end
              5:begin 
                exp.RES = {1'b0,~(drv.OPA ^ drv.OPB)};
              end
              6:begin 
                if(drv.INP_VALID == 2'b11 || drv.INP_VALID == 2'b01) exp.RES = {1'b0,~(drv.OPA)};
                else exp.ERR = 1;
              end
              7:begin
                if(drv.INP_VALID == 2'b11 || drv.INP_VALID == 2'b10) exp.RES = {1'b0,~(drv.OPB)};
                else exp.ERR = 1;
              end
              8:begin 
                if(drv.INP_VALID == 2'b11 || drv.INP_VALID == 2'b01) exp.RES = {1'b0,(drv.OPA >>1)};
                else exp.ERR = 1;
              end
              9:begin 
                if(drv.INP_VALID == 2'b11 || drv.INP_VALID == 2'b01) exp.RES = {1'b0,(drv.OPA <<1)};
                else exp.ERR = 1;
              end
              10:begin 
                if(drv.INP_VALID == 2'b11 || drv.INP_VALID == 2'b10) exp.RES = {1'b0,(drv.OPB >>1)};
                else exp.ERR = 1;
              end
              11:begin 
                if(drv.INP_VALID == 2'b11 || drv.INP_VALID == 2'b10) exp.RES = {1'b0,(drv.OPB <<1)};
                else exp.ERR = 1;
              end
              12:begin //6
                if (drv.OPB >= `WIDTH) exp.ERR = 1;
                else
                  begin
                    rot_val= drv.OPB[rot_bits-1 :0];
                    exp.RES = {1'b0, (drv.OPA << rot_val) | (drv.OPA >> (`WIDTH - rot_val))};
                  end
              end //6
              13:begin//7
                if (drv.OPB >= `WIDTH) exp.ERR = 1;
                else 
                   begin
                     rot_val= drv.OPB[rot_bits-1 : 0];
                     exp.RES = {1'b0, (drv.OPA >> rot_val) | (drv.OPA << (`WIDTH - rot_val))};
                  end
              end //7
            endcase
          end //4
      end //1
    else
      begin //2
        //Latch previous outputs
      end//2
  endtask
endclass
