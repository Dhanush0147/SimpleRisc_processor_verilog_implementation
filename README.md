Simple RISC Processor – RTL & Simulation Guide
This project implements a modular Simple RISC Processor in Verilog using Vivado. The design includes core datapath, control, and memory interface modules, along with testbenches for simulation.

📁 Directory Structure
🔧 RTL Source Files (src/)
Module File	Description
tiny_risc.v	🔝 Top module for synthesis and simulation
ALU & Arithmetic	ALU.v, Adder.v, Adder_Subtracter.v, Full_Adder.v, div.v, division.v, mod.v, mul.v
Shifter & Logic	ushifter.v, logic_block.v
Control & Flags	control.v, flag.v
Data Movement	mov.v, mem_to_wr.v, registerfile.v
Pipeline Registers	if_of_pipo.v, of_ex_pipo.v, ex_to_mr.v
Fetch & Decode	instruction_fetch.v, of_unit.v, imm_btarget.v
Execution & Branching	execution_unit.v, execution_pipeline.v, branch_unit.v, branch_mux.v
Selectors & MUX	mux_2x1.v, mux_4x1.v, selector_32.v, selector_4.v

🧪 Simulation Files (simulation/)
Testbench File	Description
tiny_risc_tb.v	🔝 Top-level testbench for full processor simulation
Module Testbenches	control_tb.v, exe_tb.v, if_of_pipo_tb.v, execution_pipeline_tb.v, registerfile_tb.v, of_unit_tb.v, ushifter_tb.v, writebck.v
Utilities	stimuli.v, testbench.v

🛠️ Using in Vivado
For Synthesis:
Add all RTL source files.

Set tiny_risc.v as the Top Module.

For Simulation:
Add all RTL source files + simulation testbenches.

Set tiny_risc_tb.v as the Simulation Top Module.

