module XORgate(inputA,inputB,outputC)
    input [15:0] inputA,
    input [15:0] inputB,
    output [31:0] outputC
    always @* begin
        outputC = inputA ^ inputB;
    end
endmodule

module testbench();
    reg [15:0] inputA;
    reg [15:0] inputB;
    wire [31:0] outputC;

    XORgate DUT (
        .inputA(inputA),
        .inputB(inputB),
        .outputC(outputC)
    );

    initial begin
        inputA = 16'b0000000001111111;
        inputB = 16'b0000000001111111;
        #60;
        $display("inputA = %b", inputA);
        $display("inputB = %b", inputB);
        $display("outputC = %b", outputC);

        inputA = 16'b1000000000000001;
        inputB = 16'b0000000000000000;
        #60;
        $display("inputA = %b", inputA);
        $display("inputB = %b", inputB);
        $display("outputC = %b", outputC);
    end
endmodule