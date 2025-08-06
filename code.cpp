
//how instructions move through the 5-stage pipeline

#include <iostream>
#include <vector>
#include <string>
using namespace std;


vector<string> stages = {"IF", "ID", "EX", "MEM", "WB"};

void simulatePipeline(const vector<string>& program) {
    cout << "\n===== RISC-V Pipeline Simulation =====\n";

    int totalCycles = program.size() + stages.size() - 1;

    for (int cycle = 0; cycle < totalCycles; ++cycle) {
        cout << "Cycle " << cycle + 1 << ":\n";

        for (int i = 0; i < program.size(); ++i) {
            int stageIndex = cycle - i;
            if (stageIndex >= 0 && stageIndex < stages.size()) {
                cout << "  " << program[i] << " --> " << stages[stageIndex] << "\n";
            }
        }

        cout << "--------------------------------------\n";
    }

    cout << "======================================\n";
}

int main() {
    vector<string> program = {
        "addi x1, x0, 5",  // Load 5 into x1
        "add x2, x1, x1",  // x2 = x1 + x1
        "add x3, x2, x1"   // x3 = x2 + x1
    };

    simulatePipeline(program);
    return 0;
}
