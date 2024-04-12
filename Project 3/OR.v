module OR(inputA,inputB,outputC);
    input  [15:0] inputA;
    input  [15:0] inputB;
    wire   [15:0] inputA;
    wire   [15:0] inputB;
    reg    [15:0] opResult;
    reg    [31:0] outputC;
    output [31:0] outputC;

    always@(*)
        begin
            outputC=inputA | inputB;
        end

endmodule 
