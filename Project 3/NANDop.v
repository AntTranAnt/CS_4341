module NAND(inputA,inputB,outputC);
	input  [15:0] inputA;
	input  [15:0] inputB;
	wire   [15:0] inputA;
	wire   [15:0] inputB;
	reg    [15:0] result;
	reg    [31:0] outputC;
	output [31:0] outputC;

	always@(*)
		begin
			//in theory should do AND op
			result= ~(inputA&inputB);
			outputC=result;
		end
 
endmodule

module testbench();

    reg [15:0] inputA;
    reg [15:0] inputB;
    wire [31:0] outputC;

    NAND DUT (
        .inputA(inputA),
        .inputB(inputB),
        .outputC(outputC)
    );

    initial begin
        inputA = 16'b0000000000000000;
        inputB = 16'b0000000000000000;
        #10;
        $display("InputA = %b", inputA);
        $display("InputB = %b", inputB);
        $display("OutputC = %b", outputC);

        inputA = 16'b1111111111111111;
        inputB = 16'b0000000000000000;
        #10;
        $display("InputA = %b", inputA);
        $display("InputB = %b", inputB);
        $display("OutputC = %b", outputC);

        inputA = 16'b0000000000000000;
        inputB = 16'b1111111111111111;
        #10;
        $display("InputA = %b", inputA);
        $display("InputB = %b", inputB);
        $display("OutputC = %b", outputC);

        inputA = 16'b1111111111111111;
        inputB = 16'b1111111111111111;
        #10;
        $display("InputA = %b", inputA);
        $display("InputB = %b", inputB);
        $display("OutputC = %b", outputC);
    end

endmodule