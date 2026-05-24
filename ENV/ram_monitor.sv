///////////////////////////////////
//
//------------------HEADER--------------------- 
//FILE NAME: ram_monitor.sv 
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: ram_monitor
//DESCRIPTION: Monitor is responsible to take pin or system level activity coming from bus (interface) and convert it into the transaction or sequence level activity.Monitor collect transaction or sequence level activity from interface (bus) as per the protocol.It basically sample/monitor interface data adhering to the protocol and send it to other component (i.e. scoreboard, reference model/predictor, coverage collector etc.)
//Version: 2
//Date: 22-04-2026
//Time: 3:00 pm
//
/////////////////////////////////////
class ram_monitor;

	// mailboxes
	mailbox #(ram_trans) mon2rm_mbx;    // to reference model
	mailbox #(ram_trans) mon2scb_mbx;   // to scoreboard 
  
	// virtual interface (monitor view)
	virtual ram_inf.MON_MP vif;

  // collected transaction
	ram_trans item_collected;

  function void build (mailbox #(ram_trans) mon2scb_mbx,mailbox #(ram_trans) mon2rm_mbx);   
    this.mon2scb_mbx= new();
    this.mon2rm_mbx = new();  
  endfunction

	//connect
	function void connect(mailbox #(ram_trans) mon2rm_mbx,
						mailbox #(ram_trans) mon2scb_mbx,
						virtual ram_inf.MON_MP vif);
		this.mon2rm_mbx  = mon2rm_mbx;
		this.mon2scb_mbx = mon2scb_mbx;
		this.vif         = vif;
	endfunction

	// run loop
	task run();
    forever begin	
      item_collected = new();
      dut2monitor();
      //this.item_collected.print("MONITOR");
      mon2rm_mbx.put(item_collected);
      mon2scb_mbx.put(item_collected);
     end
		
	endtask

	// sampling 
	task dut2monitor();

    // wait for clock edge (sampling phase)
    @(vif.mon_cb);
    item_collected.we = vif.mon_cb.we;
    item_collected.waddr = vif.mon_cb.waddr;
    item_collected.wdata = vif.mon_cb.wdata;

    item_collected.re = vif.mon_cb.re;
    item_collected.raddr = vif.mon_cb.raddr;
    item_collected.rdata = vif.mon_cb.rdata;

    if(item_collected.we && !item_collected.re)
      item_collected.kind_e = WRITE;

    else if(!item_collected.we && item_collected.re)
      item_collected.kind_e = READ;

    else if(item_collected.we && item_collected.re)
      item_collected.kind_e = SIM_RW;

    else
      item_collected.kind_e = IDLE;
    
  endtask

  function void print(string id = "");
    this.item_collected.print(id);
  endfunction


endclass
