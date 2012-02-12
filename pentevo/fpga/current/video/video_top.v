// This module is a video top-level


module video_top (

// clocks
	input wire clk, zclk,
	input wire f0, f1,
	input wire h0, h1,
	input wire c0, c1, c2, c3,
	// input wire t0,	// debug!!!

// video DAC
	output wire	[1:0] vred,
	output wire	[1:0] vgrn,
	output wire	[1:0] vblu,

// video syncs
	output wire	hsync,
	output wire	vsync,
	output wire	csync,

// Z80 controls
	input wire [15:0] a,
	input wire [ 7:0] d,
	input wire [14:0] cram_data_in,
	input wire [15:0] sfys_data_in,
	input wire 		  cram_we,
	input wire 		  sfys_we,

// port write strobes
    input wire        zborder_wr,
    input wire        border_wr,
    input wire        zvpage_wr,
    input wire        vpage_wr,
    input wire        vconf_wr,
    input wire        x_offsl_wr,
    input wire        x_offsh_wr,
    input wire        y_offsl_wr,
    input wire        y_offsh_wr,
    input wire        tsconf_wr,
    input wire        palsel_wr,
    input wire        tgpage_wr,
    input wire        hint_beg_wr ,
    input wire        vint_begl_wr,
    input wire        vint_begh_wr,

// ZX controls
    input wire        res,
	output wire       int_start,

// DRAM interface
	output wire [20:0] video_addr,
	output wire [ 4:0] video_bw,
	output wire        video_go,
	input  wire [15:0] dram_rddata,     // reg'ed, should be latched by c3 (video_strobe)
	input  wire [15:0] dram_rdata,      // raw, should be latched by c2 (video_next)
	input  wire        video_next,
	input  wire        video_strobe,
	output wire [20:0] ts_addr,
	output wire        ts_req,
	input  wire        ts_next,

// video controls
	input wire vga_on

);


// video config
	wire [7:0] vpage;      //
	wire [7:0] vconf;      //
	wire [8:0] x_offs;     // re-latched at line_start
	wire [8:0] y_offs;     //
	wire [3:0] palsel;     //
	wire [7:0] tsconf;          // re-latch!
	wire [4:0] tgpage;          //  these
	wire [7:0] vpage_d;
    wire [3:0] palsel_d;
	wire [7:0] hint_beg;
	wire [8:0] vint_beg;
	wire [8:0] hpix_beg;
	wire [8:0] hpix_end;
	wire [8:0] vpix_beg;
	wire [8:0] vpix_end;
	wire [5:0] x_tiles;
    wire [9:0] x_offs_mode;
    wire [4:0] go_offs;
	wire [1:0] render_mode;
	wire tv_hires;
	wire vga_hires;
	wire nogfx;
	wire tv_blank;
    
// counters
    wire [7:0] cnt_col;
    wire [8:0] cnt_row;
    wire [8:0] cnt_tp_row;
	wire cptr;
    wire [3:0] scnt;
	wire [8:0] lcount;
    
// synchro
	wire frame_start;
	wire line_start;
	wire pix_start;
	wire tv_pix_start;
    wire vga_pix_start;
	wire tspix_start;
	wire vga_blank;
	wire vga_line;
	wire tm_pf;
	wire hpix;
	wire vpix;
	wire hvpix;
	wire flash;
	wire pix_stb;

// fetcher
	wire [31:0] fetch_data;
	wire [31:0] fetch_temp;
	wire [3:0] fetch_sel;
	wire [1:0] fetch_bsl;
	wire fetch_stb;
    
// video data
 	wire [7:0] border;
	wire [7:0] vplex;
	wire [7:0] vgaplex;
    
// TS
    wire ts_render_done;
    wire [20:0] tsg_addr;
    wire ts_rld;
    
// TM-buf    
    wire [8:0] tmb_waddr;
    wire [8:0] tmb_raddr;
    wire [15:0] tmb_rdata;

// TS-line
	// wire [8:0] ts_waddr = a[8:0];
	// wire [7:0] ts_wdata = {d[7:1], 1'b1};
	// wire ts_we = c3;
	wire [8:0] ts_waddr;
	wire [7:0] ts_wdata;
	wire ts_we;
	wire [8:0] ts_raddr;

