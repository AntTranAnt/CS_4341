//-------------------------------------------------
// Cohort: OnOff
// Tony Tran, Hasan Kadado, Anthony Tran, Angel Gomez
//-------------------------------------------------

module SixteenBitAddSub(
    input [15:0] inputA,
    input [15:0] inputB,
    input mode,
    output reg [31:0] result,
    output wire carryOut, 
    output reg overflow
);

wire [15:0] b;
wire [15:0] sum; 
wire c0; 
wire [15:0] c; 

assign c0 = mode;

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : gen_xor
        assign b[i] = inputB[i] ^ mode;
    end
endgenerate

FullAdder fa0(inputA[0], b[0], c0, c[0], sum[0]);
generate
    for (i = 1; i < 16; i = i + 1) begin : gen_fa
        FullAdder fa(inputA[i], b[i], c[i-1], c[i], sum[i]);
    end
endgenerate

assign carryOut = c[15]; 


always @* begin
    result[15:0] = sum[15:0];
    result[31:16] = {16{sum[15]}};
    overflow = c[15] ^ c[14]; 
end

endmodule

/* 
module testbench();


//Data Inputs
reg [3:0]dataA;
reg [3:0]dataB;
reg mode;

//Outputs
wire[7:0]result;
wire carry;
wire err;

//Instantiate the Modules
FourBitAddSub addsub(dataA,dataB,mode,result,carry,err);


initial
begin
//        0123456789ABCDEF
$display("Addition");
mode=0; 
dataA=4'b0010; 
dataB=4'b0010;
#100;
 
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result);
$display("err=%b",err);

 
mode=0; 
dataA=4'b0100;
dataB=4'b0100;
#100;
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result); 
$display("err=%b",err);

mode=0; 
dataA=4'b0010;
dataB=4'b1100;
#100;
 
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result);
$display("err=%b",err);



mode=0; 
dataA=4'b0100;
dataB=4'b1110;
#100;
$write("mode=%b;",mode);
$write("%b+%b=[%b];",dataA,dataB,result);
$display("err=%b",err);


$display("Subtraction");
mode=1; 
dataA=4'b1110; 
dataB=4'b1100;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
$display("err=%b",err);


mode=1; 
dataA=4'b1100;
dataB=4'b0010;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
 
$display("err=%b",err);


mode=1; 
dataA=4'b1100;
dataB=4'b0111;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
 
$display("err=%b",err);

mode=1; 
dataA=4'b1100;
dataB=4'b1110;
#100;
$write("mode=%b;",mode);
$write("%b-%b=[%b];",dataA,dataB,result);
 
$display("err=%b",err);




end




endmodule
 */