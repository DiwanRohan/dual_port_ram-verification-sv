///////////////////////////////////
//
//------------------HEADER--------------------- 
//FILE NAME: ram_env.sv 
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: ram_env
//DESCRIPTION: It takes handles of all the verification sub-components, it decalres all the mailboxes, and all the interfaces, it creates everything using the method build, it then takes connect method to call the verification sub-components and finally using the run method it makes all the verification sub-components to run task in parallel
//Version: 2
//Date: 22-04-2026
//Time: 6:00 pm
//
/////////////////////////////////////
class ram_env;

	// components
	ram_gen_base   gen;
	ram_driver     drv;
	ram_monitor    mon;
	ram_ref_model  rm;
	ram_scoreboard scb;
  ram_coverage   cov;

	// virtual interface
	virtual ram_inf.DRV_MP vif;
  virtual ram_inf.MON_MP vifm;

	// mailboxes
	mailbox #(ram_trans) gen2drv_mbx;
	mailbox #(ram_trans) mon2rm_mbx;
	mailbox #(ram_trans) mon2scb_mbx;
	mailbox #(ram_trans) rm2scb_mbx;

  //Events
  //event drv_done;

	
	// build
	function void build();

		//create objects
    drv = new();
		mon = new();
		rm  = new();
		scb = new();
    cov = new();
    
		
		// create mailboxes
		gen2drv_mbx  = new();
		mon2rm_mbx   = new();
		mon2scb_mbx  = new();
		rm2scb_mbx   = new();

	endfunction

	// connect
	function void connect(virtual ram_inf vif);
    this.vif = vif;
    this.vifm = vif;
    gen.connect(gen2drv_mbx);  
    drv.connect(gen2drv_mbx, vif);
    mon.connect(mon2rm_mbx, mon2scb_mbx, vif);
    rm.connect(mon2rm_mbx, rm2scb_mbx);
    scb.connect(mon2scb_mbx, rm2scb_mbx, cov);
    
  endfunction

	// run
  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      rm.run();
      scb.run();
    join_none

  endtask

endclass


   
  
