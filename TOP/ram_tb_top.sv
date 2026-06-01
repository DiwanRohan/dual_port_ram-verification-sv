`include "ram_if.sv"

module ram_tb_top;

  // import package
  import ram_pkg::*;

  // clock
  bit clk;

  // interface instance
  ram_if intf (clk);

  // test handle
  ram_base_test test;

  // clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // DUT instantiation
  ram DUT (
      .clk  (clk),
      .rst  (intf.rst),
      .we   (intf.we),
      .re   (intf.re),
      .waddr(intf.waddr),
      .raddr(intf.raddr),
      .wdata(intf.wdata),
      .rdata(intf.rdata)
  );

  task automatic apply_reset;

    $display("[%0t] APPLYING RESET", $time);

    // notify reset starting
    ->ram_pkg::reset_start_ev;

    intf.rst = 1;

    intf.we    = 0;
    intf.re    = 0;
    intf.waddr = 0;
    intf.raddr = 0;
    intf.wdata = 0;

    repeat (5) @(posedge clk);

    intf.rst = 0;

    @(posedge clk);

    $display("[%0t] RESET DEASSERTED", $time);

    // notify reset complete
    ->ram_pkg::reset_done_ev;

  endtask

  task automatic run_test();
    apply_reset();
    test = new();
    test.build();
    test.connect(intf);
    test.run();
    #0;
    wait (ram_pkg::raise_ctr == 0);
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
      $display(" =        =    =        =   =            =          ");
      $display(" =        =    =        =   =            =          ");
      $display(" ==========    ==========   ==========   ========== ");
      $display(" =             =        =            =            = ");
      $display(" =             =        =            =            = ");
      $display(" =             =        =            =            = ");
      $display(" =             =        =   ==========   ========== ");
    end else begin
      $display(" ==========   ==========    ==========   =          ");
      $display(" =            =        =        =        =          ");
      $display(" =            =        =        =        =         ");
      $display(" ==========   ==========        =        =          ");
      $display(" =            =        =        =        =          ");
      $display(" =            =        =        =        =          ");
      $display(" =            =        =        =        =          ");
      $display(" =            =        =    ==========   ===========");
    end
    $display("Pass_cnt = %0d", test.env.scb.pass_cnt);
    $display("Fail_cnt = %0d", test.env.scb.fail_cnt);
    test.env.cov.report();

  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

endmodule
