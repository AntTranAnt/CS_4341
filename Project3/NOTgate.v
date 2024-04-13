//-------------------------------------------------
// Cohort: OnOff
// Tony Tran, Hasan Kadado, Anthony Tran, Angel Gomez
//-------------------------------------------------
module SixteenBitNOTgate(input [15:0] inputA, output reg [31:0] outputC);
    always @(*) begin
        outputC = ~inputA;
    end
endmodule


// module testbench();
//     reg [15:0] inputA;
//     wire [31:0] outputC;

//     NOTgate DUT (
//         .inputA(inputA),
//         .outputC(outputC)
//     );

//     initial begin
//         inputA = 16'b0000000001111111;
//         #60;
//         $display("inputA = %b", inputA);
//         $display("outputC = %b", outputC);

//         inputA = 16'b1000000000000001;
//         #60;
//         $display("inputA = %b", inputA);
//         $display("outputC = %b", outputC);
//     end
// endmodule