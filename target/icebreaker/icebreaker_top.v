`timescale 1ns / 1ps
//define our module and it's inputs/outputs
module top(
	input CLK,
	// input BTN1,
	// input BTN2,
	// input BTN3,
	// input BTN_N,
	// input [7:0] sw,
	// output [4:0] led,
	// output [6:0] seg,
	// output ca
    );
	
	wire          clk_core;
	
	SB_PLL40_PAD #(
	  .DIVR(4'b0010), // 4MHz
	  .DIVF(7'b0000000),
	  .DIVQ(3'b000),
	  .FILTER_RANGE(3'b001),
	  .FEEDBACK_PATH("SIMPLE"),
	  .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
	  .FDA_FEEDBACK(4'b0000),
	  .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
	  .FDA_RELATIVE(4'b0000),
	  .SHIFTREG_DIV_MODE(2'b00),
	  .PLLOUT_SELECT("GENCLK"),
	  .ENABLE_ICEGATE(1'b0)
	) core_pll (
	  .PACKAGEPIN(CLK),
	  .PLLOUTCORE(clk_core),
	  //.PLLOUTGLOBAL(),
	  .EXTFEEDBACK(),
	  .DYNAMICDELAY(),
	  .RESETB(1'b1),
	  .BYPASS(1'b0),
	  .LATCHINPUTVALUE(),
	);
	
	// ----------------------------------------------------------------------
    // VerilogBoy core
    
    reg vb_rst;
    wire        vb_phi;
    wire [15:0] vb_a;
    wire [7:0]  vb_dout;
    wire [7:0]  vb_din;
    wire        vb_wr;
    wire        vb_rd;
    wire        vb_cs;
    wire [1:0]  vb_key_out;
    wire [7:0]  vb_key;
    wire        vb_hs;
    wire        vb_vs;
    wire        vb_cpl;
    wire [1:0]  vb_pixel;
    wire        vb_valid;
    wire [15:0] vb_left;
    wire [15:0] vb_right;
	wire vb_done;
	wire vb_fault;

    boy boy(
        .rst(vb_rst),
        .clk(clk_core),
        .phi(),
        .a(vb_a),
        .dout(vb_dout),
        .din(vb_din),
        .wr(vb_wr),
        .rd(vb_rd),
        // .cs(vb_cs),
        // .key_out(vb_key_out),
        .key(vb_key),
        .hs(vb_hs),
        .vs(vb_vs),
        .cpl(vb_cpl),
        .pixel(vb_pixel),
        .valid(vb_valid),
        .left(vb_left),
        .right(vb_right),
        .done(vb_done),
		.fault(vb_fault)
    );
	
	
	
	// module boy(
    // input wire rst, // Async Reset Input
    // input wire clk, // 4.19MHz Clock Input
    // output wire phi, // 1.05MHz Reference Clock Output
    // // Cartridge interface
    // output wire [15:0] a, // Address Bus
    // output wire [7:0] dout,  // Data Bus
    // input wire [7:0] din,
    // output wire wr, // Write Enable
    // output wire rd, // Read Enable
    // // Keyboard input
    // input wire [7:0] key,
    // // LCD output
    // output wire hs, // Horizontal Sync Output
    // output wire vs, // Vertical Sync Output
    // output wire cpl, // Pixel Data Latch
    // output wire [1:0] pixel, // Pixel Data
    // output wire valid,
    // // Sound output
    // output reg [15:0] left,
    // output reg [15:0] right,
    // // Debug interface
    // output wire done,
    // output wire fault
    // );
	
	endmodule