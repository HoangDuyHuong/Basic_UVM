// // Import UVM package và include macros
// import uvm_pkg::*;
// `include "uvm_macros.svh"

// //=======================================
// // 1. CLASS AGENT 
// //=======================================
// class agent extends uvm_env;
//   `uvm_component_utils(agent)
  
//   function new(string name = "agent", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     `uvm_info(get_type_name(), $sformatf("Entered build_phase"), UVM_LOW)
//     `uvm_info(get_type_name(), $sformatf("Exit build_phase"), UVM_LOW)    
//   endfunction
  
//   function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     `uvm_info(get_type_name(), $sformatf("Entered connect_phase in agent"), UVM_LOW)
//     `uvm_info(get_type_name(), $sformatf("Exit connect_phase in agent"), UVM_LOW)
//   endfunction
  
// endclass

// //=======================================
// // 2. CLASS Enviroment 
// //=======================================
// class env extends uvm_env;
//   `uvm_component_utils(env)
//   agent my_agt;
  
//   function new(string name = "env", uvm_component parent);
//     super.new(name, parent);
//   endfunction
  
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     `uvm_info(get_type_name(), $sformatf("Entered build_phase in env"), UVM_LOW);
//     my_agt = agent::type_id::create("my_agt", this);
//     `uvm_info(get_type_name(), $sformatf("Exited build_phase in env"), UVM_LOW);
//   endfunction
  
//   function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     `uvm_info(get_type_name(), $sformatf("Entered connect_phase in env"), UVM_LOW);
//     `uvm_info(get_type_name(), $sformatf("Exit connect_phase in env"), UVM_LOW);
//   endfunction
  
// endclass


// //==============================
// // 3. Class Test
// //==============================
// class test extends uvm_test;
//   `uvm_component_utils(test);
//   env my_env;
  
//   function new(string name = "test", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     `uvm_info(get_type_name(), $sformatf("Entered build phase in test"), UVM_LOW);
//     my_env = env::type_id::create("my_env", this);
//     `uvm_info(get_type_name(), $sformatf("Exit build phase in test"), UVM_LOW);
//   endfunction
  
//   function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     `uvm_info(get_type_name(), $sformatf("Entered connect_phase in test"), UVM_LOW);
//     `uvm_info(get_type_name(), $sformatf("Exit connect_phase in test"), UVM_LOW);
//   endfunction
  
//   task run_phase(uvm_phase phase);
//     phase.raise_objection(this);
//     #10ns;
//     phase.drop_objection(this);
//   endtask
	  
// endclass

// //=======================================
// // 4. TOP MODULE 
// //=======================================
// module top;
  

//   initial begin

//     run_test();
//   end

// endmodule



// Example a APB UVM testbench
// import package
import uvm_pkg::*;
`include "uvm_macros.svh"


//=======================//
// create apb_scoreboard //
//=======================//
class apb_scoreboard extends uvm_component;
// 	reg factory
  `uvm_component_utils(apb_scoreboard);
  
//   new
  function new(string name = "apb_scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction
  
//   build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Enter build phase sb"), UVM_LOW);
    `uvm_info(get_type_name(), $sformatf("Exit build phase sb"), UVM_LOW);
  endfunction
endclass


//=====================//
// Class apb_agent     //
//=====================//
class apb_agent extends uvm_component();
//   reg factory
  `uvm_component_utils(apb_agent);
  
  function new(string name = "apb_agent", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Enter build phase agent"), UVM_LOW);
    `uvm_info(get_type_name(), $sformatf("Exit build phase agent"), UVM_LOW);
  endfunction
  
  function void end_of_elaboratio_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Exit end_of_elaboratio_phase in env"), UVM_LOW);
  endfunction  
endclass


//=======================//
// Class apb_env         //
//=======================//

class apb_env extends uvm_env;
// 	reg factory
  `uvm_component_utils(apb_env);
  apb_agent      my_agt;
  apb_scoreboard my_sb;
  
  function new(string name = "apb_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Enter build phase in env"), UVM_LOW);
    my_sb = apb_scoreboard::type_id::create("my_sb", this);
    my_agt = apb_agent::type_id::create("my_agt", this);
    `uvm_info(get_type_name(), $sformatf("Exit build phase in env"), UVM_LOW);
  endfunction
  
endclass



//=====================//
// Class apb_base_test //
//=====================//
class apb_base_test extends uvm_test;
// 	reg factory
  `uvm_component_utils(apb_base_test);
  
  apb_env my_env;
  
//   new
  function new(string name = "apb_base_test", uvm_component parent);
    super.new(name,parent);
  endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), $sformatf("Enter build phase in base_test"), UVM_LOW);
      my_env = apb_env::type_id::create("my_env", this);
      `uvm_info(get_type_name(), $sformatf("Exit build phase in base_test"), UVM_LOW);
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
      `uvm_info(get_type_name(), "Enter end_of_elaboration_phase", UVM_LOW);
      
      uvm_top.print_topology();
    endfunction
    
    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      #10ns;
      phase.drop_objection(this);
    endtask

endclass


//=====================//
// Top Module          //
//=====================//
module top;
  
	initial begin
      run_test();
    end
  
endmodule
