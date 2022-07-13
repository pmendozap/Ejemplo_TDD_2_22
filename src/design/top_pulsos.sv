`timescale 1ns / 1ps

module top_pulsos(
        input  logic clk_pi,        // Clock input port
        input  logic rst_n_pi,      // Reset input port - active low        
        input  logic button_pi,     // Button input port
        output logic led_po         // Led output port
    );
    
    logic button_r;
    

    fsm_pulsos dut(
        .clk_i      (clk_pi),      
        .rst_n_i    (rst_n_pi),     // Reset input - active low
        .button_o   (button_pi),        // Button input
        .pulse_o    (led_po)        // Pulse output 
    );
    
endmodule
