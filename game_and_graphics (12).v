//KEY[0] synchronous reset when pressed
//KEY[1] go signal
//SW[9] - the players switch this at the start of their turn

//LEDR[9] - represents who's turn it is
//HEX1 and HEX2 -> hands of player one, results of reg hand 1 and hand2
//HEX3 and HEX4 -> hands of player two, results of reg hand 2 and hand3
`timescale 1ns/1ns

module game_and_graphics(	SW, 
									KEY, 
									CLOCK_50, 
									LEDR, 
									HEX1, 
									HEX2, 
									HEX3, 
									HEX4,
									
									
									//graphics
									VGA_CLK,   						//	VGA Clock
									VGA_HS,							//	VGA H_SYNC
									VGA_VS,							//	VGA V_SYNC
									VGA_BLANK_N,						//	VGA BLANK
									VGA_SYNC_N,						//	VGA SYNC
									VGA_R,   						//	VGA Red[9:0]
									VGA_G,	 						//	VGA Green[9:0]
									VGA_B,   						//	VGA Blue[9:0]
									
									//audio
									AUD_ADCDAT,
									// Bidirectionals
									AUD_BCLK,
									AUD_ADCLRCK,
									AUD_DACLRCK,
									FPGA_I2C_SDAT,
									// Outputs
									AUD_XCK,
									AUD_DACDAT,
									FPGA_I2C_SCLK
									
									);
	input [9:0] SW; 
	input [3:0] KEY; 
	input CLOCK_50;
	output [9:0]LEDR;
	output [6:0] HEX1, HEX2, HEX3, HEX4;

	wire resetn;
	wire go;
	wire [3:0] switches;

	wire win;
	wire state;
	//4 results, one for each hand
	wire [2:0] hand1;
	wire [2:0] hand3;
	wire [2:0] hand2;
	wire [2:0] hand4;
	wire [2:0] ld_hand_select;

	assign go = ~KEY[1];
	assign resetn = KEY[0];
	
	
	
	//VGA DECLARATIONS
	
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	reg [2:0] colour;
	reg [7:0] x;
	reg [6:0] y;


	part2 u0(
		.clk(CLOCK_50),
		.resetn(resetn),   
		.go(go), //instead of go, pass in the synchronized??

		.turn(SW[9]),
		.win(win),

		.hand1(hand1),
		.hand3(hand3),
		.hand4(hand4),
		.hand2(hand2),
		.switch(switch),
		.ld_hand_select_for_plot(ld_hand_select),
		
		.switch_hand_1(SW[1]),
		.switch_hand_2(SW[2]),
		.switch_hand_3(SW[3]),
		.switch_hand_4(SW[4]),
		.state(state)
	);

	hex_decoder H1(
		.hex_digit({1'b0,hand1}), 
		.segments(HEX1)
	);
	hex_decoder H2(
		.hex_digit({1'b0,hand2}), 
		.segments(HEX2)
	);

	hex_decoder H3(
		.hex_digit({1'b0,hand3}), 
		.segments(HEX3)
	);
	
	hex_decoder H4(
		.hex_digit({1'b0,hand4}), 
		.segments(HEX4)
	);
	
	wire [17:0] out;
	wire [2:0] hand_signal;

assign LEDR[0] = win;
assign LEDR[9] = SW[9];

reg one_finger_left_enable_hand1;
reg two_finger_left_enable_hand1;
reg three_finger_left_enable_hand1;
reg four_finger_left_enable_hand1;
reg five_finger_left_enable_hand1;

reg one_finger_left_enable_hand2;
reg two_finger_left_enable_hand2;
reg three_finger_left_enable_hand2;
reg four_finger_left_enable_hand2;
reg five_finger_left_enable_hand2;

reg one_finger_right_enable_hand3;
reg two_finger_right_enable_hand3;
reg three_finger_right_enable_hand3;
reg four_finger_right_enable_hand3;
reg five_finger_right_enable_hand3;

reg one_finger_right_enable_hand4;
reg two_finger_right_enable_hand4;
reg three_finger_right_enable_hand4;
reg four_finger_right_enable_hand4;
reg five_finger_right_enable_hand4;

wire [7:0] player_one_hand_1_1_x;
wire [6:0] player_one_hand_1_1_y;
wire [2:0] player_one_hand_1_1_colour;
//wire player_one_hand_1_1_print_done;

wire [7:0] player_one_hand_1_2_x;
wire [6:0] player_one_hand_1_2_y;
wire [2:0] player_one_hand_1_2_colour;
//wire player_one_hand_1_2_print_done;

wire [7:0] player_one_hand_1_3_x;
wire [6:0] player_one_hand_1_3_y;
wire [2:0] player_one_hand_1_3_colour;
//wire player_one_hand_1_3_print_done;

wire [7:0] player_one_hand_1_4_x;
wire [6:0] player_one_hand_1_4_y;
wire [2:0] player_one_hand_1_4_colour;
//wire player_one_hand_1_4_print_done;

wire [7:0] player_one_hand_1_5_x;
wire [6:0] player_one_hand_1_5_y;
wire [2:0] player_one_hand_1_5_colour;
//wire player_one_hand_1_5_print_done;

wire [7:0] player_one_hand_2_1_x;
wire [6:0] player_one_hand_2_1_y;
wire [2:0] player_one_hand_2_1_colour;
//wire player_one_hand_2_1_print_done;

wire [7:0] player_one_hand_2_2_x;
wire [6:0] player_one_hand_2_2_y;
wire [2:0] player_one_hand_2_2_colour;
//wire player_one_hand_2_2_print_done;

wire [7:0] player_one_hand_2_3_x;
wire [6:0] player_one_hand_2_3_y;
wire [2:0] player_one_hand_2_3_colour;
//wire player_one_hand_2_3_print_done;

wire [7:0] player_one_hand_2_4_x;
wire [6:0] player_one_hand_2_4_y;
wire [2:0] player_one_hand_2_4_colour;
//wire player_one_hand_2_4_print_done;

wire [7:0] player_one_hand_2_5_x;
wire [6:0] player_one_hand_2_5_y;
wire [2:0] player_one_hand_2_5_colour;
//wire player_one_hand_2_5_print_done;


///////////////////////////////////////

wire [7:0] player_two_hand_1_1_x;
wire [6:0] player_two_hand_1_1_y;
wire [2:0] player_two_hand_1_1_colour;
//wire player_two_hand_1_1_print_done;

wire [7:0] player_two_hand_1_2_x;
wire [6:0] player_two_hand_1_2_y;
wire [2:0] player_two_hand_1_2_colour;
//wire player_two_hand_1_2_print_done;

wire [7:0] player_two_hand_1_3_x;
wire [6:0] player_two_hand_1_3_y;
wire [2:0] player_two_hand_1_3_colour;
//wire player_two_hand_1_3_print_done;

wire [7:0] player_two_hand_1_4_x;
wire [6:0] player_two_hand_1_4_y;
wire [2:0] player_two_hand_1_4_colour;
//wire player_two_hand_1_4_print_done;

wire [7:0] player_two_hand_1_5_x;
wire [6:0] player_two_hand_1_5_y;
wire [2:0] player_two_hand_1_5_colour;
//wire player_two_hand_1_5_print_done;

wire [7:0] player_two_hand_2_1_x;
wire [6:0] player_two_hand_2_1_y;
wire [2:0] player_two_hand_2_1_colour;
//wire player_two_hand_2_1_print_done;

wire [7:0] player_two_hand_2_2_x;
wire [6:0] player_two_hand_2_2_y;
wire [2:0] player_two_hand_2_2_colour;
//wire player_two_hand_2_2_print_done;

wire [7:0] player_two_hand_2_3_x;
wire [6:0] player_two_hand_2_3_y;
wire [2:0] player_two_hand_2_3_colour;
//wire player_two_hand_2_3_print_done;

wire [7:0] player_two_hand_2_4_x;
wire [6:0] player_two_hand_2_4_y;
wire [2:0] player_two_hand_2_4_colour;
//wire player_one_hand_2_4_print_done;

wire [7:0] player_two_hand_2_5_x;
wire [6:0] player_two_hand_2_5_y;
wire [2:0] player_two_hand_2_5_colour;
//wire player_two_hand_2_5_print_done;


always @(*)begin
	//if (ld_hand_select==1)begin
	if (hand1 == 3'd0)
	begin
	//need a totally closed fist lol for teh reset page
	//i guess if the hands are 0, dont actually draw anything
	//oh we can have like something on screen that says reset to start
	one_finger_left_enable_hand1 <= 0;
	two_finger_left_enable_hand1 <= 0;
	three_finger_left_enable_hand1<=0;
	four_finger_left_enable_hand1<=0;
	five_finger_left_enable_hand1 <=0;
	end

	else if (hand1 == 3'd1)
	begin
		one_finger_left_enable_hand1 <= 1;
	two_finger_left_enable_hand1<= 0;
	three_finger_left_enable_hand1<=0;
	four_finger_left_enable_hand1<=0;
	five_finger_left_enable_hand1<=0;

	end

	else if (hand1 == 3'd2)
	begin
	one_finger_left_enable_hand1 <= 0;
	two_finger_left_enable_hand1 <= 1;
	three_finger_left_enable_hand1<=0;
	four_finger_left_enable_hand1 <=0;
	five_finger_left_enable_hand1 <=0;
	end

	else if (hand1 == 3'd3)
	begin
	one_finger_left_enable_hand1 <= 0;
	two_finger_left_enable_hand1 <= 0;
	three_finger_left_enable_hand1<=1;
	four_finger_left_enable_hand1 <=0;
	five_finger_left_enable_hand1 <=0;
	end

	else if (hand1 == 3'd4)
	begin
	one_finger_left_enable_hand1 <= 0;
	two_finger_left_enable_hand1 <= 0;
	three_finger_left_enable_hand1<=0;
	four_finger_left_enable_hand1 <=1;
	five_finger_left_enable_hand1 <=0;
	end

	else if (hand1 == 3'd5)
	begin 
	one_finger_left_enable_hand1 <= 0;
	two_finger_left_enable_hand1 <= 0;
	three_finger_left_enable_hand1<=0;
	four_finger_left_enable_hand1 <=0;
	five_finger_left_enable_hand1 <=1;
	end	
	
	if (hand2 == 3'd0)
	begin
	//need a totally closed fist lol for teh reset page
	//i guess if the hands are 0, dont actually draw anything
	//oh we can have like something on screen that says reset to start
	one_finger_left_enable_hand2 <= 0;
	two_finger_left_enable_hand2 <= 0;
	three_finger_left_enable_hand2<=0;
	four_finger_left_enable_hand2<=0;
	five_finger_left_enable_hand2 <=0;
	end

	else if (hand2 == 3'd1)
	begin
		one_finger_left_enable_hand2 <= 1;
	two_finger_left_enable_hand2<= 0;
	three_finger_left_enable_hand2<=0;
	four_finger_left_enable_hand2<=0;
	five_finger_left_enable_hand2<=0;

	end

	else if (hand2 == 3'd2)
	begin
	one_finger_left_enable_hand2 <= 0;
	two_finger_left_enable_hand2 <= 1;
	three_finger_left_enable_hand2<=0;
	four_finger_left_enable_hand2 <=0;
	five_finger_left_enable_hand2 <=0;
	end

	else if (hand2 == 3'd3)
	begin
	one_finger_left_enable_hand2 <= 0;
	two_finger_left_enable_hand2 <= 0;
	three_finger_left_enable_hand2<=1;
	four_finger_left_enable_hand2 <=0;
	five_finger_left_enable_hand2 <=0;
	end

	else if (hand2 == 3'd4)
	begin
	one_finger_left_enable_hand2 <= 0;
	two_finger_left_enable_hand2 <= 0;
	three_finger_left_enable_hand2<=0;
	four_finger_left_enable_hand2 <=1;
	five_finger_left_enable_hand2 <=0;
	end

	else if (hand2 == 3'd5)
	begin 
	one_finger_left_enable_hand2 <= 0;
	two_finger_left_enable_hand2 <= 0;
	three_finger_left_enable_hand2<=0;
	four_finger_left_enable_hand2 <=0;
	five_finger_left_enable_hand2 <=1;
	end
	
	if (hand3 == 3'd0)
	begin
	//need a totally closed fist lol for teh reset page
	//i guess if the hands are 0, dont actually draw anything
	//oh we can have like something on screen that says reset to start
	one_finger_right_enable_hand3 <= 0;
	two_finger_right_enable_hand3 <= 0;
	three_finger_right_enable_hand3<=0;
	four_finger_right_enable_hand3<=0;
	five_finger_right_enable_hand3 <=0;
	end

	else if (hand3 == 3'd1)
	begin
		one_finger_right_enable_hand3 <= 1;
	two_finger_right_enable_hand3<= 0;
	three_finger_right_enable_hand3<=0;
	four_finger_right_enable_hand3<=0;
	five_finger_right_enable_hand3<=0;

	end

	else if (hand3 == 3'd2)
	begin
	one_finger_right_enable_hand3 <= 0;
	two_finger_right_enable_hand3 <= 1;
	three_finger_right_enable_hand3<=0;
	four_finger_right_enable_hand3 <=0;
	five_finger_right_enable_hand3 <=0;
	end

	else if (hand3 == 3'd3)
	begin
	one_finger_right_enable_hand3 <= 0;
	two_finger_right_enable_hand3 <= 0;
	three_finger_right_enable_hand3<=1;
	four_finger_right_enable_hand3 <=0;
	five_finger_right_enable_hand3 <=0;
	end

	else if (hand3 == 3'd4)
	begin
	one_finger_right_enable_hand3 <= 0;
	two_finger_right_enable_hand3 <= 0;
	three_finger_right_enable_hand3<=0;
	four_finger_right_enable_hand3 <=1;
	five_finger_right_enable_hand3 <=0;
	end

	else if (hand3 == 3'd5)
	begin 
	one_finger_right_enable_hand3 <= 0;
	two_finger_right_enable_hand3 <= 0;
	three_finger_right_enable_hand3<=0;
	four_finger_right_enable_hand3 <=0;
	five_finger_right_enable_hand3 <=1;
	end
	
	if (hand4 == 3'd0)
	begin
	//need a totally closed fist lol for teh reset page
	//i guess if the hands are 0, dont actually draw anything
	//oh we can have like something on screen that says reset to start
	one_finger_right_enable_hand4 <= 0;
	two_finger_right_enable_hand4 <= 0;
	three_finger_right_enable_hand4<=0;
	four_finger_right_enable_hand4<=0;
	five_finger_right_enable_hand4 <=0;
	end

	else if (hand4 == 3'd1)
	begin
		one_finger_right_enable_hand4 <= 1;
	two_finger_right_enable_hand4<= 0;
	three_finger_right_enable_hand4<=0;
	four_finger_right_enable_hand4<=0;
	five_finger_right_enable_hand4<=0;

	end

	else if (hand4 == 3'd2)
	begin
	one_finger_right_enable_hand4 <= 0;
	two_finger_right_enable_hand4 <= 1;
	three_finger_right_enable_hand4<=0;
	four_finger_right_enable_hand4 <=0;
	five_finger_right_enable_hand4 <=0;
	end

	else if (hand4 == 3'd3)
	begin
	one_finger_right_enable_hand4 <= 0;
	two_finger_right_enable_hand4 <= 0;
	three_finger_right_enable_hand4<=1;
	four_finger_right_enable_hand4 <=0;
	five_finger_right_enable_hand4 <=0;
	end

	else if (hand4 == 3'd4)
	begin
	one_finger_right_enable_hand4 <= 0;
	two_finger_right_enable_hand4 <= 0;
	three_finger_right_enable_hand4<=0;
	four_finger_right_enable_hand4 <=1;
	five_finger_right_enable_hand4 <=0;
	end

	else if (hand4 == 3'd5)
	begin 
	one_finger_right_enable_hand4 <= 0;
	two_finger_right_enable_hand4 <= 0;
	three_finger_right_enable_hand4<=0;
	four_finger_right_enable_hand4 <=0;
	five_finger_right_enable_hand4 <=1;
	end
	
	
	
	
	else begin
	one_finger_left_enable_hand1 <= 0;
	two_finger_left_enable_hand1 <= 0;
	three_finger_left_enable_hand1<=0;
	four_finger_left_enable_hand1 <=0;
	five_finger_left_enable_hand1 <=0;
	one_finger_left_enable_hand2 <= 0;
	two_finger_left_enable_hand2 <= 0;
	three_finger_left_enable_hand2<=0;
	four_finger_left_enable_hand2 <=0;
	five_finger_left_enable_hand2 <=0;
	one_finger_right_enable_hand3 <= 0;
	two_finger_right_enable_hand3 <= 0;
	three_finger_right_enable_hand3<=0;
	four_finger_right_enable_hand3 <=0;
	five_finger_right_enable_hand3 <=0;
	one_finger_right_enable_hand4 <= 0;
	two_finger_right_enable_hand4 <= 0;
	three_finger_right_enable_hand4<=0;
	four_finger_right_enable_hand4 <=0;
	five_finger_right_enable_hand4 <=0;
	end
	
	end
	//sucks to suck


//drawing player1
//change the write en when we want it to draw
//also, starting x and starting y are always fixed

//										
//draw_one_finger_right_hand player_one_hand_2 ( 	.reset(resetn),
//																.writeEn(1'd1),
//																.x(x),
//																.y(y),
//																.startx(40),
//																.starty(60),
//																.clock(CLOCK_50),
//																.color(colour)
//										);										
										
//draw_one_finger_left_hand player_two_hand_3 ( 	.reset(resetn),
//																.writeEn(1'd1),
//																.x(x),
//																.y(y),
//																.startx(80),
//																.starty(60),
//																.clock(CLOCK_50),
//																.color(colour)
//										);
										
//draw_one_finger_right_hand player_two_hand_2 ( 	.reset(resetn),
//																.writeEn(1'd1),
//																.x(x),
//																.y(y),
//																.startx(120),
//																.starty(60),
//																.clock(CLOCK_50),
//																.color(colour));
																
//left space																
															
draw_one_finger_left_hand player_one_hand_1_1 ( 	.reset(resetn),
																.writeEn(one_finger_left_enable_hand1),
																.x(player_one_hand_1_1_x),
																.y(player_one_hand_1_1_y),
																.startx(0),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_one_hand_1_1_print_done),
																.color(player_one_hand_1_1_colour));
																
draw_two_finger_left_hand player_one_hand_1_2 ( 	.reset(resetn),
																.writeEn(two_finger_left_enable_hand1),
																.x(player_one_hand_1_2_x),
																.y(player_one_hand_1_2_y),
																.startx(0),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_one_hand_1_2_print_done),
																.color(player_one_hand_1_2_colour));
																
draw_three_finger_left_hand player_one_hand_1_3 ( 	.reset(resetn),
																.writeEn(three_finger_left_enable_hand1),
																.x(player_one_hand_1_3_x),
																.y(player_one_hand_1_3_y),
																.startx(0),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_one_hand_1_3_print_done),
																.color(player_one_hand_1_3_colour));
																
draw_four_finger_left_hand player_one_hand_1_4 ( 	.reset(resetn),
																.writeEn(four_finger_left_enable_hand1),
																.x(player_one_hand_1_4_x),
																.y(player_one_hand_1_4_y),
																.startx(0),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_one_hand_1_4_print_done),
																.color(player_one_hand_1_4_colour));
draw_five_finger_left_hand player_one_hand_1_5 ( 	.reset(resetn),
																.writeEn(five_finger_left_enable_hand1),
																.x(player_one_hand_1_5_x),
																.y(player_one_hand_1_5_y),
																.startx(0),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_one_hand_1_5_print_done),
																.color(player_one_hand_1_5_colour));
																
draw_one_finger_left_hand player_one_hand_2_1 ( 	.reset(resetn),
																.writeEn(one_finger_left_enable_hand2),
																.x(player_one_hand_2_1_x),
																.y(player_one_hand_2_1_y),
																.startx(40),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_one_hand_2_1_print_done),
																.color(player_one_hand_2_1_colour));
																
draw_two_finger_left_hand player_one_hand_2_2 ( 	.reset(resetn),
																.writeEn(two_finger_left_enable_hand2),
																.x(player_one_hand_2_2_x),
																.y(player_one_hand_2_2_y),
																.startx(40),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_one_hand_2_2_print_done),
																.color(player_one_hand_2_2_colour));
																
draw_three_finger_left_hand player_one_hand_2_3 ( 	.reset(resetn),
																.writeEn(three_finger_left_enable_hand2),
																.x(player_one_hand_2_3_x),
																.y(player_one_hand_2_3_y),
																.startx(40),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_one_hand_2_3_print_done),
																.color(player_one_hand_2_3_colour));
																
draw_four_finger_left_hand player_one_hand_2_4 ( 	.reset(resetn),
																.writeEn(four_finger_left_enable_hand2),
																.x(player_one_hand_2_4_x),
																.y(player_one_hand_2_4_y),
																.startx(40),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_one_hand_2_4_print_done),
																.color(player_one_hand_2_4_colour));
draw_five_finger_left_hand player_one_hand_2_5 ( 	.reset(resetn),
																.writeEn(five_finger_left_enable_hand2),
																.x(player_one_hand_2_5_x),
																.y(player_one_hand_2_5_y),
																.startx(40),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_one_hand_2_5_print_done),
																.color(player_one_hand_2_5_colour));
																
																
																
																
																
																
draw_one_finger_right_hand player_two_hand_1_1 ( 	.reset(resetn),
																.writeEn(one_finger_right_enable_hand3),
																.x(player_two_hand_1_1_x),
																.y(player_two_hand_1_1_y),
																.startx(80),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_two_hand_1_1_print_done),
																.color(player_two_hand_1_1_colour));
																
draw_two_finger_right_hand player_two_hand_1_2 ( 	.reset(resetn),
																.writeEn(two_finger_right_enable_hand3),
																.x(player_two_hand_1_2_x),
																.y(player_two_hand_1_2_y),
																.startx(80),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_two_hand_1_2_print_done),
																.color(player_two_hand_1_2_colour));
																
draw_three_finger_right_hand player_two_hand_1_3 ( 	.reset(resetn),
																.writeEn(three_finger_right_enable_hand3),
																.x(player_two_hand_1_3_x),
																.y(player_two_hand_1_3_y),
																.startx(80),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_two_hand_1_3_print_done),
																.color(player_two_hand_1_3_colour));
																
draw_four_finger_right_hand player_two_hand_1_4 ( 	.reset(resetn),
																.writeEn(four_finger_right_enable_hand3),
																.x(player_two_hand_1_4_x),
																.y(player_two_hand_1_4_y),
																.startx(80),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_two_hand_1_4_print_done),
																.color(player_two_hand_1_4_colour));
draw_five_finger_right_hand player_two_hand_1_5 ( 	.reset(resetn),
																.writeEn(five_finger_right_enable_hand3),
																.x(player_two_hand_1_5_x),
																.y(player_two_hand_1_5_y),
																.startx(80),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_two_hand_1_5_print_done),
																.color(player_two_hand_1_5_colour));
																
draw_one_finger_right_hand player_two_hand_2_1 ( 	.reset(resetn),
																.writeEn(one_finger_right_enable_hand4),
																.x(player_two_hand_2_1_x),
																.y(player_two_hand_2_1_y),
																.startx(120),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_two_hand_2_1_print_done),
																.color(player_two_hand_2_1_colour));
																
draw_two_finger_right_hand player_two_hand_2_2 ( 	.reset(resetn),
																.writeEn(two_finger_right_enable_hand4),
																.x(player_two_hand_2_2_x),
																.y(player_two_hand_2_2_y),
																.startx(120),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_two_hand_2_2_print_done),
																.color(player_two_hand_2_2_colour));
																
draw_three_finger_right_hand player_two_hand_2_3 ( 	.reset(resetn),
																.writeEn(three_finger_right_enable_hand4),
																.x(player_two_hand_2_3_x),
																.y(player_two_hand_2_3_y),
																.startx(120),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_two_hand_2_3_print_done),
																.color(player_two_hand_2_3_colour));
																
draw_four_finger_right_hand player_two_hand_2_4 ( 	.reset(resetn),
																.writeEn(four_finger_right_enable_hand4),
																.x(player_two_hand_2_4_x),
																.y(player_two_hand_2_4_y),
																.startx(120),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_two_hand_2_4_print_done),
																.color(player_two_hand_2_4_colour));
draw_five_finger_right_hand player_two_hand_2_5 ( 	.reset(resetn),
																.writeEn(five_finger_right_enable_hand4),
																.x(player_two_hand_2_5_x),
																.y(player_two_hand_2_5_y),
																.startx(120),
																.starty(60),
																.clock(CLOCK_50),
																//.print_done(player_two_hand_2_5_print_done),
																.color(player_two_hand_2_5_colour));																
																
state_animator graphics(CLOCK_50, resetn, hand_signal);
  				 
always @(*)
begin
		 x = out[17:10];
		 y = out[9:3];
		 colour = out[2:0];

	
end


		selector graphicshand1 (player_one_hand_1_1_x, player_one_hand_1_1_y,player_one_hand_1_1_colour, one_finger_left_enable_hand1,
				 player_one_hand_1_2_x, player_one_hand_1_2_y,player_one_hand_1_2_colour, two_finger_left_enable_hand1,
				 player_one_hand_1_3_x, player_one_hand_1_3_y,player_one_hand_1_3_colour,three_finger_left_enable_hand1,
				 player_one_hand_1_4_x, player_one_hand_1_4_y,player_one_hand_1_4_colour, four_finger_left_enable_hand1,
				 player_one_hand_1_5_x, player_one_hand_1_5_y,player_one_hand_1_5_colour, five_finger_left_enable_hand1,
				 
				 player_one_hand_2_1_x, player_one_hand_2_1_y,player_one_hand_2_1_colour, one_finger_left_enable_hand2,
				 player_one_hand_2_2_x, player_one_hand_2_2_y,player_one_hand_2_2_colour, two_finger_left_enable_hand2,
				 player_one_hand_2_3_x, player_one_hand_2_3_y,player_one_hand_2_3_colour,three_finger_left_enable_hand2,
				 player_one_hand_2_4_x, player_one_hand_2_4_y,player_one_hand_2_4_colour, four_finger_left_enable_hand2,
				 player_one_hand_2_5_x, player_one_hand_2_5_y,player_one_hand_2_5_colour, five_finger_left_enable_hand2,
				 
				 player_two_hand_1_1_x, player_two_hand_1_1_y,player_two_hand_1_1_colour, one_finger_right_enable_hand3,
				 player_two_hand_1_2_x, player_two_hand_1_2_y,player_two_hand_1_2_colour, two_finger_right_enable_hand3,
				 player_two_hand_1_3_x, player_two_hand_1_3_y,player_two_hand_1_3_colour,three_finger_right_enable_hand3,
				 player_two_hand_1_4_x, player_two_hand_1_4_y,player_two_hand_1_4_colour, four_finger_right_enable_hand3,
				 player_two_hand_1_5_x, player_two_hand_1_5_y,player_two_hand_1_5_colour, five_finger_right_enable_hand3,
				 
				 player_two_hand_2_1_x, player_two_hand_2_1_y,player_two_hand_2_1_colour, one_finger_right_enable_hand4,
				 player_two_hand_2_2_x, player_two_hand_2_2_y,player_two_hand_2_2_colour, two_finger_right_enable_hand4,
				 player_two_hand_2_3_x, player_two_hand_2_3_y,player_two_hand_2_3_colour,three_finger_right_enable_hand4,
				 player_two_hand_2_4_x, player_two_hand_2_4_y,player_two_hand_2_4_colour, four_finger_right_enable_hand4,
				 player_two_hand_2_5_x, player_two_hand_2_5_y,player_two_hand_2_5_colour, five_finger_right_enable_hand4,
				 
				 
				 
				CLOCK_50,
				 ld_hand_select, 
				 out,
				 hand_signal);
				 
/*always @(*)																
begin																
	if (one_finger_left_enable_hand1 == 1)
	begin*/
//		assign x = out[17:10];
//		assign y = out[9:3];
//		assign colour = out[2:0];
	/*end
	else if (two_finger_left_enable ==1)
	begin
		x = player_one_hand_1_2_x;
		y = player_one_hand_1_2_y;
		colour= player_one_hand_1_2_colour;
	end
	else if (three_finger_left_enable ==1)
	begin
		x = player_one_hand_1_3_x;
		y = player_one_hand_1_3_y;
		colour = player_one_hand_1_3_colour;
	end
	else if (four_finger_left_enable == 1)
	begin
	x = player_one_hand_1_4_x;
		y = player_one_hand_1_4_y;
		colour = player_one_hand_1_4_colour;
	end
	else if (five_finger_left_enable == 1)
	begin
	x = player_one_hand_1_5_x;
		y = player_one_hand_1_5_y;
		colour = player_one_hand_1_5_colour;
	end
end*/
									

	
//end	
//vga shit

vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(1'd1),
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "background3BMP.mif";
		
		
//************************************************AUDIO**********************************************************************


/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
//input				CLOCK_50;
//input		[3:0]	KEY;
//input		[3:0]	SW;

input				AUD_ADCDAT;

// Bidirectionals
inout				AUD_BCLK;
inout				AUD_ADCLRCK;
inout				AUD_DACLRCK;

inout				FPGA_I2C_SDAT;

// Outputs
output				AUD_XCK;
output				AUD_DACDAT;

output				FPGA_I2C_SCLK;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;
wire		[31:0]	left_channel_audio_out;
wire		[31:0]	right_channel_audio_out;
wire				write_audio_out;

wire [3:0] switch;

//assign switch = 4'b0100;
//assign switches[1] = 1;

// Internal Registers

reg [18:0] delay_cnt;
wire [18:0] delay;

reg snd;

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge CLOCK_50)
	if(delay_cnt == delay) begin
		delay_cnt <= 0;
		snd <= !snd;
	end else delay_cnt <= delay_cnt + 1;

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign delay = {switch[3:0], 15'd3000};

wire [31:0] sound = (switch == 0) ? 0 : snd ? 32'd10000000 : -32'd10000000;  //if all switches are turned off then no sound will be outputted


assign read_audio_in			= audio_in_available & audio_out_allowed;

assign left_channel_audio_out	= left_channel_audio_in+sound;
assign right_channel_audio_out	= right_channel_audio_in+sound;
assign write_audio_out			= audio_in_available & audio_out_allowed;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50						(CLOCK_50),
	.reset						   (~KEY[2]),

	.clear_audio_in_memory		(),
	.read_audio_in				(read_audio_in),
	
	.clear_audio_out_memory		(),
	.left_channel_audio_out		(left_channel_audio_out),
	.right_channel_audio_out	(right_channel_audio_out),
	.write_audio_out			(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_ADCLRCK				(AUD_ADCLRCK),
	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs
	.audio_in_available			(audio_in_available),
	.left_channel_audio_in		(left_channel_audio_in),
	.right_channel_audio_in		(right_channel_audio_in),

	.audio_out_allowed			(audio_out_allowed),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT)

);

avconf #(.USE_MIC_INPUT(1)) avc (
	.FPGA_I2C_SCLK					(FPGA_I2C_SCLK),
	.FPGA_I2C_SDAT					(FPGA_I2C_SDAT),
	.CLOCK_50					(CLOCK_50),
	.reset						(~KEY[2])
);
 
endmodule



module state_animator (input clk, input resetn,output reg [2:0] hand_signal);

	reg [2:0] current_state, next_state; 

	localparam      S_DRAW_HAND1     = 3'd0, 
						 S_DRAW_HAND2 		= 3'd1,
						 S_DRAW_HAND3     = 3'd2, 
						 S_DRAW_HAND4     = 3'd3;

	// Next state logic aka our state table
    always @(*)
    begin: state_table 
            case (current_state)
				S_DRAW_HAND1: next_state = S_DRAW_HAND2;		
				S_DRAW_HAND2 : next_state = S_DRAW_HAND3; 
				S_DRAW_HAND3: next_state = S_DRAW_HAND4;
				S_DRAW_HAND4: next_state = S_DRAW_HAND1;
            default:     next_state = S_DRAW_HAND1;                           // default state is hand1
        endcase
    end // end of state_table
	 
  

    // Output logic aka all of our datapath control signals
	always @(*)
	begin: enable_signals
	
	// By default make all our signals 0 to avoid latches.
	// This is a different style from using a default statement.
	// It makes the code easier to read.  If you add other out
	// signals be sure to assign a default value for them here.
	hand_signal = 3'd0;
	
	case (current_state)
	
		S_DRAW_HAND1: 
		begin
		
		
		hand_signal = 3'd1;
			 
		end
		
		S_DRAW_HAND2:
		begin 
		
		hand_signal = 3'd2;
			
		end
		
		S_DRAW_HAND3: 
		begin
		
		
		hand_signal = 3'd3;
			 
		end
		
		S_DRAW_HAND4:
		begin 
		
		hand_signal = 3'd4;
			
		end

	  
	endcase //end case of current state
	
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_DRAW_HAND1;
        else
		  begin
			   current_state <= next_state;
		  end
    end // state_FFS





endmodule


module selector (	player_one_hand_1_1_x, player_one_hand_1_1_y,player_one_hand_1_1_colour, one_finger_left_enable_hand1,
					player_one_hand_1_2_x, player_one_hand_1_2_y,player_one_hand_1_2_colour, two_finger_left_enable_hand1,
					player_one_hand_1_3_x, player_one_hand_1_3_y,player_one_hand_1_3_colour, three_finger_left_enable_hand1,
					player_one_hand_1_4_x, player_one_hand_1_4_y,player_one_hand_1_4_colour, four_finger_left_enable_hand1,
					player_one_hand_1_5_x, player_one_hand_1_5_y,player_one_hand_1_5_colour, five_finger_left_enable_hand1,
					
					player_one_hand_2_1_x, player_one_hand_2_1_y,player_one_hand_2_1_colour, one_finger_left_enable_hand2,
				 player_one_hand_2_2_x, player_one_hand_2_2_y,player_one_hand_2_2_colour, two_finger_left_enable_hand2,
				 player_one_hand_2_3_x, player_one_hand_2_3_y,player_one_hand_2_3_colour,three_finger_left_enable_hand2,
				 player_one_hand_2_4_x, player_one_hand_2_4_y,player_one_hand_2_4_colour, four_finger_left_enable_hand2,
				 player_one_hand_2_5_x, player_one_hand_2_5_y,player_one_hand_2_5_colour, five_finger_left_enable_hand2,
				 
				 player_two_hand_1_1_x, player_two_hand_1_1_y,player_two_hand_1_1_colour, one_finger_right_enable_hand3,
				 player_two_hand_1_2_x, player_two_hand_1_2_y,player_two_hand_1_2_colour, two_finger_right_enable_hand3,
				 player_two_hand_1_3_x, player_two_hand_1_3_y,player_two_hand_1_3_colour,three_finger_right_enable_hand3,
				 player_two_hand_1_4_x, player_two_hand_1_4_y,player_two_hand_1_4_colour, four_finger_right_enable_hand3,
				 player_two_hand_1_5_x, player_two_hand_1_5_y,player_two_hand_1_5_colour, five_finger_right_enable_hand3,
				 
				 player_two_hand_2_1_x, player_two_hand_2_1_y,player_two_hand_2_1_colour, one_finger_right_enable_hand4,
				 player_two_hand_2_2_x, player_two_hand_2_2_y,player_two_hand_2_2_colour, two_finger_right_enable_hand4,
				 player_two_hand_2_3_x, player_two_hand_2_3_y,player_two_hand_2_3_colour,three_finger_right_enable_hand4,
				 player_two_hand_2_4_x, player_two_hand_2_4_y,player_two_hand_2_4_colour, four_finger_right_enable_hand4,
				 player_two_hand_2_5_x, player_two_hand_2_5_y,player_two_hand_2_5_colour, five_finger_right_enable_hand4,
					
					clock,
					ld_hand_select,
					out,
					hand_signal);
					
					input clock;
					input [2:0] hand_signal;
					input [7:0] player_one_hand_1_1_x;
					input [7:0] player_one_hand_1_2_x;
					input [7:0] player_one_hand_1_3_x;
					input [7:0] player_one_hand_1_4_x;
					input [7:0] player_one_hand_1_5_x;
					
					input [6:0] player_one_hand_1_1_y;
					input [6:0] player_one_hand_1_2_y;
					input [6:0] player_one_hand_1_3_y;
					input [6:0] player_one_hand_1_4_y;
					input [6:0] player_one_hand_1_5_y;
					
					input [2:0] player_one_hand_1_1_colour;
					input [2:0] player_one_hand_1_2_colour;
					input [2:0] player_one_hand_1_3_colour;
					input [2:0] player_one_hand_1_4_colour;
					input [2:0] player_one_hand_1_5_colour;
					
					input [2:0] ld_hand_select;
					input one_finger_left_enable_hand1;
					input two_finger_left_enable_hand1;
					input three_finger_left_enable_hand1;
					input four_finger_left_enable_hand1;
					input five_finger_left_enable_hand1;
					
				
					input [7:0] player_one_hand_2_1_x;
					input [7:0] player_one_hand_2_2_x;
					input [7:0] player_one_hand_2_3_x;
					input [7:0] player_one_hand_2_4_x;
					input [7:0] player_one_hand_2_5_x;
					
					input [6:0] player_one_hand_2_1_y;
					input [6:0] player_one_hand_2_2_y;
					input [6:0] player_one_hand_2_3_y;
					input [6:0] player_one_hand_2_4_y;
					input [6:0] player_one_hand_2_5_y;
					
					input [2:0] player_one_hand_2_1_colour;
					input [2:0] player_one_hand_2_2_colour;
					input [2:0] player_one_hand_2_3_colour;
					input [2:0] player_one_hand_2_4_colour;
					input [2:0] player_one_hand_2_5_colour;
					
				
					input one_finger_left_enable_hand2;
					input two_finger_left_enable_hand2;
					input three_finger_left_enable_hand2;
					input four_finger_left_enable_hand2;
					input five_finger_left_enable_hand2;
					
					input [7:0] player_two_hand_2_1_x;
					input [7:0] player_two_hand_2_2_x;
					input [7:0] player_two_hand_2_3_x;
					input [7:0] player_two_hand_2_4_x;
					input [7:0] player_two_hand_2_5_x;
					
					input [6:0] player_two_hand_2_1_y;
					input [6:0] player_two_hand_2_2_y;
					input [6:0] player_two_hand_2_3_y;
					input [6:0] player_two_hand_2_4_y;
					input [6:0] player_two_hand_2_5_y;
					
					input [2:0] player_two_hand_2_1_colour;
					input [2:0] player_two_hand_2_2_colour;
					input [2:0] player_two_hand_2_3_colour;
					input [2:0] player_two_hand_2_4_colour;
					input [2:0] player_two_hand_2_5_colour;
					
				
					input one_finger_right_enable_hand4;
					input two_finger_right_enable_hand4;
					input three_finger_right_enable_hand4;
					input four_finger_right_enable_hand4;
					input five_finger_right_enable_hand4;
					
					input [7:0] player_two_hand_1_1_x;
					input [7:0] player_two_hand_1_2_x;
					input [7:0] player_two_hand_1_3_x;
					input [7:0] player_two_hand_1_4_x;
					input [7:0] player_two_hand_1_5_x;
					
					input [6:0] player_two_hand_1_1_y;
					input [6:0] player_two_hand_1_2_y;
					input [6:0] player_two_hand_1_3_y;
					input [6:0] player_two_hand_1_4_y;
					input [6:0] player_two_hand_1_5_y;
					
					input [2:0] player_two_hand_1_1_colour;
					input [2:0] player_two_hand_1_2_colour;
					input [2:0] player_two_hand_1_3_colour;
					input [2:0] player_two_hand_1_4_colour;
					input [2:0] player_two_hand_1_5_colour;
					
				
					input one_finger_right_enable_hand3;
					input two_finger_right_enable_hand3;
					input three_finger_right_enable_hand3;
					input four_finger_right_enable_hand3;
					input five_finger_right_enable_hand3;
					
					output reg [17:0] out;
					
				always @(*) begin	
					if (hand_signal == 3'd1)
					begin
						if (one_finger_left_enable_hand1 ==1)
						begin
							out = {player_one_hand_1_1_x, player_one_hand_1_1_y, player_one_hand_1_1_colour};
						end
						else if (two_finger_left_enable_hand1 ==1)
						begin
							out = {player_one_hand_1_2_x, player_one_hand_1_2_y, player_one_hand_1_2_colour};
						end
						else if (three_finger_left_enable_hand1 ==1)
						begin
							out = {player_one_hand_1_3_x, player_one_hand_1_3_y, player_one_hand_1_3_colour};
						end
						else if (three_finger_left_enable_hand1 ==1)
						begin
							out = {player_one_hand_1_4_x, player_one_hand_1_4_y, player_one_hand_1_4_colour};
						end
						else if (five_finger_left_enable_hand1 ==1)
						begin
							out = {player_one_hand_1_5_x, player_one_hand_1_5_y, player_one_hand_1_5_colour};
						end
						else 
						begin
							out = {player_one_hand_1_1_x, player_one_hand_1_1_y, player_one_hand_1_1_colour};
						end
					end
					else if (hand_signal == 3'd2)
					begin
						if (one_finger_left_enable_hand2 ==1)
						begin
							out = {player_one_hand_2_1_x, player_one_hand_2_1_y, player_one_hand_2_1_colour};
						end
						else if (two_finger_left_enable_hand2 ==1)
						begin
							out = {player_one_hand_2_2_x, player_one_hand_2_2_y, player_one_hand_2_2_colour};
						end
						else if (three_finger_left_enable_hand2 ==1)
						begin
							out = {player_one_hand_2_3_x, player_one_hand_2_3_y, player_one_hand_2_3_colour};
						end
						else if (three_finger_left_enable_hand2 ==1)
						begin
							out = {player_one_hand_2_4_x, player_one_hand_2_4_y, player_one_hand_2_4_colour};
						end
						else if (five_finger_left_enable_hand2 ==1)
						begin
							out = {player_one_hand_2_5_x, player_one_hand_2_5_y, player_one_hand_2_5_colour};
						end
						else 
						begin
							out = {player_one_hand_2_1_x, player_one_hand_2_1_y, player_one_hand_2_1_colour};
						end
					end
					
					else if (hand_signal == 3'd3)
					begin
						if (one_finger_right_enable_hand3 ==1)
						begin
							out = {player_two_hand_1_1_x, player_two_hand_1_1_y, player_two_hand_1_1_colour};
						end
						else if (two_finger_right_enable_hand3 ==1)
						begin
							out = {player_two_hand_1_2_x, player_two_hand_1_2_y, player_two_hand_1_2_colour};
						end
						else if (three_finger_right_enable_hand3 ==1)
						begin
							out = {player_two_hand_1_3_x, player_two_hand_1_3_y, player_two_hand_1_3_colour};
						end
						else if (three_finger_right_enable_hand3 ==1)
						begin
							out = {player_two_hand_1_4_x, player_one_hand_1_4_y, player_two_hand_1_4_colour};
						end
						else if (five_finger_right_enable_hand3 ==1)
						begin
							out = {player_two_hand_1_5_x, player_one_hand_1_5_y, player_two_hand_1_5_colour};
						end
						else 
						begin
							out = {player_two_hand_1_1_x, player_one_hand_1_1_y, player_two_hand_1_1_colour};
						end
					end
					else if (hand_signal == 3'd4)
					begin
						if (one_finger_right_enable_hand4 ==1)
						begin
							out = {player_two_hand_2_1_x, player_two_hand_2_1_y, player_two_hand_2_1_colour};
						end
						else if (two_finger_right_enable_hand4 ==1)
						begin
							out = {player_two_hand_2_2_x, player_two_hand_2_2_y, player_two_hand_2_2_colour};
						end
						else if (three_finger_right_enable_hand4 ==1)
						begin
							out = {player_two_hand_2_3_x, player_two_hand_2_3_y, player_two_hand_2_3_colour};
						end
						else if (three_finger_right_enable_hand4 ==1)
						begin
							out = {player_two_hand_2_4_x, player_two_hand_2_4_y, player_two_hand_2_4_colour};
						end
						else if (five_finger_right_enable_hand4 ==1)
						begin
							out = {player_two_hand_2_5_x, player_two_hand_2_5_y, player_two_hand_2_5_colour};
						end
						else 
						begin
							out = {player_two_hand_2_1_x, player_two_hand_2_1_y, player_two_hand_2_1_colour};
						end
					end
					
					else
					begin
						out = 18'd0;
					end
					
				end	

endmodule

module part2(
    input clk,
    input resetn,
    input go,
	output LEDR,

    input switch_hand_1,
	 input switch_hand_2,
	 input switch_hand_3,
	 input switch_hand_4,
  
  input turn, 
  output win,
  output [3:0] switch,
  
  output  [2:0] hand1,
  output  [2:0] hand3,
  output  [2:0] hand2,
  output  [2:0] hand4,
  output [2:0] ld_hand_select_for_plot,
  
  output state
    );

    // lots of wires to connect our datapath and control
		wire [2:0] ld_hand_select;
		wire [2:0] alu_select_a;
		wire [2:0] alu_select_b;
	 

    control C0(
		.clk(clk),
		.resetn(resetn),

		.go(go),

		.turn(turn),
		.ld_hand_select_for_plot(ld_hand_select_for_plot),
		.ld_hand_select(ld_hand_select),
		.alu_select_a(alu_select_a),
		.alu_select_b(alu_select_b),
		
		  .switch_hand_1(switch_hand_1),
		  .switch_hand_2(switch_hand_2),
		  .switch_hand_3(switch_hand_3),
		  .switch_hand_4(switch_hand_4),
		
		.state(state)
	);

    datapath D0(
	   .go(go),
		.clk(clk),
		.resetn(resetn),

		.ld_hand_select(ld_hand_select),
		.alu_select_a(alu_select_a),
		.alu_select_b(alu_select_b),

		.win(win),
		.switch(switch),

		.hand1(hand1),
		.hand3(hand3),
		.hand2(hand2),
		.hand4(hand4)
	);
				 
 endmodule        
               

module control(
	input clk,
	input resetn,
	input go,
	
	 input switch_hand_1,
	 input switch_hand_2,
	 input switch_hand_3,
	 input switch_hand_4,

	output reg LEDR,
	input turn,
	
	output reg [2:0] ld_hand_select,
	output reg [2:0] ld_hand_select_for_plot,
	output reg [2:0] alu_select_a,
	output reg [2:0] alu_select_b,
	output reg state

	);
	
	//make an output reg for the state and actually have an LED for what state ur in

	reg [2:0] current_state, next_state; 

	localparam      S_IDLE     = 2'd0, //initial waiting state
						 S_NOTHING = 2'd1, //so long as they hit the button, they stay in this state.
						 S_CYCLE_ADD       = 2'd2; //once they release the button,we add

	// Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
				S_IDLE: next_state = go ? S_NOTHING : S_IDLE; 			// Loop in current state until value is input
				S_NOTHING : next_state = go ? S_NOTHING : S_CYCLE_ADD; 	// if they still holding button, stay in same state, if they release button head to next state
				S_CYCLE_ADD: next_state = S_IDLE;     					// after 1 cycle, go back to waiting
            default:     next_state = S_IDLE;                           // default state is waiting
        endcase
    end // end of state_table
  

    // Output logic aka all of our datapath control signals
	always @(*)
	begin: enable_signals
	
	// By default make all our signals 0 to avoid latches.
	// This is a different style from using a default statement.
	// It makes the code easier to read.  If you add other out
	// signals be sure to assign a default value for them here.
	
	ld_hand_select = 3'd0;
	ld_hand_select_for_plot = 3'd0;
	state = 1'b0;
	alu_select_a = 3'd0;
	alu_select_b = 3'd0;
	
	case (current_state)
	
		S_IDLE: 
		begin
			ld_hand_select = 3'd0;
			ld_hand_select_for_plot = 3'd0;
			alu_select_a = 3'd0;
			alu_select_b = 3'd0;
			state = 1'b0;
		end
		
		S_NOTHING:
		begin
			//legit like do nothing everything set to the default values
			ld_hand_select = 3'd0;
			ld_hand_select_for_plot = 3'd0;
			alu_select_a = 3'd0;
			alu_select_b = 3'd0;
			state = 1'b1; //LEDR for checking what state we in
		end
		
		S_CYCLE_ADD: 
		begin 
			state = 1'b0;
			
			if (switch_hand_1 == 1 && switch_hand_2 ==1 && switch_hand_3 == 1 && switch_hand_4 == 1)
			begin
				//do nothing since its an illegal move
			end
			else if (switch_hand_1 == 1 && switch_hand_3 == 1 && switch_hand_2 == 0 && switch_hand_4 == 0)
			begin
			
				alu_select_a = 3'd1;
				alu_select_b = 3'd3;
				if (turn == 0)
					begin
					ld_hand_select = 3'd1; //hand 1
					ld_hand_select_for_plot = 3'd1;
					end
				else
					begin
					ld_hand_select = 3'd3; //hand 3
					ld_hand_select_for_plot = 3'd3;
					end
			end
			
			else if (switch_hand_1 == 1 && switch_hand_4 == 1 && switch_hand_2 == 0 && switch_hand_3 == 0)
			begin
				alu_select_a = 3'd1;
				alu_select_b = 3'd4;
				if (turn == 0)
					begin
					ld_hand_select = 3'd1; //hand 1
					ld_hand_select_for_plot = 3'd1;
					end
				else
					begin
					ld_hand_select = 3'd4; //hand 4
					ld_hand_select_for_plot = 3'd4;
					end
			end
			
			else if (switch_hand_2 == 1 && switch_hand_3 == 1 && switch_hand_1 == 0 && switch_hand_4 == 0)
			begin
				alu_select_a = 3'd2;
				alu_select_b = 3'd3;
				if (turn == 0)
					begin
					ld_hand_select = 3'd2; //hand 2
					ld_hand_select_for_plot = 3'd2;
					end
				else
					begin
					ld_hand_select = 3'd3; //hand 3
					ld_hand_select_for_plot = 3'd3;
					end
			end
			
			else if (switch_hand_2 == 1 && switch_hand_4 == 1 && switch_hand_1 == 0 && switch_hand_3 == 0)
			begin
				alu_select_a = 3'd2;
				alu_select_b = 3'd4;			
				if (turn == 0)
					begin
					ld_hand_select = 3'd2; //hand 2
					ld_hand_select_for_plot = 3'd2;
					end
				else
					begin
					ld_hand_select = 3'd4; //hand 3
					ld_hand_select_for_plot = 3'd4;
					end
			end
			
			else //another illegal move case
			begin
			alu_select_a = 3'd0;
			alu_select_b = 3'd0;
			ld_hand_select = 3'd0;
			ld_hand_select_for_plot = 3'd0;
				//do nothing i guess
			end
		end
	  
	endcase //end case of current state
	
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_IDLE;
        else
		  begin
			   current_state <= next_state;
		  end
    end // state_FFS
endmodule

module datapath(
	input go,
	input clk,
	input resetn,

	output reg win,
	output reg [3:0]switch,

	input [2:0] ld_hand_select, //should be 3 bits :D
	input [2:0] alu_select_a,
	input [2:0] alu_select_b,

	//changing from output reg to output wire
	output reg [2:0] hand1,
	output reg [2:0] hand3,
	output reg [2:0] hand2,
	output reg [2:0] hand4

	);
	 
	//all of these are 3 bits wide
	// input registers
	//reg [2:0] hand1, hand3;

	// ouput of the alu
	//reg [2:0] alu_out;
	reg [2:0] alu_out;
	reg [2:0] alu_a;
	reg [2:0] alu_b;
	//wire [2:0] alu_select_a;
	//wire [2:0] alu_select_b;
	
	
	
	always @(*)  
	begin
		//if(!resetn) begin
			//alu_a = 3'd0;
			//alu_b = 3'd0;
		//end
	//else 
		//begin
			case(alu_select_a)
				3'd0: 
					alu_a = 3'd0;
				3'd1:
					alu_a = hand1;
				3'd2:
					alu_a = hand2;
				3'd3:
					alu_a = hand3;
				3'd4:
					alu_a = hand4;
				default:
					alu_a = 3'd0;
			endcase
			
			case(alu_select_b)
				3'd0: 
					alu_b = 3'd0;
				3'd1:
					alu_b = hand1;
				3'd2:
					alu_b = hand2;
				3'd3:
					alu_b = hand3;
				3'd4:
					alu_b = hand4;
				default:
					alu_b = 3'd0;
			endcase
		//end
	end 
	
	always @(posedge clk) begin
		if(!resetn) begin
			hand1 <= 3'b001; //all hands set equal to 1
			hand2 <= 3'b001;
			hand3 <= 3'b001;
			hand4 <= 3'b001;
		end
		
		else 
		begin
			case (ld_hand_select)
				3'd0:
					begin
						if (hand1 == 3'd5) hand1 <= 3'd5; 
						else hand1 <= hand1;
						
						if (hand2 == 3'd5) hand2 <= 3'd5;
						else hand2 <= hand2;
						
						if (hand3 == 3'd5) hand3 <= 3'd5;
						else hand3 <= hand3;
						
						if (hand4 == 3'd5) hand4 <= 3'd5;
						else hand4 <= hand4;
					end
				3'd1:                   //loading hand1
					begin
					
					if (alu_out != 3'd0)
					begin
						if (hand1 == 3'd5) hand1 <= 3'd5; 
						else hand1 <= alu_out;
						
						if (hand2 == 3'd5) hand2 <= 3'd5;
						else hand2 <= hand2;
						
						if (hand3 == 3'd5) hand3 <= 3'd5;
						else hand3 <= hand3;
						
						if (hand4 == 3'd5) hand4 <= 3'd5;
						else hand4 <= hand4;
					end
					else
					begin
						hand1 <= hand1;
						hand2 <= hand2;
						hand3 <= hand3;
						hand4 <= hand4;
					end
					end
				3'd2:
					begin                //loading hand3
					
					if (alu_out != 3'd0)
					begin
						if (hand1 == 3'd5) hand1 <= 3'd5; 
						else hand1 <= hand1;
						
						if (hand2 == 3'd5) hand2 <= 3'd5;
						else hand2 <= alu_out;
						
						if (hand3 == 3'd5) hand3 <= 3'd5;
						else hand3 <= hand3;
						
						if (hand4 == 3'd5) hand4 <= 3'd5;
						else hand4 <= hand4;
					end
					
					else
					begin
						hand1 <= hand1;
						hand2 <= hand2;
						hand3 <= hand3;
						hand4 <= hand4;
					end
					end
				3'd3: 
					begin                //loading hand2
					
					if (alu_out != 3'd0)
					begin
						if (hand1 == 3'd5) hand1 <= 3'd5; 
						else hand1 <= hand1;
						
						if (hand2 == 3'd5) hand2 <= 3'd5;
						else hand2 <= hand2;
						
						if (hand3 == 3'd5) hand3 <= 3'd5;
						else hand3 <= alu_out;
						
						if (hand4 == 3'd5) hand4 <= 3'd5;
						else hand4 <= hand4;
					end
					
					else
					begin
						hand1 <= hand1;
						hand2 <= hand2;
						hand3 <= hand3;
						hand4 <= hand4;
					end
					end
				3'd4:
					begin                //loading hand4
					
					if (alu_out != 3'd0)
					begin
						if (hand1 == 3'd5) hand1 <= 3'd5; 
						else hand1 <= hand1;
						
						if (hand2 == 3'd5) hand2 <= 3'd5;
						else hand2 <= hand2;
						
						if (hand3 == 3'd5) hand3 <= 3'd5;
						else hand3 <= hand3;
						
						if (hand4 == 3'd5) hand4 <= 3'd5;
						else hand4 <= alu_out;
					end
					
					else
					begin
						hand1 <= hand1;
						hand2 <= hand2;
						hand3 <= hand3;
						hand4 <= hand4;
					end
					end
				default: //any other case
					begin
						hand1 <= hand1;
						hand2 <= hand2;
						hand3 <= hand3;
						hand4 <= hand4;
					end
			endcase			
		end
	end

    // The ALU 
	always @(*)
	begin
	
			if (alu_a == 3'd5 || alu_b == 3'd5) alu_out = 3'd0;//do nothing, no addition
			else alu_out = alu_a + alu_b; //performs addition
			
			//rollover code
			if (alu_out == 3'd6)
			begin
				alu_out = 3'd1;
			end
			else if (alu_out == 3'd7)
			begin
				alu_out = 3'd2;
			end	
			else
			begin
				//do nothing
			end
		
	end//END OF ALU

	always @(posedge clk) 
	begin
		if (hand1 == 3'd5 && hand2 == 3'd5) begin
			win = 1;
			switch = 4'b0100;
		end
		else if (hand3 == 3'd5 && hand4 == 3'd5)begin
			win = 1;
			switch = 4'b0100;;
		end
		else 
		begin
			win = 0;
			switch = 4'b0000;
		end
	end
     
endmodule


module hex_decoder(hex_digit, segments);
	input [3:0] hex_digit;
	output reg [6:0] segments;

	always @(*)
	case (hex_digit)
		4'h0: segments = 7'b100_0000;
		4'h1: segments = 7'b111_1001;
		4'h2: segments = 7'b010_0100;
		4'h3: segments = 7'b011_0000;
		4'h4: segments = 7'b001_1001;
		4'h5: segments = 7'b001_0010;
		4'h6: segments = 7'b000_0010;
		4'h7: segments = 7'b111_1000;
		4'h8: segments = 7'b000_0000;
		4'h9: segments = 7'b001_1000;
		4'hA: segments = 7'b000_1000;
		4'hB: segments = 7'b000_0011;
		4'hC: segments = 7'b100_0110;
		4'hD: segments = 7'b010_0001;
		4'hE: segments = 7'b000_0110;
		4'hF: segments = 7'b000_1110;   
	default: segments = 7'h7f;
	endcase
endmodule

module draw_one_finger_left_hand (x, y, startx, starty, color, clock, writeEn, reset);
	input clock;
	input writeEn;
	input reset;
	input [7:0] startx;
	input [6:0] starty;
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	
	reg [10:0] address;
	reg [7:0] count_x = 0;
	reg [6:0] count_y = 0;
	
	
	oneleftcolour_rom left1(
					.address(address), //this
					.clock(clock),
					.q(color)
					);
	
	reg [5:0] addr_x = 0;
	reg [5:0] addr_y = 0;

	always @(posedge clock)
	begin
		if (~reset)
		begin
			addr_x = 6'd0;
			addr_y = 6'd0;
			count_x = 8'd0;
			count_y = 7'd0;
		end
		else if (writeEn)
		begin
			if (addr_x != 6'd40)
			begin
				count_x = count_x + 1'b1;
				addr_x = addr_x + 1'b1;
				address = address+1;
			end
			else if (addr_y != 6'd30)
			begin
				addr_y = addr_y + 1'b1;
				count_y = count_y + 1'b1;
				addr_x = 6'd0;
				count_x = 8'd0;
			end
		end
	end

	assign x = count_x + startx;
	assign y = count_y + starty;
	
	
endmodule

module draw_two_finger_left_hand (x, y, startx, starty, color, clock, writeEn, reset);
	input clock;
	input writeEn;
	input reset;
	input [7:0] startx;
	input [6:0] starty;
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	
	reg [10:0] address;
	reg [7:0] count_x = 0;
	reg [6:0] count_y = 0;
	
	
	twoleftcolour left2(
					.address(address), //this
					.clock(clock),
					.q(color)
					);
	
	reg [5:0] addr_x = 0;
	reg [5:0] addr_y = 0;

	always @(posedge clock)
	begin
		if (~reset)
		begin
			addr_x = 6'd0;
			addr_y = 6'd0;
			count_x = 8'd0;
			count_y = 7'd0;
		end
		else if (writeEn)
		begin
			if (addr_x != 6'd40)
			begin
				count_x = count_x + 1'b1;
				addr_x = addr_x + 1'b1;
				address = address+1;
			end
			else if (addr_y != 6'd30)
			begin
				addr_y = addr_y + 1'b1;
				count_y = count_y + 1'b1;
				addr_x = 6'd0;
				count_x = 8'd0;
			end
		end
	end

	assign x = count_x + startx;
	assign y = count_y + starty;
	
	
endmodule

module draw_three_finger_left_hand (x, y, startx, starty, color, clock, writeEn, reset);
	input clock;
	input writeEn;
	input reset;
	input [7:0] startx;
	input [6:0] starty;
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	
	reg [10:0] address;
	reg [7:0] count_x = 0;
	reg [6:0] count_y = 0;
	
	
	threeleftcolour_rom left3(
					.address(address), //this
					.clock(clock),
					.q(color)
					);
	
	reg [5:0] addr_x = 0;
	reg [5:0] addr_y = 0;

	always @(posedge clock)
	begin
		if (~reset)
		begin
			addr_x = 6'd0;
			addr_y = 6'd0;
			count_x = 8'd0;
			count_y = 7'd0;
		end
		else if (writeEn)
		begin
			if (addr_x != 6'd40)
			begin
				count_x = count_x + 1'b1;
				addr_x = addr_x + 1'b1;
				address = address+1;
			end
			else if (addr_y != 6'd30)
			begin
				addr_y = addr_y + 1'b1;
				count_y = count_y + 1'b1;
				addr_x = 6'd0;
				count_x = 8'd0;
			end
		end
	end

	assign x = count_x + startx;
	assign y = count_y + starty;
	
	
endmodule

module draw_four_finger_left_hand (x, y, startx, starty, color, clock, writeEn, reset);
	input clock;
	input writeEn;
	input reset;
	input [7:0] startx;
	input [6:0] starty;
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	
	reg [10:0] address;
	reg [7:0] count_x = 0;
	reg [6:0] count_y = 0;
	
	
	fourlefthand_rom left4(
					.address(address), //this
					.clock(clock),
					.q(color)
					);
	
	reg [5:0] addr_x = 0;
	reg [5:0] addr_y = 0;

	always @(posedge clock)
	begin
		if (~reset)
		begin
			addr_x = 6'd0;
			addr_y = 6'd0;
			count_x = 8'd0;
			count_y = 7'd0;
		end
		else if (writeEn)
		begin
			if (addr_x != 6'd40)
			begin
				count_x = count_x + 1'b1;
				addr_x = addr_x + 1'b1;
				address = address+1;
			end
			else if (addr_y != 6'd30)
			begin
				addr_y = addr_y + 1'b1;
				count_y = count_y + 1'b1;
				addr_x = 6'd0;
				count_x = 8'd0;
			end
		end
	end

	assign x = count_x + startx;
	assign y = count_y + starty;
	
	
endmodule

module draw_five_finger_left_hand (x, y, startx, starty, color, clock, writeEn, reset);
	input clock;
	input writeEn;
	input reset;
	input [7:0] startx;
	input [6:0] starty;
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	
	reg [10:0] address;
	reg [7:0] count_x = 0;
	reg [6:0] count_y = 0;
	
	
	fivelefthand_rom left5(
					.address(address), //this
					.clock(clock),
					.q(color)
					);
	
	reg [5:0] addr_x = 0;
	reg [5:0] addr_y = 0;

	always @(posedge clock)
	begin
		if (~reset)
		begin
			addr_x = 6'd0;
			addr_y = 6'd0;
			count_x = 8'd0;
			count_y = 7'd0;
		end
		else if (writeEn)
		begin
			if (addr_x != 6'd40)
			begin
				count_x = count_x + 1'b1;
				addr_x = addr_x + 1'b1;
				address = address+1;
			end
			else if (addr_y != 6'd30)
			begin
				addr_y = addr_y + 1'b1;
				count_y = count_y + 1'b1;
				addr_x = 6'd0;
				count_x = 8'd0;
			end
		end
	end

	assign x = count_x + startx;
	assign y = count_y + starty;
	
	
endmodule

module draw_one_finger_right_hand (x, y, startx, starty, color, clock, writeEn, reset/*, print_done*/);
	input clock;
	input writeEn;
	input reset;
	input [7:0] startx;
	input [6:0] starty;
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	//output reg print_done;
	reg [10:0] address;
	reg [7:0] count_x = 0;
	reg [6:0] count_y = 0;
	
	
	onerightcolour_rom right1(
					.address(address), //this
					.clock(clock),
					.q(color)
					);
	
	reg [5:0] addr_x = 0;
	reg [5:0] addr_y = 0;

	always @(posedge clock)
	begin
		if (~reset)
		begin
			addr_x = 6'd0;
			addr_y = 6'd0;
			count_x = 8'd0;
			count_y = 7'd0;
		end
		else if (writeEn)
		begin
			if (addr_x != 6'd40)
			begin
				count_x = count_x + 1'b1;
				addr_x = addr_x + 1'b1;
				address = address+1;
			end
			else if (addr_y != 6'd30)
			begin
				addr_y = addr_y + 1'b1;
				count_y = count_y + 1'b1;
				addr_x = 6'd0;
				count_x = 8'd0;
			end
		end
	end

	assign x = count_x + startx;
	assign y = count_y + starty;
	
	
endmodule

module draw_two_finger_right_hand (x, y, startx, starty, color, clock, writeEn, reset/*, print_done*/);
	input clock;
	input writeEn;
	input reset;
	input [7:0] startx;
	input [6:0] starty;
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	//output reg print_done;
	reg [10:0] address;
	reg [7:0] count_x = 0;
	reg [6:0] count_y = 0;
	
	
	tworightcolour_rom right2(
					.address(address), //this
					.clock(clock),
					.q(color)
					);
	
	reg [5:0] addr_x = 0;
	reg [5:0] addr_y = 0;

	always @(posedge clock)
	begin
		if (~reset)
		begin
			addr_x = 6'd0;
			addr_y = 6'd0;
			count_x = 8'd0;
			count_y = 7'd0;
		end
		else if (writeEn)
		begin
			if (addr_x != 6'd40)
			begin
				count_x = count_x + 1'b1;
				addr_x = addr_x + 1'b1;
				address = address+1;
			end
			else if (addr_y != 6'd30)
			begin
				addr_y = addr_y + 1'b1;
				count_y = count_y + 1'b1;
				addr_x = 6'd0;
				count_x = 8'd0;
			end
		end
	end

	assign x = count_x + startx;
	assign y = count_y + starty;
	
	
endmodule

module draw_three_finger_right_hand (x, y, startx, starty, color, clock, writeEn, reset/*, print_done*/);
	input clock;
	input writeEn;
	input reset;
	input [7:0] startx;
	input [6:0] starty;
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	//output reg print_done;
	reg [10:0] address;
	reg [7:0] count_x = 0;
	reg [6:0] count_y = 0;
	
	
	threerighthandscolour_rom right3(
					.address(address), //this
					.clock(clock),
					.q(color)
					);
	
	reg [5:0] addr_x = 0;
	reg [5:0] addr_y = 0;

	always @(posedge clock)
	begin
		if (~reset)
		begin
			addr_x = 6'd0;
			addr_y = 6'd0;
			count_x = 8'd0;
			count_y = 7'd0;
		end
		else if (writeEn)
		begin
			if (addr_x != 6'd40)
			begin
				count_x = count_x + 1'b1;
				addr_x = addr_x + 1'b1;
				address = address+1;
			end
			else if (addr_y != 6'd30)
			begin
				addr_y = addr_y + 1'b1;
				count_y = count_y + 1'b1;
				addr_x = 6'd0;
				count_x = 8'd0;
			end
		end
	end

	assign x = count_x + startx;
	assign y = count_y + starty;
	
	
endmodule

module draw_four_finger_right_hand (x, y, startx, starty, color, clock, writeEn, reset/*, print_done*/);
	input clock;
	input writeEn;
	input reset;
	input [7:0] startx;
	input [6:0] starty;
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	//output reg print_done;
	reg [10:0] address;
	reg [7:0] count_x = 0;
	reg [6:0] count_y = 0;
	
	
	fourrighthandcolour_rom right4(
					.address(address), //this
					.clock(clock),
					.q(color)
					);
	
	reg [5:0] addr_x = 0;
	reg [5:0] addr_y = 0;

	always @(posedge clock)
	begin
		if (~reset)
		begin
			addr_x = 6'd0;
			addr_y = 6'd0;
			count_x = 8'd0;
			count_y = 7'd0;
		end
		else if (writeEn)
		begin
			if (addr_x != 6'd40)
			begin
				count_x = count_x + 1'b1;
				addr_x = addr_x + 1'b1;
				address = address+1;
			end
			else if (addr_y != 6'd30)
			begin
				addr_y = addr_y + 1'b1;
				count_y = count_y + 1'b1;
				addr_x = 6'd0;
				count_x = 8'd0;
			end
		end
	end

	assign x = count_x + startx;
	assign y = count_y + starty;
	
	
endmodule

module draw_five_finger_right_hand (x, y, startx, starty, color, clock, writeEn, reset/*, print_done*/);
	input clock;
	input writeEn;
	input reset;
	input [7:0] startx;
	input [6:0] starty;
	output [7:0] x;
	output [6:0] y;
	output [2:0] color;
	//output reg print_done;
	reg [10:0] address;
	reg [7:0] count_x = 0;
	reg [6:0] count_y = 0;
	
	
	fiverighthandcolour_rom right5(
					.address(address), //this
					.clock(clock),
					.q(color)
					);
	
	reg [5:0] addr_x = 0;
	reg [5:0] addr_y = 0;

	always @(posedge clock)
	begin
		if (~reset)
		begin
			addr_x = 6'd0;
			addr_y = 6'd0;
			count_x = 8'd0;
			count_y = 7'd0;
		end
		else if (writeEn)
		begin
			if (addr_x != 6'd40)
			begin
				count_x = count_x + 1'b1;
				addr_x = addr_x + 1'b1;
				address = address+1;
			end
			else if (addr_y != 6'd30)
			begin
				addr_y = addr_y + 1'b1;
				count_y = count_y + 1'b1;
				addr_x = 6'd0;
				count_x = 8'd0;
			end
		end
	end

	assign x = count_x + startx;
	assign y = count_y + starty;
	
	
endmodule

