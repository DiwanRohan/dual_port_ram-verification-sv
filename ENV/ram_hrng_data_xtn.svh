import ram_pkg::*;
class ram_hrng_data_xtn extends ram_gen_base;

  task run();
    repeat (`NUM_TRANSACTIONS) begin
      //trans = new()
      `SV_DO_WITH(trans, {wdata > 150;})

    end
  endtask

endclass
