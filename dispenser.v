module dispenser (input clk,
                     input rst,
                     input [1:0] SW,
                     output reg [7:0] LED,                                     // LED[7] is the left most-LED
                     output reg [6:0] digit4, digit3, digit2, digit1  // digit4 is the left-most SSD
                    );
  
	 reg [1:0] current_state;
	 reg [1:0] next_state;
	 reg start_timer, start_timer1;
     wire time_up, time_up1;
    
	 
	 parameter [2:0] EMPTY = 2'b00;
	 parameter [2:0] EMPTY_WARMING = 2'b01;
	 parameter [2:0] FULL_WARMING = 3'b10;
	 parameter [2:0] FULL_HOT= 3'b11;
			// additional registers

	always @ (posedge clk or posedge rst)
	begin
		if(rst)
			begin
			current_state <= EMPTY;
			end
		else 
			current_state <= next_state;
	end
	
	// sequential part - state transitions
	always @ (posedge clk or posedge rst)
	begin
		
	end

	// combinational part - next state definitions
	always @ (*)
	begin
		if(rst)
			next_state = EMPTY;
		else
		begin
		case(current_state)
			EMPTY: 
			if(SW[0] == 0 && SW[1] == 1)
				next_state = FULL_WARMING;
			else
				next_state = EMPTY;
				
			FULL_WARMING: 
			if(SW[0] == 1 && SW[1] == 1)
				next_state = EMPTY;
			else if(SW[0] == 0 && SW[1] == 0)
				next_state = FULL_HOT;
			else
				next_state = FULL_WARMING;
				
			EMPTY_WARMING:
				if(SW[0] == 1 && SW[1] == 1)
					next_state = EMPTY;
				else if(SW[0] == 0 && SW[1] == 0)
					next_state = FULL_HOT;
				else
					next_state = EMPTY_WARMING;
					
			FULL_HOT:
				if(SW[0] == 1 && SW[1] == 1)
					next_state = EMPTY;
				else if(SW[0] == 0 && SW[1] == 1)
					next_state = EMPTY_WARMING;
				else
					next_state = FULL_HOT;
										
		endcase
		end
	end
	
	// sequential part - control registers
	always @ (posedge clk or posedge rst)
	begin
			// your code goes here	
	end 	
	
	

// combinational - outputs
	always @ (posedge clk or posedge rst)
	begin
	if(rst)
		LED <= 8'b00000000;
	else
		begin
			case(current_state)
			EMPTY:
				begin
				LED <= 8'b00000001;
				digit4 <= 7'b1001111; //1
				digit3 <= 7'b0000001; //0
				end
			FULL_WARMING:
				begin
				LED <= 8'b10000000; //
				digit4 <= 7'b0000001; //p
				digit3 <= 7'b1001111; //e

				end
			EMPTY_WARMING:
				begin
				LED <= 8'b00010000;
				digit4 <= 7'b1001111;
				digit3 <= 7'b1001111;
				end
			FULL_HOT:
				begin
				LED <= 8'b00010000;
				digit4 <= 7'b0000001;
				digit3 <= 7'b0000001;
				end
		endcase
		end
	end

		// additional always statements

 
 always @ (posedge clk or posedge rst)
 begin 
	if(rst)
		start_timer1 <= 0;
 end

timer timeup(clk,rst,start_timer,time_up);
timer1 timeup1(clk,rst,start_timer1,time_up1);
endmodule


module timer(clk, rst, start_timer, time_up);

input clk,rst;
input start_timer;
output reg time_up;

reg [31:0] counter;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		counter <= 0;
		time_up <= 0;
	end
	else begin
		if(start_timer) begin
			if(counter < 32'd50)
				counter <= counter + 1;
			else
				counter <= counter;
		end
		else begin
			counter <= 0;
		end
		
		time_up <= (counter == 32'd50);
		end
	end
endmodule

module timer1(clk, rst, start_timer1, time_up1);

input clk,rst;
input start_timer1;
output reg time_up1;

reg [31:0] counter;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		counter <= 0;
		time_up1 <= 0;
	end
	else begin
		if(start_timer1) begin
			if(counter < 32'd25)
				counter <= counter + 1;
			else
				counter <= counter;
		end
		else begin
			counter <= 0;
		end
		
		time_up1 <= (counter == 32'd25);
		end
	end
endmodule