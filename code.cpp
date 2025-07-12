
#include <iostream>
#include <vector>
#include <unordered_map>
#include <iomanip>
#include <string>
using namespace std;

// Instruction representation
struct Instruction {
    string type; // R, I, S, B
    int rd, rs1, rs2, imm;
    string label;
};

vector<string> pipeline = {"IF", "ID", "EX", "MEM", "WB"};

// Known instruction formats and types
unordered_map<string, Instruction> instrMap = {
    {"add",  {"R", 0, 0, 0, 0, ""}},
    {"addi", {"I", 0, 0, 0, 0, ""}},
    {"sw",   {"S", 0, 0, 0, 0, ""}},
    {"beq",  {"B", 0, 0, 0, 0, ""}},
};

// Pipeline stage registers
struct IF_ID { string raw; };
struct ID_EX { string op; int rd, rs1, rs2, imm; };
struct EX_MEM { int rd, alu_result; };
struct MEM_WB { int rd, mem_out; };

int reg[32] = {0};         // Register file
int dataMem[256] = {0};    // Data memory
vector<string> program;    // Program lines

// Parse input instruction string into structured Instruction
Instruction parse(string line) {
    Instruction inst;
    auto pos = line.find(' ');
    string op = line.substr(0, pos);
    inst.type = instrMap[op].type;

    // Pattern matching and extraction
    if (op == "add") {
        sscanf(line.c_str(), "add x%d, x%d, x%d", &inst.rd, &inst.rs1, &inst.rs2);
    } else if (op == "addi") {
        sscanf(line.c_str(), "addi x%d, x%d, %d", &inst.rd, &inst.rs1, &inst.imm);
    } else if (op == "sw") {
        sscanf(line.c_str(), "sw x%d, %d(x%d)", &inst.rs2, &inst.imm, &inst.rs1);
    } else if (op == "beq") {
        sscanf(line.c_str(), "beq x%d, x%d, %d", &inst.rs1, &inst.rs2, &inst.imm);
    }
    inst.label = op;
    return inst;
}

// Core simulation driver (ASCII output only, abstract stages)
void runSimulator(vector<string> code) {
    cout << "\n==== Pipeline Simulation ====" << endl;
    for (int cycle = 0; cycle < code.size(); cycle++) {
        cout << "Cycle " << cycle + 1 << ": " << code[cycle] << endl;
    }
    cout << "============================\n";
}

int main() {
    // ========== 🧪 TEST CASE BLOCK 1 ========== //
    // Expected: Normal add and addi execution
    vector<string> test1 = {
        "addi x1, x0, 5",    // Load 5 into x1
        "addi x2, x0, 10",   // Load 10 into x2
        "add x3, x1, x2"     // x3 = x1 + x2 = 15
    };
    runSimulator(test1);

    // ========== 🧪 TEST CASE BLOCK 2 ========== //
    // Expected: Store and branch (branch should not be taken)
    vector<string> test2 = {
        "addi x4, x0, 1",    // Load 1 into x4
        "sw x4, 0(x0)",      // Store x4 at address 0
        "addi x5, x0, 0",    // x5 = 0
        "beq x4, x5, -4"     // Branch backward if equal (should not branch)
    };
    runSimulator(test2);

    // ========== 🧪 TEST CASE BLOCK 3 ========== //
    // Expected: Straight data flow with no hazards
    vector<string> test3 = {
        "addi x1, x0, 1",    // Initial value
        "add x2, x1, x1",    // x2 = 2
        "add x3, x2, x2"     // x3 = 4
    };
    runSimulator(test3);

    // ========== 🧪 TEST CASE BLOCK 4 ========== //
    // Expected: RAW hazard on x1 and x2
    vector<string> test4 = {
        "addi x1, x0, 1",    // x1 = 1
        "add x2, x1, x1",    // Hazard: needs x1
        "add x3, x2, x1"     // Hazard: needs x2
    };
    runSimulator(test4);

    return 0;
}
