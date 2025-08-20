`include "defines.svh"
class alu_driver extends uvm_driver #(alu_seq_item);
  virtual alu_interface vif;
  
  `uvm_component_utils(alu_driver)
  
  function new(string name  = "alu_driver",uvm_component parent);
    super.new(name,parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual alu_interface)::get(this, "", "password", vif))
      `uvm_fatal("NO_VIF",$sformatf("ERROR"));
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
    seq_item_port.get_next_item(req);
      drive();
    seq_item_port.item_done();
    end
    
  endtask 
  
  task drive();
    @(vif.drv_cb);
         if(req.CE == 1)
            begin //2
              if((req.MODE == 1 && req.INP_VALID == 2'b11) || (req.MODE == 0 && req.INP_VALID == 2'b11))
                begin //3
                  vif.OPA <= req.OPA;
                  vif.OPB <= req.OPB;
                  vif.INP_VALID <= req.INP_VALID;
                  vif.CIN <= req.CIN;
                  vif.MODE <= req.MODE;
                  vif.CE <= req.CE;
                  vif.CMD <= req.CMD;
                  
                       req.print();
              `uvm_info("DRIVER PRINT", $sformatf("printed"),UVM_LOW);
                  if(req.MODE == 1 && (req.CMD == 9 || req.CMD == 10))
                    repeat(3)@(posedge vif.drv_cb);
                  else
                    repeat(2)@(posedge vif.drv_cb);

               end //3
              
              else if((req.MODE == 1 && req.CMD inside {4,5,6,7}) || (req.MODE == 0 && req.CMD inside {6,7,8,9,10,11}))
                begin //4
                  vif.OPA <= req.OPA;
                  vif.OPB <= req.OPB;
                  vif.INP_VALID <= req.INP_VALID;
                  vif.CIN <= req.CIN;
                  vif.MODE <= req.MODE;
                  vif.CE <= req.CE;
                  vif.CMD <= req.CMD;
                  
                  req.print();
              `uvm_info("DRIVER PRINT", $sformatf("printed"),UVM_LOW);
                end//4
              
              else if(((req.MODE == 1 && !(req.CMD inside {4,5,6,7})) || (req.MODE == 0 && !(req.CMD inside {6,7,8,9,10,11}))))
                begin//5
                  if(req.INP_VALID == 2'b10 || req.INP_VALID == 2'b01)
                    begin //6
                      vif.OPA <= req.OPA;
                      vif.OPB <= req.OPB;
                      vif.INP_VALID <= req.INP_VALID;
                      vif.CIN <= req.CIN;
                      vif.MODE <= req.MODE;
                      vif.CE <= req.CE;
                      vif.CMD <= req.CMD;
                      
                      req.CMD.rand_mode(0);
                      req.MODE.rand_mode(0);
                      req.CE.rand_mode(0);
                      
                      for(int j = 0 ; j < 16 ; j++)
                        begin //7
                          @(posedge vif.drv_cb)
                          req.randomize();
                          if(req.INP_VALID == 2'b11)
                            begin //8
                              vif.OPA <= req.OPA;
                              vif.OPB <= req.OPB;
                              vif.INP_VALID <= req.INP_VALID;
                              vif.CIN <= req.CIN;
                              vif.MODE <= req.MODE;
                              vif.CE <= req.CE;
                              vif.CMD <= req.CMD;
                              break;
                            end//8
                          else
                            begin //9
                              vif.OPA <= req.OPA;
                              vif.OPB <= req.OPB;
                              vif.INP_VALID <= req.INP_VALID;
                              vif.CIN <= req.CIN;
                              vif.MODE <= req.MODE;
                              vif.CE <= req.CE;
                              vif.CMD <= req.CMD;
                            end //9
                          
                          req.CMD.rand_mode(1);
                          req.MODE.rand_mode(1);
                          req.CE.rand_mode(1);
                          
                          req.print();
              `uvm_info("DRIVER PRINT", $sformatf("printed"),UVM_LOW);
                          
                          if(req.MODE == 1 && (req.CMD == 9 || req.CMD == 10))
                            repeat(3)@(posedge vif.drv_cb);
                          else
                            repeat(2)@(posedge vif.drv_cb);

                              
                        end//7
                    end//6
                end//5
              
            end //2
  endtask
endclass 
