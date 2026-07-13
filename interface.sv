interface fsmif(input clk);
logic get_data, reset_;
logic  [7:0] data;
logic rd, sipo_en, dp1_en, dp2_en, dp3_en, dp4_en;
logic wr, done_frame, latch_en;
logic [17:0] rd_addr;


clocking cb @(posedge clk);
output get_data, data;
input sipo_en, latch_en; 
input dp1_en, dp2_en, dp3_en, dp4_en, wr;
input done_frame, rd_addr, rd;
endclocking

modport tb(clocking cb, input clk, output reset_);

endinterface

