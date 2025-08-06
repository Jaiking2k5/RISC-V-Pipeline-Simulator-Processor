    vector<string> test1 = {
        "addi x1, x0, 5",   // Load 5 into x1
        "add x2, x1, x1",   // x2 = x1 + x1
        "add x3, x2, x1"    // x3 = x2 + x1
    };

    // Cycle 1: addi x1, x0, 5 --> IF
    // Cycle 2: addi x1, x0, 5 --> ID
    //          add x2, x1, x1 --> IF
    // Cycle 3: addi x1, x0, 5 --> EX
    //          add x2, x1, x1 --> ID
    //          add x3, x2, x1 --> IF
    // Cycle 4: addi x1, x0, 5 --> MEM
    //          add x2, x1, x1 --> EX
    //          add x3, x2, x1 --> ID
    // Cycle 5: addi x1, x0, 5 --> WB
    //          add x2, x1, x1 --> MEM
    //          add x3, x2, x1 --> EX
    // Cycle 6: add x2, x1, x1 --> WB
    //          add x3, x2, x1 --> MEM
    // Cycle 7: add x3, x2, x1 --> WB

    simulatePipeline(test1);

    vector<string> test2 = {
        "addi x5, x0, 10",  // Load 10 into x5
        "addi x6, x0, 20"   // Load 20 into x6
    };

    // Cycle 1: addi x5, x0, 10 --> IF
    // Cycle 2: addi x5, x0, 10 --> ID
    //          addi x6, x0, 20 --> IF
    // Cycle 3: addi x5, x0, 10 --> EX
    //          addi x6, x0, 20 --> ID
    // Cycle 4: addi x5, x0, 10 --> MEM
    //          addi x6, x0, 20 --> EX
    // Cycle 5: addi x5, x0, 10 --> WB
    //          addi x6, x0, 20 --> MEM
    // Cycle 6: addi x6, x0, 20 --> WB

    simulatePipeline(test2);

    return 0;
