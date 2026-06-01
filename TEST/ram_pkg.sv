///////////////////////////////////
//
//------------------HEADER--------------------- 
//FILE NAME: ram_base_test.sv 
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: ram_base_test
//DESCRIPTION: this includes all files of environment
//Version: 1
//Date: 21-04-2026
//Time: 10:00 am
//
/////////////////////////////////////

package ram_pkg;

  event reset_start_ev;
  event reset_done_ev;
  event drv_done;

  // definitions
  `include "ram_defines.sv"

  int raise_ctr = 0;

  function void raise_objection();
    raise_ctr++;
    $display("[OBJECTION] Raised -> count = %0d",raise_ctr);
  endfunction

  function void drop_objection();
    raise_ctr--;
    $display("[OBJECTION] Dropped -> count = %0d",raise_ctr);
  endfunction


  // base class
  `include "sv_sequence_item.sv"

  // transaction
  `include "ram_trans.sv"

  //testcases
  `include "ram_gen.sv"
  `include "ram_lrng_data_xtn.svh"
  `include "ram_hrng_data_xtn.svh"
  `include "ram_wr_rd_xtn.svh"
  `include "ram_cov_xtn.svh"


  
  //components
  `include "ram_driver.sv"
  `include "ram_monitor.sv"
  `include "ram_ref_model.sv"
  `include "ram_coverage.sv"
  `include "ram_scoreboard.sv"
  
  // environment
  `include "ram_env.sv"

  // test
  `include "ram_base_test.sv"

endpackage

