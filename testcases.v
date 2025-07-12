// Testbench 1 - Modified
module tb1_MIPS;

reg clk1, clk2;
integer i, j;

MIPS_32 dut(clk1, clk2);

initial begin
    clk1 = 0; clk2 = 0;
    repeat (20) begin
        #5 clk1 = 1; #5 clk1 = 0;
        #5 clk2 = 1; #5 clk2 = 0;
    end
end

initial begin
    for (i = 0; i < 32; i = i + 1)
        dut.RegFile[i] = i;

    dut.Memory[0] = 32'h2801000a;
    dut.Memory[1] = 32'h28020014;
    dut.Memory[2] = 32'h28030019;
    dut.Memory[3] = 32'h0ce77800; // Dummy
    dut.Memory[4] = 32'h0ce77800; // Dummy
    dut.Memory[5] = 32'h00222000;
    dut.Memory[6] = 32'h0ce77800; // Dummy
    dut.Memory[7] = 32'h00832800;
    dut.Memory[8] = 32'hfc000000;
end

initial begin
    $dumpfile("tb1_wave.vcd");
    $dumpvars(0, tb1_MIPS);
    dut.HALTED = 0;
    dut.PC = 0;
    dut.TAKEN_BRANCH = 0;

    #280;
    for (j = 0; j < 6; j = j + 1)
        $display("R[%0d] = %0d", j, dut.RegFile[j]);

    #300 $finish;
end

endmodule


// Testbench 2 - Modified
module tb2_MIPS;

reg clk1, clk2;
integer i;

MIPS_32 dut(clk1, clk2);

initial begin
    clk1 = 0; clk2 = 0;
    repeat (20) begin
        #5 clk1 = 1; #5 clk1 = 0;
        #5 clk2 = 1; #5 clk2 = 0;
    end
end

initial begin
    for (i = 0; i < 32; i = i + 1)
        dut.RegFile[i] = i;

    dut.Memory[0] = 32'h28010078;
    dut.Memory[1] = 32'h0c631800; // Dummy
    dut.Memory[2] = 32'h20220000;
    dut.Memory[3] = 32'h0c631800; // Dummy
    dut.Memory[4] = 32'h2842002d;
    dut.Memory[5] = 32'h0c631800; // Dummy
    dut.Memory[6] = 32'h24220001;
    dut.Memory[7] = 32'hfc000000;

    dut.Memory[120] = 32'd85;
end

initial begin
    $dumpfile("tb2_wave.vcd");
    $dumpvars(0, tb2_MIPS);
    dut.HALTED = 0;
    dut.PC = 0;
    dut.TAKEN_BRANCH = 0;

    #500;
    $display("Mem[120] = %0d | Mem[121] = %0d", dut.Memory[120], dut.Memory[121]);
    #600 $finish;
end

endmodule


// Testbench 3 - Modified
module tb3_MIPS;

reg clk1, clk2;
integer i;

MIPS_32 dut(clk1, clk2);

initial begin
    clk1 = 0; clk2 = 0;
    repeat (20) begin
        #5 clk1 = 1; #5 clk1 = 0;
        #5 clk2 = 1; #5 clk2 = 0;
    end
end

initial begin
    for (i = 0; i < 32; i = i + 1)
        dut.RegFile[i] = i;

    dut.Memory[0] = 32'h280a00c8;
    dut.Memory[1] = 32'h28020001;
    dut.Memory[2] = 32'h0e94a000; // Dummy
    dut.Memory[3] = 32'h21430000;
    dut.Memory[4] = 32'h0e94a000; // Dummy
    dut.Memory[5] = 32'h14431000;
    dut.Memory[6] = 32'h2c630001;
    dut.Memory[7] = 32'h0e94a000; // Dummy
    dut.Memory[8] = 32'h3460fffc;
    dut.Memory[9] = 32'h2542fffe;
    dut.Memory[10] = 32'hfc000000;

    dut.Memory[200] = 32'd7;
end

initial begin
    $dumpfile("tb3_wave.vcd");
    $dumpvars(0, tb3_MIPS);
    $monitor("R2 = %0d", dut.RegFile[2]);

    dut.HALTED = 0;
    dut.PC = 0;
    dut.TAKEN_BRANCH = 0;

    #4000;
    $display("Mem[200] = %0d | Mem[198] = %0d", dut.Memory[200], dut.Memory[198]);
    #3000 $finish;
end

endmodule
