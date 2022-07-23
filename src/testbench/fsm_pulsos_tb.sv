`timescale 1ns / 1ps

module fsm_pulsos_tb;
import pkg_top_pulsos::*;
    // variables
    logic    clk;      
    logic    rst_n;         // Reset input - active low
    logic    button;        // Button input
    logic    pulse;         // Pulse output
    
    integer  count1 = 0;    // For having random delays
    integer  count2 = 0;    // Count length of pulse
        
    // simulation parameters 
    localparam PERIOD = 10;
    
    
    fsm_pulsos dut(
        .clk_i      (clk),      
        .rst_n_i    (rst_n),    // Reset input - active low
        .button_i   (button),   // Button input
        .pulse_o    (pulse)     // Pulse output 
    );
     
    initial begin
        clk = 0;
        forever begin
            #(PERIOD/2); clk = ~clk;
        end
    end
    
    // Stimulus
    initial begin
        rst_n  <= 1'b0;
        button <= ~DETECTED_SLOPE;
        
        repeat(2) begin
            @(posedge clk); #1;
        end
        rst_n <= 1'b1;
        
        repeat(20) begin
            count1 = $random%10 + 1;
            repeat(count1) begin
                @(posedge clk); #1;
            end
            button <= ~button;
        end
        
        @(posedge clk);
        button <= ~DETECTED_SLOPE;    
        repeat(4) begin
            @(posedge clk); #1;
            button <= ~button;
        end
        
        @(posedge clk); #1;
        @(posedge clk); #1;
        $finish;               
    end
    
    // Check
    always begin
        if(DETECTED_SLOPE==1) begin
            @(posedge button); #1;
        end else begin
            @(negedge button); #1;
        end
        count2 = 0;
        do begin
            @(posedge clk); #1;
            if(pulse == OUT_POLARITY)count2 = count2 + 1;
        end while(button == DETECTED_SLOPE);
        if(count2 == 1) $display("%t OK   : pulse lasted %d clks", $time, count2);
        if(count2 != 1) $display("%t Error: pulse lasted %d clks", $time, count2); 
    end
     
endmodule;