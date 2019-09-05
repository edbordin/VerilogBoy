`timescale 1ns / 1ps
//define our module and it's inputs/outputs
module top(
    input CLK,
    output FLASH_SCK,
    inout FLASH_SSB,
    inout FLASH_IO0,
    inout FLASH_IO1,
    inout FLASH_IO2,
    inout FLASH_IO3,
    output P1A1,
    output P1A2,
    output P1A3,
    output P1A4,
    output P1A7,
    output P1A8,
    output P1A9,
    output P1A10,

    output P1B1,
    output P1B2,
    output P1B3,
    output P1B4,
    output P1B7,
    output P1B8,
    output P1B9,
    output P1B10,
    input P2_1,
    input P2_10
    );
    
    wire          clk_hdmi;
    wire          clk_core_local;
    wire          clk_core;
    
    
    // 39.75 MHz clock
    SB_PLL40_PAD #(
      .FEEDBACK_PATH("SIMPLE"),
      .DIVR(4'b0000),         // DIVR =  0
      .DIVF(7'b0110100),      // DIVF = 52
      .DIVQ(3'b100),          // DIVQ =  4
      .FILTER_RANGE(3'b001),   // FILTER_RANGE = 1
      .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
      .FDA_FEEDBACK(4'b0000),
      .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
      .FDA_RELATIVE(4'b0000),
      .SHIFTREG_DIV_MODE(2'b00),
      .PLLOUT_SELECT("GENCLK"),
      .ENABLE_ICEGATE(1'b0)
    ) core_pll (
      .PACKAGEPIN(CLK),
      .PLLOUTGLOBAL(clk_hdmi),
      //.PLLOUTGLOBAL(),
      .EXTFEEDBACK(),
      .DYNAMICDELAY(),
      .RESETB(1'b1),
      .BYPASS(1'b0),
      .LATCHINPUTVALUE(),
    );
    
    clk_div #(
        .WIDTH(4),
        .DIV(10)
    ) clk_div_4mhz (
        .i(clk_hdmi),
        .o(clk_core_local)
    );
    SB_GB clk_global_buf (
        .USER_SIGNAL_TO_GLOBAL_BUFFER (clk_core_local),
        .GLOBAL_BUFFER_OUTPUT (clk_core)
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
    
    assign vb_rst = 0;
    assign vb_din = 1;
    assign {P1A1, P1A2, P1A3, P1A4, P1A7, P1A8, P1A9, P1A10, P1B1, P1B2, P1B3, P1B4, P1B7, P1B8, P1B9, P1B10} = vb_a;

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