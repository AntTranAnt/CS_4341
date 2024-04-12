module XOR(inputA,inputB,outputC)
    input [15:0] inputA,
    input [15:0] inputB,
    wire  [15:0] inputA;
    wire  [15:0] inputB;
    output reg [31:0] outputC

    always @* begin
        // Perform XOR operation between inputA and inputB
        outputC = inputA ^ inputB;
end