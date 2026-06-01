class ram_coverage;

  //TRANSACTION HANDLE
  ram_trans  tr;

  //previous transaction type
  trans_kind_e prev_kind;

  //COVERGROUP
  covergroup ram_cg;

    option.per_instance = 1;

    //OPERATION TYPE COVERAGE
    cp_kind: coverpoint tr.kind_e {
      bins idle = {IDLE}; bins write = {WRITE}; bins read = {READ}; bins simrw = {SIM_RW};
    }

    //WRITE ENABLE COVERAGE
    cp_we: coverpoint tr.we {
      bins enable = {1}; bins disable_ = {0};
    }

    //READ ENABLE COVERAGE
    cp_re: coverpoint tr.re {
      bins enable = {1}; bins disable_ = {0};
    }

    //WRITE ADDRESS COVERAGE
    cp_waddr: coverpoint tr.waddr iff (tr.we) {
      bins addr[] = {[0 : 15]};
      bins low_range = {[0 : 3]};
      bins mid_range = {[4 : 11]};
      bins high_range = {[12 : 15]};
      bins first_addr = {0};
      bins last_addr = {15};
    }

    //READ ADDRESS COVERAGE
    cp_raddr: coverpoint tr.raddr iff (tr.re) {
      bins addr[] = {[0 : 15]};
      bins low_range = {[0 : 3]};
      bins mid_range = {[4 : 11]};
      bins high_range = {[12 : 15]};
      bins first_addr = {0};
      bins last_addr = {15};
    }

    //WRITE DATA COVERAGE
    cp_wdata: coverpoint tr.wdata iff (tr.we) {
      bins zero = {8'h00};
      bins low_range = {[8'h01 : 8'h3F]};
      bins mid_range = {[8'h40 : 8'hBF]};
      bins high_range = {[8'hC0 : 8'hFE]};
      bins max_value = {8'hFF};
    }

    //READ DATA COVERAGE
    cp_rdata: coverpoint tr.rdata iff (tr.re) {
      bins zero = {8'h00};
      bins low_range = {[8'h01 : 8'h3F]};
      bins mid_range = {[8'h40 : 8'hBF]};
      bins high_range = {[8'hC0 : 8'hFE]};
      bins max_value = {8'hFF};
    }

    //SAME ADDRESS COVERAGE
    cp_same_addr: coverpoint (tr.waddr == tr.raddr) iff (tr.we && tr.re) {
      bins same = {1}; bins diff = {0};
    }

    //TRANSITION COVERAGE
    cp_transition: coverpoint tr.kind_e {
      bins wr_to_rd = (WRITE => READ);
      bins rd_to_wr = (READ => WRITE);
      bins wr_to_idle = (WRITE => IDLE);
      bins idle_to_wr = (IDLE => WRITE);
      bins sim_to_wr = (SIM_RW => WRITE);
      bins sim_to_rd = (SIM_RW => READ);
      bins wr_to_wr = (WRITE => WRITE);
      bins rd_to_rd = (READ => READ);
      bins rd_to_sim = (READ => SIM_RW);
      bins wr_to_sim = (WRITE => SIM_RW);
      bins idle_to_rd = (IDLE => READ);
    }

    // CROSS COVERAGE

    //WRITE ENABLE vs WRITE ADDRESS
    cross_we_waddr : cross cp_we, cp_waddr{
      ignore_bins invalid = binsof (cp_we.disable_);
    }

    //READ ENABLE vs READ ADDRESS
    cross_re_raddr : cross cp_re, cp_raddr{
      ignore_bins invalid = binsof (cp_re.disable_);
    }

    //WRITE ENABLE vs WRITE DATA
    cross_we_wdata : cross cp_we, cp_wdata{
      ignore_bins invalid = binsof (cp_we.disable_);
    }

    //ALL ENABLE COMBINATIONS
    cross_we_re : cross cp_we, cp_re;

  endgroup

  //CONSTRUCTOR
  function new();
    ram_cg = new();
    prev_kind = IDLE;
  endfunction

  //SAMPLE COVERAGE
  task sample_coverage(ram_trans tr_h);
    this.tr = tr_h;
    ram_cg.sample();
    prev_kind = tr.kind_e;
  endtask

  //REPORT
  function void report();
    $display("======================================");
    $display(" FUNCTIONAL COVERAGE = %0.2f %% ", ram_cg.get_coverage());
    $display("======================================");
  endfunction

endclass
