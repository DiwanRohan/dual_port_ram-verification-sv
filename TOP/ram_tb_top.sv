`include "ram_inf.sv"
`include "ram_pkg.sv"

module ram_tb_top;

	// import package
	import ram_pkg::*;

	// clock
	bit clk;

	// interface instance
	ram_inf inf(clk);

	// test handle
	ram_base_test test;

	// clock generation
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	// DUT instantiation
	ram DUT (
		.clk   (clk),
		.rst   (inf.rst),
		.we    (inf.we),
		.re    (inf.re),
		.waddr (inf.waddr),
		.raddr (inf.raddr),
		.wdata (inf.wdata),
		.rdata (inf.rdata)
	);

  task apply_reset();

    $display("[%0t] APPLYING RESET", $time);

    // notify reset starting
    -> ram_pkg::reset_start_ev;

    inf.rst = 1;

    inf.we    = 0;
    inf.re    = 0;
    inf.waddr = 0;
    inf.raddr = 0;
    inf.wdata = 0;

    repeat(5) @(posedge clk);

    inf.rst = 0;

    @(posedge clk);

    $display("[%0t] RESET DEASSERTED", $time);

    // notify reset complete
    -> ram_pkg::reset_done_ev;

  endtask

   task run_test();
     apply_reset();
     test=new();  
     test.build();
     test.connect(inf);
     test.run();
     #0;
     wait(ram_pkg::raise_ctr==0);
     $display("=== TEST END ===\n");
     $finish;
  endtask

	// test flow
  initial begin
    run_test();

    /*if(env.scb.fail_cnt>0) begin
        test.env.gen.print("GEN");
        test.env.drv.print("DRV");
        test.env.mon.print("MON");
        test.env.rm.print("REF");
        test.env.scb.print("SCB_ACT","SCB_EXP");
        //test.env.gen.print("GEN");
    end
   */ 
  end
   
  final begin     
      if ((test.env.scb.fail_cnt == 0) && (test.env.scb.pass_cnt > 0)) begin
         $display(" ==========    ==========   ==========   ========== ");
         $display(" =        =    =        =   =            =	         ");  
         $display(" =        =    =        =   =            =          ");  
	       $display(" ==========    ==========   ==========   ========== ");
	       $display(" =             =        =            =            = ");
         $display(" =             =        =            =            = ");  
         $display(" =             =        =            =            = "); 
	       $display(" =             =        =   ==========   ========== ");  
	    end
      else begin
         $display(" ==========   ==========    ==========   =          ");
         $display(" =            =        =        =        =          "); 
         $display(" =            =        =        =        =	         "); 
	       $display(" ==========   ==========        =        =          "); 
	       $display(" =            =        =        =        =          "); 
         $display(" =            =        =        =        =	         "); 
         $display(" =            =        =        =        =	         ");    
	       $display(" =            =        =    ==========   ===========");
      end
      $display("Pass_cnt = %0d",test.env.scb.pass_cnt);
      $display("Fail_cnt = %0d",test.env.scb.fail_cnt);
      test.env.cov.report();
      
	  end  

  initial begin
      $dumpfile("dump.vcd");    
      $dumpvars();
    end

endmodule	
