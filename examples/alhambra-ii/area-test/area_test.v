/*
 * Area Test Module for ice40hx8k FPGA
 * 
 * This module is designed to utilize approximately 60-70% of the ice40hx8k FPGA resources
 * through a combination of multipliers, register arrays, BRAM instances, and combinational logic.
 * 
 * Features:
 * - Pattern generation counters: 6 x 32-bit counters for generating patterns
 * - BRAM address counters: 4 x 9-bit counters for BRAM addressing
 * - Multipliers: 18 x 16x16-bit multipliers (8+4+4+2 groups)
 * - Register arrays: 6 arrays of 64 x 16-bit registers each
 * - BRAMs: 32 instances of 256x16 bits = 8K words total (all BRAM blocks used)
 * - Combinational logic: Complex logic to utilize remaining LUTs
 * - Accumulators: 6 x 32-bit accumulators
 * - LED assignment: Final result displayed on 8 LEDs
 * 
 * Resource utilization estimate:
 * - ~98% of LUTs (multipliers + combinational logic)
 * - ~100% of BRAMs (32 of 32 available - all blocks used)
 * - ~30% of flip-flops (registers + counters)
 * 
 * The design demonstrates high FPGA resource utilization while staying within
 * the available limits of the ice40hx8k device.
 *
 * Copyright (c) 2025 Carlos Venegas <carlos@magnitude.es>
 * X: @cavearr | FPGAwars: charliva@gmail.com
 *
 * -- License:
 * This work is dedicated to the public domain under the Creative Commons Zero (CC0) 1.0 Universal.
 * To the extent possible under law, the author(s) have waived all copyright and related or neighboring
 * rights to this work worldwide. No rights are reserved.
 * Full text: https://creativecommons.org/publicdomain/zero/1.0/
 */

