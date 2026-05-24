# =========================================================
# RAM VERIFICATION TB DO FILE
# =========================================================

# -------------------------
# USER CONFIGURATION
# -------------------------
set TESTNAME RAM_LRNG_DATA_TEST
set SEED random

# -------------------------
# CREATE LIBRARY
# -------------------------
vlib work
vmap work work

# -------------------------
# COMPILE
# -------------------------
vlog -sv +acc -cover bcst \
+incdir+../ENV \
+incdir+../TEST \
+incdir+../TOP \
../RTL/*.sv \
../TEST/ram_pkg.sv \
../TOP/ram_tb_top.sv
# -------------------------
# START SIMULATION
# -------------------------
vsim -coverage \
-sv_seed $SEED \
work.ram_tb_top \
+$TESTNAME

# -------------------------
# ADD WAVES
# -------------------------
#add wave -r /*
do wave.do

# -------------------------
# OPTIONAL RADIX
# -------------------------
radix hex

# -------------------------
# RUN SIMULATION
# -------------------------
run -all

# -------------------------
# SAVE COVERAGE
# -------------------------
coverage save ram_cov.ucdb

# -------------------------
# HTML COVERAGE REPORT
# -------------------------
vcover report \
-html ram_cov.ucdb \
-htmldir cov_html

# -------------------------
# OPEN COVERAGE GUI
# -------------------------
vsim -viewcov ram_cov.ucdb

# =========================================================
# USAGE
# =========================================================
# vsim -do run.do
#
# OR
#
# questa -do run.do
#
# Change:
#   set TESTNAME WR_RD_TEST
#   set SEED 25
#
# as needed
# =========================================================