// VGA-line
	wire [9:0] vga_cnt_in;
	wire [9:0] vga_cnt_out;


	video_ports video_ports (
		.clk		  	(clk),
        .d              (d),
        .res            (res),
        .border_wr      (border_wr),
        .zborder_wr     (zborder_wr),
    	.zvpage_wr	    (zvpage_wr),
    	.vpage_wr	    (vpage_wr),
    	.vconf_wr	    (vconf_wr),
    	.x_offsl_wr	    (x_offsl_wr),
    	.x_offsh_wr	    (x_offsh_wr),
    	.y_offsl_wr	    (y_offsl_wr),
    	.y_offsh_wr	    (y_offsh_wr),
    	.palsel_wr	    (palsel_wr),
    	.hint_beg_wr    (hint_beg_wr),
    	.vint_begl_wr   (vint_begl_wr),
    	.vint_begh_wr   (vint_begh_wr),
    	.tsconf_wr	    (tsconf_wr),
    	.tgpage_wr	    (tgpage_wr),
        .border         (border),
        .vpage          (vpage),
        .vconf          (vconf),
        .x_offs         (x_offs),
        .y_offs         (y_offs),
        .palsel         (palsel),
        .hint_beg       (hint_beg),
        .vint_beg       (vint_beg),
        .tsconf         (tsconf),
        .tgpage         (tgpage)
);


	video_mode video_mode (
		.clk		  	(clk),
		.f1			    (f1),
		.c3			    (c3),
		.vconf		    (vconf),
		.vpage	    	(vpage),
		.vpage_d    	(vpage_d),
		.palsel	    	(palsel),
		.palsel_d    	(palsel_d),
		.fetch_sel		(fetch_sel),
		.fetch_bsl		(fetch_bsl),
		.fetch_cnt	    (scnt),
		.fetch_stb	    (fetch_stb),
		.txt_char	    (fetch_temp[15:0]),
		.x_offs			(x_offs),
		.x_offs_mode	(x_offs_mode),
        .line_start     (line_start),
		.tm_en	        (tsconf[6:5]),
		.tm_pf	        (tm_pf),
		.zvpage_wr	    (zvpage_wr),
		.hpix_beg	    (hpix_beg),
		.hpix_end	    (hpix_end),
		.vpix_beg	    (vpix_beg),
		.vpix_end	    (vpix_end),
		.x_tiles	    (x_tiles),
        .go_offs        (go_offs),
        .cnt_col        (cnt_col),
        .cnt_row        (cnt_row),
        .cnt_tp_row     (cnt_tp_row),
        .cptr	        (cptr),
		.pix_start	    (pix_start),
		.tv_hires		(tv_hires),
		.vga_hires	    (vga_hires),
		.nogfx		    (nogfx),
		.pix_stb	    (pix_stb),
		.render_mode	(render_mode),
		.tmb_waddr	    (tmb_waddr),
		.video_addr	    (video_addr),
		.video_bw		(video_bw)
);


	video_sync video_sync (
		.clk			(clk),
		.f1				(f1),
		.c3				(c3),
		.hpix_beg		(hpix_beg),
		.hpix_end		(hpix_end),
		.vpix_beg		(vpix_beg),
		.vpix_end		(vpix_end),
        .go_offs        (go_offs),
        .x_offs         (x_offs_mode[1:0]),
        .y_offs_wr      (y_offsl_wr | y_offsh_wr),
		.hint_beg		(hint_beg),
		.vint_beg		(vint_beg),
		.hsync			(hsync),
		.vsync			(vsync),
		.csync			(csync),
		.tv_blank		(tv_blank),
		.vga_blank		(vga_blank),
		.vga_cnt_in		(vga_cnt_in),
		.vga_cnt_out	(vga_cnt_out),
		.ts_raddr	    (ts_raddr),
		.lcount			(lcount),
        .cnt_col        (cnt_col),
        .cnt_row        (cnt_row),
        .cnt_tp_row     (cnt_tp_row),
        .cptr	        (cptr),
		.scnt			(scnt),
		.flash			(flash),
		.pix_stb	    (pix_stb),
		.pix_start		(pix_start),
		.tspix_start	(tspix_start),
		.cstart			(x_offs_mode[9:2]),
		.rstart			(y_offs),
		.vga_line		(vga_line),
		.frame_start	(frame_start),
		.line_start		(line_start),
		.int_start		(int_start),
		.tm_pf			(tm_pf),
		.hpix			(hpix),
		.vpix			(vpix),
		.hvpix			(hvpix),
		.nogfx			(nogfx),
        .tiles_en       (|tsconf[6:5]),
		.video_go		(video_go),
		.video_next		(video_next)
);


	video_fetch video_fetch (
		.clk			(clk),
		.f_sel			(fetch_sel),
		.b_sel			(fetch_bsl),
		.fetch_stb		(fetch_stb),
		.fetch_data		(fetch_data),
		.fetch_temp		(fetch_temp),
		.video_strobe	(video_strobe),
		.video_data		(dram_rddata)
);


	video_ts video_ts (
		// .clk		    (clk),
		// .clk		    (0),
		// .zclk		    (zclk),
		// .c3			    (c3),
		// .line_start		(line_start),
		// .num_tiles		(x_tiles),
		// .lcount			(lcount),
		// .tsconf			(tsconf),
		// .tgpage			(tgpage),
		// .vpage			(vpage_d),
		// .tsg_addr		(tsg_addr),
		// .sfys_addr_in	(a[8:1]),
		// .sfys_data_in	(sfys_data_in),
		// .sfys_we		(sfys_we)
);


	video_ts_render video_ts_render (
		.clk		    (clk),
        .reset          (line_start & c3),
        // .go             (tspix_start & c0),       // debug!!!
        .go             (0),       // debug!!!
        // .reload         (ts_rld),
        // .reload         (tspix_start & c0),       // debug!!!
        .reload         (0),       // debug!!!
        .x_coord        (0),
        .x_size         (0),
        .x_flip         (0),
        // .addr           (tsg_addr),
        .addr           (0),
        .pal            (15),
        .done           (ts_render_done),
        .ts_waddr       (ts_waddr),
        .ts_wdata       (ts_wdata),
        .ts_we          (ts_we),
        .dram_addr      (ts_addr),
        .dram_req       (ts_req),
        .dram_rdata     (dram_rdata),
        .dram_next      (ts_next)
);


	video_render video_render (
		.clk		    (clk),
		.c1			    (c1),
		.hvpix 	        (hvpix),
		.nogfx			(nogfx),
		.flash			(flash),
		.hires			(tv_hires),
		.psel			(scnt),
		.palsel			(palsel_d),
		.render_mode	(render_mode),
		.data	 	    (fetch_data),
		.border_in 	    (border),
		.tsdata_in 	    (ts_rdata),
		.vplex_out 	    (vplex)
);


	video_out video_out (
		.clk			(clk),
		.zclk			(zclk),
		.f0				(f0),
		.c3				(c3),
		.vga_on			(vga_on),
		.tv_blank 		(tv_blank),
		.vga_blank		(vga_blank),
		.vga_line		(vga_line),
		.palsel			(palsel_d),
	    .plex_sel_in	({h1, f1}),
		.tv_hires		(tv_hires),
		.vga_hires		(vga_hires),
		// .t0			(t0),	//debug
		.cram_addr_in	(a[8:1]),
		.cram_data_in	(cram_data_in),
		.cram_we		(cram_we),
	    .vplex_in		(vplex),
	    .vgaplex		(vgaplex),
		.vred			(vred),
	    .vgrn			(vgrn),
	    .vblu			(vblu)
);


