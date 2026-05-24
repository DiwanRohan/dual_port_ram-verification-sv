///////////////////////////////////
//
//------------------HEADER--------------------- 
//FILE NAME: ram_base_test.sv 
//AUTHOR NAME: Rohan Diwan
//CLASS NAME: ram_base_test
//DESCRIPTION: The ram_base_test class acts as the top-level control layer of the verification environment. It is responsible for creating and managing the environment, and coordinating the overall simulation flow.It holds a handle to the environment (ram_env) and a virtual interface, which is passed from the top module. The virtual interface allows the test to indirectly connect lower-level components like the driver and monitor to the DUT signals.
//Version: 1
//Date: 21-04-2026
//Time: 10:00 am
//
/////////////////////////////////////

class ram_base_test;

  ram_env env;
  virtual ram_inf vif;

  // Multiple testcases
  ram_lrng_data_xtn lxtn;
  ram_hrng_data_xtn hxtn;
  ram_wr_rd_xtn     wrxtn;
  ram_cov_xtn       covxtn;

  function void connect(virtual ram_inf vif);
    this.vif = vif;
    env.connect(vif);
  endfunction

  function void build();

    env = new();

    env.build();
        
    `sv_do_on(RAM_LRNG_DATA_TEST,lxtn)
    
    `sv_do_on(RAM_HRNG_DATA_TEST,hxtn)

    `sv_do_on(WR_RD_TEST, wrxtn)

    `sv_do_on(COV_TEST, covxtn);

    `sv_do_on_with(RAM_HRNG_DATA_TEST,hxtn,{no_of_trans==30;})   

  endfunction


  task run();

    $display("\n=== TEST START ===");
    
    fork
      env.run();      
    join_none
    #0;
    
  endtask
  		
endclass
