Title: MIPS-32 Processor with 5-Stage Pipelining in Verilog

Description:
This project involved designing and implementing a simplified 32-bit MIPS processor architecture in Verilog, featuring a classic 5-stage pipeline: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB). The processor supports a range of R-type, I-type, load/store, and branching instructions, including arithmetic (ADD, SUB, MUL), logical (AND, OR), and control instructions (BEQZ, BNEQZ, HLT).

To ensure correct operation and simulate instruction-level parallelism, we integrated dummy instructions to handle hazards and developed comprehensive testbenches using memory-initialized programs. The processor runs on a two-phase non-overlapping clock (clk1, clk2) to emulate real hardware timing and synchrony.

The project not only deepened my understanding of digital design principles and CPU microarchitecture but also provided hands-on experience with pipelining, control logic, and modular test-driven development in Verilog.