// 4 buffers * 2 tile-planes * 64 tiles * 16 bits (9x16) - used to prefetch tiles
// (2 altdprams)
    video_tmbuf video_tmbuf (
        .clock      (clk),
        .data       (dram_rdata),
        .wraddress  (tmb_waddr),
        .wren       (video_next & tm_pf),
        .rdaddress  (tmb_raddr),
        .q          (tmb_rdata)
);


// 2 buffers: 512 pixels * 8 bits (9x8) - used as bitmap buffer for TS overlay over graphics
// (2 altdprams)
    wire tl_act0 = lcount[0];
    wire tl_act1 = !lcount[0];
    wire [8:0] ts_waddr0 = tl_act0 ? ts_raddr : ts_waddr;
    wire [7:0] ts_wdata0 = tl_act0 ? 0 : ts_wdata;
    wire       ts_we0    = tl_act0 ? c3 : ts_we;
    wire [8:0] ts_waddr1 = tl_act1 ? ts_raddr : ts_waddr;
    wire [7:0] ts_wdata1 = tl_act1 ? 0 : ts_wdata;
    wire       ts_we1    = tl_act1 ? c3 : ts_we;
    wire [7:0] ts_rdata  = tl_act0 ? ts_rdata0 : ts_rdata1;
    wire [7:0] ts_rdata0, ts_rdata1;
    
    video_tsline0 video_tsline0 (
        .clock      (clk),
        .wraddress  (ts_waddr0),
        .data       (ts_wdata0),
        .wren       (ts_we0),
        .rdaddress  (ts_raddr),
        .q          (ts_rdata0)
);
    video_tsline1 video_tsline1 (
        .clock      (clk),
        .wraddress  (ts_waddr1),
        .data       (ts_wdata1),
        .wren       (ts_we1),
        .rdaddress  (ts_raddr),
        .q          (ts_rdata1)
);


// 2 lines * 512 pix * 8 bit (10x8) - used for VGA doubler
// (1 altdpram)
	video_vmem video_vmem(
		.clock		(clk),
		.wraddress	(vga_cnt_in),
		.data		(vplex),
		.wren		(c3),
	    .rdaddress	(vga_cnt_out),
	    .q			(vgaplex)
);

endmodule
