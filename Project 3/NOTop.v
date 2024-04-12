module NOT(inputA,outputC);
	input  [15:0] inputA;
	wire   [15:0] inputA;
	reg    [15:0] result;
	reg    [31:0] outputC;
	output [31:0] outputC;

	always@(*)
		begin
		    //single input taken and inverted
			result= ~inputA;
			outputC=result;
		end
 
endmodule

module testbench();

    reg [15:0] inputA;
    wire [31:0] outputC;

    NOT DUT (
        .inputA(inputA),
        .outputC(outputC)
    );

    initial begin
        inputA = 16'b0000000000000000;
        #10;
        $display("InputA = %b", inputA);
        $display("OutputC = %b", outputC);

        inputA = 16'b1111111111111111;
        #10;
        $display("InputA = %b", inputA);
        $display("OutputC = %b", outputC);

        inputA = 16'b010011101;
        #10;
        $display("InputA = %b", inputA);
        $display("OutputC = %b", outputC);
    end

endmodule