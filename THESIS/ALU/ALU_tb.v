//ALU WITH DATA MEMORY
//SO FAR IT WORKS BUT ONLY BYTE ORIENTED OPERATIONS WERE IMPLEMENTED PA
//9/3/2024
`timescale 1ns / 1ns
`include "ALU.v"
module ALU_tb;

    reg clk;
    reg [13:0] OP_CODE;
    //reg [7:0] L_REG;
    reg [7:0] REG1;
    //reg d;
    //reg [2:0] b;
    wire [7:0] W_REG;
    wire [7:0] STATUS_REG;
    wire [7:0] CHECK_REG;

    localparam ADDWF = 6'b000111;
    localparam ANDWF = 6'b000101;
    localparam CLRF =  6'b000001;
    localparam CLRW =  6'b000001;
    localparam COMF =  6'b001001;
    localparam DECF =  6'b000011;
    localparam INCF =  6'b001010;
    localparam IORWF = 6'b000100;
    localparam MOVF =  6'b001000;
    localparam MOVWF = 6'b000000;
    localparam RLF =   6'b001101;
    localparam RRF =   6'b001100;
    localparam SUBWF = 6'b000010;
    localparam SWAPF = 6'b001110;
    localparam XORWF = 6'b000110;


    // Instantiate the ALU module
    ALU uut (
        .clk(clk),
        .OP_CODE(OP_CODE),
        //.L_REG(L_REG),
        //.d(d),
        //.b(b),
        .W_REG(W_REG),
        .STATUS_REG(STATUS_REG),
        .CHECK_REG(CHECK_REG)
    );

    // Clock generation
    always begin
        #10 clk = ~clk; // 20ns clock period (50MHz)
    end

    // Testbench
    initial begin

        // Setup waveform dump
        $dumpfile("ALU_tb.vcd");
        $dumpvars(0, ALU_tb);

        // Initialize clock and inputs
        clk = 0;
        //L_REG = 8'h00;
        REG1 = 8'h95;
        //b = 3'h0;
        
        //00 1000 0 000 1100
        // OPCODE FOR MOVF TO W
        // F_ADDR = 0C => data_memory[GPR]
        // F(GPR) = 95H => W = 95H  Z = 0
        OP_CODE = 14'b00100000001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - MOVF TO W", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        #20;

        // 00 0111 1 000 1100
        // OPCODE FOR ADDWF TO F(GPR)
        // F_ADDR = 0C => data_memory[GPR]
        // F(GPR) = 95H + W = 95H => F(GPR) = 2A, Z = 0, C = 1, DC = 1
        OP_CODE = 14'b00011110001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - ADDWF TO F", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        #20;

        // 00 0101 0 000 0100
        // OPCODE FOR ANDWF TO W
        // F_ADDR = 04 => data_memory[FSR]
        // W = 95H & F(FSR) = 89H => w = 81, Z = 0
        OP_CODE = 14'b00010100000100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - ANDWF TO W", OP_CODE);
        $display("d = %b, W_REG = %h, F(FSR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        #20;

        // 00 0001 1 000 1100
        // OPCODE FOR CLRF
        // F_ADDR = 0C => data_memory[GPR]
        // W = 81, F(GPR) = 2A => GPR = 0, Z = 1
        OP_CODE = 14'b00000110001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - CLRF", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        #20;

        // 00 0001 0 000 1100
        // OPCODE FOR CLRW
        // F_ADDR = 0C => data_memory[GPR]
        // W = 81, => W = 0, Z = 1
        OP_CODE = 14'b00000100001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - CLRW", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        #20;

        // 00 0111 0 000 0100
        // OPCODE FOR ADDWF TO W
        // F_ADDR = 04 => data_memory[FSR] = 89
        // W = 0H + F(FSR) = 89H => w = 89, Z = 0
        OP_CODE = 14'b00011100000100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - ADDWF TO W", OP_CODE);
        $display("d = %b, W_REG = %h, F(FSR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 00 1001 1 000 1100
        // OPCODE FOR COMF TO F
        // F_ADDR = 0C => data_memory[GPR]
        // GPR = 00, => GPR = FF, W = 89
        OP_CODE = 14'b00100110001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - COMF TO F", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 00 0011 0 000 1100
        // OPCODE FOR DECF(GPR) TO W
        // F_ADDR = 0C => data_memory[GPR]
        // GPR = FF - 1 = FE, => W = FE
        OP_CODE = 14'b00001100001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - DECF(GPR) TO W", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 00 1010 1 000 1100
        // OPCODE FOR DECF(GPR) TO F
        // F_ADDR = 0C => data_memory[GPR]
        // GPR = FF + 1 = 00, => GPR = 00, Z = 1
        OP_CODE = 14'b00101010001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - INCF(GPR) TO W", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 00 0100 1 000 0100
        // OPCODE FOR IORWF(FSR) TO F
        // F_ADDR = 04 => data_memory[FSR]
        // FSR = 89 | W = FE, => FSR = FF, Z = 1
        OP_CODE = 14'b00010010000100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - IORWF(FSR) TO F", OP_CODE);
        $display("d = %b, W_REG = %h, F(FSR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 00 0000 1 000 1100
        // OPCODE FOR MOVWF TO GPR
        // F_ADDR = 0C => data_memory[GPR]
        // W = FE => GPR = 00, GPR = FE,
        OP_CODE = 14'b00000010001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - MOVWF(GPR) TO F", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 00 1101 0 000 1100
        // OPCODE FOR RLF(GPR) TO W
        // F_ADDR = 0C => data_memory[GPR]
        // GPR = FE (RLF) => W = FC, C = 1
        OP_CODE = 14'b00110100001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - RLF(GPR) TO W", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 00 1100 1 000 0100
        // OPCODE FOR RRF(FSR) TO F
        // F_ADDR = 04 => data_memory[FSR]
        // FSR = FF (RRF) => FSR = 7F, C = 1
        OP_CODE = 14'b00110010000100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - RRF(FSR) TO F", OP_CODE);
        $display("d = %b, W_REG = %h, F(FSR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 00 0010 0 000 0100
        // OPCODE FOR SUBWF(FSR) TO W
        // F_ADDR = 04 => data_memory[FSR]
        // FSR = 7F - W = FC => W = 83, C = 1, DC = 1 
        OP_CODE = 14'b00001000000100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - SUBWF(FSR) TO W", OP_CODE);
        $display("d = %b, W_REG = %h, F(FSR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 00 1110 0 000 1100
        // OPCODE FOR SWAPF(GPR) TO W
        // F_ADDR = 0C => data_memory[GPR]
        // GPR = FE => W = EF, 
        OP_CODE = 14'b00111000001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - SWAPF(GPR) TO W", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 00 1110 1 000 1100
        // OPCODE FOR SWAPF(GPR) TO F
        // F_ADDR = 0C => data_memory[GPR]
        // GPR = FE => GPR = EF, 
        OP_CODE = 14'b00111010001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - SWAPF(GPR) TO F", OP_CODE);
        $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // // 00 0010 0 000 1100
        // // OPCODE FOR SUBWF(GPR) TO W
        // // F_ADDR = 04 => data_memory[FSR]
        // // GPR = EF - W = EF => W = 00, C = 1, DC = 0/1??, Z = 1 
        // OP_CODE = 14'b00001000001100; // Match the width to 14 bits
        // #20;
        // $display("OP_CODE = %b - SUBWF(GPR) TO F", OP_CODE);
        // $display("d = %b, W_REG = %h, F(GPR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        // //#20;

        // 00 0110 1 000 0100
        // OPCODE FOR XORWF(FSR) TO F
        // F_ADDR = 04 => data_memory[FSR]
        // FSR = 7F XOR W = EF => FSR = 90, 
        OP_CODE = 14'b00011010000100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - XORWF(FSR) TO F", OP_CODE);
        $display("d = %b, W_REG = %h, F(FSR) = %h, STATUS_REG = %b",OP_CODE[7],W_REG,CHECK_REG,STATUS_REG);
        //#20;

        // 11 111 0 0001 0101
        // OPCODE FOR ADDLW
        // W = EF + K = 15 => W = 04, C = 1, DC = 1 
        OP_CODE = 14'b11111000010101; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - ADDLW", OP_CODE);
        $display("k = %h, W_REG = %h, STATUS_REG = %b",OP_CODE[7:0],W_REG,STATUS_REG);
        //#20;

        // 11 1001 0100 0010
        // OPCODE FOR ANDLW
        // W = EF & K = 20 => W = 0, Z = 1
        OP_CODE = 14'b11100101000010; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - ANDLW", OP_CODE);
        $display("k = %h, W_REG = %h, STATUS_REG = %b",OP_CODE[7:0],W_REG,STATUS_REG);
        //#20;

                // 11 1100 0010 0000
        // OPCODE FOR SUBLW
        // K = 20 - W = 0 => W = 20, Z = 0
        OP_CODE = 14'b11110000100000; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - SUBLW", OP_CODE);
        $display("k = %h, W_REG = %h, STATUS_REG = %b",OP_CODE[7:0],W_REG,STATUS_REG);
        //#20;

        // 11 0000 1010 0011
        // OPCODE FOR MOVLW
        // K = A3 => W = A3
        OP_CODE = 14'b11000010100011; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - MOVLW", OP_CODE);
        $display("k = %h, W_REG = %h, STATUS_REG = %b",OP_CODE[7:0],W_REG,STATUS_REG);
        //#20;

        // 11 1000 0000 0100
        // OPCODE FOR IORLW
        // W = 13 | k = 4 => W = A7
        OP_CODE = 14'b11100000000100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - IORLW", OP_CODE);
        $display("k = %h, W_REG = %h, STATUS_REG = %b",OP_CODE[7:0],W_REG,STATUS_REG);
        //#20;

        // 11 1010 0000 1100
        // OPCODE FOR XORLW
        // K = C ^ W = A7 => W = AB
        OP_CODE = 14'b11101000001100; // Match the width to 14 bits
        #20;
        $display("OP_CODE = %b - XORLW", OP_CODE);
        $display("k = %h, W_REG = %h, STATUS_REG = %b",OP_CODE[7:0],W_REG,STATUS_REG);
        //#20;


    $finish;
    end

endmodule
