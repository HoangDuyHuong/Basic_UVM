// import package
import uvm_pkg::*;
`include "uvm_macros.svh"


//=====================================
// Study tracking error via uvm_error
//uvm_report_server: store count errors
//=====================================

//====================
// Class apb_base_test
//====================
// class apb_base_test extends uvm_test;
//   `uvm_component_utils(apb_base_test)
  
//   function new(string name = "apb_base_test", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   virtual function void final_phase(uvm_phase phase);
//     uvm_report_server svr;
    
//     super.final_phase(phase);
    
//     `uvm_info("final_phase","Enter ... ", UVM_LOW)
    
// //     Decleare server
//     svr = uvm_report_server::get_server();
//     if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0 )begin
//       $display("\n======================");
//       $display(" ### TEST FAILED  ###");
//       $display("======================");
//     end
//     else begin
//       $display("\n======================");
//       $display(" ### TEST PASSED  ###");
//       $display("======================");
//     end
    
//     `uvm_info("Final_phase", "Exitting ... ", UVM_LOW);
//   endfunction
// endclass





//========================
// TestClass apb_read_test
//========================
// class apb_read_test extends apb_base_test;
//   `uvm_component_utils(apb_read_test)	
  
//   string msg = "apb_read_test";
  
//   function new(string name = "apb_read_test", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   task run_phase(uvm_phase phase);
//     super.run_phase(phase);
    
//     phase.raise_objection(this);
    
//     `uvm_info("msg", "Start run test", UVM_LOW)
//     #100ns;
//     `uvm_error(msg, "Empty test")
//     phase.drop_objection(this);
//   endtask
// endclass



//========================
// Top Module
//========================
// module top;

// 	initial begin
//       run_test("apb_read_test");
//     end

// endmodule





//=================================
// UVM Report Catcher
// Use to change message gen by sys
// uvm_report_catcher
//=================================


//=========
//Interface
//=========
interface apb_if;
	logic clk;
endinterface


//================
// class timer_env
//================
class timer_env extends uvm_env;
  `uvm_component_utils(timer_env)
  
  function new(string name = "timer_env", uvm_component parent);
    super.new(name,parent);
  endfunction
endclass




//========================
// class apb_read_sequence
//========================
class apb_read_sequence extends uvm_sequence;
  `uvm_object_utils(apb_read_sequence)
  
  function new(string name = "apb_read_sequence");
    super.new(name);
  endfunction
endclass



//==========================
// class timer_error_cathcer
//==========================
class timer_error_catcher extends uvm_report_catcher;
  `uvm_object_utils(timer_error_catcher)

  string error_msg_q[$];
  
  function new(string name = "timer_error_catcher");
    super.new(name);
  endfunction
  
  virtual function action_e catch();
  	string str_cmp;
    
    if(get_severity() == UVM_ERROR) begin
      foreach(error_msg_q[i]) begin
        str_cmp = error_msg_q[i];
        if(get_message() == str_cmp)begin
          set_severity(UVM_INFO);
          `uvm_info("REPORT_CATCHER", $sformatf("Denoted below error message: %s", str_cmp), UVM_NONE)
        end
      end
    
    end
  
    return THROW;
  endfunction
  
//   add message
  virtual function void add_error_catcher_msg(string str);
    error_msg_q.push_back(str);
  endfunction
  
endclass




//==========================
// class timer_base_test
//==========================
class timer_base_test extends uvm_test;
  `uvm_component_utils(timer_base_test)
  
  timer_env env;
  virtual apb_if apb_vif;
  timer_error_catcher err_catcher;
  
  time usr_timeout=1s;
  
  function new(string name = "timer_base_test", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual apb_if)::get(this,"","apb_vif",apb_vif))
      `uvm_fatal(get_type_name(), $sformatf("failed to get apb_vif from uvm_config_db"))
      
    env = timer_env::type_id::create("timer_env",this);
    err_catcher = timer_error_catcher::type_id::create("err_catcher");
    
//  enable catcher working, use uvm_report_cb
    uvm_report_cb::add(null,err_catcher);
    
    uvm_config_db #(virtual apb_if)::set(this,"env","apb_vif",apb_vif);
    
    uvm_top.set_timeout(usr_timeout);
    
  endfunction
  
  
endclass





//=================================
// class timer_reserved_region_test
//=================================
class timer_reserved_region_test extends timer_base_test;
  `uvm_component_utils(timer_reserved_region_test)
  
  apb_read_sequence rd_seq;
  
  function new(string name = "timer_reserved_region_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    `uvm_info(get_type_name(),"Start Test ...",UVM_LOW)
    
    err_catcher.add_error_catcher_msg("Slave response ERROR");
    
//     rd_seq = apb_read_sequence::type_id::create("rd_seq");
//     rd_seq.start(env.apb_agt.sequencer);
    #10ns;
    
    `uvm_error("DUt_MOCK","Slave response ERROR")
    
    phase.drop_objection(this);
  endtask
endclass




//=================
// class TOP_MODULE
//=================
module testbench;
	
  apb_if apb_vif();
  initial begin
  
    uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top", "apb_vif",apb_vif);
    
    run_test("timer_reserved_region_test");
    
  end
endmodule


