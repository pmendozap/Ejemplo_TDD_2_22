`timescale 1ns / 1ps

module fsm_pulsos_tb;

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
        button <= 1'b0;
        
        repeat(2) begin
            @(posedge clk);
        end
        rst_n <= 1'b1;
        
        repeat(20) begin
            count1 = $random%10 + 1;
            repeat(count1) begin
                @(posedge clk);
            end
            button <= ~button;
        end
        
        @(posedge clk);
        button <= 0;    
        repeat(4) begin
            @(posedge clk);
            button <= ~button;
        end
        
        @(posedge clk);
        @(posedge clk);
        $finish;               
    end
    
    // Check
    always begin
        @(posedge button);
        count2 = 0;
        do begin
            @(posedge clk);
            if(pulse == 1)count2 = count2 + 1;
        end while(button == 1);
        if(count2 == 1) $display("%t OK   : pulse lasted %d clks", $time, count2);
        if(count2 != 1) $display("%t Error: pulse lasted %d clks", $time, count2); 
    end
     
endmodule;