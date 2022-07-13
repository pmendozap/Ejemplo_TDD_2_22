`timescale 1ns / 1ps

module fsm_pulsos(
    input logic     clk_i,      
    input logic     rst_n_i,    // Reset input - active low
    input logic     button_o,   // Button input
    output logic    pulse_o     // Pulse output 
    );

    enum logic [1:0] {
        WAIT_ONE,           // Wait for One in the input
        PULSE_GEN,          // Generate the pulse
        WAIT_ZERO           // Wait for the input to go back to zero
    } state_r, next_state;

    // NEXT STATE LOGIC -- Combinational
    always_comb begin
        case(state_r)
        WAIT_ONE:
            begin 
                if(!button_o) next_state = WAIT_ONE;
                else          next_state = PULSE_GEN;
            end
            
        PULSE_GEN:
            begin
                if(!button_o) next_state = WAIT_ONE;
                else          next_state = WAIT_ZERO;
            end
            
        WAIT_ZERO:
            begin
                if(!button_o) next_state = WAIT_ONE;
                else          next_state = WAIT_ZERO;
            end
            
        default: next_state = WAIT_ONE;
        endcase
    end
    
    // MEMORY
    always_ff @(posedge clk_i)
        if(!rst_n_i) state_r <= WAIT_ONE;
        else         state_r <= next_state;


    // OUTPUT LOGIC - Combinational
    always_comb begin
        case(state_r)
            WAIT_ONE:  pulse_o = 1'b0;
            PULSE_GEN: pulse_o = 1'b1;
            WAIT_ZERO: pulse_o = 1'b0;
            default:   pulse_o = 1'b0; 
        endcase
    end

endmodule
