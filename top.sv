`include "tb.sv"
`include "dut.sv"

module fsm_top;
logic clk = 0;
initial forever #5 clk = ~clk;

fsmif fsm_if(.*);
fsm u1 (.get_data(fsm_if.get_data), .reset_(fsm_if.reset_), .clk(clk), .rd(fsm_if.rd), .rd_addr(fsm_if.rd_addr), .data(fsm_if.data), 
	.done_frame(fsm_if.done_frame), .latch_en(fsm_if.latch_en),
	.sipo_en(fsm_if.sipo_en), .dp1_en(fsm_if.dp1_en), .dp2_en(fsm_if.dp2_en), .dp3_en(fsm_if.dp3_en), .dp4_en(fsm_if.dp4_en), .wr(fsm_if.wr));
fsm_tb tb(.*);
endmodule
