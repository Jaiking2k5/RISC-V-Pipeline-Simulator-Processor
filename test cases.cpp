// 🧪 Test Cases — 5-Stage RISC-V Pipeline Simulator

// Test Case 1: Independent Instructions
// Expect no hazard or stall
// Cycle 1: addi x1, x0, 5 (IF)
// Cycle 2: addi x2, x0, 10 (IF), addi x1 in ID
// Cycle 3: add x3, x1, x2 (IF), addi x2 in ID, addi x1 in EX

addi x1, x0, 5
addi x2, x0, 10
add x3, x1, x2


// Test Case 2: Memory store and compare
// Expect MEM access and conditional check
// Cycle 1: addi x4, x0, 1
// Cycle 2: sw x4, 0(x0)
// Cycle 3: addi x5, x0, 0
// Cycle 4: beq x4, x5, -4 (branch not taken)

addi x4, x0, 1
sw x4, 0(x0)
addi x5, x0, 0
beq x4, x5, -4


// Test Case 3: RAW hazard without forwarding
// Expect a stall inserted manually/logically
// x1 used by x2 before write-back

addi x1, x0, 5
add x2, x1, x1
add x3, x2, x2


// Test Case 4: Deliberate stalling
// Simulates delay to avoid RAW hazard manually

addi x1, x0, 1
nop
add x2, x1, x1
nop
add x3, x2, x1



# Test Case 1: Simple ALU operations
addi x1, x0, 5
addi x2, x0, 10
add x3, x1, x2    # Expect x3 = 15

# Test Case 2: Store/Load
addi x4, x0, 1
sw x4, 0(x0)
lw x5, 0(x0)       # Expect x5 = 1

# Test Case 3: Branch
addi x6, x0, 1
beq x6, x0, -2     # Not taken
