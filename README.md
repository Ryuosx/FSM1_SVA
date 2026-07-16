# FSM Verification using SystemVerilog Interface & Clocking Block

## Overview

This project demonstrates the verification of a **Finite State Machine (FSM)** using **SystemVerilog Interfaces** and **Clocking Blocks**. The design implements an FSM responsible for generating memory read addresses, controlling a six-stage processing pipeline, and indicating completion after an entire frame of data has been processed.

The verification environment makes use of:

- SystemVerilog Interface
- Clocking Block
- Modports
- SystemVerilog Assertions (SVA)
- Functional Coverage through Cover Properties

---

## Project Structure

```
.
├── README.md
├── dut.sv          // FSM Design (DUT)
├── interface.sv    // Interface with Clocking Block
├── tb.sv           // Testbench
└── top.sv          // Top module
```

---

## Files Description

### `dut.sv`

Contains the FSM Design Under Test (DUT).

Features:

- 16-state finite state machine
- 64-byte address generation
- 4096 block counter
- Pipeline control signal generation
- Read address generation
- Frame completion detection
- SystemVerilog Assertions
- Functional Coverage

Control signals generated include:

- `rd`
- `sipo_en`
- `latch_en`
- `dp1_en`
- `dp2_en`
- `dp3_en`
- `dp4_en`
- `wr`
- `done_frame`

---

### `interface.sv`

Defines the communication between DUT and Testbench.

Contains:

- Shared interface signals
- Clocking Block
- Modport for Testbench

Clocking Block:

```systemverilog
clocking cb @(posedge clk);
    output get_data, data;
    input sipo_en;
    input latch_en;
    input dp1_en;
    input dp2_en;
    input dp3_en;
    input dp4_en;
    input wr;
    input done_frame;
    input rd_addr;
    input rd;
endclocking
```

The clocking block ensures synchronized driving and sampling of signals, eliminating race conditions between the DUT and the testbench.

---

### `tb.sv`

Implements the testbench.

Responsibilities:

- Generates reset sequence
- Drives `get_data`
- Stimulates the DUT through the clocking block
- Demonstrates synchronized signal driving

Reset Sequence:

```text
reset = 1
↓
reset = 0
↓
reset = 1
```

Stimulus:

- Initiates one complete frame transfer
- Triggers another transfer after completion

---

### `top.sv`

Top-level module.

Responsibilities:

- Generates clock
- Instantiates interface
- Instantiates FSM DUT
- Instantiates testbench
- Connects all modules together

Clock Generation:

```systemverilog
initial
    forever #5 clk = ~clk;
```

Clock Period:

```
10 time units
```

---

## FSM Operation

The FSM transitions through the following sequence:

```
IDLE
   │
   ▼
GEN_BLK_ADDR
   │
   ▼
WAIT0
   │
   ▼
CNT1
   │
   ▼
WAIT1
   │
   ▼
CNT2
   │
   ▼
WAIT2
   │
   ▼
CNT3
   │
   ▼
WAIT3
   │
   ▼
CNT4
   │
   ▼
WAIT4
   │
   ▼
CNT5
   │
   ▼
WAIT5
   │
   ▼
CNT6
   │
   ▼
DLY
   │
   ▼
NEXT_BLK
```

The cycle repeats until all **4096 blocks** have been processed.

---

## Address Generation

Address generation uses:

- **6-bit address counter**
- **12-bit block counter**

Read address:

```
rd_addr = {blk_cnt, addr_cnt}
```

Resulting address width:

```
18 bits
```

---

## SystemVerilog Assertions

The design contains several assertions to verify FSM correctness.

### One-Hot State Encoding

Verifies that only one state is active at a time.

```systemverilog
$countones(n_state) == 1
```

---

### State Transition Verification

Checks:

- IDLE → GEN_BLK_ADDR
- GEN_BLK_ADDR runs for 64 cycles
- Correct transition to WAIT0

---

### Pipeline Sequence Verification

Ensures correct execution order:

```
CNT1
↓

CNT2
↓

CNT3
↓

CNT4
↓

CNT5
↓

CNT6
```

---

### Frame Verification

Checks:

- Complete frame transfer
- Proper state progression
- Frame completion

---

### Complete Frame Assertion

Verifies:

```
done_frame == 1
```

after all **4096 blocks** are processed.

---

## Clocking Block Benefits

Using the clocking block provides:

- Eliminates race conditions
- Synchronizes DUT and Testbench
- Cleaner timing behavior
- Easier signal driving
- Improved readability
- Better verification methodology

---

## Simulation Flow

```
Clock Generation
        │
        ▼
Reset Sequence
        │
        ▼
Drive get_data
        │
        ▼
FSM begins operation
        │
        ▼
Generate 64 addresses
        │
        ▼
Pipeline processing
        │
        ▼
Next Block
        │
        ▼
Repeat for 4096 blocks
        │
        ▼
done_frame asserted
```

---

## How to Simulate

### Compile

```sh
vlog interface.sv dut.sv tb.sv top.sv
```

### Simulate

```sh
vsim fsm_top
```

### Run Simulation

```sh
run -all
```

---

## Expected Behavior

- Reset initializes the FSM to `IDLE`.
- Assertion of `get_data` starts frame processing.
- The FSM generates **64 read addresses** for each block.
- Pipeline enable signals (`latch_en`, `dp1_en`–`dp4_en`, `wr`) are asserted in sequence.
- The block counter increments after each completed block.
- After processing **4096 blocks**, `done_frame` is asserted and the FSM returns to `IDLE`.

---

## Concepts Demonstrated

- SystemVerilog Interfaces
- Clocking Blocks
- Modports
- Finite State Machine (FSM)
- Address Generation
- Pipeline Control
- SystemVerilog Assertions (SVA)
- Cover Properties
- Functional Verification
- Race-Free Testbench Design

---


