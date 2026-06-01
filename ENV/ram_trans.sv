///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: ram_trans.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: ram_trans
//DESCRIPTION: This is the transaction packet of the SV Environment which is responsible for defining the rand variables for inputs to dut and constraints on them while also defining all the other ports.
//Version: 1
//Date: 21-04-2026
//Time: 10:00 am
//
/////////////////////////////////////

`ifndef RAM_TRANS_SV
`define RAM_TRANS_SV
`include "ram_defines.sv"
typedef enum bit [1:0] {
  IDLE,
  WRITE,
  READ,
  SIM_RW
} trans_kind_e;
//Child class consisting all the methods of class sv_sequence_item which are copy, clone, print
class ram_trans extends sv_sequence_item;

  // type of operation
  //Creating variable of type trans_kind_e which consists of {WRITE, READ, SIM_RW, IDLE}
  rand trans_kind_e kind_e;

  // Read and write addresses
  //This is drived using the driver so can be randomized in generator
  rand bit [`ADDR_WIDTH-1:0] waddr;
  //This is drived using the driver so can be randomized in generator
  rand bit [`ADDR_WIDTH-1:0] raddr;

  // data
  //This is drived using the driver so can be randomized in generator
  rand bit [`DATA_WIDTH-1:0] wdata;
  bit [`DATA_WIDTH-1:0] rdata;//This is output so no rand
  //This is determined in the reference model and is output so no rand
  bit [`DATA_WIDTH-1:0] exp_rdata;
  bit rst = 0;
  bit we;
  bit re;

  //Constraint for kind of transactions to be generated for dut
  constraint kind_dist_c {

    kind_e dist {

      WRITE  := 30,
      READ   := 30,
      SIM_RW := 20,
      IDLE   := 20
    };
  }

  function void copy(sv_sequence_item rhs);  //This is deep copy for handle
    ram_trans t;

    if (!$cast(t, rhs)) return;  //This is just safety just in case

    this.we        = t.we;
    this.re        = t.re;
    this.waddr     = t.waddr;
    this.raddr     = t.raddr;
    this.wdata     = t.wdata;
    this.rdata     = t.rdata;
    this.exp_rdata = t.exp_rdata;
  endfunction

  function ram_trans clone();
    ram_trans t = new();
    t.copy(this);
    return t;
  endfunction

  function void post_randomize();

    case (kind_e)

      WRITE: begin
        we = 1;
        re = 0;
      end

      READ: begin
        we = 0;
        re = 1;
      end

      SIM_RW: begin
        we = 1;
        re = 1;
      end

      IDLE: begin
        we = 0;
        re = 0;
      end

      default: begin
        we = 0;
        re = 0;
      end

    endcase
  endfunction


  function void print(string id);
    $display("|----------------------------------|");
    $display("|----------TIME: %0t --------------|", $time);
    $display("|----------------------------------|");
    $display("|----------ID :   %s --------------|", id);
    $display("|----------RST:  %0d --------------|", this.rst);
    $display("|----------------------------------|");
    $display("|-------WADDR: %0d  -------------|", this.waddr);
    $display("|--------------------------------|");
    $display("|-------WDATA: %0d  -------------|", this.wdata);
    $display("|--------------------------------|");
    $display("|-------WE: %0d   ---------------|", this.we);
    $display("|--------------------------------|");
    $display("|-------RE: %0d   ---------------|", this.re);
    $display("|--------------------------------|");
    $display("|-------RADDR: %0d  -------------|", this.raddr);
    $display("|--------------------------------|");
    $display("|-------RDATA: %0d  -------------|", this.rdata);
    $display("|-------EXP_RDATA: %0d  ---------|", this.exp_rdata);
    $display("|----------------------------------|");
    $display("");
    $display("");
  endfunction

endclass

`endif
