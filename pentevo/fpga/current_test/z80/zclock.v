// PentEvo project (c) NedoPC 2008-2011
//
// Z80 clocking module, also contains some wait-stating when 14MHz
//
// IDEAL:
// fclk    _/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\_/`\
//          |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
// zclk     /```\___/```\___/```\___/```````\_______/```````\_______/```````````````\_______________/```````````````\_______________/`
//          |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
// zpos     `\___/```\___/```\___/```\___________/```\___________/```\___________________________/```\___________________________/```\
//          |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
// zneg     _/```\___/```\___/```\_______/```\___________/```\___________________/```\___________________________/```\________________

// clock phasing:
// c3 must be zpos for 7mhz, therefore c1 - zneg
// for 3.5 mhz, c3 is both zpos and zneg (alternating)




// 14MHz rulez:
// 1. do variable stalls for memory access.
// 2. do fallback on 7mhz for external IO accesses
// 3. clock switch 14-7-3.5 only at RFSH


`include "../include/tune.v"

module zclock(

	input fclk,
	input zclk, // Z80 clock, buffered via act04 and returned back to the FPGA
	output reg zclk_out, // generated Z80 clock - passed through inverter externally!
	input c0, c2,
    
	input rst,
	input rfsh_n, // switch turbo modes in RFSH part of m1
	input  wire iorq,
	input  wire external_port,

	output reg zpos,
	output reg zneg,
	input  wire zclk_stall,

	input [1:0] turbo, // 2'b00 -  3.5 MHz
	                   // 2'b01 -  7.0 MHz
	                   // 2'b1x - 14.0 MHz

	output reg [1:0] int_turbo // internal turbo, switched on /RFSH
    
);

	reg prec3_cnt;
	wire h_prec3_1; // to take every other pulse of c2
	wire h_prec3_2; // to take every other pulse of c2

	reg [2:0] zcount; // counter for generating 3.5 and 7 MHz z80 clocks


	reg old_rfsh_n;


	reg clk14_src; // source for 14MHz clock


`ifdef SIMULATE
	initial // simulation...
	begin
		prec3_cnt = 1'b0;
		int_turbo   = 2'b00;
		old_rfsh_n  = 1'b1;
		clk14_src   = 1'b0;

		zclk_out = 1'b0;
	end
`endif

	// switch clock only at predefined time
	always @(posedge fclk) if(zpos)
	begin
		old_rfsh_n <= rfsh_n;

		if( old_rfsh_n && !rfsh_n )
			int_turbo <= turbo;
	end


	// make 14MHz iorq wait
	reg [3:0] io_wait_cnt;

	reg io_wait;

	wire io;
	reg  io_r;

	assign io = iorq & external_port;

	always @(posedge fclk)
	if( zpos )
		io_r <= io;

	always @(posedge fclk)
	if (rst)
		io_wait_cnt <= 4'd0;
	else if( io && (!io_r) && zpos && int_turbo[1] )
		// io_wait_cnt[3] <= 1'b1;
		io_wait_cnt[0] <= 1'b1;
	// else if( io_wait_cnt[3] )
	else if (|io_wait_cnt)
		io_wait_cnt <= io_wait_cnt + 4'd1;


	always @(posedge fclk)
	case( io_wait_cnt )
		4'b0000: io_wait <= 1'b0;
		4'b0001: io_wait <= 1'b1;
		4'b0010: io_wait <= 1'b1;
		4'b0011: io_wait <= 1'b1;
		4'b0100: io_wait <= 1'b1;
		4'b0101: io_wait <= 1'b1;
		4'b0110: io_wait <= 1'b1;
		4'b0111: io_wait <= 1'b1;
		4'b1000: io_wait <= 1'b1;
		4'b1001: io_wait <= 1'b1;
		4'b1010: io_wait <= 1'b1;
		4'b1011: io_wait <= 1'b1;
		4'b1100: io_wait <= 1'b1;
		4'b1101: io_wait <= 1'b0;
		4'b1110: io_wait <= 1'b1;
		4'b1111: io_wait <= 1'b0;
		default: io_wait <= 1'b0;
	endcase


	wire stall = zclk_stall | io_wait;


	// 14MHz clocking
	always @(posedge fclk)
	if( !stall )
		clk14_src <= ~clk14_src;
	//
	wire pre_zpos_140 =   clk14_src ;
	wire pre_zneg_140 = (~clk14_src);



	// take every other pulse of c2 (make half c2)
	always @(posedge fclk) if( c2 )
		prec3_cnt <= ~prec3_cnt;

	assign h_prec3_1 =  prec3_cnt && c2;
	assign h_prec3_2 = !prec3_cnt && c2;

	wire pre_zpos_35 = h_prec3_2;
	wire pre_zneg_35 = h_prec3_1;

	wire pre_zpos_70 = c2;
	wire pre_zneg_70 = c0;

	wire pre_zpos = int_turbo[1] ? pre_zpos_140 : ( int_turbo[0] ? pre_zpos_70 : pre_zpos_35 );
	wire pre_zneg = int_turbo[1] ? pre_zneg_140 : ( int_turbo[0] ? pre_zneg_70 : pre_zneg_35 );


	always @(posedge fclk)
	begin
		zpos <= (~stall) & pre_zpos & zclk_out;
	end

	always @(posedge fclk)
	begin
		zneg <= (~stall) & pre_zneg & (~zclk_out);
	end


	// make Z80 clock: account for external inversion and make some leading of clock
	// 9.5 ns propagation delay: from fclk posedge to zclk returned back any edge
	// (1/28)/2=17.9ns half a clock lead
	// 2.6ns lag because of non-output register emitting of zclk_out
	// total: 5.8 ns lead of any edge of zclk relative to posedge of fclk => ACCOUNT FOR THIS WHEN DOING INTER-CLOCK DATA TRANSFERS

	always @(negedge fclk)
	begin
		if (zpos)
			zclk_out <= 1'b0;

		if (zneg)
			zclk_out <= 1'b1;
	end


endmodule