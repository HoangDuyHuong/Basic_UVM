// Import UVM package và include macros
import uvm_pkg::*;
`include "uvm_macros.svh"

//=======================================
// 1. CLASS AGENT
//=======================================
class agent extends uvm_env;
  `uvm_component_utils(agent)
  
  function new(string name = "agent", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Entered build_phase"), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Exit build_phase"), UVM_LOW)    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Entered connect_phase in agent"), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Exit connect_phase in agent"), UVM_LOW)
  endfunction
  
endclass

//=======================================
// 2. CLASS TEST 
//=======================================
class my_test extends uvm_test;
  `uvm_component_utils(my_test)
  
  // Khai báo handle cho agent
  agent m_agent;

  function new(string name = "my_test", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Entered build_phase (test)"), UVM_LOW)
    
    // Khởi tạo agent
    m_agent = agent::type_id::create("m_agent", this);
    
    `uvm_info(get_type_name(), $sformatf("Exit build_phase (test)"), UVM_LOW)    
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #10ns;
    phase.drop_objection(this);
  endtask

endclass

//=======================================
// 3. TOP MODULE
//=======================================
module top;
  
  initial begin
       run_test();
  end

endmodule
