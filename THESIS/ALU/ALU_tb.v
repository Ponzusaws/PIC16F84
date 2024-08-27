`timescale 1ns / 1ns
`include "ALU.v"

module ALU_tb;

    reg clk;
    reg [7:0] F_ADD;
    reg [6:0] OP_CODE;
    reg [7:0] L_REG;
    wire [7:0] W_REG;
    wire [7:0] F_OUT;
    //wire C_FLAG;           // Carry out flag from ALU
    wire [7:0] STATUS_REG;


    // Instantiate the ALU module
    ALU uut (
        .clk(clk),
        .W_REG(W_REG),
        .F_ADD(F_ADD),
        .L_REG (L_REG),
        .OP_CODE(OP_CODE),
        .F_OUT(F_OUT),
        //.C_FLAG(C_FLAG),
        .STATUS_REG(STATUS_REG)
    );

    // Clock generation
    always begin
        #10 clk = ~clk; // 20ns clock period (50MHz)
    end

    // Testbench
    initial begin
        // Initialize clock and inputs
        clk = 0;
        F_ADD = 8'b00000000;
        L_REG = 8'b00000000;
        OP_CODE = 7'b0000000;

        // Setup waveform dump
        $dumpfile("ALU_tb.vcd");
        $dumpvars(0, ALU_tb);
    
        // Apply test cases

        // Test ADDWF (Add W_REG and F_ADD)
        #20; // Wait for initial clock edge
        F_ADD = 8'b11111111; // Set F_ADD
        OP_CODE = 7'b0001110; // OP_CODE for ADDWF
        #20; // Wait for one clock cycle
        $display("Test 1: ADDWF TO W  - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        // Test another operation (Update W_REG and check F_OUT)
        F_ADD = 8'b11111111; 
        OP_CODE = 7'b0001111; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 1: ADDWF TO F  - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);
        
        F_ADD = 8'b11110000; 
        OP_CODE = 7'b0001010; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 2: ANDWF TO W  - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b10001111; 
        OP_CODE = 7'b0001011; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 2: ANDWF TO F  - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);
       
        F_ADD = 8'b11111111; 
        OP_CODE = 7'b0000011; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 3: CLRF        - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111; 
        OP_CODE = 7'b0000010; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 4: CLRW        - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111; 
        OP_CODE = 7'b0010010; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 5: COMF TO W   - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000000;
        OP_CODE = 7'b0010011; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 5: COMF TO F   - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000001; 
        OP_CODE = 7'b0000110; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 6: DECF TO W   - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0000111; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 6: DECF TO F   - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000000; 
        OP_CODE = 7'b0010100; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 7: INCF TO W   - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b10000000;
        OP_CODE = 7'b0010101; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 7: INCF TO F   - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111; 
        OP_CODE = 7'b0001000; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 8: IORWF TO W  - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b10000000;
        OP_CODE = 7'b0001001; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 8: IORWF TO F  - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b10101010;
        OP_CODE = 7'b0010000; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 9: MOVF TO W   - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b01010101;
        OP_CODE = 7'b0010001; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 9: MOVF TO F   - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b10001111;
        OP_CODE = 7'b0000001; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 10: MOVWF      - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);
        // Finish simulation
        #20; 
        
        F_ADD = 8'b11111111;
        OP_CODE = 7'b0000000; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 11: NOP        - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0000100; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 12: SUBWF to W - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG );
    

        F_ADD = 8'b01010101;
        OP_CODE = 7'b0000101; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 12: SUBWF to F - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);
        // Finish simulation
        #20; 

        F_ADD = 8'b01111111;
        OP_CODE = 7'b0011100; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 13: SWAPF to W - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00101111;
        OP_CODE = 7'b0011101; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 13: SWAPF to F - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0001100; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 14: XORWF to W - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b10010010;
        OP_CODE = 7'b0001101; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 14: XORWF to F - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000001;
        OP_CODE = 7'b0011010; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 15: RLF to W -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b10000100;
        OP_CODE = 7'b0011011; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 15: RLF to F -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000001;
        OP_CODE = 7'b0011000; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 16: RRF to W -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0011001; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 16: RRF to F -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0100000; // OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 17: BCF to 0 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0100001;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 17: BCF to 1 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0100010;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 17: BCF to 2 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0100011;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 17: BCF to 3 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0100100;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 17: BCF to 4 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0100101;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 17: BCF to 5 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0100110;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 17: BCF to 6 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0100111;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 17: BCF to 7 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000000;
        OP_CODE = 7'b0101000;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 18: BSF to 0 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000000;
        OP_CODE = 7'b0101001;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 18: BSF to 1 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000000;
        OP_CODE = 7'b0101010;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 18: BSF to 2 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);
    
        F_ADD = 8'b00000000;
        OP_CODE = 7'b0101011;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 18: BSF to 3 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000000;
        OP_CODE = 7'b0101100;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 18: BSF to 4 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000000;
        OP_CODE = 7'b0101101;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 18: BSF to 5 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000000;
        OP_CODE = 7'b0101110;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 18: BSF to 6 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000000;
        OP_CODE = 7'b0101111;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 18: BSF to 7 -   F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0110000;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 19: BTFSC to 0 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0110001;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 19: BTFSC to 1 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0110010;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 19: BTFSC to 2 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);


        F_ADD = 8'b11111111;
        OP_CODE = 7'b0110011;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 19: BTFSC to 3 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0110100;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 19: BTFSC to 4 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0110101;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 19: BTFSC to 5 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b11111111;
        OP_CODE = 7'b0110110;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 19: BTFSC to 6 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

    
        F_ADD = 8'b11111111;
        OP_CODE = 7'b0110111;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 19: BTFSC to 7 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000000;
        OP_CODE = 7'b0111000;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 20: BTFSS to 0 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000001;
        OP_CODE = 7'b0111001;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 20: BTFSS to 1 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000011;
        OP_CODE = 7'b0111010;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 20: BTFSS to 2 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00000111;
        OP_CODE = 7'b0111011;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 20: BTFSS to 3 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00001111;
        OP_CODE = 7'b0111100;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 20: BTFSS to 4 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00011111;
        OP_CODE = 7'b0111101;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 20: BTFSS to 5 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b00111111;
        OP_CODE = 7'b0111110;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 20: BTFSS to 6 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        F_ADD = 8'b01111111;
        OP_CODE = 7'b0111111;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 20: BTFSS to 7 - F_ADD = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", F_ADD, W_REG, F_OUT, STATUS_REG);

        //LITERAL AND CONTROL OPERATIONS

        L_REG = 8'b11111111;
        OP_CODE = 7'b11111xx;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 21: ADDLW      - L_REG = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", L_REG, W_REG, F_OUT, STATUS_REG);

        L_REG = 8'b10011001;
        OP_CODE = 7'b111001x;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 22: ANDLW      - L_REG = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", L_REG, W_REG, F_OUT, STATUS_REG);

        L_REG = 8'b00001110;
        OP_CODE = 7'b111000x;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 23: IORLW      - L_REG = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", L_REG, W_REG, F_OUT, STATUS_REG);

        L_REG = 8'b00000011;
        OP_CODE = 7'b1100x;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 24: MOVLW      - L_REG = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", L_REG, W_REG, F_OUT, STATUS_REG);

        L_REG = 8'b00000010;
        OP_CODE = 7'b11110x;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 25: SUBLW      - L_REG = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", L_REG, W_REG, F_OUT, STATUS_REG);

        L_REG = 8'b11100011;
        OP_CODE = 7'b111010x;// OP_CODE for another operation
        #20; // Wait for one clock cycle
        $display("Test 26: XORLW      - L_REG = %b, W_REG = %b, F_OUT = %b, STATUS_REG = %b", L_REG, W_REG, F_OUT, STATUS_REG);



        $finish;
    end

endmodule

