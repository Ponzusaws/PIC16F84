//ALU WITH DATA MEMORY
//SO FAR IT WORKS BUT ONLY BYTE ORIENTED OPERATIONS WERE IMPLEMENTED PA
//9/3/2024

//9-5-2024
//ADDED "BANKING"
module ALU(
    input wire clk,
    input wire [13:0] OP_CODE, //INSTRUCTION
    input wire [7:0] REG1,
    output reg [7:0] W_REG,  //W_REG
    output reg [7:0] CHECK_REG,
    output reg [7:0] STATUS_REG,
    output reg [7:0] BANK1
);

    //BYTE-ORIENTED FILE REGISTER OPERATIONS 7-BIT
    // [13:8] - OPCODE -> 6-BIT
    // [7]    - d -> DESTINATION
    localparam ADDWF = 6'b000111;
    localparam ANDWF = 6'b000101;
    localparam CLR  =  6'b000001;
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

    // localparam NOP =   14'b0000000xx00000;
    //BIT-ORIENTED FILE REGISTER OPERATIONS
    // [13:10] - OPCODE -> 4-BIT
    // [9:7]   - b -> 3-BIT BIT ADDRESS
    localparam BCF =   4'b0100;
    localparam BSF =   4'b0101;
    // localparam BTFSC = 14'b01100000000000;
    // localparam BTFSS = 14'b01110000000000;

    //LITERAL AND CONTROL OPERATIONS
    //GENERAL - [13:8] - OPCODE -> 6-BIT
    //          [7:0]  - K (literal) -> 8-BIT VALUE
    localparam XORLW = 6'b111010;
    localparam ANDLW = 6'b111001;
    localparam IORLW = 6'b111000;
    localparam ADDLW = 5'b11111;
    localparam SUBLW = 5'b11110;
    localparam MOVLW = 4'b1100;
    
    // // Add these lines if you have operations like INCFSZ and DEFFSZ
    // localparam INCFSZ = 14'b01000100000000; // Example definition
    // localparam DEFFSZ = 14'b01001000000000; // Example definition

    // Initialize registers
    initial begin
        W_REG      = 8'b00000000;
        STATUS_REG = 8'b00000000;
        CHECK_REG  = 8'b00000000;
    end
    
    // Declare the memory (68 bytes)
    //0-127 BANK 0 & 128-255 BANK 1
    reg [7:0] data_memory [0:255];

    // Define the special function registers (SFR)
    localparam INDF     = 7'h00;
    localparam TMR0     = 7'h01;
    localparam PCL      = 7'h02;
    localparam STATUS   = 7'h03;
    localparam FSR      = 7'h04;
    localparam PORTA    = 7'h05;
    localparam PORTB    = 7'h06;
    localparam EEDATA   = 7'h08;
    localparam EEADR    = 7'h09;
    localparam PCLATH   = 7'h0A;
    localparam INTCON   = 7'h0B;
    localparam GPR      = 7'h0C;

    //initialize the registers
    initial begin
        //data_memory[FADDR] = 8'h00;
        data_memory[INDF]   = 8'h00;
        data_memory[TMR0]   = 8'h00;
        data_memory[PCL]    = 8'h00;
        data_memory[STATUS] = 8'h00; // or memory[STATUS] = STATUS_REG;
        data_memory[FSR]    = 8'h89;
        data_memory[PORTA]  = 8'h00;
        data_memory[PORTB]  = 8'h00;
        data_memory[EEDATA] = 8'h00;
        data_memory[EEADR]  = 8'h00;
        data_memory[PCLATH] = 8'h00;
        data_memory[INTCON] = 8'h00;
        data_memory[GPR]    = 8'h95;
    end

    reg [8:0] c_out;  // For addition/subtraction carry out
    reg [3:0] tmp1;
    reg [3:0] tmp2;
    reg tmp_cout = 1'b0;
    reg tmp_msbF = 1'b0;
    reg [7:0] ALU_OUT;
    

    wire b = OP_CODE[9:7]; // 3-bit address
    wire d = OP_CODE[7];    // destination bit 0 => W, 1 => f
    wire [6:0] F_ADDR = OP_CODE[6:0]; // 7-bit file register address
    reg [7:0] F_REG;
    reg [7:0] K_LITERAL = 8'b00000000;

    reg [7:0] test_bank1;


    always @(posedge clk) begin

        //the value of the register at these addresses(bank 0) will be stored to the same registers at bank 1
        if (F_ADDR == 8'h00 || F_ADDR == 8'h02 || F_ADDR == 8'h03 || F_ADDR == 8'h04 || F_ADDR == 8'h0A || F_ADDR == 8'h0B ) begin
            test_bank1 = F_ADDR + 8'h80;
            data_memory[test_bank1] = data_memory[F_ADDR];
        end 
        //the value of the registers with addresses from 0C - 4F(bank 0) will be stored in bank 1
        if (F_ADDR >= 8'h0C || F_ADDR <= 8'h4F) begin
            test_bank1 = F_ADDR + 8'h80;
            data_memory[test_bank1] = data_memory[F_ADDR];
        end

        //the value of the register at these addresses(bank 1) will be stored to the same registers at bank 0
        if (F_ADDR == 8'h80 || F_ADDR == 8'h82 || F_ADDR == 8'h83 || F_ADDR == 8'h84 || F_ADDR == 8'h8A || F_ADDR == 8'h8B ) begin 
            test_bank1 = F_ADDR - 8'h80;
            data_memory[test_bank1] = data_memory[F_ADDR];
        end 
        //the value of the registers with addresses from 8C - CF(bank 1) will be stored in bank 0
        if (F_ADDR >= 8'h8C || F_ADDR <= 8'hCF) begin
            test_bank1 = F_ADDR - 8'h80;
            data_memory[test_bank1] = data_memory[F_ADDR];
        end

        data_memory[STATUS] = 8'h00;  //RESETS STATUS
        F_REG = data_memory[F_ADDR]; // the value of the register at the OP_CODE[6:0] address is stored in F_REG ;
        K_LITERAL = OP_CODE[7:0];

        //BYTE-ORIENTED FILE REGISTER OPERATIONS 7-BIT
        // [13:8] - OPCODE -> 6-BIT
        // [7]    - d -> DESTINATION
        case (OP_CODE[13:8])
            ADDWF: begin 
                c_out = W_REG + F_REG;
                
                ALU_OUT = c_out[7:0];
                data_memory[STATUS] [0] = c_out[8];

                if (d == 1'b0) begin // ADDWF to W_REG
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        data_memory[STATUS] [2] = 1'b1;
                    end
                end 
                else if (d == 1'b1)begin // ADDWF to F
                    data_memory[F_ADDR] = ALU_OUT;
                    if (data_memory[F_ADDR] == 8'b00000000) begin
                        data_memory[STATUS] [2] = 1'b1;
                    end
                end

                if ((W_REG[3:0] + F_REG[3:0] > 4'b1001) || (W_REG[7:4] + F_REG[7:4] > 4'b1001) || data_memory[STATUS][0] == 1) begin
                    data_memory[STATUS] [1] = 1'b1;
                end

                STATUS_REG = data_memory[STATUS];
                CHECK_REG = data_memory[F_ADDR];

            end
            ANDWF: begin // ANDWF
                ALU_OUT = W_REG & F_REG;
                if (d == 1'b0) begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end
                end 
                else if (d == 1'b1) begin
                    data_memory[F_ADDR] = ALU_OUT;
                    CHECK_REG = data_memory[F_ADDR];
                    if (data_memory[F_ADDR] == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end
                end

                CHECK_REG = data_memory[F_ADDR];
                STATUS_REG = data_memory[STATUS];

            end
            CLR: begin 
                if (d == 1'b1) begin // CLRF
                    data_memory[F_ADDR] = 8'b00000000;
                    data_memory[STATUS][2] = 1'b1;
                end
                else if (d == 1'b0) begin // CLRW
                    W_REG = 8'b00000000;
                    data_memory[STATUS][2] = 1'b1;   

                end
                STATUS_REG = data_memory[STATUS];
                CHECK_REG = data_memory[F_ADDR];
            end
            COMF: begin //COMF
                ALU_OUT = ~F_REG;
                if (d == 1'b0)begin //to W
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end
                end
                else if (d == 1'b1) begin // TO F
                    data_memory[F_ADDR] = ALU_OUT;
                        if (data_memory[F_ADDR] == 8'b00000000) begin
                            data_memory[STATUS][2] = 1'b1;
                    end
                end
                CHECK_REG = data_memory[F_ADDR];
                STATUS_REG = data_memory[STATUS];
            end
            DECF: begin // DECF 
                ALU_OUT = F_REG - 1'b1;
                if (d == 1'b0)begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end 
                end
                else if (d == 1'b1) begin
                    data_memory[F_ADDR] = ALU_OUT;
                    if (data_memory[F_ADDR] == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end 
                end
                CHECK_REG = data_memory[F_ADDR];
                STATUS_REG = data_memory[STATUS];
            end
            INCF: begin // INCF 
                ALU_OUT = F_REG + 1'b1;
                if (d == 1'b0)begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end 
                end
                else if (d == 1'b1) begin
                    data_memory[F_ADDR] = ALU_OUT;
                    if (data_memory[F_ADDR] == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end 
                end
                CHECK_REG = data_memory[F_ADDR];
                STATUS_REG = data_memory[STATUS];
            end
            IORWF: begin // IORWF
                ALU_OUT = W_REG | F_REG;
                if (d == 1'b0) begin
                    W_REG = ALU_OUT;
                    if (W_REG != 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end
                end 
                else if (d == 1'b1) begin
                    data_memory[F_ADDR] = ALU_OUT;
                    CHECK_REG = data_memory[F_ADDR];
                    if (data_memory[F_ADDR] != 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end
                end

                CHECK_REG = data_memory[F_ADDR];
                STATUS_REG = data_memory[STATUS];

            end
            MOVF: begin // MOVF 
                if (d == 1'b0) begin
                    W_REG = F_REG;
                    if (W_REG == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end
                end 
                else if (d == 1'b1)begin
                    data_memory[F_ADDR] = F_REG;
                    if (data_memory[F_ADDR] == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end
                end
                CHECK_REG = data_memory[F_ADDR]; //inorder to check the data of reg at f addr
                STATUS_REG = data_memory[STATUS]; //inorder to check the data of status reg 

            end
            MOVWF: begin
                if (d == 1'b1) begin
                    data_memory[F_ADDR] = W_REG;
                end
                CHECK_REG = data_memory[F_ADDR]; //inorder to check the data of reg at f addr
                STATUS_REG = data_memory[STATUS]; //inorder to check the data of status reg 
            end      
            RLF: begin // RLF
                tmp_cout = data_memory[STATUS][0];
                tmp_msbF = F_REG[7];
                data_memory[STATUS][0] = tmp_msbF;
                ALU_OUT = F_REG << 1;
                ALU_OUT[0] = tmp_cout;

                if(d == 1'b0) begin
                    W_REG = ALU_OUT;
                end
                else if (d == 1'b1) begin
                    data_memory[F_ADDR] = ALU_OUT;
                end

                CHECK_REG = data_memory[F_ADDR]; //inorder to check the data of reg at f addr
                STATUS_REG = data_memory[STATUS]; //inorder to check the data of status reg 
            end
            RRF: begin // RRF 
                tmp_cout = data_memory[STATUS][0];
                tmp_msbF = F_REG[0];
                data_memory[STATUS][0] = tmp_msbF;
                ALU_OUT =  F_REG >> 1;
                ALU_OUT[7] = tmp_cout;

                if(d == 1'b0) begin
                    W_REG = ALU_OUT;
                end
                else if (d == 1'b1) begin
                    data_memory[F_ADDR] = ALU_OUT;
                end
                CHECK_REG = data_memory[F_ADDR]; //inorder to check the data of reg at f addr
                STATUS_REG = data_memory[STATUS]; //inorder to check the data of status reg 

            end
            SUBWF: begin
                if (W_REG > F_REG) begin
                    ALU_OUT = F_REG - W_REG; // No borrow, normal subtraction
                    data_memory[STATUS][0] = 1'b0;           // Set C_OUT since no borrow occurred
                end else begin
                    ALU_OUT = F_REG - W_REG;  // Borrow occurred, subtract in reverse
                    data_memory[STATUS][0] = 1'b1;           // Clear C_OUT since borrow occurred
                end

                if(d == 1'b0) begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end 
                end
                else if(d == 1'b1) begin
                    data_memory[F_ADDR] = ALU_OUT;
                    if (data_memory[F_ADDR] == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end 
                end

                if ((W_REG[3:0] + F_REG[3:0] > 4'b1001) || (W_REG[7:4] + F_REG[7:4] > 4'b1001) || data_memory[STATUS][0] == 1) begin
                    data_memory[STATUS][1] = 1'b1;
                end

                STATUS_REG = data_memory[STATUS];
                CHECK_REG = data_memory[F_ADDR];
            end
            SWAPF: begin // SWAPF
                if (d == 1'b0) begin
                    // tmp1 = F_REG[3:0];
                    // tmp2 = F_REG[7:4];
                    // W_REG[3:0] <= tmp2;
                    // W_REG[7:4] <= tmp1;
                    W_REG = {F_REG[3:0], F_REG[7:4]};

                end
                else if (d == 1'b1) begin
                    // tmp1 = F_REG[3:0];
                    // tmp2 = F_REG[7:4];
                    // ALU_OUT[3:0] <= tmp2;
                    // ALU_OUT[7:4] <= tmp1;
                    data_memory[F_ADDR] = {F_REG[3:0], F_REG[7:4]};
                end
                STATUS_REG = data_memory[STATUS];
                CHECK_REG = data_memory[F_ADDR];
            end
            XORWF: begin // IORWF
                ALU_OUT = W_REG ^ F_REG;
                if (d == 1'b0) begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end
                end 
                else if (d == 1'b1) begin
                    data_memory[F_ADDR] = ALU_OUT;
                    CHECK_REG = data_memory[F_ADDR];
                    if (data_memory[F_ADDR] == 8'b00000000) begin
                        data_memory[STATUS][2] = 1'b1;
                    end
                end

                CHECK_REG = data_memory[F_ADDR];
                STATUS_REG = data_memory[STATUS];

            end
            //LITERAL AND CONTROL OPERATIONS
            ANDLW: begin //ADDLW
                W_REG = W_REG & K_LITERAL;
                if (W_REG == 8'b00000000) begin
                    data_memory[STATUS][2] = 1'b1;
                end 
                STATUS_REG = data_memory[STATUS];
            end
            IORLW: begin // IORLW
                W_REG = W_REG | K_LITERAL;
                if (W_REG == 8'b00000000) begin
                    data_memory[STATUS][2] = 1'b1;
                end 
            end
            XORLW: begin // XORLW
                W_REG = W_REG ^ K_LITERAL;
                if (W_REG == 8'b00000000) begin
                    data_memory[STATUS][2] = 1'b1;
                end 
            end
            default: begin
                // No assignment to W_REG and F_REG; they retain their previous values
            end
        endcase

        case (OP_CODE[13:9]) //5-BITS OPCODE
        //LITERAL AND CONTROL OPERATIONS
            ADDLW: begin //ADDLW
                {data_memory[STATUS][0], W_REG} = W_REG + K_LITERAL;
                //FSR_REG = 8'b00000000;

                if ((W_REG[3:0] + K_LITERAL[3:0] > 4'b1001) || (W_REG[7:4] + K_LITERAL[7:4] > 4'b1001) || data_memory[STATUS][0] == 1) begin
                    data_memory[STATUS][1] = 1'b1;
                end

                if (W_REG == 8'b00000000) begin
                    data_memory[STATUS][2] = 1'b1;
                end 
                STATUS_REG = data_memory[STATUS];
            end
            SUBLW: begin // SUBLW
                if (W_REG > K_LITERAL) begin
                    W_REG = K_LITERAL - W_REG; // No borrow, normal subtraction
                    STATUS_REG[0] = 1'b0;           // Set C_OUT since no borrow occurred
                end else begin
                    W_REG = K_LITERAL - W_REG;  // Borrow occurred, subtract in reverse
                    STATUS_REG[0] = 1'b1;           // Clear C_OUT since borrow occurred
                end
                
                if ((W_REG[3:0] + K_LITERAL[3:0] > 4'b1001) || (W_REG[7:4] + K_LITERAL[7:4] > 4'b1001) || data_memory[STATUS][0] == 1) begin
                    data_memory[STATUS][1] = 1'b1;
                end

                if (W_REG == 8'b00000000) begin
                    data_memory[STATUS][2] = 1'b1;
                end 
                STATUS_REG = data_memory[STATUS];
            end
            default: begin

            end
        endcase

        case (OP_CODE[13:10]) //4-BITS OPCODE
            MOVLW : begin
                W_REG =  K_LITERAL;
            end
            BCF:begin // BCF
                data_memory[F_ADDR][b] = 1'b0;
                CHECK_REG = data_memory[F_ADDR];
            end
            BSF:begin // BSF 
                data_memory[F_ADDR][b] = 1'b1;
                CHECK_REG = data_memory[F_ADDR];
            end

        endcase

        BANK1 = data_memory[test_bank1];
    end
endmodule
