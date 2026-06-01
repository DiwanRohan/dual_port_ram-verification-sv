# =========================================================
# RAM VERIFICATION TB DO FILE
# =========================================================

# -------------------------
# USER CONFIGURATION
# -------------------------
set TESTNAME RAM_LRNG_DATA_TEST
set SEED random

# -------------------------
# CLEANUP STALE LOGS / LOCKS
# -------------------------
# Deletes old waveform databases so you don't get the "WLF file in use" warning
if [file exists vsim.wlf] { file delete -force vsim.wlf }

# -------------------------
# CREATE LIBRARY
# -------------------------
vlib work
vmap work work

# -------------------------
# COMPILE
# -------------------------
# Note: Ensure you have removed `include "../TEST/ram_pkg.sv"` from ram_tb_top.sv!
vlog -sv +acc -cover bcst \
+incdir+../ENV \
+incdir+../TEST \
+incdir+../TOP \
../TEST/ram_pkg.sv \
../RTL/*.sv \
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
if [file exists wave.do] { do wave.do }

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
# Updated '-htmldir' to '-output' to satisfy the QuestaSim 2024.1 compiler rules
vcover report \
-html ram_cov.ucdb \
-output cov_html

# -------------------------
# OPEN COVERAGE GUI
# -------------------------
vsim -viewcov ram_cov.ucdb

# =========================================================
# USAGE
# =========================================================
# vsim -do run.do
# =========================================================