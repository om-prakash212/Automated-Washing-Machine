`timescale 10ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Om Prakash Barik
// Create Date: 05.08.2024 20:12:53
// Design Name: Finite State Machine
// Module Name: auto_WM
// Project Name: Automated Washing Machine
//////////////////////////////////////////////////////////////////////////////////


module auto_WM(clk, reset, door_close, start, filled, detergent_added, cycle_timeout, drained, spin_timeout, door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash);

    
    input clk, reset, door_close, start, filled, detergent_added, cycle_timeout,drained, spin_timeout;
    output reg door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash;
    
    // defining the states
    parameter check_door = 3'b000;
    parameter fill_water = 3'b001;
    parameter add_detergent = 3'b010;
    parameter cycle = 3'b100;
    parameter drain_water = 3'b101;
    parameter spin = 3'b101;
    
    reg[2:0] current_state, next_state;
    always@(*)
    begin
    
    case(current_state)
		check_door:
			if(start==1 && door_close==1)
			begin
				next_state = fill_water;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				soap_wash = 0;
				water_wash = 0;
				done = 0;
			end
			else begin
			next_state = current_state;
			motor_on = 0;
			fill_valve_on = 0;
			drain_valve_on = 0;
			door_lock = 1;
			soap_wash = 0;
			water_wash = 0;
			done = 0;
			end
		fill_water:
			if (filled==1)
			begin
				if(soap_wash == 0)
				begin
					next_state = add_detergent;
					motor_on = 0;
					fill_valve_on = 0;
					drain_valve_on = 0;
					door_lock = 1;
					soap_wash = 1;
					water_wash = 0;
					done = 0;
				end
				else
				begin
					next_state = cycle;
					motor_on = 0;
					fill_valve_on = 0;
					drain_valve_on = 0;
					door_lock = 1;
					soap_wash = 1;
					water_wash = 1;
					done = 0;
				end
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_valve_on = 1;
				drain_valve_on = 0;
				door_lock = 1;
				done = 0;
			end
			add_detergent:
			if(detergent_added==1)
			begin
				next_state = cycle;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				soap_wash = 1;
				done = 0;
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				soap_wash = 1;
				water_wash = 0;
				done = 0;
			end
			cycle:
			if(cycle_timeout == 1)
			begin
				next_state = drain_water;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				//soap_wash = 1;
				done = 0;
			end
			else
			begin
				next_state = current_state;
				motor_on = 1;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				//soap_wash = 1;
				done = 0;
			end
			drain_water:
			 if(drained==1)
			 begin
				if(water_wash==0)
				begin
					next_state = fill_water;
					motor_on = 0;
					fill_valve_on = 0;
					drain_valve_on = 0;
					door_lock = 1;
					soap_wash = 1;
					//water_wash = 1;
					done = 0;
				end
				else
				begin
				next_state = spin;
					motor_on = 0;
					fill_valve_on = 0;
					drain_valve_on = 0;
					door_lock = 1;
					soap_wash = 1;
					water_wash = 1;
					done = 0;
				end
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 1;
				door_lock = 1;
				soap_wash = 1;
				//water_wash = 1;
				done = 0;
			end
			spin:
			if(spin_timeout==1)
			begin
				next_state = door_close;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 0;
				door_lock = 1;
				soap_wash = 1;
				water_wash = 1;
				done = 1;
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_valve_on = 0;
				drain_valve_on = 1;
				door_lock = 1;
				soap_wash = 1;
				water_wash = 1;
				done = 0;
			end
			default:
				next_state = check_door;
				
			endcase
	end
			
endmodule

module new_test();
	reg clk, reset, door_close, start, filled, detergent_added, cycle_timeout, drained, spin_timeout;
	wire door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash; 
	
	
auto_WM machine1(clk, reset, door_close, start, filled, detergent_added, cycle_timeout, drained, spin_timeout, door_lock, motor_on, fill_valve_on, drain_valve_on, done, soap_wash, water_wash);


	
	
	initial
		
	begin
	clk = 0;
		reset = 1;
		start = 0;
		door_close = 0;
		filled = 0;
		drained = 0;
		detergent_added = 0;
		cycle_timeout = 0;
		spin_timeout = 0;
		
		#5 reset=0;
		#5 start=1;door_close=1;
		#10 filled=1;
		#10 detergent_added=1;
		//filled=0;
		#10 cycle_timeout=1;
		//detergent_added=0;
		#10 drained=1;
		//cycle_timeout=0;
		#10 spin_timeout=1;
		//drained=0;
		
		/*
		
		#0 reset = 0;
		#2 start = 1;
		#4 door_close = 1;
		#3 filled = 1;
		#3 detergent_added = 1;
		#2 cycle_timeout = 1;
		#2 drained = 1; 
		#3 spin_timeout = 1;
		*/
	end
	
	always
	begin
		#5 clk = ~clk;
	end
	
	initial
	begin
		$monitor("Time=%d, Clock=%b, Reset=%b, start=%b, door_close=%b, filled=%b, detergent_added=%b, cycle_timeout=%b, drained=%b, spin_timeout=%b, door_lock=%b, motor_on=%b, fill_valve_on=%b, drain_valve_on=%b, soap_wash=%b, water_wash=%b, done=%b",$time, clk, reset, start, door_close, filled, detergent_added, cycle_timeout, drained, spin_timeout, door_lock, motor_on, fill_valve_on, drain_valve_on, soap_wash, water_wash, done);
	end
endmodule

