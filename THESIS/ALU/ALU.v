module ALU(
    input wire clk,
    //input wire [7:0] F_ADD,
    input wire [13:0] OP_CODE,
    input wire [7:0] L_REG,
    input wire d,
    input wire [2:0] b,
    input wire [7:0] REG1,
    output reg [7:0] W_REG,  // Initialize W_REG to a known value
    output reg [7:0] FSR_REG,  // Initialize FSR_REG to a known value
    output reg [7:0]  STATUS_REG 

);

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
    localparam BTFSC = 14'b01100000000000;
    localparam BTFSS = 14'b01110000000000;
    localparam ADDLW = 14'b11111000000000;
    localparam ANDLW = 14'b11100100000000;
    localparam IORLW = 14'b11100000000000;
    localparam MOVLW = 14'b11000000000000;
    localparam SUBLW = 14'b11110000000000;
    localparam XORLW = 14'b11101000000000;

      // Add these lines if you have operations like INCFSZ and DEFFSZ
    localparam INCFSZ = 14'b01000100000000; // Example definition
    localparam DEFFSZ = 14'b01001000000000; // Example definition

    // Initialize registers
    initial begin
        W_REG = 8'b00000000;
        STATUS_REG = 8'b00000000;
    end
    
    reg [8:0] c_out;  // For addition/subtraction carry out
    reg [3:0] tmp1;
    reg [3:0] tmp2;
    reg tmp_cout = 1'b0;
    reg tmp_msbF = 1'b0;
    reg [7:0] ALU_OUT;

   
    
    always @(posedge clk) begin
        // Reset C_FLAG at the start of each clock cycle
        STATUS_REG[0] = 1'b0;   //C FLAG
        STATUS_REG[1] = 1'b0;   //DC FLAG
        STATUS_REG[2] = 1'b0;   //Z FLAG

        // Perform operations based on OP_CODE
        case (OP_CODE)
            NOP: begin // NOP

            end
            ADDWF: begin // ADDWF to W_REG
                c_out = W_REG + FSR_REG;
                
                ALU_OUT = c_out[7:0];
                STATUS_REG[0] = c_out[8];

                if (d == 1'b0) begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end
                end 
                else if (d == 1'b1)begin
                    FSR_REG = ALU_OUT;
                    if (FSR_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end
                end

                if ((W_REG[3:0] + FSR_REG[3:0] > 4'b1001) || (W_REG[7:4] + FSR_REG[7:4] > 4'b1001) || STATUS_REG[0] == 1) begin
                    STATUS_REG[1] = 1'b1;
                end

            end

            ANDWF: begin // ANDWF
                ALU_OUT = W_REG & FSR_REG;
                if (d == 0) begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end
                end 
                else begin
                    FSR_REG = ALU_OUT;
                    if (FSR_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end
                end
            end

           CLRF: begin // CLRF
                FSR_REG = 8'b00000000;
                STATUS_REG[2] = 1'b1;
            end


          CLRW: begin // CLRW
                W_REG = 8'b00000000;
                STATUS_REG[2] = 1'b1;      
            end

           COMF: begin 
                ALU_OUT = ~FSR_REG;

                if (d == 1'b0)begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end
                end
                else begin
                    FSR_REG = ALU_OUT;
                        if (FSR_REG == 8'b00000000) begin
                            STATUS_REG[2] = 1'b1;
                    end
                end
            end

            DECF: begin // DECF to W_REG
                ALU_OUT = FSR_REG - 1'b1;
                if (d == 1'b0)begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
                else begin
                    FSR_REG = ALU_OUT;
                    if (FSR_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
            end

          INCF: begin // INCF 
                ALU_OUT = FSR_REG + 1'b1;

                if (d == 0)begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
                else begin
                    FSR_REG = ALU_OUT;
                    if (FSR_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end

            end

            INCFSZ: begin // INCFSZ
                ALU_OUT = FSR_REG + 1'b1;
                if (ALU_OUT == 8'b00000000) begin
                    //NOOP
                    #20;
                end

                if (d == 0)begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
                else begin
                    FSR_REG = ALU_OUT;
                    if (FSR_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end

            end

            DEFFSZ: begin // DECFSZ
                ALU_OUT = FSR_REG - 1'b1;
                if (ALU_OUT == 8'b00000000) begin
                     //NOOP
                    #20;
                end

                if (d == 0)begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
                else begin
                    FSR_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
            end

            IORWF: begin // IORWF 
                ALU_OUT = W_REG | FSR_REG;
                // if (ALU_OUT == 8'b00000000) begin
                //     STATUS_REG[2] = 1'b0;
                // end 

                if (d == 1'b0)begin
                    W_REG = ALU_OUT;
                    if (W_REG != 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
                else begin
                    FSR_REG = ALU_OUT;
                    if (FSR_REG != 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
            end

            MOVF: begin // MOVF 
                //FSR_REG =  REG1;
                if (d == 1'b0) begin
                    //W_REG = FSR_REG;
                    W_REG = REG1;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end
                end 
                else if (d == 1'b1)begin
                    //FSR_REG = FSR_REG;
                    FSR_REG = REG1;
                    if (FSR_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end
                end

            end
            MOVWF: begin
                FSR_REG = W_REG;
            end
            SWAPF: begin // SWAPF to W
                if (d == 1'b0) begin
                    tmp1 = FSR_REG[3:0];
                    tmp2 = FSR_REG[7:4];
                    W_REG[3:0] <= tmp2;
                    W_REG[7:4] <= tmp1;

                end
                else begin
                    tmp1 = FSR_REG[3:0];
                    tmp2 = FSR_REG[7:4];
                    FSR_REG[3:0] <= tmp2;
                    FSR_REG[7:4] <= tmp1;
                end
            end

            XORWF: begin // XORWF
                ALU_OUT = W_REG ^ FSR_REG;

                if (d == 1'b0)begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
                else begin
                    FSR_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
            end

            RLF: begin // RLF
                tmp_cout = STATUS_REG[0];
                tmp_msbF = FSR_REG[7];
                STATUS_REG[0] = tmp_msbF;
                ALU_OUT = FSR_REG << 1;
                ALU_OUT[0] = tmp_cout;

                if(d == 1'b0) begin
                    W_REG = ALU_OUT;
                end
                else begin
                    FSR_REG = ALU_OUT;
                end

            end
            RRF: begin // RRF to W
                tmp_cout = STATUS_REG[0];
                tmp_msbF = FSR_REG[0];
                STATUS_REG[0] = tmp_msbF;
                ALU_OUT =  FSR_REG >> 1;
                ALU_OUT[7] = tmp_cout;

                if(d == 1'b0) begin
                    W_REG = ALU_OUT;
                end
                else begin
                    FSR_REG = ALU_OUT;
                end
            end
            SUBWF: begin
                if (W_REG > FSR_REG) begin
                    ALU_OUT = FSR_REG - W_REG; // No borrow, normal subtraction
                    STATUS_REG[0] = 1'b0;           // Set C_OUT since no borrow occurred
                end else begin
                    ALU_OUT = FSR_REG - W_REG;  // Borrow occurred, subtract in reverse
                    STATUS_REG[0] = 1'b1;           // Clear C_OUT since borrow occurred
                end

                if(d == 1'b0) begin
                    W_REG = ALU_OUT;
                    if (W_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end
                else begin
                    FSR_REG = ALU_OUT;
                    if (FSR_REG == 8'b00000000) begin
                        STATUS_REG[2] = 1'b1;
                    end 
                end

                if ((W_REG[3:0] + FSR_REG[3:0] > 4'b1001) || (W_REG[7:4] + FSR_REG[7:4] > 4'b1001) || STATUS_REG[0] == 1) begin
                    STATUS_REG[1] = 1'b1;
                end
                
            end
            BCF:begin // BCF at bit 0
                if (b == 3'b000 )begin
                    FSR_REG[0] = 1'b0;
                end
                else if (b == 3'b001)begin
                    FSR_REG[1] = 1'b0;
                end
                else if (b == 3'b010)begin
                    FSR_REG[2] = 1'b0;
                end
                else if (b == 3'b011)begin
                    FSR_REG[3] = 1'b0;
                end
                else if (b == 3'b100)begin
                    FSR_REG[4] = 1'b0;
                end
                else if (b == 3'b101)begin
                    FSR_REG[5] = 1'b0;
                end
                else if (b == 3'b110)begin
                    FSR_REG[6] = 1'b0;
                end
                else if (b == 3'b111)begin
                    FSR_REG[7] = 1'b0;
                end
            end

            BSF:begin // BSF 
                if (b == 3'b000 )begin
                    FSR_REG[0] = 1'b1;
                end
                else if (b == 3'b001)begin
                    FSR_REG[1] = 1'b1;
                end
                else if (b == 3'b010)begin
                    FSR_REG[2] = 1'b1;
                end
                else if (b == 3'b011)begin
                    FSR_REG[3] = 1'b1;
                end
                else if (b == 3'b100)begin
                    FSR_REG[4] = 1'b1;
                end
                else if (b == 3'b101)begin
                    FSR_REG[5] = 1'b1;
                end
                else if (b == 3'b110)begin
                    FSR_REG[6] = 1'b1;
                end
                else if (b == 3'b111)begin
                    FSR_REG[7] = 1'b1;
                end
            end

            BTFSC: begin //BTFSC TO BIT 0
                if (b == 3'b000) begin
                    if (FSR_REG[0]==1'b0) begin
                        #20;
                    end
                    else begin
                        FSR_REG[0] = 1'b0;
                    end
                end
                else if (b == 3'b001) begin
                    if (FSR_REG[1]==1'b0) begin
                         #20;
                    end
                    else begin
                        FSR_REG[1] = 1'b0;
                    end
                end
                else if (b == 3'b010) begin
                    if (FSR_REG[2]==1'b0) begin
                        #20;
                    end
                    else begin
                        FSR_REG[2] = 1'b0;
                    end
                end
                else if (b == 3'b011) begin
                    if (FSR_REG[3]==1'b0) begin
                        #20;
                    end
                    else begin
                        FSR_REG[3] = 1'b0;
                    end
                end
                else if (b == 3'b100) begin
                    if (FSR_REG[4]==1'b0) begin
                        #20;
                    end
                    else begin
                        FSR_REG[4] = 1'b0;
                    end
                end
                else if (b == 3'b101) begin
                    if (FSR_REG[5]==1'b0) begin
                        #20;
                    end
                    else begin
                        FSR_REG[5] = 1'b0;
                    end
                end
                else if (b == 3'b110) begin
                        if (FSR_REG[6]==1'b0) begin
                         #20;
                    end
                    else begin
                        FSR_REG[6] = 1'b0;
                    end
                end
                else if (b == 3'b111) begin
                    if (FSR_REG[7]==1'b0) begin
                        #20;
                    end
                    else begin
                        FSR_REG[7] = 1'b0;
                    end
                end
                
            end

            BTFSS: begin //BTFSC TO BIT 0
                if (b == 3'b000) begin
                    if (FSR_REG[0]==1'b1) begin
                        #20;
                    end
                    else begin
                        FSR_REG[0] = 1'b1;
                    end
                end
                else if (b == 3'b001) begin
                    if (FSR_REG[1]==1'b1) begin
                        #20;
                    end
                    else begin
                        FSR_REG[1] = 1'b1;
                    end
                end
                else if (b == 3'b010) begin
                    if (FSR_REG[2]==1'b1) begin
                        #20;
                    end
                    else begin
                        FSR_REG[2] = 1'b1;
                    end
                end
                else if (b == 3'b011) begin
                    if (FSR_REG[3]==1'b1) begin
                        #20;
                    end
                    else begin
                        FSR_REG[3] = 1'b1;
                    end
                end
                else if (b == 3'b100) begin
                    if (FSR_REG[4]==1'b1) begin
                        #20;
                    end
                    else begin
                        FSR_REG[4] = 1'b1;
                    end
                end
                else if (b == 3'b101) begin
                    if (FSR_REG[5]==1'b1) begin
                        #20;
                    end
                    else begin
                        FSR_REG[5] = 1'b1;
                    end
                end
                else if (b == 3'b110) begin
                    if (FSR_REG[6]==1'b1) begin
                        #20;
                    end
                    else begin
                        FSR_REG[6] = 1'b1;
                    end
                end
                else if (b == 3'b111) begin
                    if (FSR_REG[7]==1'b1) begin
                        #20;
                    end
                    else begin
                        FSR_REG[7] = 1'b1;
                    end
                end
            end
            //CONTROL AND LITERAL OPERATIONS
            ADDLW: begin //ADDLW
                {STATUS_REG[0], W_REG} = W_REG + L_REG;
                //FSR_REG = 8'b00000000;

                if ((W_REG[3:0] + L_REG[3:0] > 4'b1001) || (W_REG[7:4] + L_REG[7:4] > 4'b1001) || STATUS_REG[0] == 1) begin
                    STATUS_REG[1] = 1'b1;
                end

                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end

            ANDLW: begin //ANDLW
                W_REG = W_REG & L_REG;
                //FSR_REG = 8'b00000000;
        
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            IORLW: begin // IORLW
                W_REG = W_REG | L_REG;
                FSR_REG = 8'b00000000;

                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            MOVLW: begin // MOVLW
                W_REG =  L_REG;
            end
            SUBLW: begin // SUBLW
                if (W_REG > L_REG) begin
                    W_REG = L_REG - W_REG; // No borrow, normal subtraction
                    STATUS_REG[0] = 1'b0;           // Set C_OUT since no borrow occurred
                end else begin
                    W_REG = L_REG - W_REG;  // Borrow occurred, subtract in reverse
                    STATUS_REG[0] = 1'b1;           // Clear C_OUT since borrow occurred
                end
                FSR_REG = 8'b00000000;        // Clear FSR_REG as per the operation
                if ((W_REG[3:0] + L_REG[3:0] > 4'b1001) || (W_REG[7:4] + L_REG[7:4] > 4'b1001) || STATUS_REG[0] == 1) begin
                    STATUS_REG[1] = 1'b1;
                end
                
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            XORLW: begin // XORLW
                W_REG = W_REG ^ L_REG;
                FSR_REG = 8'b00000000;
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            default: begin
                // No assignment to W_REG and FSR_REG; they retain their previous values
            end
        endcase

    end
endmodule
