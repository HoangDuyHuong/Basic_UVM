// import package
import uvm_pkg::*;
`include "uvm_macros.svh"

// //=============//
// // Class Agent //
// //=============//
// class apb_agent extends uvm_agent;
// // reg factory
//   `uvm_component_utils(apb_agent);
  
// //   instance
//   apb_monitor   monitor;
//   apb_dirver    driver;
//   apb_sequencer sequencer;

// //   new
//   function new(string name = "apb_agent", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
// //   build phase
//   virtual function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     if(is_active == UVM_ACTIVE) begin
//       `uvm_info(get_type_name(), $sformatf("Active agent is configued"), UVM_LOW);
//       monitor = apb_monitor::type_id::create("monitor", this);
//       driver = apb_driver::type_id::create("driver", this);
//       sequencer = apb_sequencer::type_id::create("sequencer", this);
//     end
//     else begin
//       `uvm_info(get_type_name(), $sformatf("Passive agent is configued"), UVM_LOW);
//       monitor = apb_monitor::type_id::create("monitor", this);
//     end
//   endfunction
  
// //   connect phase
//   virtual function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//   endfunction
// endclass


//================//
// Class Sequencer//
//================//
// class apb_sequencer extends uvm_sequencer #(apb_transaction);
//   `uvm_component_utils(apb_sequencer);
  
//   function new(string name = "apb_sequencer", uvm_component parent);
//     super.new(name,parent);
//   endfunction
// endclass



//=============//
// Class Driver//
//=============//
// class apb_driver extends uvm_driver #(apb_transaction);
//   `uvm_component_utils(apb_driver);
  
//   function new(string name = "apb_driver", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   virtual function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//   endfunction
  
//   virtual task run_phase(uvm_phase phase);
//   	forever begin
//       //     	Get item (request) from sequence through sequencer
//       seq_item_port.get_next_item(req);
      
// //       Driving
//       driver();
      
// //       response item to sequence though sequencer
//       seq_item_port.item_done()
//     end
//   endtask
  
//   virtual task driver();
//   	#1us;
//   endtask
  
// endclass






