// megafunction wizard: %RAM: 2-PORT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altdpram 

// ============================================================
// File Name: video_tmbuf.v
// Megafunction Name(s):
// 			altdpram
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 6.1 Build 201 11/27/2006 SJ Web Edition
// ************************************************************


//Copyright (C) 1991-2006 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module video_tmbuf (
	clock,
	data,
	rdaddress,
	wraddress,
	wren,
	q);

	input	  clock;
	input	[15:0]  data;
	input	[8:0]  rdaddress;
	input	[8:0]  wraddress;
	input	  wren;
	output	[15:0]  q;

	wire [15:0] sub_wire0;
	wire [15:0] q = sub_wire0[15:0];

	altdpram	altdpram_component (
				.wren (wren),
				.inclock (clock),
				.data (data),
				.rdaddress (rdaddress),
				.wraddress (wraddress),
				.q (sub_wire0),
				.aclr (1'b0),
				.byteena (1'b1),
				.inclocken (1'b1),
				.outclock (1'b1),
				.outclocken (1'b1),
				.rdaddressstall (1'b0),
				.rden (1'b1),
				.wraddressstall (1'b0));
	defparam
		altdpram_component.indata_aclr = "OFF",
		altdpram_component.indata_reg = "INCLOCK",
		altdpram_component.intended_device_family = "ACEX1K",
		altdpram_component.lpm_type = "altdpram",
		altdpram_component.outdata_aclr = "OFF",
		altdpram_component.outdata_reg = "UNREGISTERED",
		altdpram_component.rdaddress_aclr = "OFF",
		altdpram_component.rdaddress_reg = "INCLOCK",
		altdpram_component.rdcontrol_aclr = "OFF",
		altdpram_component.rdcontrol_reg = "UNREGISTERED",
		altdpram_component.width = 16,
		altdpram_component.widthad = 9,
		altdpram_component.wraddress_aclr = "OFF",
		altdpram_component.wraddress_reg = "INCLOCK",
		altdpram_component.wrcontrol_aclr = "OFF",
		altdpram_component.wrcontrol_reg = "INCLOCK";


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: ADDRESSSTALL_A NUMERIC "0"
// Retrieval info: PRIVATE: ADDRESSSTALL_B NUMERIC "0"
// Retrieval info: PRIVATE: BYTEENA_ACLR_A NUMERIC "0"
// Retrieval info: PRIVATE: BYTEENA_ACLR_B NUMERIC "0"
// Retrieval info: PRIVATE: BYTE_ENABLE_A NUMERIC "0"
// Retrieval info: PRIVATE: BYTE_ENABLE_B NUMERIC "0"
// Retrieval info: PRIVATE: BYTE_SIZE NUMERIC "1"
// Retrieval info: PRIVATE: BlankMemory NUMERIC "1"
// Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_A NUMERIC "0"
// Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_B NUMERIC "0"
// Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_A NUMERIC "0"
// Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_B NUMERIC "0"
// Retrieval info: PRIVATE: CLRdata NUMERIC "0"
// Retrieval info: PRIVATE: CLRq NUMERIC "0"
// Retrieval info: PRIVATE: CLRrdaddress NUMERIC "0"
// Retrieval info: PRIVATE: CLRrren NUMERIC "0"
// Retrieval info: PRIVATE: CLRwraddress NUMERIC "0"
// Retrieval info: PRIVATE: CLRwren NUMERIC "0"
// Retrieval info: PRIVATE: Clock NUMERIC "0"
// Retrieval info: PRIVATE: Clock_A NUMERIC "0"
// Retrieval info: PRIVATE: Clock_B NUMERIC "0"
// Retrieval info: PRIVATE: ECC NUMERIC "0"
// Retrieval info: PRIVATE: IMPLEMENT_IN_LES NUMERIC "0"
// Retrieval info: PRIVATE: INDATA_ACLR_B NUMERIC "0"
// Retrieval info: PRIVATE: INDATA_REG_B NUMERIC "1"
// Retrieval info: PRIVATE: INIT_FILE_LAYOUT STRING "PORT_A"
// Retrieval info: PRIVATE: INIT_TO_SIM_X NUMERIC "0"
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "ACEX1K"
// Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
// Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
// Retrieval info: PRIVATE: MAXIMUM_DEPTH NUMERIC "0"
// Retrieval info: PRIVATE: MEMSIZE NUMERIC "8192"
// Retrieval info: PRIVATE: MEM_IN_BITS NUMERIC "0"
// Retrieval info: PRIVATE: MIFfilename STRING ""
// Retrieval info: PRIVATE: OPERATION_MODE NUMERIC "2"
// Retrieval info: PRIVATE: OUTDATA_ACLR_B NUMERIC "0"
// Retrieval info: PRIVATE: OUTDATA_REG_B NUMERIC "1"
// Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
// Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_MIXED_PORTS NUMERIC "0"
// Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_PORT_A NUMERIC "3"
// Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_PORT_B NUMERIC "3"
// Retrieval info: PRIVATE: REGdata NUMERIC "1"
// Retrieval info: PRIVATE: REGq NUMERIC "0"
// Retrieval info: PRIVATE: REGrdaddress NUMERIC "1"
// Retrieval info: PRIVATE: REGrren NUMERIC "1"
// Retrieval info: PRIVATE: REGwraddress NUMERIC "1"
// Retrieval info: PRIVATE: REGwren NUMERIC "1"
// Retrieval info: PRIVATE: USE_DIFF_CLKEN NUMERIC "0"
// Retrieval info: PRIVATE: UseDPRAM NUMERIC "1"
// Retrieval info: PRIVATE: VarWidth NUMERIC "0"
// Retrieval info: PRIVATE: WIDTH_READ_A NUMERIC "16"
// Retrieval info: PRIVATE: WIDTH_READ_B NUMERIC "16"
// Retrieval info: PRIVATE: WIDTH_WRITE_A NUMERIC "16"
// Retrieval info: PRIVATE: WIDTH_WRITE_B NUMERIC "16"
// Retrieval info: PRIVATE: WRADDR_ACLR_B NUMERIC "0"
// Retrieval info: PRIVATE: WRADDR_REG_B NUMERIC "1"
// Retrieval info: PRIVATE: WRCTRL_ACLR_B NUMERIC "0"
// Retrieval info: PRIVATE: enable NUMERIC "0"
// Retrieval info: PRIVATE: rden NUMERIC "0"
// Retrieval info: CONSTANT: INDATA_ACLR STRING "OFF"
// Retrieval info: CONSTANT: INDATA_REG STRING "INCLOCK"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "ACEX1K"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altdpram"
// Retrieval info: CONSTANT: OUTDATA_ACLR STRING "OFF"
// Retrieval info: CONSTANT: OUTDATA_REG STRING "UNREGISTERED"
// Retrieval info: CONSTANT: RDADDRESS_ACLR STRING "OFF"
// Retrieval info: CONSTANT: RDADDRESS_REG STRING "INCLOCK"
// Retrieval info: CONSTANT: RDCONTROL_ACLR STRING "OFF"
// Retrieval info: CONSTANT: RDCONTROL_REG STRING "UNREGISTERED"
// Retrieval info: CONSTANT: WIDTH NUMERIC "16"
// Retrieval info: CONSTANT: WIDTHAD NUMERIC "9"
// Retrieval info: CONSTANT: WRADDRESS_ACLR STRING "OFF"
// Retrieval info: CONSTANT: WRADDRESS_REG STRING "INCLOCK"
// Retrieval info: CONSTANT: WRCONTROL_ACLR STRING "OFF"
// Retrieval info: CONSTANT: WRCONTROL_REG STRING "INCLOCK"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL clock
// Retrieval info: USED_PORT: data 0 0 16 0 INPUT NODEFVAL data[15..0]
// Retrieval info: USED_PORT: q 0 0 16 0 OUTPUT NODEFVAL q[15..0]
// Retrieval info: USED_PORT: rdaddress 0 0 9 0 INPUT NODEFVAL rdaddress[8..0]
// Retrieval info: USED_PORT: wraddress 0 0 9 0 INPUT NODEFVAL wraddress[8..0]
// Retrieval info: USED_PORT: wren 0 0 0 0 INPUT VCC wren
// Retrieval info: CONNECT: @data 0 0 16 0 data 0 0 16 0
// Retrieval info: CONNECT: q 0 0 16 0 @q 0 0 16 0
// Retrieval info: CONNECT: @wraddress 0 0 9 0 wraddress 0 0 9 0
// Retrieval info: CONNECT: @rdaddress 0 0 9 0 rdaddress 0 0 9 0
// Retrieval info: CONNECT: @wren 0 0 0 0 wren 0 0 0 0
// Retrieval info: CONNECT: @inclock 0 0 0 0 clock 0 0 0 0
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: GEN_FILE: TYPE_NORMAL video_tmbuf.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL video_tmbuf.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL video_tmbuf.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL video_tmbuf.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL video_tmbuf_inst.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL video_tmbuf_bb.v FALSE
// Retrieval info: LIB_FILE: altera_mf