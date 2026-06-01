///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: ram_ref_model.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: ram_ref_model
//DESCRIPTION: Reference model is a verification component where you write a logic to generate expected output (checker logics). (Predicting the output). Also known as predictor.
//Version: 2
//Date: 22-04-2026
//Time: 4:00 pm
//
/////////////////////////////////////
class ram_ref_model;

  // mailboxes
  mailbox #(ram_trans) mon2rm_mbx;
  mailbox #(ram_trans) rm2scb_mbx;

  // transaction handles
  ram_trans trans_h;

  // reference memory
  reg [`DATA_WIDTH-1:0] ram[`DEPTH];
  reg [`ADDR_WIDTH:0] i;
  bit [`DATA_WIDTH-1:0] prev_exp_rdata;
  bit [`ADDR_WIDTH-1:0] prev_raddr;
  bit prev_re;

  //function void build (mailbox #(ram_trans) mon2rm_mbx, mailbox #(ram_trans) rm2scb_mbx);
  //this.mon2rm_mbx=new();
  // this.rm2scb_mbx=new();
  //endfunction

  // connect
  function void connect(mailbox#(ram_trans) mon2rm_mbx, mailbox#(ram_trans) rm2scb_mbx);
    this.mon2rm_mbx = mon2rm_mbx;
    this.rm2scb_mbx = rm2scb_mbx;
  endfunction

  // main run loop
  task run();
    forever begin

      this.mon2rm_mbx.get(trans_h);
      predict_exp_rdata(trans_h);
      this.rm2scb_mbx.put(trans_h);
      //this.trans_h.print("REF Model");
    end

  endtask


  // predictor
  task predict_exp_rdata(ram_trans t);

    // assign PREVIOUS cycle expected
    t.exp_rdata = prev_exp_rdata;

    if (t.rst) begin

      prev_exp_rdata = 0;

      for (i = 0; i < `DEPTH; i++) ram[i] = 0;

    end else begin

      // compute NEXT expected
      if (t.re) prev_exp_rdata = ram[t.raddr];

      // write
      if (t.we) ram[t.waddr] = t.wdata;

    end
  endtask

  function void print(string id = "");
    this.trans_h.print(id);
  endfunction


endclass
