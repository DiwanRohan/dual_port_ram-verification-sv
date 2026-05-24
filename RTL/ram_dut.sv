///////////////////////////////////
//
//------------------HEADER--------------------- 
//FILE NAME: ram_dut.sv 
//AUTHOR NAME: Rohan Diwan
//MODULE NAME: ram_dut
//DESCRIPTION: This is the design file of dual port ram which gives the functionality of dual port ram
//Version: 2
//Date: 22-04-2026
//Time: 12:30 pm
//
/////////////////////////////////////

`include "ram_defines.sv"
module ram (clk,
            rst,
            we,
            waddr,
            wdata,
            re,
            raddr,
            rdata);

//port direction
  input clk, rst;

 //write signals
  input                   we;
  input [`ADDR_WIDTH-1:0] waddr;
  input [`DATA_WIDTH-1:0] wdata;

 //read signals
  input                        re;
  input      [`ADDR_WIDTH-1:0] raddr;
  output reg [`DATA_WIDTH-1:0] rdata;


 //internal memory
 reg [`DATA_WIDTH-1:0] ram [0:`DEPTH-1];

 reg [`ADDR_WIDTH:0] i;

 //implementation
 always@(posedge clk)
  if (rst) begin
     rdata <= `DATA_WIDTH'd0;
	 //memory initialisation
     for (i=0;i<`DEPTH;i=i+1) 
         ram[i] <= `DATA_WIDTH'd0;
  end
  else begin
    //write logic
     if (we)
        ram[waddr] <= wdata;
    //read logic
     if (re)
        rdata <= ram[raddr];
  end

endmodule
