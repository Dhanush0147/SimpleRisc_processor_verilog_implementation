# Simple RISC Processor – RTL & Simulation Guide

This project implements a modular **Simple RISC Processor** in Verilog using Vivado. It includes all core datapath, control, and pipeline components, along with testbenches for verification.

---

## 📁 Directory Structure

### 🔧 RTL Source Files (`src/`)

These files contain the synthesizable Verilog modules for the processor:

- **Top Module**
  - `tiny_risc.v` → 🔝 **Top module for synthesis and simulation**

- **Arithmetic & ALU**
  - `ALU.v`
  - `Adder.v`
  - `Adder_Subtracter.v`
  - `Full_Adder.v`
  - `div.v`
  - `division.v`
  - `mod.v`
  - `mul.v`

- **Logic & Shifting**
  - `logic_block.v`
  - `ushifter.v`

- **Control & Flag**
  - `control.v`
  - `flag.v`

- **Data Movement**
  - `mov.v`
  - `mem_to_wr.v`
  - `registerfile.v`

- **Instruction Flow & Decoding**
  - `instruction_fetch.v`
  - `imm_btarget.v`
  - `of_unit.v`

- **Pipeline Registers**
  - `if_of_pipo.v`
  - `of_ex_pipo.v`
  - `ex_to_mr.v`

- **Execution & Branching**
  - `execution_unit.v`
  - `execution_pipeline.v`
  - `branch_unit.v`
  - `branch_mux.v`

- **Multiplexers & Selectors**
  - `mux_2x1.v`
  - `mux_4x1.v`
  - `selector_32.v`
  - `selector_4.v`

---

### 🧪 Simulation Files (`simulation/`)

Use these for testing and verifying individual modules or full processor functionality:

- **Top-Level Testbench**
  - `tiny_risc_tb.v` → 🔝 **Top module for simulation**

- **Module-Specific Testbenches**
  - `control_tb.v`
  - `exe_tb.v`
  - `execution_pipeline_tb.v`
  - `if_of_pipo_tb.v`
  - `of_unit_tb.v`
  - `registerfile_tb.v`
  - `ushifter_tb.v`
  - `writebck.v`

- **Utility Files**
  - `stimuli.v`
  - `testbench.v`

---

## ⚙️ Running in Vivado

### For Synthesis:
1. Create a Vivado project.
2. Add all **RTL files** from `src/`.
3. Set **`tiny_risc.v`** as the **Top Module**.
4. Run synthesis, implementation, and generate bitstream.

### For Simulation:
1. Create a Vivado project.
2. Add all **RTL files** from `src/`.
3. Add simulation files from `simulation/`.
4. Set **`tiny_risc_tb.v`** as the **Simulation Top Module**.
5. Run behavioral simulation.

---

## 👥 Contributors

- [Dhanush](https://github.com/Dhanush0147)
- [Korak](https://github.com/KorakBasu)

---

For bugs, enhancements, or contributions – feel free to open an issue or pull request!
