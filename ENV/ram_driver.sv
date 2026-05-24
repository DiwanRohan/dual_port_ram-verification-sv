///////////////////////////////////
//
//------------------HEADER--------------------- 
//FILE NAME: ram_driver.sv 
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: ram_driver
//DESCRIPTION: Driver responsible to takes transaction or sequence level activity(stimulus) coming from generator and convert it into the pin or system level activity.Driver drives the pin or system level activity via interface (bus) as per the protocol.It basically drives input data to design adhering to the protocol.
//Version: 2
//Date: 22-04-2026
//Time: 12:00 pm
//
/////////////////////////////////////
class ram_driver;

	// mailbox from generator
	local mailbox #(ram_trans) gen2drv_mbx;

	// virtual interface (driver view)
	virtual ram_inf.DRV_MP vif;

	// current transaction
	ram_trans trans_h;

  //event for marking driver done
  //event drv_done;

	// connect
	function void connect(mailbox #(ram_trans) gen2drv_mbx,virtual ram_inf.DRV_MP vif);
		this.gen2drv_mbx = gen2drv_mbx;
		this.vif         = vif;
	endfunction

	// main run loop
	task run();
    forever begin
      //trans_h = new();    
	    this.gen2drv_mbx.get(trans_h);
 		  this.send_to_dut(trans_h);
      //this.trans_h.print("DRIVER");
      -> drv_done;
    end
	endtask

	// drive one transaction
	task send_to_dut(ram_trans tr);
	
		@(vif.drv_cb);
    vif.drv_cb.we    <= tr.we;
    vif.drv_cb.waddr <= tr.waddr;
    vif.drv_cb.wdata <= tr.wdata;
  
    vif.drv_cb.re    <= tr.re;
    vif.drv_cb.raddr <= tr.raddr;

    //@(vif.drv_cb);
    //vif.drv_cb.we <= 0;
    //vif.drv_cb.re <= 0;
    
  endtask

  function void print(string id = "");
    this.trans_h.print(id);
  endfunction

		
endclass


/*
case(tr.kind_e)
			WRITE: begin
				vif.drv_cb.we <= 1;
				vif.drv_cb.re <= 0;
				vif.drv_cb.waddr <= tr.waddr;
				vif.drv_cb.wdata <= tr.wdata;
			end
			
			READ: begin
				vif.drv_cb.we <= 0;
				vif.drv_cb.re <= 1;
				vif.drv_cb.raddr <= tr.raddr;
			end
			
			SIM_RW: begin
				vif.drv_cb.we <= 1;
				vif.drv_cb.re <= 1;
				vif.drv_cb.waddr <= tr.waddr;
				vif.drv_cb.wdata <= tr.wdata;
				vif.drv_cb.raddr <= tr.raddr;
			end
			
			IDLE: begin
				vif.drv_cb.we <= 0;
				vif.drv_cb.re <= 0;
				end
		endcase

		@(vif.drv_cb);
    vif.drv_cb.we <= 0;
		vif.drv_cb.re <= 0;
		
		//tr.print("DRV");
	endtask
*/
