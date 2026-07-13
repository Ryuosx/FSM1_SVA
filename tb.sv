`include "interface.sv"
module fsm_tb(fsmif.tb fsm_if);

initial begin
fsm_if.reset_ = 1;
#3 fsm_if.reset_ = 0;
#4 fsm_if.reset_ = 1;
end

initial begin
fsm_if.cb.get_data <= 0;
#17 fsm_if.cb.get_data <= 1;
#27 fsm_if.cb.get_data <= 0;

#3194915 fsm_if.cb.get_data <= 1;  
end

endmodule

