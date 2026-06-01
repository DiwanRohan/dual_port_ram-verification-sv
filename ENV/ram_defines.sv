///////////////////////////////////
//
//------------------HEADER---------------------
//FILE NAME: ram_defines.sv
//AUTHOR NAME: Rohan Diwan
//MODULE NAME: definitions
//DESCRIPTION: All the definitons are placed over here
//Version: 2
//Date: 22-04-2026
//Time: 12:00 pm
//
/////////////////////////////////////
`ifndef RAM_DEFINES_SV
`define RAM_DEFINES_SV

// ADDRESS WIDTH
`define ADDR_WIDTH 4

// DERIVED PARAMETERS
`define DATA_WIDTH 8
`define DEPTH (1 << `ADDR_WIDTH)


// TEST CONTROL
`define NUM_TRANSACTIONS 10000


`define SV_DO_WITH(OBJ, CNSTR) \
OBJ = new();\
trans = OBJ;\
if (!OBJ.randomize() with CNSTR) \
  $error("Randomization Failed!"); \
send_item();

`define SV_DO(OBJ) \
OBJ = new();\
trans = OBJ;\
if (!OBJ.randomize()) \
  $error("Randomization Failed!"); \
send_item();

`define SV_DO_ON(TEST_NAME, TEST_OBJ_NAME) \
if ($test$plusargs(`"TEST_NAME`")) begin\
  TEST_OBJ_NAME = new();\
  void'(``TEST_OBJ_NAME``.randomize()); \
  env.gen = ``TEST_OBJ_NAME``; \
end

`define SV_DO_ON_WITH(TEST_NAME, TEST_OBJ_NAME, CNSTR) \
if ($test$plusargs(`"TEST_NAME`")) begin \
  TEST_OBJ_NAME = new(); \
  void'(``TEST_OBJ_NAME``.randomize() with ``CNSTR``);  \
   env.gen = ``TEST_OBJ_NAME``; \
end

`endif
