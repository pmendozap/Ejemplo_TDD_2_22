`timescale 1ns / 1ps

module fsm_pulsos(
    input logic     clk_i,      
    input logic     rst_n_i,    // Reset input - active low
    input logic     button_i,   // Button input
    output logic    pulse_o     // Pulse output 
    );
    
    import pkg_top_pulsos::*;

    enum logic [1:0] {
        WAIT_ACTIVE,        // Wait for the active level in the input
        PULSE_GEN,          // Generate the pulse
        WAIT_INACTIVE       // Wait for the input to go back to inactive
    } state_r, next_state;

    // NEXT STATE LOGIC -- Combinational
    always_comb begin
        case(state_r)
        WAIT_ACTIVE:
            begin 
                if(button_i == DETECTED_SLOPE) next_state = PULSE_GEN;
                else                           next_state = WAIT_ACTIVE;
            end
            
        PULSE_GEN:
            begin
                if(button_i == DETECTED_SLOPE) next_state = WAIT_INACTIVE;
                else                           next_state = WAIT_ACTIVE;
            end
            
        WAIT_INACTIVE:
            begin
                if(button_i == DETECTED_SLOPE) next_state = WAIT_INACTIVE;
                else                           next_state = WAIT_ACTIVE;
            end
            
        default: next_state = WAIT_ACTIVE;
        endcase
    end
    
    // MEMORY
    always_ff @(posedge clk_i)
        if(!rst_n_i) state_r <= WAIT_ACTIVE;
        else         state_r <= next_state;


    // OUTPUT LOGIC - Combinational
    always_comb begin
        case(state_r)
            WAIT_ACTIVE:    pulse_o = ~OUT_POLARITY;
            PULSE_GEN:      pulse_o = OUT_POLARITY;
            WAIT_INACTIVE:  pulse_o = ~OUT_POLARITY;
            default:        pulse_o = ~OUT_POLARITY; 
        endcase
    end

endmodule
