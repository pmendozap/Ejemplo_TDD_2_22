`timescale 1ns / 1ps

module sync_inputs
    #(
        parameter DELAY = 3
    )(
        input logic  clk_i,
        input logic  pin_i,
        output logic pin_o
    );
    
    logic [DELAY-1:0] delay_line;
    
    always_ff @(posedge clk_i)
        delay_line <= {pin_i, delay_line[DELAY-1:1]};
    
    assign pin_o = delay_line[0];
endmodule
