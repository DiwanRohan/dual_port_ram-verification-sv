
///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: ram_scoreboard.sv
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: ram_scoreboard
//DESCRIPTION: Scoreboard is responsible to check whether your design output is correct or not.It's collects expected value from reference model, actual value from monitor and compare those values and log the status.Functional Coverage can be part of Scoreboard
//Version: 2
//Date: 22-04-2026
//Time: 5:00 pm
//
/////////////////////////////////////
class ram_scoreboard;

  // mailboxes
  mailbox #(ram_trans) mon2scb_mbx;  // actual path
  mailbox #(ram_trans) rm2scb_mbx;  // expected path

  // transaction handles
  ram_trans act_tr, exp_tr;
  ram_coverage cov;

  //Error count
  int pass_cnt, fail_cnt;

  int total_seen;


  //Queues for storing actual and expected
  ram_trans act_q[$];
  ram_trans exp_q[$];

  //connect
  function void connect(mailbox#(ram_trans) mon2scb_mbx, mailbox#(ram_trans) rm2scb_mbx,
                        ram_coverage cov);
    this.mon2scb_mbx = mon2scb_mbx;
    this.rm2scb_mbx = rm2scb_mbx;
    this.cov = cov;
  endfunction

  // main loop
  task run();
    fork

      forever begin
        mon2scb_mbx.get(act_tr);
        act_q.push_back(act_tr);
      end

      forever begin
        rm2scb_mbx.get(exp_tr);
        exp_q.push_back(exp_tr);
      end

      forever begin
        wait (act_q.size() > 0 && exp_q.size() > 0);

        act_tr = act_q.pop_front();
        exp_tr = exp_q.pop_front();

        total_seen++;

        if (act_tr.rdata !== 0 && exp_tr.rdata !== 0) compare(act_tr, exp_tr);
        //this.act_tr.print("SCB");

        cov.sample_coverage(act_tr);
      end
    join_none

  endtask

  // comparison logic
  task compare(ram_trans act, ram_trans exp);

    if (act.re) begin

      if (act.rdata === exp.exp_rdata) begin
        pass_cnt++;
        //$display("[SCB PASS] RDATA=%0d EXPECTED=%0d", act.rdata,exp.exp_rdata);
      end else begin
        fail_cnt++;
        $display("[SCB FAIL] RDATA=%0d EXPECTED=%0d", act.rdata, exp.exp_rdata);
        //exp.print("SCB_EXP");
        act.print("SCB_ACT");
      end
    end

  endtask

  function void report();
    $display("PASS count = %0d", pass_cnt);
    $display("FAIL count = %0d", fail_cnt);
  endfunction

  function void print(string id1 = "", string id2 = "");
    this.act_tr.print(id1);
    this.exp_tr.print(id2);
  endfunction


endclass
