# SHA1-OptiFlow: Power & Performance Optimization

This project implements a complete logic synthesis and optimization flow for the `sha1_core` hardware module, using STcmos65 technology libraries. The goal is to perform a detailed analysis of Power, Performance, and Area (PPA) metrics and implement dynamic and static power reduction techniques.

## Project Structure
- `rtl/sha1_core/`: Contains the RTL source code and SDC timing constraints.
- `scripts/`: Contains the TCL scripts for synthesis and analysis.
- `tech/`: Contains the technology libraries (.db files) and setup configurations.
- `saved/`: Working directory for synthesis reports and simulation data.

## Prerequisites
- **Synopsys Design Compiler**: Logic synthesis.
- **Synopsys PrimeTime**: Static Timing Analysis and Power Analysis.
- **QuestaSIM**: Gate-level functional simulation for switching activity generation.

## Methodology

### Exercise 1: Baseline Synthesis
- **Objective**: Find the minimum clock period (multiples of 0.5 ns) satisfying Slack >= 0 and Area <= 24100.
- **Flow**: 
    1. Iterate with different clock periods in `sha1_core.sdc`.
    2. Synthesize using `synthesis.tcl`.
    3. Generate VCD trace via QuestaSIM.
    4. Extract PPA metrics with `pt_analysis.tcl`.

### Exercise 2: Power Optimization
- **2.1 Clock Gating**: Implementation of gating logic (Min width: 8, Max fanout: 32) using `compile_ultra -gate_clock`.
- **2.2 Multi-Vth Synthesis**: Leakage optimization using LVT/SVT/HVT cell mapping.

### Exercise 3: Custom Analysis
- Implementation of a custom TCL procedure to analyze critical timing paths and cell occurrences.

## Usage
To execute the synthesis flow:
```bash
dc_shell -f scripts/synthesis.tcl
