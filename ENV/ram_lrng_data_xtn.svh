import ram_pkg::*;
`include "ram_defines.sv"
class ram_lrng_data_xtn extends ram_gen_base;

  task run();
    ram_pkg::raise_objection();
    repeat (`NUM_TRANSACTIONS) begin
      //trans = new();
      //if (!trans.randomize() with {wdata < 100;}) //randomize to generate traffic
      //$error("Randomization Failed!");

      `SV_DO(trans)
      //send_item();

      //this.gen2drv_mbx.put(trans);
      //this.trans.print("GEN");
      // @(drv_done);
    end
    ram_pkg::drop_objection();
  endtask

endclass
