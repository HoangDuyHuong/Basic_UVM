// // import package
import uvm_pkg::*;
`include "uvm_macros.svh"


//==========================================
// Study connect (Port/Export/Analysis port)
//==========================================
// class simple_trans extends uvm_sequence_item;
//   typedef enum bit {
//   	WRITE = 1,
//     READ  = 0
//   } xact_type_enum;
  
//   rand xact_type_enum xact_type;
//   rand bit[7:0] addr;
//   rand bit[7:0] data;

  
//   `uvm_object_utils_begin (simple_trans)
//   `uvm_field_enum (xact_type_enum, xact_type, UVM_ALL_ON | UVM_HEX)
//   `uvm_field_int (addr,                       UVM_ALL_ON | UVM_HEX)
//   `uvm_field_int (data,                       UVM_ALL_ON | UVM_HEX)
//   `uvm_object_utils_end
  
//   function new(string name = "simple_trans");
//     super.new(name);
//   endfunction
  
// endclass

//=================================================================================
//Ky hieu: hinh vuong(Port),hinh tron(Export),hinh thoi(Analysis port)
//EX: producer(Port) -> consumer(Export)
// Build in method of Port: uvm_blocking_put_port and uvm_blocking_put_imp (export)
//=================================================================================

//===============
//Class Producer
//===============
// class producer extends uvm_component;
//   `uvm_component_utils(producer)
  
//   uvm_blocking_put_port #(simple_trans) put_port;
  
//   function new(string name = "porducer", uvm_component parent);
//     super.new(name,parent);
//     put_port = new("put_port", this);
//   endfunction
  
//   virtual task run_phase(uvm_phase phase);
//     simple_trans trans;
//     for(int i=0; i<2; i++) begin
// //     	Generate transaction
//       trans = simple_trans::type_id::create("trans");
//       trans.randomize();
//       `uvm_info(get_type_name(), "Sent trans to consumer", UVM_LOW)
//       trans.print();
//       put_port.put(trans);
//       #10ns;
//     end
//   endtask
  
// endclass


//===============
//Class Consumer
//===============
// class consumer extends uvm_component;
//   `uvm_component_utils(consumer)
  
//   uvm_blocking_put_imp #(simple_trans, consumer) put_export;
  
//   function new(string name = "consumer", uvm_component parent);
//     super.new(name, parent);
//     put_export = new("put_export", this);
//   endfunction
  
//   task put(simple_trans trans);
//     `uvm_info(get_type_name(), "Receive trans from producer", UVM_LOW)
//     trans.print();
//   endtask
	
// endclass
  

//===============
//Class env
//===============
// class env extends uvm_env;
//   `uvm_component_utils(env)
  
//   producer prod;
//   consumer cons;
  
//   function new(string name = "env", uvm_component parent = null);
//     super.new(name,parent);
//   endfunction
  
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     prod  = producer::type_id::create("prod", this);
//     cons = consumer::type_id::create("cons", this);
//   endfunction
  
//   function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     prod.put_port.connect(cons.put_export);
//   endfunction
  
// endclass


//===============
//Class test
//===============
// class test extends uvm_test;
//   `uvm_component_utils(test)
  
//   env my_env;
  
//   function new(string name = "test", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     `uvm_info(get_type_name(), "Enter Test ...", UVM_LOW);
//     my_env = env::type_id::create("my_env", this);
    
//   endfunction
  
//   task run_phase(uvm_phase phase);
//     phase.raise_objection(this);
//     #10ns;
//     phase.drop_objection(this);
  	
//   endtask
  
// endclass


//===============
//Top Module
//===============

// module top;
// 	initial begin
//       run_test();
//     end
// endmodule


//=========================================
//Consumer Get data from Producer
// Swap producer(export) -> consumer (port)
// Use 2 method: uvm_blocking_get_port
//				 uvm_blocking_get_imp	
//=========================================

//===============
// Class producer
//===============
// class producer extends uvm_component;
//   `uvm_component_utils(producer);
//   uvm_blocking_get_imp #(simple_trans,producer) get_export;
  
//   function new(string name = "producer", uvm_component parent);
//     super.new(name, parent);
//     get_export = new("get_export", this);
//   endfunction
  
//   task get(output simple_trans trans);
//     simple_trans tmp = simple_trans::type_id::create("tmp");
//     `uvm_info(get_type_name(), "Give consumer trans", UVM_LOW);
//     tmp.randomize();
//     tmp.print();
//     trans = tmp;
//   endtask
// endclass


//===============
// Class consumer
//===============
// class consumer extends uvm_component;
//   `uvm_component_utils(consumer)
//   uvm_blocking_get_port #(simple_trans) get_port;
  
