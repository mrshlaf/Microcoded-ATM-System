# 🏧 Microcoded ATM System: FPGA-Based Security SoC

![Language](https://img.shields.io/badge/Language-VHDL-blue?style=for-the-badge&logo=vhdl)
![Platform](https://img.shields.io/badge/Platform-Intel%20DE1--SoC-red?style=for-the-badge&logo=intel)
![Tools](https://img.shields.io/badge/Tools-Quartus%20Prime%20%7C%20ModelSim-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)

> **Final Project - Digital System Design (PSD)**
> *Department of Electrical Engineering, Faculty of Engineering, Universitas Indonesia*

---

## 📖 Executive Summary

This project implements a fully functional **Microcoded ATM Controller** on an FPGA architecture. Moving beyond traditional software-based microcontrollers, this system utilizes a **System-on-Chip (SoC)** approach where the control logic, memory, and arithmetic processing are synthesized directly into hardware gates.

The core innovation lies in the use of **Microprogramming (Modul 9)** to replace rigid hardwired State Machines, allowing for a flexible control store that separates the "Decision Logic" (FSM) from the "Control Signals" (Output).

### 🎯 Key Capabilities
* **Hardware-Level Security:** PIN authentication is performed via a parallel loop accelerator, eliminating software interrupt latency.
* **Synchronous Banking Logic:** User balances are stored in Block RAM and processed via custom VHDL arithmetic functions to deduct fees in real-time.
* **Automated Verification:** The system includes a self-checking testbench that autonomously validates timing constraints and logic correctness.

---

## 📂 Project Structure
Here is how we organized the files so you don't get lost:

```text
📁 ATM_Final_Project_PSD
│
├── 📄 README.md              <-- (You are reading this right now)
│
├── 📁 src                    <-- (CORE VHDL SOURCE CODE)
│   ├── atm_pkg.vhd           # Custom Arithmetic Package
│   ├── clk_divider.vhd       # Clock Divider for timing
│   ├── auth_accelerator.vhd  # PIN Validation Logic
│   ├── bank_ram.vhd          # User Data Storage
│   ├── rom_microcode.vhd     # The "Brain" (Control Store)
│   ├── fsm_controller.vhd    # State Machine
│   └── atm_top.vhd           # Top-Level Wrapper
│
├── 📁 testbench              <-- (SIMULATION FILES)
│   └── tb_atm_top.vhd        # Self-Checking Script
│
├── 📁 quartus_project        <-- (INTEL QUARTUS FILES)
│   ├── atm_top.qpf
│   └── atm_top.qsf
│
├── 📁 screenshots            <-- (PROOF OF WORK)
│   ├── rtl_viewer.png        # The Schematic
│   ├── compile_success_modelsim.png   # Green Checks ✅
|   ├── compile_success_quartus.png   # Green Checks ✅
│   ├── waveform_result.png   # Timing Diagrams
│   └── transcript_log.png    # "Status: Valid" logs
│
└── 📁 reports                <-- (DOCUMENTATION)
    ├── Laporan_Final_Project.pdf
    └── Presentasi_Final_Project.pptx
```

---

## 🏗️ System Architecture

The system is designed using a **Structural VHDL** approach, integrating five distinct subsystems into a single Top-Level Entity (`atm_top.vhd`).

### 1. The Control Plane (Brain)
* **FSM Controller (`fsm_controller.vhd`):** Manages the high-level states: `IDLE` → `CHECK_PIN` → `OPERATION` → `DONE/ERROR`.
* **Microcode ROM (`rom_microcode.vhd`):** Acts as the look-up table for control signals. Instead of complex `IF-ELSE` statements in the FSM, the controller simply points to an address in the ROM to retrieve the correct LED/Display patterns.

### 2. The Data Plane (Muscle)
* **Auth Accelerator (`auth_accelerator.vhd`):** A dedicated hardware block that compares the input PIN against the stored user password using a `FOR LOOP` construct. This ensures validation happens in a single clock cycle window.
* **Bank RAM (`bank_ram.vhd`):** A synchronous memory unit storing user balances.
    * *User 0:* Balance 9
    * *User 1:* Balance 8
* **Arithmetic Unit (`atm_pkg.vhd`):** A custom package containing the `calc_admin_fee` function. It automatically subtracts a fixed administration fee (1 unit) before the balance is sent to the display.

---

## 📊 Technical Implementation Details

We integrated **8 Core Laboratory Modules** into this final project:

| Feature | Implementation Method | Description |
| :--- | :--- | :--- |
| **Microprogramming** | *Modul 9* | Decoupled Control Unit using ROM for output mapping. |
| **Arithmetic Ops** | *Modul 7 (Function)* | Encapsulated `function` for fee deduction logic. |
| **Parallel Logic** | *Modul 6 (Looping)* | `for i in 0 to 3 loop` used for PIN bit comparison. |
| **Memory** | *Modul 2 (Dataflow)* | Synchronous read/write logic for user data storage. |
| **Clock Mgmt** | *Modul 3 (Behavioral)* | Frequency divider to slow down the 50MHz onboard clock. |
| **Verification** | *Modul 4 (Testbench)* | Automated `assert` statements for pass/fail validation. |

---

## 🧪 Simulation & Verification Strategy

We utilized a **Self-Checking Testbench** (`tb_atm_top.vhd`) to verify the design. The testbench does not require manual waveform inspection; it prints the status directly to the ModelSim console[cite: 106].

### Tested Scenarios
1.  **Security Breach Attempt:**
    * *Input:* Wrong PIN (`1111`).
    * *Expected Result:* Error LED High, State returns to IDLE.
    * *Status:* **PASSED**.
2.  **Valid Transaction (User 0):**
    * *Input:* Correct PIN (`1010`), Initial Balance `9`.
    * *Expected Result:* Success LED High, Display shows `8` (9 - 1 fee).
    * *Status:* **PASSED**.
3.  **Multi-User Handling (User 1):**
    * *Input:* Correct PIN, Initial Balance `8`.
    * *Expected Result:* Display shows `7` (8 - 1 fee).
    * *Status:* **PASSED**.

---

## ⚡ Quick Start Guide

To run this project on your local machine, follow these steps:

### Prerequisites
* **Intel Quartus Prime (Lite/Standard)** - For Synthesis & Bitstream Generation.
* **ModelSim - Intel FPGA Edition** - For RTL Simulation.

### Installation & Run
1.  **Clone the Repo:**
    ```bash
    git clone https://github.com/thafinity/FINPROPSD.git
    ```
2.  **Open in Quartus:**
    * Launch Quartus Prime.
    * Open Project `atm_top.qpf`.
    * Click **Start Compilation** to verify syntax and synthesis.
3.  **Simulate in ModelSim:**
    * Open ModelSim.
    * `File` -> `Change Directory` to the project folder.
    * Compile all VHDL files in the `src/` folder.
    * Simulate `tb_atm_top`.
    * Run command: `run -all`.

---

## 👥 The Team (Group 20)

This project was engineered by **Group 20** for the Digital System Design Laboratory:

* **Marshal Aufa Diliyana** (2406346913)
* **Zahir** (2406487084)
* **Thalita Salma Artanti** (2406419354)
* **Caesar Nur Falah W.** (2406487052)

---

## 📜 License & Acknowledgment
* **Course:** Digital System Design (Proyek Sistem Digital)
* **Institution:** Universitas Indonesia
* **Tools:** Intel FPGA, ModelSim, VHDL IEEE Standard.

*Copyright © 2025 Group 20. All Rights Reserved.*
