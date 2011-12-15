// This module generates all video raster signals


module video_sync (

// clocks
	input wire clk, q2, c6, pix_stb,

// video parameters
	input wire [8:0] hpix_beg,
	input wire [8:0] hpix_end,
	input wire [8:0] vpix_beg,
	input wire [8:0] vpix_end,
	input wire [4:0] go_offs,
	input wire [1:0] x_offs,
	input wire [7:0] hint_beg,
	input wire [8:0] vint_beg,
	input wire [7:0] cstart,
    input wire [8:0] rstart,
	
// video syncs
	output reg hsync,
	output reg vsync,
	output reg csync,

// video controls
	input wire nogfx,
	output wire hpix,
	output wire vpix,
	output wire hvpix,
	output wire tv_blank,
	output wire vga_blank,
	output wire vga_line,
	output wire frame_start,
	output wire line_start,
	output wire pix_start,
	output wire tspix_start,
	output wire flash,

// video counters
	output wire [9:0] vga_cnt_in,
	output wire [9:0] vga_cnt_out,
	output wire [8:0] lcount,
	output reg [7:0] cnt_col,
	output reg [8:0] cnt_row,
	output reg cptr,
	output reg [4:0] scnt,

// DRAM
	input wire video_next,
	output wire video_go,

// ZX controls
	output wire int_start
	
);
	
	localparam HSYNC_BEG 	= 9'd10;
	localparam HSYNC_END 	= 9'd43;
	localparam HBLNK_BEG 	= 9'd00;
	localparam HBLNK_END 	= 9'd88;
	
	localparam HSYNCV_BEG 	= 9'd5;
	localparam HSYNCV_END 	= 9'd31;
	localparam HBLNKV_END 	= 9'd44;
	
	localparam HPERIOD   	= 9'd448;

	localparam VSYNC_BEG 	= 9'd08;
	localparam VSYNC_END 	= 9'd11;
	localparam VBLNK_BEG 	= 9'd00;
	localparam VBLNK_END 	= 9'd32;
	
	localparam VPERIOD   	= 9'd320;	// fucking pentagovn!!!


// counters
	reg [8:0] hcount = 0;
	reg [8:0] vcount = 0;
	reg [8:0] cnt_out = 0;

	// horizontal TV (7 MHz)
	always @(posedge clk) if (c6)
		hcount <= line_start ? 0 : hcount + 1;

	// horizontal VGA (14MHz)
	always @(posedge clk) if (q2)
		cnt_out <= vga_pix_start & c6 ? 0 : cnt_out + 1;

	// vertical TV (15.625 kHz)
	always @(posedge clk) if (c6) if (line_start)
		vcount <= vcount == (VPERIOD - 1) ? 0 : vcount + 1;

	// column address for DRAM
	always @(posedge clk)
		if (line_start)
		begin
			cnt_col <= cstart;
			cptr <= 1'b0;
		end
		else
		if (video_next)
		begin
			cnt_col <= cnt_col + 1;
			cptr <= ~cptr;
		end

	// row address for DRAM
	always @(posedge clk) if (c6)
		if (frame_start)
			cnt_row <=  rstart;
		else
		if (line_start & vpix)
			cnt_row <=  cnt_row + 1;
	
	// pixel counter
	always @(posedge clk) if (pix_stb)		// f0 or q2
		scnt <= pix_start ? 0 : scnt + 1;
	
	assign vga_cnt_in = {vcount[0], hcount - HBLNK_END};
	assign vga_cnt_out = {~vcount[0], cnt_out};
	assign lcount = vcount - vpix_beg - 1;

	
// FLASH generator
	reg [4:0] flash_ctr;
	assign flash = flash_ctr[4];
	always @(posedge clk) if (int_start & c6)
		flash_ctr <= flash_ctr + 1;


//	strobes
	wire hs = (hcount >= HSYNC_BEG) & (hcount < HSYNC_END);
	wire vs = (vcount >= VSYNC_BEG) & (vcount < VSYNC_END);
	wire tv_hblank = (hcount > HBLNK_BEG) & (hcount < HBLNK_END + 1);
	wire tv_vblank = (vcount >= VBLNK_BEG) & (vcount < VBLNK_END);
	assign tv_blank = tv_hblank | tv_vblank;
	assign vga_hblank = (cnt_out >= 9'd360);
	assign vga_blank = vga_hblank | vga_vblank;
	
	wire hs_vga = ((hcount >= HSYNCV_BEG) & (hcount < HSYNCV_END)) |
			((hcount >= (HSYNCV_BEG + HPERIOD/2)) & (hcount < (HSYNCV_END + HPERIOD/2)));
	
	assign vga_pix_start = ((hcount == (HBLNKV_END) - 1) | (hcount == (HBLNKV_END + HPERIOD/2 - 1)));

	assign vga_line = (hcount >= HPERIOD/2);
	
	assign hpix = (hcount >= hpix_beg) & (hcount < hpix_end);
	assign vpix = (vcount >= vpix_beg) & (vcount < vpix_end);
	assign hvpix = hpix & vpix;
	
	assign video_go = (hcount >= (hpix_beg - go_offs - x_offs)) & (hcount < (hpix_end - go_offs)) & vpix &!nogfx;
	
	assign line_start = (hcount == (HPERIOD - 1));
	assign frame_start = line_start & (vcount == (VPERIOD - 1));
	assign pix_start = (hcount == (hpix_beg - 1 - x_offs));
	assign tspix_start = (hcount == (hpix_beg - 1));
	
	assign int_start = (hcount == {hint_beg, 1'b0}) & (vcount == vint_beg);


	reg vga_vblank;
	always @(posedge clk) if (line_start & c6)
		vga_vblank <= tv_vblank;
	
	
	always @(posedge clk)
	begin
		hsync <= ~hs_vga;
		vsync <= ~vs;
		csync <= ~(vs ^ hs);
	end


endmodule