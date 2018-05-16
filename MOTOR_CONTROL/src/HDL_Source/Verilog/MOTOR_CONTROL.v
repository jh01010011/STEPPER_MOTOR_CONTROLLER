timeunit 1ns;
timeprecision 1ps;


module MOTOR_CONTROL(input logic FSM_A_RESET,
					 input logic CW,CCW,
					 input logic SYS_CLK,
					output logic[3:0] MOTOR_DRIVE ) ;  
					
const logic[3:0] A=4'b1010;
const logic[3:0] B=4'b1001;
const logic[3:0] C=4'b0101;
const logic[3:0] D=4'b0110;

logic[2:0] P_STATE, N_STATE;  
logic COUNT_LT_8,SCLR, INC;
					
always_comb

begin: NSOL

begin: NSL
N_STATE='bx;

case(P_STATE)

3'b000: N_STATE=3'b001;

3'b001: begin 
		if(COUNT_LT_8 || CW==CCW)
			N_STATE=P_STATE;
		else
			begin
			if(CW)
			N_STATE=3'b011;
			else
			N_STATE=3'b110;
			end
		end

3'b011:	begin 
		if(COUNT_LT_8 || CW==CCW)
			N_STATE=P_STATE;
		else 
			begin
			if(CW)
			N_STATE=3'b010;
			else
			N_STATE=3'b001;
			end
		end
3'b010: begin 
		if(COUNT_LT_8 || CW==CCW)
			N_STATE=P_STATE;
		else 
			begin
			if(CW)
			N_STATE=3'b110;
			else
			N_STATE=3'b011;
			end
		end

3'b110: begin 
		if(COUNT_LT_8 || CW==CCW)
			N_STATE=P_STATE;
		else
			begin
			if(CW)
			N_STATE=3'b001;
			else
			N_STATE=3'b010;
			end
		end			 
		
	default: assign FSM_A_RESET=1'b1;

endcase	



end: NSL

begin: OL
	case(P_STATE)

3'b000: SCLR=1'b1;
3'b001: begin
		MOTOR_DRIVE=A;
		INC=1'b1;
		if(!COUNT_LT_8 && CW!=CCW)SCLR=1'b1;
		end
3'b011: begin
		MOTOR_DRIVE=B;
		INC=1'b1;
		if(!COUNT_LT_8 && CW!=CCW)SCLR=1'b1;
		end
3'b010:	begin
		MOTOR_DRIVE=C;
		INC=1'b1;
		if(!COUNT_LT_8 && CW!=CCW)SCLR=1'b1;
		end
3'b110:	begin
		MOTOR_DRIVE=D;
		INC=1'b1;
		if(!COUNT_LT_8 && CW!=CCW)SCLR=1'b1;
		end 

default: ;

endcase

end: OL

end: NSOL

always_ff@(posedge SYS_CLK, posedge FSM_A_RESET)
begin: PSR
	  if(FSM_A_RESET)P_STATE<=3'b000;
	  else
	  	  P_STATE<=N_STATE;
end: PSR

endmodule	

module DATAPATH()


