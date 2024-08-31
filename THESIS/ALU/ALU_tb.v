`timescale 1ns / 1ns
`include "ALU.v"
module ALU_tb;

    reg clk;
    reg [13:0] OP_CODE;
    reg [7:0] L_REG;
    reg [7:0] REG1;
    reg d;
    reg [2:0] b;
    wire [7:0] W_REG;
    wire [7:0] FSR_REG;
    wire [7:0] STATUS_REG;
    //wire C_FLAG;           // Carry out flag from ALU

    localparam NOP =   14'b00000000000000;
    localparam ADDWF = 14'b00011100000000;
    localparam ANDWF = 14'b00010100000000;
    localparam CLRF =  14'b00000110000000;
    localparam CLRW =  14'b00000100000000;
    localparam COMF =  14'b00100100000000;
    localparam DECF =  14'b00001100000000;
    localparam INCF =  14'b00101000000000;
    localparam IORWF = 14'b00010000000000;
    localparam MOVF =  14'b00100000000000;
    localparam MOVWF = 14'b00000010000000;
    localparam RLF =   14'b00110100000000;
    localparam RRF =   14'b00110000000000;
    localparam SUBWF = 14'b00001000000000;
    localparam SWAPF = 14'b00111000000000;
    localparam XORWF = 14'b00011000000000;
    localparam BCF =   14'b01000000000000;
    localparam BSF =   14'b01010000000000;
    // localparam BTFSC = 14'b01100000000000;
    // localparam BTFSS = 14'b01110000000000;
    localparam ADDLW = 14'b11111000000000;
    localparam ANDLW = 14'b11100100000000;
    localparam IORLW = 14'b11100000000000;
    localparam MOVLW = 14'b11000000000000;
    localparam SUBLW = 14'b11110000000000;
    localparam XORLW = 14'b11101000000000;


    // Instantiate the ALU module
    ALU uut (
        .clk(clk),
        .OP_CODE(OP_CODE),
        .L_REG(L_REG),
        .d(d),
        .b(b),
        .W_REG(W_REG),
        .FSR_REG(FSR_REG),
        .STATUS_REG(STATUS_REG),
        .REG1(REG1)
    );

    // Clock generation
    always begin
        #10 clk = ~clk; // 20ns clock period (50MHz)
    end

    // Testbench
    initial begin
        // Initialize clock and inputs
        clk = 0;
        OP_CODE = 14'b00000000000000; // Match the width to 14 bits
        L_REG = 8'h00;
        REG1 = 8'h00;
        d = 1'b0;
        b = 3'h0;

        #20;
        $display("OP_CODE = %b - NOP", OP_CODE);
        $display("REG1 = %b, d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b",REG1,d,FSR_REG,W_REG,STATUS_REG);
        #20;

        // Setup waveform dump
        $dumpfile("ALU_tb.vcd");
        $dumpvars(0, ALU_tb);
    
        // Apply test cases
        //MOVF
        REG1 = 8'hFF; // Example operanD
        OP_CODE = MOVF; // Example OP_CODE for MOVF (adjust as per ALU spec)
        d = 1'b1; // Store result in F_REG
        #20;
        $display("OP_CODE = %b, REG1 = %b", OP_CODE, REG1);
        $display("MOVF TO F  - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - WRONG",d,FSR_REG,W_REG,STATUS_REG);
        #20;

        REG1 = 8'hF0;
        OP_CODE = MOVF; // Example OP_CODE for MOVF (adjust as per ALU spec)
        d = 1'b0; // Store result in W_REG
          #20;
        $display("OP_CODE = %b, REG1 = %b", OP_CODE, REG1);
        $display("MOVF TO W  - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - WRONG",d,FSR_REG,W_REG,STATUS_REG);
        #20;

        //ADDWF TO W
        OP_CODE = ADDWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        d = 1'b0; // Store result in W_REG
        d = 1'b1; // STORE RESULT IN FSR_REG
          #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("ADDWF TO W - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        // //ADDWF TO F
        // OP_CODE = ADDWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        // d = 1'b1; // Store result in F_REG
        // #20;
        // $display("OP_CODE = %b - ADDWF TO F ", OP_CODE);
        // $display("d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);
        
        //ANDWF TO F
        OP_CODE = ANDWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        d = 1'b1; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("ANDWF TO F - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //ANDWF TO W
        OP_CODE = ANDWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("ANDWF TO W - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //CLRF
        OP_CODE = CLRF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("CLRF       - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);
        
        //CLRW
        OP_CODE = CLRW; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        //d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("CLRW       - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //COMF
        OP_CODE = COMF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        d = 1'b1; // Store result in F_REG
        //d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("COMF TO F  - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        // OP_CODE = COMF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        // d = 1'b0; // Store result in W_REG
        // #20;
        // $display("OP_CODE = %b", OP_CODE);
        // $display("COMF TO W  - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //DECF
        OP_CODE = DECF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        d = 1'b1; // Store result in F_REG
        //d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("DECF TO F  - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //INCF
        OP_CODE = INCF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        //d = 1'b1; // Store result in F_REG
        d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("INCF TO W  - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //IORWF
        OP_CODE = IORWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        d = 1'b1; // Store result in F_REG
        //d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("IORWF TO F - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //RLF
        OP_CODE = RLF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        d = 1'b1; // Store result in F_REG
        //d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("RLF TO F   - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //RLF
        OP_CODE = RLF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        //d = 1'b1; // Store result in F_REG
        d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("RLF TO W   - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);
        
        //MOVWF
        OP_CODE = MOVWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("MOVWF      - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //RRF
        OP_CODE = RRF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        //d = 1'b1; // Store result in F_REG
        d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("RRF TO W   - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //SUBWF
        OP_CODE = SUBWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        d = 1'b1; // Store result in F_REG
        //d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("SUBWF TO F - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //SUBWF
        OP_CODE = SUBWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        d = 1'b1; // Store result in F_REG
        //d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("SUBWF TO F - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        // //SUBWF
        // OP_CODE = SUBWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        // //d = 1'b1; // Store result in F_REG
        // d = 1'b0; // Store result in W_REG
        // #20;
        // $display("OP_CODE = %b", OP_CODE);
        // $display("SUBWF TO W  - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //MOVWF
        OP_CODE = MOVWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("MOVWF      - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //SWAPF
        OP_CODE = SWAPF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        //d = 1'b1; // Store result in F_REG
        d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("SWAPF TO W - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //XORWF
        OP_CODE = XORWF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        d = 1'b1; // Store result in F_REG
        //d = 1'b0; // Store result in W_REG
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("XORWF TO F - d = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",d,FSR_REG,W_REG,STATUS_REG);

        //BCF AT BIT 7
        OP_CODE = BCF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        b = 3'b111;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("BCF AT 7 - b = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",b,FSR_REG,W_REG,STATUS_REG);

        //BCF AT BIT 0
        OP_CODE = BCF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        b = 3'b000;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("BCF AT 0 - b = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",b,FSR_REG,W_REG,STATUS_REG);

        //BSF AT BIT 2
        OP_CODE = BSF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        b = 3'b010;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("BSF AT 2 - b = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",b,FSR_REG,W_REG,STATUS_REG);

        //BSF AT BIT 6
        OP_CODE = BSF; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        b = 3'b110;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("BSF AT 6 - b = %b, FSR_REG = %h, W_REG = %h, STATUS_REG = %b - ",b,FSR_REG,W_REG,STATUS_REG);

        OP_CODE = ADDLW; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        L_REG = 8'h19;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("ADDLW - L_REG = %h, W_REG = %h, STATUS_REG = %b - ",L_REG,W_REG,STATUS_REG);

        OP_CODE = ADDLW; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        L_REG = 8'h19;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("ADDLW - L_REG = %h, W_REG = %h, STATUS_REG = %b - ",L_REG,W_REG,STATUS_REG);

        OP_CODE = ANDLW; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        L_REG = 8'h09;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("ANDLW - L_REG = %h, W_REG = %h, STATUS_REG = %b - ",L_REG,W_REG,STATUS_REG);

        OP_CODE = IORLW; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        L_REG = 8'hFB;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("IORLW - L_REG = %h, W_REG = %h, STATUS_REG = %b - ",L_REG,W_REG,STATUS_REG);

        OP_CODE = MOVLW; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        L_REG = 8'h03;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("MOVLW - L_REG = %h, W_REG = %h, STATUS_REG = %b - ",L_REG,W_REG,STATUS_REG);

        OP_CODE = SUBLW; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        L_REG = 8'h02;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("SUBLW - L_REG = %h, W_REG = %h, STATUS_REG = %b - ",L_REG,W_REG,STATUS_REG);

        OP_CODE = XORLW; // Example OP_CODE for ADDWF (adjust as per ALU spec)
        L_REG = 8'h1C;
        #20;
        $display("OP_CODE = %b", OP_CODE);
        $display("XORLW - L_REG = %h, W_REG = %h, STATUS_REG = %b - ",L_REG,W_REG,STATUS_REG);


        $finish;
    end

endmodule
