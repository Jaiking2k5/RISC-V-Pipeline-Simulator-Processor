// Simplified MIPS32 Processor with 5-Stage Pipelining (Modified Version)

module MIPS_32(clk1, clk2);

input clk1, clk2; // Two-phase clock signals

// Pipeline registers
reg [31:0] PC;
reg [31:0] IF_ID_IR, IF_ID_NPC;
reg [31:0] ID_EX_IR, ID_EX_NPC, ID_EX_A, ID_EX_B, ID_EX_Imm;
reg [31:0] EX_MEM_IR, EX_MEM_ALUout, EX_MEM_B, EX_MEM_cond;
reg [31:0] MEM_WB_IR, MEM_WB_ALUout, MEM_WB_LMD;

// Instruction types
reg [2:0] ID_EX_type, EX_MEM_type, MEM_WB_type;

// Register file and memory
reg [31:0] RegFile [0:31];
reg [31:0] Memory [0:1023];

// Opcode parameters
parameter ADD=6'b000000, SUB=6'b000001, AND=6'b000010, OR=6'b000011, SLT=6'b000100, MUL=6'b000101,
          HLT=6'b111111, LW=6'b001000, SW=6'b001001,
          ADDI=6'b001010, SUBI=6'b001011, SLTI=6'b001100,
          BNEQZ=6'b001101, BEQZ=6'b001110;

parameter RR_ALU=3'b000, RM_ALU=3'b001, LOAD=3'b010,
          STORE=3'b011, BRANCH=3'b100, HALT=3'b101;

// Control flags
reg HALTED;
reg TAKEN_BRANCH;

// Instruction field decoding wires
wire [5:0] opcode = IF_ID_IR[31:26];
wire [4:0] rs = IF_ID_IR[25:21];
wire [4:0] rt = IF_ID_IR[20:16];
wire [15:0] imm = IF_ID_IR[15:0];

// ------------------------ IF STAGE ------------------------
always @(posedge clk1) begin
    if (!HALTED) begin
        if ((EX_MEM_IR[31:26] == BEQZ && EX_MEM_cond) ||
            (EX_MEM_IR[31:26] == BNEQZ && !EX_MEM_cond)) begin
            IF_ID_IR <= #2 Memory[EX_MEM_ALUout];
            IF_ID_NPC <= #2 EX_MEM_ALUout;
            PC <= #2 EX_MEM_ALUout;
            TAKEN_BRANCH <= #2 1;
        end else begin
            IF_ID_IR <= #2 Memory[PC];
            IF_ID_NPC <= #2 PC + 1;
            PC <= #2 PC + 1;
        end
    end
end

// ------------------------ ID STAGE ------------------------
always @(posedge clk2) begin
    if (!HALTED) begin
        case (opcode)
            ADD, SUB, MUL, AND, OR, SLT: ID_EX_type <= #2 RR_ALU;
            ADDI, SUBI, SLTI: ID_EX_type <= #2 RM_ALU;
            LW: ID_EX_type <= #2 LOAD;
            SW: ID_EX_type <= #2 STORE;
            BNEQZ, BEQZ: ID_EX_type <= #2 BRANCH;
            HLT: ID_EX_type <= #2 HALT;
            default: ID_EX_type <= #2 HALT;
        endcase

        ID_EX_A <= #2 (rs == 0) ? 0 : RegFile[rs];
        ID_EX_B <= #2 (rt == 0) ? 0 : RegFile[rt];
        ID_EX_Imm <= #2 {{16{imm[15]}}, imm};
        ID_EX_IR <= #2 IF_ID_IR;
        ID_EX_NPC <= #2 IF_ID_NPC;
    end
end

// ------------------------ EX STAGE ------------------------
always @(posedge clk1) begin
    if (!HALTED) begin
        EX_MEM_IR <= #2 ID_EX_IR;
        EX_MEM_type <= #2 ID_EX_type;
        TAKEN_BRANCH <= #2 0;

        case (ID_EX_type)
            RR_ALU: begin
                case (ID_EX_IR[31:26])
                    ADD: EX_MEM_ALUout <= #2 ID_EX_A + ID_EX_B;
                    SUB: EX_MEM_ALUout <= #2 ID_EX_A - ID_EX_B;
                    MUL: EX_MEM_ALUout <= #2 ID_EX_A * ID_EX_B;
                    AND: EX_MEM_ALUout <= #2 ID_EX_A & ID_EX_B;
                    OR:  EX_MEM_ALUout <= #2 ID_EX_A | ID_EX_B;
                    SLT: EX_MEM_ALUout <= #2 (ID_EX_A < ID_EX_B);
                    default: EX_MEM_ALUout <= #2 32'hXXXXXXXX;
                endcase
            end

            RM_ALU: begin
                case (ID_EX_IR[31:26])
                    ADDI: EX_MEM_ALUout <= #2 ID_EX_A + ID_EX_Imm;
                    SUBI: EX_MEM_ALUout <= #2 ID_EX_A - ID_EX_Imm;
                    SLTI: EX_MEM_ALUout <= #2 (ID_EX_A < ID_EX_Imm);
                    default: EX_MEM_ALUout <= #2 32'hXXXXXXXX;
                endcase
            end

            LOAD, STORE: begin
                EX_MEM_ALUout <= #2 ID_EX_A + ID_EX_Imm;
                EX_MEM_B <= #2 ID_EX_B;
            end

            BRANCH: begin
                EX_MEM_ALUout <= #2 ID_EX_NPC + ID_EX_Imm;
                EX_MEM_cond <= #2 (ID_EX_A == 0);
            end
        endcase
    end
end

// ------------------------ MEM STAGE ------------------------
always @(posedge clk2) begin
    if (!HALTED) begin
        MEM_WB_IR <= #2 EX_MEM_IR;
        MEM_WB_type <= #2 EX_MEM_type;

        case (EX_MEM_type)
            RR_ALU, RM_ALU: MEM_WB_ALUout <= #2 EX_MEM_ALUout;
            LOAD: MEM_WB_LMD <= #2 Memory[EX_MEM_ALUout];
            STORE: if (!TAKEN_BRANCH) Memory[EX_MEM_ALUout] <= #2 EX_MEM_B;
        endcase
    end
end

// ------------------------ WB STAGE ------------------------
always @(posedge clk1) begin
    if (!TAKEN_BRANCH) begin
        case (MEM_WB_type)
            RR_ALU: RegFile[MEM_WB_IR[15:11]] <= #2 MEM_WB_ALUout;
            RM_ALU, LOAD: RegFile[MEM_WB_IR[20:16]] <= #2 (MEM_WB_type == LOAD) ? MEM_WB_LMD : MEM_WB_ALUout;
            HALT: HALTED <= #2 1;
        endcase
    end
end

endmodule
