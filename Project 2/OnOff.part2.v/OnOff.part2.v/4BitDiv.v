//-------------------------------------------------
// Cohort: OnOff
// Tony Tran, Hasan Kadado, Anthony Tran, Angel Gomez
//-------------------------------------------------

module SixteenBitDivision(input [15:0] numerator, input [15:0] denominator, output reg [31:0] quotient, output reg error);

    always @(numerator, denominator) begin
        if (denominator == 0) begin
            quotient = 32'd0;
            error = 1'b1;
        end else begin
            quotient = numerator / denominator;
            error = 1'b0;
        end
    end

endmodule



/*
module testbench();

reg [3:0]inputA;
reg [3:0]inputB;
wire [3:0] quotient;
wire error;

FourBitDivision D40(inputB,inputA,quotient,error);

initial begin
	inputB=4'b1111;
	inputA=4'b0010;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,quotient,error);

	inputB=4'b1111;
	inputA=4'b0000;
	#60;
	$display("%d,%d,%d,%d",inputB,inputA,quotient,error);

end
endmodule
*/