//   function new(string name = "consumer", uvm_component parent);
//     super.new(name,parent);
//     get_port = new("get_port", this);
//   endfunction
  
//   virtual task run_phase(uvm_phase phase);
//   	simple_trans trans;
//     for(int i = 0; i < 2; i++) begin
//       `uvm_info(get_type_name(), "Get trans from producer", UVM_LOW);
//       get_port.get(trans);
//       `uvm_info(get_type_name(), "trans get is: ", UVM_LOW);
//       trans.print();
//       #10ns;
//     end
//   endtask 
// endclass



//===============
// Class env
//===============
// class env extends uvm_env;
//   `uvm_component_utils(env)
  
//   producer prod;
//   consumer cons;
  
//   function new(string name = "env", uvm_component parent = null);
//     super.new(name, parent);
//   endfunction
  
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     prod  = producer::type_id::create("prod", this);
//     cons = consumer::type_id::create("cons", this);
//   endfunction
  
//   function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     cons.get_port.connect(prod.get_export);
//   endfunction
// endclass

//===============
// Class test
//===============
// class test extends uvm_test;
//   `uvm_component_utils(test)
  
//   env my_env;
  
//   function new(string name = "test", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     `uvm_info(get_type_name(), "Enter Test ...", UVM_LOW);
//     my_env = env::type_id::create("my_env", this);
    
//   endfunction
  
//   task run_phase(uvm_phase phase);
//     phase.raise_objection(this);
//     #10ns;
//     phase.drop_objection(this);
  	
//   endtask
// endclass


//===============
//Top Module
//===============

// module top;
// 	initial begin
//       run_test();
//     end
// endmodule



//=======================================================
//Connect from monitor to scoreboard use analysis_port
// use 2 build_in method: uvm_analysis_port  (monitor)
//						  uvm_analysis_imp   (scoreboard)
//=======================================================
//=====================
//Class apb_transaction
//=====================
// class apb_transaction extends uvm_component;
//   `uvm_component_utils(apb_transaction)
  
//   function new(string name = "apb_transaction", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
// endclass


//=============
//Class Monitor
//=============
// class apb_monitor extends uvm_monitor;
//   `uvm_component_utils(apb_monitor)
  
//   uvm_analysis_port #(apb_transaction) item_observed_port;
  
//   function new(string name = "apb_monitor", uvm_component parent);
//     super.new(name,parent);
//     item_observed_port = new("item_observed_port", this);
//   endfunction
  
//   virtual function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//   endfunction
  
//   virtual task run_phase(uvm_phase phase);
//   	apb_transaction trans;
//     item_observed_port.write(trans);
//   endtask
  
// endclass


//================
//Class Scoreboard
//================
// class apb_scoreboard extends uvm_scoreboard;
//   `uvm_component_utils(apb_scoreboard);
  
//   uvm_analysis_imp #(apb_transaction,apb_scoreboard) item_collected_export;
  
//   function new(string name = "apb_scoreboard", uvm_component parent);
//     super.new(name,parent);
//     item_collected_export = new("item_collected_export", this);
//   endfunction
  
//   virtual function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//   endfunction
  
//   virtual task run_phase(uvm_phase phase);
//   endtask
  
//   virtual task write(apb_transaction trans);
//   endtask
// endclass



//================
//Class env
//================
// class env extends uvm_env;
//   `uvm_component_utils(env)
  
//   apb_monitor    mon;
//   apb_scoreboard sb;
  
//   function new(string name = "env", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   virtual function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
    
//     mon = apb_monitor::type_id::create("mon", this);
//     sb = apb_scoreboard::type_id::create("sb", this);
    
//   endfunction
  
//   virtual function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
    
//     mon.item_observed_port.connect(sb.item_collected_export);
    
//   endfunction
// endclass


//===============
// Class test
//===============
// class test extends uvm_test;
//   `uvm_component_utils(test)
  
//   env my_env;
  
//   function new(string name = "test", uvm_component parent);
//     super.new(name,parent);
//   endfunction
  
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     `uvm_info(get_type_name(), "Enter Test ...", UVM_LOW);
//     my_env = env::type_id::create("my_env", this);
    
//   endfunction
  
//   task run_phase(uvm_phase phase);
//     phase.raise_objection(this);
//     #10ns;
//     phase.drop_objection(this);
  	
//   endtask
// endclass


//===============
// Top Module
//===============

// module top;
// 	initial begin
//       run_test();
//     end
// endmodule




//===================================================================================================
//Config database
// syntax for store (Set): uvm_config_db #(type T = int)::set(uvm_component cntxt, string inst_name, string field_name, T value)
// Ex: uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top", "apb_vif", apb_if);
//syntax for retrieve (get): uvm_config_db #(type T = int)::get(uvm_component cntxt, string inst_name, inout T value);  Get return 1 if successfull, otherwise 0.
// Ex: if(!uvm_config_db #(virtual apb_if)::set(this, "", "apb_vif", apb_if))
//		`uvm_fatal("base_test", "failed to get apb_vif from apb_config_db")
//===================================================================================================

