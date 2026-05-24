import ram_pkg::*;

class ram_wr_rd_xtn extends ram_gen_base;

  task run();

    int i;

    ram_pkg::raise_objection();

    // WRITE
    for(i=1; i<=10; i++)
    begin

      `sv_do_with(trans,
      {
        kind_e == WRITE;        

        waddr  == i;
        raddr  == 0;
        wdata == (i*10);
      })

    end

    // READ
    for(i=1; i<=10; i++) begin

      `sv_do_with(trans,
      {
        kind_e == READ; 

        raddr  == i;
        waddr  == 0;
      })

    end

    ram_pkg::drop_objection();

  endtask

endclass
