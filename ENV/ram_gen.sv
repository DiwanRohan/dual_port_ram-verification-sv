///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: ram_gen.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: ram_gen
//DESCRIPTION: Responsible for stimulus/traffic (transaction items) generation and keep the same in mailbox which is further processed by driver i.e., stimulus generation could be through randomization (preferred), through a file, hardcoded values, DPI etc.
//Version: 1=2
//Date: 22-04-2026
//Time: 1:00 pm
//
/////////////////////////////////////
`include "ram_defines.sv"
;
import ram_pkg::*;
virtual class ram_gen_base;

  local mailbox #(ram_trans) gen2drv_mbx;

  rand int no_of_trans;

  //constraint NO_OF_TRANS_C {soft no_of_trans == 50;}

  ram_trans trans;

  function void connect(mailbox#(ram_trans) mbx);
    this.gen2drv_mbx = mbx;
  endfunction

  //abstract run
  pure virtual task run();

  protected task send_item();
    this.gen2drv_mbx.put(trans);
    //this.trans.print("GENERATOR");
    @(drv_done);
  endtask

  function void print(string id = "");
    this.trans.print(id);
  endfunction

endclass
