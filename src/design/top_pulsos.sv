`timescale 1ns / 1ps

module top_pulsos(
        input  logic clk_pi,        // Clock input port
        input  logic rst_n_pi,      // Reset input port - active low        
        input  logic button_pi,     // Button input port
        output logic led_po         // Led output port
    );
    
    //se�ales internas
    logic button_r;     // Bot�n sincronizado
    logic led_c;        // Salida del m�dulo generador de pulsos (sin registrar)
    
    // Sincronizadores
    sync_inputs sync_bt (
        .clk_i      (clk_pi),
        .pin_i      (button_pi),
        .pin_o      (button_r)
    );
    
    // Generador de pulsos
    fsm_pulsos dut(
        .clk_i      (clk_pi),      
        .rst_n_i    (rst_n_pi),     // Reset input - active low
        .button_i   (button_r),        // Button input
        .pulse_o    (led_c)        // Pulse output 
    );
    
    // Registrando la salida
    always_ff @(posedge clk_pi)
        led_po <= led_c;
        
endmodule
