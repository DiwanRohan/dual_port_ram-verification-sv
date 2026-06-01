class ram_cov_xtn extends ram_gen_base;

  int i;

  task run();

    ram_pkg::raise_objection();

    //IDLE
    repeat (10) begin

      `SV_DO_WITH(trans,
                  {
        kind_e == IDLE;
      })

    end

    //WRITE ALL ADDRESSES
    for (i = 0; i < 16; i++) begin

      `SV_DO_WITH(trans,
                  {
        kind_e == WRITE;

        waddr == i;

        // Explicitly hit all data bins
        if(i == 0)
          wdata == 8'h00;

        else if(i == 1)
          wdata == 8'h01;

        else if(i == 2)
          wdata == 8'h3F;

        else if(i == 3)
          wdata == 8'h40;

        else if(i == 4)
          wdata == 8'hBF;

        else if(i == 5)
          wdata == 8'hC0;

        else if(i == 6)
          wdata == 8'hFE;

        else if(i == 7)
          wdata == 8'hFF;

        else
          wdata inside {[8'h10:8'hEF]};
      })

    end

    //READ ALL ADDRESSES
    for (i = 0; i < 16; i++) begin

      `SV_DO_WITH(trans,
                  {
        kind_e == READ;

        raddr == i;
      })

    end

    //SIMULTANEOUS RW
    for (i = 0; i < 16; i++) begin

      `SV_DO_WITH(trans,
                  {
        kind_e == SIM_RW;

        waddr == i;
        raddr == i;

        wdata inside {[8'h00:8'hFF]};
      })

    end

    // FORCE ALL TRANSITIONS
    // WR -> RD
    repeat (5) begin

      `SV_DO_WITH(trans, {kind_e == WRITE;})
      `SV_DO_WITH(trans, {kind_e == READ;})

    end

    // RD -> WR
    repeat (5) begin

      `SV_DO_WITH(trans, {kind_e == READ;})
      `SV_DO_WITH(trans, {kind_e == WRITE;})

    end

    // WR -> IDLE
    repeat (5) begin

      `SV_DO_WITH(trans, {kind_e == WRITE;})
      `SV_DO_WITH(trans, {kind_e == IDLE;})

    end

    // IDLE -> WR
    repeat (5) begin

      `SV_DO_WITH(trans, {kind_e == IDLE;})
      `SV_DO_WITH(trans, {kind_e == WRITE;})

    end

    // SIM_RW -> WR
    repeat (5) begin

      `SV_DO_WITH(trans, {kind_e == SIM_RW;})
      `SV_DO_WITH(trans, {kind_e == WRITE;})

    end

    // SIM_RW -> RD
    repeat (5) begin

      `SV_DO_WITH(trans, {kind_e == SIM_RW;})
      `SV_DO_WITH(trans, {kind_e == READ;})

    end

    // IDLE -> RD
    repeat (5) begin

      `SV_DO_WITH(trans, {kind_e == IDLE;})
      `SV_DO_WITH(trans, {kind_e == READ;})

    end

    ram_pkg::drop_objection();

  endtask

endclass
