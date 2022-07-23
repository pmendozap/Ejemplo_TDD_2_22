package pkg_top_pulsos;
    typedef enum logic {
        POS_EDGE = 1'b1,
        NEG_EDGE = 1'b0
    } t_slope;
    
    localparam t_slope DETECTED_SLOPE     = POS_EDGE;   // The logic level that triggers the pulse
    localparam logic   OUT_POLARITY       = 1;          // The Active level for the output
    
endpackage
