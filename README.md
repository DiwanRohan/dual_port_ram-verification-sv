# Dual Port RAM Verification Environment

SystemVerilog-based verification environment for a Dual Port RAM supporting concurrent read/write operations, randomized transaction generation, scoreboard-based checking, assertions, and functional coverage-driven validation.

## Features
- Concurrent dual-port read/write verification
- Randomized and directed testcase support
- Modular generator-driver-monitor-scoreboard architecture
- In-order scoreboard with automated data comparison
- Functional coverage using covergroups and coverage bins
- Assertion-based protocol and stability checks
- Verification planning and coverage-driven testcase development
- Simulation automation using Makefiles and DO scripts

## Verification Components
- Transaction Generator
- Driver
- Input/Output Monitors
- Reference Model
- In-Order Scoreboard
- Functional Coverage Collector
- Assertions
- Environment Integration

## Verification Scenarios
- Simultaneous read/write operations
- Address collision handling
- Concurrent memory access validation
- Boundary address verification
- Memory data integrity checking
- Randomized traffic scenarios
- Corner-case testing

## Tools Used
- SystemVerilog
- ModelSim / QuestaSim
- Git & GitHub

## Repository Structure

```text
RTL/        -> DUT files
ENV/        -> Verification environment
TEST/       -> Testcases
SIM/        -> Simulation scripts and automation
DOCS/       -> Reports, waveforms, architecture diagrams
TOP/        -> Top-level integration
```

## Run Simulation

```bash
vsim -do run.do
```

## GitHub
Developed and maintained using modular and reusable verification methodology with scalable testcase architecture and debugging-driven validation flow.