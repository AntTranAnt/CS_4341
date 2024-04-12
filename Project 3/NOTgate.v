module NOTgate(inputA,outputC);
	input  [15:0] inputA;
	wire   [15:0] inputA;
	reg    [15:0] result;
	reg    [31:0] outputC;
	output [31:0] outputC;
	always@(*)
		begin
			outputC= ~inputA;
		end
endmodule

module testbench();
    reg [15:0] inputA;
    wire [31:0] outputC;

    NOTgate DUT (
        .inputA(inputA),
        .outputC(outputC)
    );

    initial begin
        inputA = 16'b0000000001111111;
        #60;
        $display("inputA = %b", inputA);
        $display("outputC = %b", outputC);

        inputA = 16'b1000000000000001;
        #60;
        $display("inputA = %b", inputA);
        $display("outputC = %b", outputC);
    end
endmodule