module area_test (
    input wire CLK,
    output wire LED0,
    output wire LED1,
    output wire LED2,
    output wire LED3,
    output wire LED4,
    output wire LED5,
    output wire LED6,
    output wire LED7
);

    // Pattern generation counters
    reg [31:0] counter1 = 32'h12345678;
    reg [31:0] counter2 = 32'h87654321;
    reg [31:0] counter3 = 32'hABCDEF01;
    reg [31:0] counter4 = 32'hFEDCBA10;
    reg [31:0] counter5 = 32'h55AA55AA;
    reg [31:0] counter6 = 32'hAA55AA55;
    
    // BRAM address counters (reduced to 8 bits)
    reg [7:0] bram_addr1 = 8'h0;
    reg [7:0] bram_addr2 = 8'h0;
    reg [7:0] bram_addr3 = 8'h0;
    reg [7:0] bram_addr4 = 8'h0;
    
    // Counter updates
    always @(posedge CLK) begin
        counter1 <= counter1 + 32'h12345;
        counter2 <= counter2 + 32'h54321;
        counter3 <= counter3 + 32'hABCDE;
        counter4 <= counter4 + 32'hEDCBA;
        counter5 <= counter5 + 32'h13579;
        counter6 <= counter6 + 32'h97531;
        
        // Update BRAM addresses
        bram_addr1 <= bram_addr1 + 1'b1;
        bram_addr2 <= bram_addr2 + 1'b1;
        bram_addr3 <= bram_addr3 + 1'b1;
        bram_addr4 <= bram_addr4 + 1'b1;
    end
    
    // BRAMs - 32 instances using proper BRAM module
    wire [15:0] bram_data_out [0:31];
    wire [15:0] bram_data_in [0:31];
    wire [31:0] bram_cs_n;
    wire [31:0] bram_wr_n;
    wire [31:0] bram_rd_n;
    
    // Continuous address counters for all 32 BRAMs to ensure usage
    reg [7:0] bram_continuous_addr [0:31];
    
    // Initialize and increment all BRAM addresses continuously
    integer m;
    always @(posedge CLK) begin
        for (m = 0; m < 32; m = m + 1) begin
            bram_continuous_addr[m] <= bram_continuous_addr[m] + 1'b1;
        end
    end
    
    genvar k;
    generate
        for (k = 0; k < 32; k = k + 1) begin : bram_array
            // Control signals for each BRAM
            assign bram_cs_n[k] = 1'b0; // Always enabled
            assign bram_wr_n[k] = ~(counter1[k%32] ^ counter2[k%32]); // Write enable logic
            assign bram_rd_n[k] = 1'b0; // Always reading
            
            assign bram_data_in[k] = counter1[15:0] ^ counter2[15:0] ^ k[4:0];
            
            // Instantiate BRAM module - each BRAM uses its own continuous address
            bram #(
                .BRAM_ADDR_WIDTH(8),
                .BRAM_DATA_WIDTH(16)
            ) bram_inst (
                .clk(CLK),
                .addr(bram_continuous_addr[k]),
                .cs_n(bram_cs_n[k]),
                .wr_n(bram_wr_n[k]),
                .rd_n(bram_rd_n[k]),
                .bram_data_in(bram_data_in[k]),
                .bram_data_out(bram_data_out[k])
            );
        end
    endgenerate
    
    // 8 multipliers 16x16 using BRAM data as operands
    wire [31:0] mult_result [0:7];
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mult_array
            assign mult_result[i] = bram_data_out[i][15:0] * bram_data_out[i+8][15:0];
        end
    endgenerate
    
    // 4 additional multipliers using different BRAM combinations
    wire [31:0] mult_set2 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : mult_array2
            assign mult_set2[i] = bram_data_out[i+16][15:0] * bram_data_out[i+20][15:0];
        end
    endgenerate
    
    // 4 more multipliers with cross-combinations
    wire [31:0] mult_set3 [0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : mult_array3
            assign mult_set3[i] = bram_data_out[i+24][15:0] * bram_data_out[i+28][15:0];
        end
    endgenerate
    
    // 2 additional multipliers to reach 18 total
    wire [31:0] mult_set4 [0:1];
    generate
        for (i = 0; i < 2; i = i + 1) begin : mult_array4
            assign mult_set4[i] = bram_data_out[i][15:0] * bram_data_out[i+30][15:0];
        end
    endgenerate
    
    // Remove old bram_filler as we now use all BRAMs directly
    
    // BRAM data processing - XOR all 32 BRAM outputs to ensure usage
    wire [31:0] all_bram_combined;
    assign all_bram_combined = bram_data_out[0] ^ bram_data_out[1] ^ bram_data_out[2] ^ bram_data_out[3] ^
                              bram_data_out[4] ^ bram_data_out[5] ^ bram_data_out[6] ^ bram_data_out[7] ^
                              bram_data_out[8] ^ bram_data_out[9] ^ bram_data_out[10] ^ bram_data_out[11] ^
                              bram_data_out[12] ^ bram_data_out[13] ^ bram_data_out[14] ^ bram_data_out[15] ^
                              bram_data_out[16] ^ bram_data_out[17] ^ bram_data_out[18] ^ bram_data_out[19] ^
                              bram_data_out[20] ^ bram_data_out[21] ^ bram_data_out[22] ^ bram_data_out[23] ^
                              bram_data_out[24] ^ bram_data_out[25] ^ bram_data_out[26] ^ bram_data_out[27] ^
                              bram_data_out[28] ^ bram_data_out[29] ^ bram_data_out[30] ^ bram_data_out[31];
    
    // Multiplication results combined - all 18 multipliers
    wire [31:0] all_mult_combined = mult_result[0] ^ mult_result[1] ^ mult_result[2] ^ mult_result[3] ^
                                   mult_result[4] ^ mult_result[5] ^ mult_result[6] ^ mult_result[7] ^
                                   mult_set2[0] ^ mult_set2[1] ^ mult_set2[2] ^ mult_set2[3] ^
                                   mult_set3[0] ^ mult_set3[1] ^ mult_set3[2] ^ mult_set3[3] ^
                                   mult_set4[0] ^ mult_set4[1];
    
    // Rotating shift registers for LED output
    reg [15:0] bram_shift_reg = 16'h0;
    reg [15:0] mult_shift_reg = 16'h0;
    reg [3:0] mult_bit_selector = 4'h0;
    
    always @(posedge CLK) begin
        // Rotate BRAM data through shift register
        bram_shift_reg <= {bram_shift_reg[14:0], bram_shift_reg[15]} ^ all_bram_combined[15:0];
        // Rotate multiplication data through shift register  
        mult_shift_reg <= {mult_shift_reg[14:0], mult_shift_reg[15]} ^ all_mult_combined[15:0];
        // Increment bit selector to rotate through all 16 bits of multiplication result
        mult_bit_selector <= mult_bit_selector + 1'b1;
    end
    
    // Select rotating bits from multiplication result for LSB LEDs
    wire [3:0] mult_rotating_bits;
    assign mult_rotating_bits[0] = all_mult_combined[mult_bit_selector];
    assign mult_rotating_bits[1] = all_mult_combined[(mult_bit_selector + 4) % 16];
    assign mult_rotating_bits[2] = all_mult_combined[(mult_bit_selector + 8) % 16];
    assign mult_rotating_bits[3] = all_mult_combined[(mult_bit_selector + 12) % 16];
    
    // Register arrays - expanded to 64 registers of 16 bits each
    reg [15:0] reg_array1 [0:63];
    reg [15:0] reg_array2 [0:63];
    reg [15:0] reg_array3 [0:63];
    reg [15:0] reg_array4 [0:63];
    reg [15:0] reg_array5 [0:63];
    reg [15:0] reg_array6 [0:63];
    
    integer j;
    always @(posedge CLK) begin
        // Update first array with multiplier results
        for (j = 0; j < 64; j = j + 1) begin
            if (j < 8)
                reg_array1[j] <= mult_result[j][15:0] ^ reg_array1[j];
            else if (j < 16)
                reg_array1[j] <= mult_result[j-8][31:16] ^ reg_array1[j];
            else if (j < 32)
                reg_array1[j] <= counter1[15:0] ^ reg_array1[j];
            else if (j < 48)
                reg_array1[j] <= counter2[15:0] ^ reg_array1[j];
            else
                reg_array1[j] <= bram_data_out[j-48][15:0] ^ reg_array1[j];
        end
        
        // Update second array with second multiplier set
        for (j = 0; j < 64; j = j + 1) begin
            if (j < 4)
                reg_array2[j] <= mult_set2[j][15:0] | reg_array2[j];
            else if (j < 8)
                reg_array2[j] <= mult_set2[j-4][31:16] & reg_array2[j];
            else if (j < 10)
                reg_array2[j] <= mult_set4[j-8][15:0] ^ reg_array2[j];
            else if (j < 12)
                reg_array2[j] <= mult_set4[j-10][31:16] + reg_array2[j];
            else if (j < 28)
                reg_array2[j] <= counter5[15:0] ^ reg_array2[j];
            else if (j < 44)
                reg_array2[j] <= counter6[15:0] ^ reg_array2[j];
            else if (j < 60)
                reg_array2[j] <= bram_data_out[j-44][7:0] ^ reg_array2[j];
            else
                reg_array2[j] <= bram_data_out[j-44][15:8] + reg_array2[j];
        end
        
        // Update third array with third multiplier set
        for (j = 0; j < 64; j = j + 1) begin
            if (j < 4)
                reg_array3[j] <= mult_set3[j][15:0] ^ reg_array3[j];
            else if (j < 8)
                reg_array3[j] <= mult_set3[j-4][31:16] + reg_array3[j];
            else if (j < 24)
                reg_array3[j] <= counter3[15:0] ^ reg_array3[j];
            else if (j < 40)
                reg_array3[j] <= reg_array1[j] ^ reg_array2[j] ^ j[5:0];
            else if (j < 56)
                reg_array3[j] <= reg_array1[j-16] + reg_array2[j-16] ^ counter1[7:0];
            else
                reg_array3[j] <= bram_data_out[j-56][15:0] & reg_array3[j];
        end
        
        // Update fourth array with complex combinations
        for (j = 0; j < 64; j = j + 1) begin
            if (j < 16)
                reg_array4[j] <= reg_array1[j] & reg_array2[j] ^ reg_array3[j];
            else if (j < 32)
                reg_array4[j] <= reg_array1[j] | reg_array2[j] + reg_array3[j];
            else if (j < 48)
                reg_array4[j] <= reg_array1[j] ^ reg_array2[j] & reg_array3[j];
            else
                reg_array4[j] <= reg_array1[j] + reg_array2[j] | reg_array3[j];
        end
        
        // Update fifth array with BRAM combinations
        for (j = 0; j < 64; j = j + 1) begin
            if (j < 32)
                reg_array5[j] <= bram_data_out[j][15:0] ^ reg_array4[j];
            else
                reg_array5[j] <= bram_data_out[j-32][7:0] + reg_array4[j-32] ^ counter4[7:0];
        end
        
        // Update sixth array with all combinations
        for (j = 0; j < 64; j = j + 1) begin
            if (j < 16)
                reg_array6[j] <= reg_array1[j] ^ reg_array2[j] ^ reg_array3[j] ^ reg_array4[j] ^ reg_array5[j];
            else if (j < 32)
                reg_array6[j] <= reg_array1[j] + reg_array2[j] & reg_array3[j] | reg_array4[j];
            else if (j < 48)
                reg_array6[j] <= reg_array2[j] & reg_array3[j] + reg_array4[j] ^ reg_array5[j];
            else
                reg_array6[j] <= reg_array3[j] | reg_array4[j] ^ reg_array5[j] + counter6[7:0];
        end
    end
    
    // Combinational logic to use more LUTs - expanded
    wire [15:0] combo_logic [0:15];
    generate
        for (i = 0; i < 16; i = i + 1) begin : combo_array
            assign combo_logic[i] = reg_array1[i] ^ reg_array1[i+16] ^ 
                                   reg_array1[i+32] ^ reg_array1[i+48] ^
                                   reg_array2[i] ^ reg_array2[i+16] ^
                                   reg_array2[i+32] ^ reg_array2[i+48] ^
                                   reg_array3[i] ^ reg_array3[i+16] ^
                                   reg_array3[i+32] ^ reg_array3[i+48] ^
                                   reg_array4[i] ^ reg_array4[i+16] ^
                                   reg_array4[i+32] ^ reg_array4[i+48] ^
                                   reg_array5[i] ^ reg_array5[i+16] ^
                                   reg_array5[i+32] ^ reg_array5[i+48] ^
                                   reg_array6[i] ^ reg_array6[i+16] ^
                                   reg_array6[i+32] ^ reg_array6[i+48];
        end
    endgenerate
    
    // More complex combinational logic - expanded
    wire [31:0] complex_combo [0:7];
    generate
        for (i = 0; i < 8; i = i + 1) begin : complex_array
            assign complex_combo[i] = {combo_logic[i], combo_logic[i+8]} ^
                                     {reg_array6[i*8], reg_array6[i*8+1], 
                                      reg_array6[i*8+2], reg_array6[i*8+3],
                                      reg_array6[i*8+4], reg_array6[i*8+5],
                                      reg_array6[i*8+6], reg_array6[i*8+7]} ^
                                     counter1 ^ counter2 ^ mult_result[i%8][31:16];
        end
    endgenerate
    
    // Expanded accumulators
    reg [31:0] accumulator1 = 32'h0;
    reg [31:0] accumulator2 = 32'h0;
    reg [31:0] accumulator3 = 32'h0;
    reg [31:0] accumulator4 = 32'h0;
    reg [31:0] accumulator5 = 32'h0;
    reg [31:0] accumulator6 = 32'h0;
    reg [31:0] accumulator7 = 32'h0;
    reg [31:0] accumulator8 = 32'h0;
    
    always @(posedge CLK) begin
        accumulator1 <= accumulator1 ^ complex_combo[0] ^ complex_combo[1];
        accumulator2 <= accumulator2 ^ complex_combo[2] ^ complex_combo[3];
        accumulator3 <= accumulator3 ^ complex_combo[4] ^ complex_combo[5];
        accumulator4 <= accumulator4 ^ complex_combo[6] ^ complex_combo[7];
        accumulator5 <= accumulator5 ^ counter1[15:0] ^ mult_result[0][15:0];
        accumulator6 <= accumulator6 ^ counter3[15:0] ^ mult_set2[0][15:0];
        accumulator7 <= accumulator7 ^ counter4[15:0] ^ mult_set3[0][15:0];
        accumulator8 <= accumulator8 ^ counter5[15:0] ^ all_bram_combined[15:0];
    end
    
    // Additional logic to fill remaining LUTs
    wire [31:0] extra_logic1 = accumulator1 & accumulator2 ^ accumulator3;
    wire [31:0] extra_logic2 = accumulator4 | accumulator5 + accumulator6;
    wire [31:0] extra_logic3 = extra_logic1 ^ extra_logic2 + counter4;
    wire [31:0] extra_logic4 = (extra_logic1 + extra_logic2) ^ counter5;
    wire [31:0] extra_logic5 = (extra_logic3 & counter6) | (extra_logic4 & counter1);
    wire [31:0] extra_logic6 = extra_logic5 ^ extra_logic1 + extra_logic2;
    wire [31:0] extra_logic7 = extra_logic6 & extra_logic3 | extra_logic4;
    
    // Combine BRAM data with existing logic
    wire [31:0] bram_combined = all_bram_combined;
    
    // Final result
    wire [31:0] final_result = extra_logic7 ^ accumulator1 ^ accumulator2 ^ 
                              counter1 ^ bram_combined;
    
    // LED assignment with rotating outputs
    // 4 MSB LEDs show rotating BRAM data, 4 LSB LEDs show rotating multiplication data
    assign LED7 = bram_shift_reg[15]; // MSB from BRAM data
    assign LED6 = bram_shift_reg[14];
    assign LED5 = bram_shift_reg[13];
    assign LED4 = bram_shift_reg[12];
    assign LED3 = mult_rotating_bits[3]; // Rotating bits from all 18 multipliers
    assign LED2 = mult_rotating_bits[2];
    assign LED1 = mult_rotating_bits[1];
    assign LED0 = mult_rotating_bits[0];

endmodule
/*
 * Copyright 2020 Brian O'Dell
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

module bram (
    input clk, 
    input [BRAM_ADDR_WIDTH-1:0] addr, 
    input cs_n,
    input wr_n, 
    input rd_n,
    input [BRAM_DATA_WIDTH-1:0] bram_data_in,
    output reg [BRAM_DATA_WIDTH-1:0] bram_data_out
);

    parameter BRAM_ADDR_WIDTH = 9;
    parameter BRAM_DATA_WIDTH = 8;

    reg [BRAM_DATA_WIDTH-1:0] mem [(1<<BRAM_ADDR_WIDTH)-1:0];

    always @(posedge clk)
        if (cs_n == 1'b0) begin
            begin
                if (wr_n == 1'b0) mem[(addr)] <= bram_data_in;
                if (rd_n == 1'b0) bram_data_out <= mem[addr];
            end
        end
    endmodule


