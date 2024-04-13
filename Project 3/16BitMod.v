//-------------------------------------------------
// Cohort: OnOff
// Tony Tran, Hasan Kadado, Anthony Tran, Angel Gomez
//-------------------------------------------------

module SixteenBitModulus(numerator,denominator,modulus,error);
input [15:0] numerator;
input [15:0] denominator;
output [31:0] modulus;
output error;

wire [15:0] numerator;
wire [15:0] denominator;
reg [31:0] modulus;
reg error;

always @(numerator,denominator)
begin
    modulus=numerator%denominator;
    modulus[4]=modulus[15];
    modulus[5]=modulus[15];
    modulus[6]=modulus[15];
    modulus[7]=modulus[15];

    error=~(denominator[3]|denominator[2]|denominator[1]|denominator[0]);
end

endmodule;

/*
module testbench();

reg [3:0]inputA;
reg [3:0]inputB;
wire [3:0] modulus;
wire error;

FourBitModulus M40(inputB,inputA,modulus,error);

initial begin
	inputB=4'b1111;
	inputA=4'b0010;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,modulus,error);

	inputB=4'b1111;
	inputA=4'b0000;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,modulus,error);

end
endmodule
*/
 
