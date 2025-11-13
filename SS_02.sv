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




//============================//
// Connect Sequencer to Driver//
//============================//

//============
// Class Agent
//============
// class apb_agent extends uvm_agent;
//   `uvm_component_utils(apb_agent);
  
//   apb_monitor    monitor;
//   apb_driver     driver;
//   apb_sequenceer sequencer;
  
//   string msg = "apb_agent";
  
//   function new(string name = "apb_agent", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   virtual function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     if(is_active == UVM_ACTIVE) begin
//       `uvm_info(msg, %sfomartf("Active agent is configured"), UVM_LOW);
      
//       driver    = apb_driver::type_id::create("apb_driver", this);
//       monitor   = apb_monitor::type_id::create("apb_monitor", this);
//       sequencer = apb_sequencer::type_id::create("apb_sequencer", this);
//     end
//     else begin
//       `uvm_info(msg, %sfomartf("passive agent is configured"), UVM_LOW);
//       monitor   = apb_monitor::type_id::create("apb_monitor", this);
//     end
//   endfunction
  
// // always port connect with export  
//   virtual function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     if(is_active == UVM_ACTIVE) begin
//       driver.seq_item_port.connect(sequencer.seq_item_export);
//     end
//   endfunction

// endclass



//==============
// Sequence Item
//==============

// package apb_pkg;
// 	import uvm_pkg::*;
	
class apb_transaction extends uvm_sequence_item;
  typedef enum bit {
  	WRITE = 1,
    READ  = 0
  } xact_type_enum;
  
  rand xact_type_enum xact_type;
  rand bit[31:0] address;
  rand bit[31:0] data;
  
//   Start with: `uvm_object_utils_begin
//   List of: `uvm_field_*  (int/string/enum/real/array_int)
//   End with: `uvm_object_utils_end
  
  `uvm_object_utils_begin (apb_transaction)
  `uvm_field_enum (xact_type_enum, xact_type, UVM_ALL_ON | UVM_HEX)
  `uvm_field_int (address,                    UVM_ALL_ON | UVM_HEX)
  `uvm_field_int (data,                       UVM_ALL_ON | UVM_HEX)
  `uvm_object_utils_end
  
  function new(string name = "apb_transaction");
    super.new(name);
  endfunction
  
endclass
// // endpackage


// //===========
// // Testbench
// //===========
module testbench;
  import uvm_pkg::*;
//   import apb_pkg::*;
  
  apb_transaction apb_tran1;
  apb_transaction apb_tran2;
  
  initial begin
    apb_tran1 = apb_transaction::type_id::create("apb_tran1");
    apb_tran1.randomize();
    apb_tran1.print();
    
    apb_tran2 = apb_transaction::type_id::create("apb_tran2");
    apb_tran2.randomize();
    apb_tran2.print();
    
    if(apb_tran1.compare(apb_tran2))
      `uvm_info("Testbench", "Transaction Match", UVM_LOW)
    else
      `uvm_info("Testbench", "Transaction NOT Match", UVM_LOW)
  end
endmodule



//==============
// UVM sequence
//==============
class apb_read_sequence extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(apb_read_sequence)
  
  function new(string name = "apn_read_sequene");
    super.new(name);
  endfunction
 
  virtual task body();
    `uvm_info("body", "Enter body ...", UVM_LOW)
    
    req = apb_transaction::type_id::create("req");
    
    repeat(2) begin
      start_item(req);
      if(req.randomize() with {xact_type == READ;})
        `uvm_info("body", $sformatf("transaction random is: %0s", eq.sprint()), UVM_LOW)
        else
          `uvm_fatal("body", "Randomize failure!")
          finish_item(req);
      
      get_response(rsp);
      `uvm_info("body", %sformatf("Data read from DUT: %0h", rsp.data), UVM_LOW)
    end
    `uvm_info("body", "Exiting...", UVM_LOW)
    
  endtask
  
endclass