//=================
// Interface
//=================
interface apb_interface;
  logic PCLK;
  logic PRESETN;
  logic [31:0] PADDR;
  logic [31:0] PDATA;
  logic 	   PWRITE;
  
  initial begin
  	PCLK = 0;
    forever #5 PCLK = ~PCLK;
  end
endinterface

//===================
// Simple Transaction
//===================
typedef uvm_sequence_item apb_transaction;


//===================
// APB_Driver
//===================
class apb_driver extends uvm_driver #(apb_transaction);
  `uvm_component_utils(apb_driver)
  
  virtual apb_interface apb_vif;
  
  function new(string name = "apb_driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual apb_interface)::get(this, "", "apb_vif", apb_vif))
      `uvm_fatal(get_type_name(), "[Driver] Failed get apb_vif")
      else
        `uvm_info(get_type_name(), "[Driver] GOT apb_vif",UVM_LOW)
  endfunction
endclass


//===================
// APB_Monitor
//===================
class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  
  virtual apb_interface apb_vif;
  
  function new(string name = "apb_monitor", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual apb_interface)::get(this, "", "apb_vif", apb_vif))
      `uvm_fatal(get_type_name(), "[Monitor] Failed get apb_vif!")
      else 
        `uvm_info(get_type_name(), "[Monitor] GOT apb_vif",UVM_LOW)
  endfunction
  
endclass


//===================
// APB_Sequencer
//===================
class apb_sequencer extends uvm_sequencer #(apb_transaction);
  `uvm_component_utils(apb_sequencer)
  
  function new(string name = "apb_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction
endclass
  



//====================
// class agent
//====================
class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  
  virtual apb_interface apb_vif;
  
  apb_monitor   monitor;
  apb_driver    driver;
  apb_sequencer sequencer;
  
  function new(string name = "apb_agent", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual apb_interface)::get(this,"","apb_vif", apb_vif))
      `uvm_fatal(get_type_name(), "failed get apb_vif from db")
      
      if(is_active == UVM_ACTIVE) begin
        `uvm_info(get_type_name(), $sformatf("Active agent is configed"), UVM_LOW)
        
        monitor   = apb_monitor::type_id::create("monitor", this);
        driver    = apb_driver::type_id::create("driver", this);
        sequencer = apb_sequencer::type_id::create("sequencer", this);
        
        uvm_config_db #(virtual apb_interface)::set(this,"driver","apb_vif",apb_vif);
        uvm_config_db #(virtual apb_interface)::set(this,"monitor","apb_vif",apb_vif);
        
      end
    else begin
      `uvm_info(get_type_name(),$sformatf("passsive agent configued"),UVM_LOW)
    	monitor   = apb_monitor::type_id::create("monitor", this);
      
      uvm_config_db #(virtual apb_interface)::set(this,"monitor","apb_vif",apb_vif);
      
    end
  endfunction
  
endclass

//====================
// class env
//====================
class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  virtual apb_interface apb_vif;
  apb_agent apb_agt;
  
  function new(string name = "apb_env", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual apb_interface)::get(this,"", "apb_vif", apb_vif))
      `uvm_fatal(get_type_name(), $sformatf("failed to get apb_vif from config_db"))
    
      apb_agt = apb_agent::type_id::create("apb_agt",this);
    
	  uvm_config_db #(virtual apb_interface)::set(this, "apb_agt", "apb_vif", apb_vif);
    
    `uvm_info(get_type_name(), "build phase in env exiting...", UVM_LOW);
      
  endfunction
endclass

//====================
// class apb_base_test
//====================
class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)
  
  virtual apb_interface apb_vif;
  apb_env               env;
  
  function new(string name = "apb_base_test", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual apb_interface)::get(this,"","apb_vif", apb_vif))
      `uvm_fatal(get_type_name(), $sformatf("failed to get apb_vif form uvm_config_db"))
      
      env = apb_env::type_id::create("env", this);
    
    uvm_config_db #(virtual apb_interface)::set(this, "env", "apb_vif", apb_vif);
    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #10ns;
    `uvm_info(get_type_name(), $sformatf("Testing is finshing..."), UVM_LOW);
    phase.drop_objection(this);
  endtask
  
endclass



//=================
// module testbench
//=================
module testbench;
  
  apb_interface apb_if();
  
  initial begin
    uvm_config_db #(virtual apb_interface)::set(null, "uvm_test_top", "apb_vif", apb_if);
    run_test();
  end
endmodule




