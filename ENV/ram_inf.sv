///////////////////////////////////
//
//------------------HEADER--------------------- 
//FILE NAME: ram_inf.sv 
//AUTHOR NAME: Rohan Diwan
//INTERFACE NAME: ram_inf
//DESCRIPTION: This file contains the interface and modports for the project RAM_verification, it also defines a clocking block which will defining the input and output skew which will tell us when the sampling and driving will happen during posedge.
//Version: 2
//Date: 22-04-2026
//Time: 12:30 pm
//
/////////////////////////////////////

//Guard Statement to avoid multiple compilation of a file
`ifndef RAM_INF_SV
`define RAM_INF_SV
`include "ram_defines.sv"

interface ram_inf(input logic clk);

  // reset signal
  logic rst;

  // write channel consisting of write enable, write address and write data
  logic                     we;
  logic [(`ADDR_WIDTH-1):0] waddr;
  logic [(`DATA_WIDTH-1):0] wdata;

  // read channel consisting of read enable, read address and read data
  logic                     re;
  logic [(`ADDR_WIDTH-1):0] raddr;
  logic [(`DATA_WIDTH-1):0] rdata;
  logic [(`DATA_WIDTH-1):0] exp_rdata;

  // Clocking block for driver which tells us that input and output skew will be
  clocking drv_cb @(negedge clk);
    default input #1 output #0; //Here #1 is used to intriduce delay for sampling and driving in the driver block to avoid race conditions

    output rst; //Driving in dut
    output we, waddr, wdata; //Driving in dut
    output re, raddr; //Driving in dut
    input  rdata; //Sampling from dut

  endclocking

  // monitor view
  clocking mon_cb @(posedge clk);
    default input #1 output #1; //Here monitor only samples that is why we use #1 for input and no delay for ouput

    input rst; //Sampling from dut
    input we, waddr, wdata; //Sampling from dut
    input re, raddr, rdata; //Sampling from dut

  endclocking

  // modports
  modport DRV_MP (clocking drv_cb); //Modport definition for driver
  modport MON_MP (clocking mon_cb); //Modport definition for monitor

endinterface

`endif
