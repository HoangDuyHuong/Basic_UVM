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
class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)
  
  function new(string name = "apb_base_test", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void final_phase(uvm_phase phase);
    uvm_report_server svr;
    
    super.final_phase(phase);
    
    `uvm_info("final_phase","Enter ... ", UVM_LOW)
    
//     Decleare server
    svr = uvm_report_server::get_server();
    if(svr.get_severity_count(UVM_FATAL) + svr.get_severity_count(UVM_ERROR) > 0 )begin
      $display("\n======================");
      $display(" ### TEST FAILED  ###");
      $display("======================");
    end
    else begin
      $display("\n======================");
      $display(" ### TEST PASSED  ###");
      $display("======================");
    end
    
    `uvm_info("Final_phase", "Exitting ... ", UVM_LOW);
  endfunction
endclass





//========================
// TestClass apb_read_test
//========================
class apb_read_test extends apb_base_test;
  `uvm_component_utils(apb_read_test)	
  
  string msg = "apb_read_test";
  
  function new(string name = "apb_read_test", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    phase.raise_objection(this);
    
    `uvm_info("msg", "Start run test", UVM_LOW)
    #100ns;
    `uvm_error(msg, "Empty test")
    phase.drop_objection(this);
  endtask
endclass



//========================
// Top Module
//========================
module top;

	initial begin
      run_test("apb_read_test");
    end

endmodule






