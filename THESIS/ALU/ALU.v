module ALU(
    input wire clk,
    input wire [7:0] F_ADD,
    input wire [6:0] OP_CODE,
    input wire [7:0] L_REG,
    output reg [7:0] W_REG = 8'b00000000,  // Initialize W_REG to a known value
    output reg [7:0] F_OUT = 8'b00000000,  // Initialize F_OUT to a known value
    // output reg C_FLAG = 1'b0,                // Carry out flag from ALU to a known value
    // output reg DC_FLAG = 1'b0,               //Digit Carry flag
    // output reg Z_FLAG = 1'b0,                 // Zero Flag
    output reg [7:0]  STATUS_REG = 8'b00000000
);
    
    reg [8:0] c_out;  // For addition/subtraction carry out
    reg [3:0] tmp1;
    reg [3:0] tmp2;
    reg tmp_cout = 1'b0;
    reg tmp_msbF = 1'b0;

    always @(posedge clk) begin
        // Reset C_FLAG at the start of each clock cycle
        // C_FLAG = 1'b0;
        // DC_FLAG = 1'b0;
        // Z_FLAG = 1'b0;

        STATUS_REG[0] = 1'b0;
        STATUS_REG[1] = 1'b0;
        STATUS_REG[2] = 1'b0;

        // STATUS_REG[0] = C_FLAG;
        // STATUS_REG[1] = DC_FLAG;
        // STATUS_REG[2] = Z_FLAG;

        // Perform operations based on OP_CODE
        case (OP_CODE)
            7'b0001110: begin // ADDWF to W_REG
                c_out = W_REG + F_ADD;
                
                W_REG = c_out[7:0];
                STATUS_REG[0] = c_out[8];
                F_OUT = 8'b00000000;

                if ((W_REG[3:0] + F_ADD[3:0] > 4'b1001) || (W_REG[7:4] + F_ADD[7:4] > 4'b1001) || STATUS_REG[0] == 1) begin
                    STATUS_REG[1] = 1'b1;
                end

                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end

            end
            7'b0001111: begin // ADDWF to F_OUT
                c_out = W_REG + F_ADD;
                F_OUT = c_out[7:0];
                STATUS_REG[0] = c_out[8];

                if ((W_REG[3:0] + F_ADD[3:0] > 4'b1001) || (W_REG[7:4] + F_ADD[7:4] > 4'b1001) || STATUS_REG[0] == 1) begin
                    STATUS_REG[1] = 1'b1;
                end

                if (F_OUT == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end
            end
            7'b0001010: begin // ANDWF to W_REG
                W_REG = W_REG & F_ADD;
                F_OUT = 8'b00000000;

                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end
            end
            7'b0001011: begin // ANDWF to F_OUT
                F_OUT = W_REG & F_ADD;
                if (F_OUT == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end
            end
            7'b0000011: begin // CLRF
                F_OUT = 8'b00000000;
                STATUS_REG[2] = 1'b1;
            end
            7'b0000010: begin // CLRW
                W_REG = 8'b00000000;
                F_OUT = 8'b00000000;
                STATUS_REG[2] = 1'b1;
                
            end

            7'b0010010: begin // COMF to W_REG
                W_REG = ~F_ADD;
                F_OUT = 8'b00000000;
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b0010011: begin // COMF to F_OUT
                F_OUT = ~F_ADD;
                if (F_OUT == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b0000110: begin // DECF to W_REG
                W_REG = F_ADD - 1'b1;
                F_OUT = 8'b00000000;
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b0000111: begin // DECF to F_OUT
                F_OUT = F_ADD - 1'b1;
                if (F_OUT == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b0010100: begin // INCF to W_REG
                W_REG = F_ADD + 1'b1;
                F_OUT = 8'b00000000;
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b0010101: begin // INCF to F_OUT
                F_OUT = F_ADD + 1'b1;
                if (F_OUT == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b0001000: begin // IORWF to W_REG
                W_REG = W_REG | F_ADD;
                F_OUT = 8'b00000000;
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b0;
                end 
            end
            7'b0001001: begin // IORWF to F_OUT
                F_OUT = W_REG | F_ADD;
                if (F_OUT == 8'b00000000) begin
                    STATUS_REG[2] = 1'b0;
                end 
            end
            7'b0010000: begin // MOVF to W_REG
                W_REG = F_ADD;
                F_OUT = 8'b00000000;
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b0;
                end 
            end
            7'b0010001: begin // MOVF to F_OUT
                F_OUT = F_ADD;
                if (F_OUT == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b0000001: begin // MOVWF
                F_OUT = W_REG;
            end
            7'b0000000: begin // NOP
                W_REG = W_REG;
                F_OUT = 8'b00000000;

            end
            7'b0000100: begin // SUBWF to W_REG
                if (F_ADD >= W_REG) begin
                    W_REG = W_REG - F_ADD; // No borrow, normal subtraction
                    STATUS_REG[0] = 1'b1;           // Set C_FLAG since no borrow occurred
                end else begin
                    W_REG = W_REG - F_ADD;  // Borrow occurred, subtract in reverse
                    STATUS_REG[0] = 1'b0;           // Clear C_FLAG since borrow occurred
                end
                F_OUT = 8'b00000000;        // Clear F_OUT as per the operation

                //DC FLAG
                if ((W_REG[3:0] + F_ADD[3:0] > 4'b1001) || (W_REG[7:4] + F_ADD[7:4] > 4'b1001) || STATUS_REG[0] == 1) begin
                    STATUS_REG[1] = 1'b1;
                end
                //Z FLAG
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            
            7'b0000101: begin // SUBWF to F_OUT
                if (F_ADD >= W_REG) begin
                    F_OUT = W_REG - F_ADD;  // No borrow, normal subtraction
                    STATUS_REG[0] = 1'b1;           // Set C_FLAG since no borrow occurred
                end else begin
                    F_OUT = W_REG - F_ADD;  // Borrow occurred, subtract in reverse
                    STATUS_REG[0] = 1'b0;           // Clear C_FLAG since borrow occurred
                end
                W_REG = W_REG;

                if ((W_REG[3:0] + F_ADD[3:0] > 4'b1001) || (W_REG[7:4] + F_ADD[7:4] > 4'b1001) || STATUS_REG[0] == 1) begin
                    STATUS_REG[1] = 1'b1;
                end

                if (F_OUT == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b0011100: begin // SWAPF to W
                W_REG = F_ADD;
                tmp1 = W_REG[3:0];
                tmp2 = W_REG[7:4];
                W_REG[3:0] <= tmp2;
                W_REG[7:4] <= tmp1;
                F_OUT = 8'b00000000;
            end
            7'b0011101: begin // SWAPF to F
                F_OUT =  F_ADD;
                tmp1 = F_OUT[3:0];
                tmp2 = F_OUT[7:4];
                F_OUT[3:0] <= tmp2;
                F_OUT[7:4] <= tmp1;
            end
            7'b0001100: begin // XORWF to W
                W_REG = W_REG ^ F_ADD;
                F_OUT = 8'b00000000;
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b0001101: begin // XORWF to F
                F_OUT = W_REG ^ F_ADD;
                if (F_OUT == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b0011010: begin // RLF to W
                tmp_cout = STATUS_REG[0];
                tmp_msbF = F_ADD[7];
                STATUS_REG[0] = tmp_msbF;
                F_OUT = F_ADD << 1;
                F_OUT[0] = tmp_cout;
                W_REG = F_OUT;
                F_OUT = 8'b00000000;
            end
            7'b0011011: begin // RLF to F
                tmp_cout = STATUS_REG[0];
                tmp_msbF = F_ADD[7];
                STATUS_REG[0] = tmp_msbF;
                F_OUT = F_ADD << 1;
                F_OUT[0] = tmp_cout;
                F_OUT = F_OUT;
            end
            7'b0011000: begin // RRF to W
                tmp_cout = STATUS_REG[0];
                tmp_msbF = F_ADD[0];
                STATUS_REG[0] = tmp_msbF;
                F_OUT = F_ADD >> 1;
                F_OUT[7] = tmp_cout;
                W_REG = F_OUT;
                F_OUT = 8'b00000000;
            end
            7'b0011001: begin // RRF to F
                tmp_cout = STATUS_REG[0];
                tmp_msbF = F_ADD[0];
                STATUS_REG[0] = tmp_msbF;
                F_OUT = F_ADD >> 1;
                F_OUT[7] = tmp_cout;
                F_OUT = F_OUT;
            end
            7'b0100000:begin // BCF at bit 0
                F_OUT = F_ADD;
                F_OUT[0] = 1'b0;
            end

            7'b0100001:begin // BCF at bit 1
                F_OUT = F_ADD;
                F_OUT[1] = 1'b0;
            end

            7'b0100010:begin // BCF at bit 2
                F_OUT = F_ADD;
                F_OUT[2] = 1'b0;
            end

            7'b0100011:begin // BCF at bit 3
                F_OUT = F_ADD;
                F_OUT[3] = 1'b0;
            end

            7'b0100100:begin // BCF at bit 4
                F_OUT = F_ADD;
                F_OUT[4] = 1'b0;
            end

            7'b0100101:begin // BCF at bit 5
                F_OUT = F_ADD;
                F_OUT[5] = 1'b0;
            end

            7'b0100110:begin // BCF at bit 6
                F_OUT = F_ADD;
                F_OUT[6] = 1'b0;
            end

            7'b0100111:begin // BCF at bit 7
                F_OUT = F_ADD;
                F_OUT[7] = 1'b0;
            end

            7'b0101000:begin // BSF at bit 0
                F_OUT = F_ADD;
                F_OUT[0] = 1'b1;
            end

            7'b0101001:begin // BSF at bit 1
                F_OUT = F_ADD;
                F_OUT[1] = 1'b1;
            end

            7'b0101010:begin // BSF at bit 2
                F_OUT = F_ADD;
                F_OUT[2] = 1'b1;
            end

            
            7'b0101011:begin // BSF at bit 3
                F_OUT = F_ADD;
                F_OUT[3] = 1'b1;
            end

             7'b0101100:begin // BSF at bit 4
                F_OUT = F_ADD;
                F_OUT[4] = 1'b1;
            end

              7'b0101101:begin // BSF at bit 5
                F_OUT = F_ADD;
                F_OUT[5] = 1'b1;
            end

            7'b0101110:begin // BSF at bit 6
                F_OUT = F_ADD;
                F_OUT[6] = 1'b1;
            end

            7'b0101111:begin // BSF at bit 7
                F_OUT = F_ADD;
                F_OUT[7] = 1'b1;
            end
            7'b0110000:begin //BTFSC TO BIT 0
                if (F_ADD[0] == 1'b0) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[0] = 1'b0;
                end
            end

             7'b0110001:begin //BTFSC TO BIT 1
               if (F_ADD[0] == 1'b0) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[1] = 1'b0;
                end
            end

            7'b0110010:begin //BTFSC TO BIT 2
                if (F_ADD[2] == 1'b0) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[2] = 1'b0;
                end
            end

            7'b0110011:begin //BTFSC TO BIT 3
                if (F_ADD[3] == 1'b0) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[3] = 1'b0;
                end
            end

            7'b0110100:begin //BTFSC TO BIT 4
                if (F_ADD[4] == 1'b0) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[4] = 1'b0;
                end
            end

            7'b0110101:begin //BTFSC TO BIT 5
                if (F_ADD[5] == 1'b0) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[5] = 1'b0;
                end
            end

            7'b0110110:begin //BTFSC TO BIT 6
                if (F_ADD[6] == 1'b0) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[6] = 1'b0;
                end
            end
            7'b0110111:begin //BTFSC TO BIT 7
                if (F_ADD[7] == 1'b0) begin
                    F_OUT = F_ADD;
                    //F_OUT = 8'b00000001;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[7] = 1'b0;
                end
            end

            7'b0111000:begin //BTFSS TO BIT 0
                if (F_ADD[0] == 1'b1) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[0] = 1'b1;
                end
            end

            7'b0111001:begin //BTFSS TO BIT 1
                if (F_ADD[1] == 1'b1) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[1] = 1'b1;
                end
            end

            7'b0111010:begin //BTFSS TO BIT 2
                if (F_ADD[2] == 1'b1) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[2] = 1'b1;
                end
            end

            7'b0111011:begin //BTFSS TO BIT 3
                if (F_ADD[3] == 1'b1) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[3] = 1'b1;
                end
            end

            7'b0111100:begin //BTFSS TO BIT 4
                if (F_ADD[4] == 1'b1) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[4] = 1'b1;
                end
            end

            7'b0111101:begin //BTFSS TO BIT 5
                if (F_ADD[5] == 1'b1) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[5] = 1'b1;
                end
            end

            7'b0111110:begin //BTFSS TO BIT 6
                if (F_ADD[6] == 1'b1) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[6] = 1'b1;
                end
            end

            7'b0111111:begin //BTFSS TO BIT 7
                if (F_ADD[7] == 1'b1) begin
                    F_OUT = F_ADD;
                end
                else begin
                    F_OUT = F_ADD;
                    F_OUT[7] = 1'b1;
                end
            end
            //CONTROL AND LITERAL OPERATIONS
            7'b11111xx:begin //ADDLW
               {STATUS_REG[0], W_REG} = L_REG + W_REG;
               F_OUT = 8'b00000000;

                if ((W_REG[3:0] + F_ADD[3:0] > 4'b1001) || (W_REG[7:4] + F_ADD[7:4] > 4'b1001) || STATUS_REG[0] == 1) begin
                    STATUS_REG[1] = 1'b1;
                end

               if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end

            7'b111001x:begin //ANDLW
                W_REG = W_REG & L_REG;
                F_OUT = 8'b00000000;
        
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b111000x: begin // IORLW
                W_REG = W_REG | L_REG;
                F_OUT = 8'b00000000;
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b1100x: begin // MOVLW
                W_REG =  L_REG;
            end
            7'b11110x: begin // SUBLW 
                if (W_REG >= L_REG) begin
                    W_REG = L_REG - W_REG; // No borrow, normal subtraction
                    STATUS_REG[0] = 1'b0;           // Set C_OUT since no borrow occurred
                end else begin
                    W_REG = L_REG - W_REG;  // Borrow occurred, subtract in reverse
                    STATUS_REG[0] = 1'b1;           // Clear C_OUT since borrow occurred
                end
                F_OUT = 8'b00000000;        // Clear F_OUT as per the operation
                if ((W_REG[3:0] + F_ADD[3:0] > 4'b1001) || (W_REG[7:4] + F_ADD[7:4] > 4'b1001) || STATUS_REG[0] == 1) begin
                    STATUS_REG[1] = 1'b1;
                end
                
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            7'b111010x: begin // XORLW
                W_REG = W_REG ^ L_REG;
                F_OUT = 8'b00000000;
                if (W_REG == 8'b00000000) begin
                    STATUS_REG[2] = 1'b1;
                end 
            end
            default: begin
                // No assignment to W_REG and F_OUT; they retain their previous values
            end
        endcase
    end
endmodule
