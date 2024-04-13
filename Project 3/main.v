//-------------------------------------------------
// Cohort: OnOff
// Tony Tran, Hasan Kadado, Anthony Tran, Angel Gomez
//-------------------------------------------------

//=================================================================
//Breadboard
//=================================================================

module breadboard(
    input [15:0] inputA,
    input [15:0] inputB,
    input [3:0] opcode,
    output reg [1:0] error,
    output reg [31:0] outputC
);

//=======================================================
// CONTROL
//========================================================

wire [15:0][31:0] channels; 
wire [15:0] select;         
wire [31:0] b;            
wire [31:0] unknown;

// Decode the opcode to select the operation
Dec4x16 dec1(opcode, select);
StructMux mux1(channels, select, b);

//=======================================================
//
// OPERATIONS
//
//=======================================================
wire [31:0] outputAND;
wire [31:0] outputOR;
wire [31:0] outputNOT;
wire [31:0] outputNOR;
wire [31:0] outputXOR;
wire [31:0] outputNAND;
wire [31:0] outputXNOR;

wire [31:0] outputADDSUB;
wire ADDerror;
wire [31:0] outputMUL;
wire [31:0] outputDIV;
wire DIVerror;
wire [31:0] outputMOD;
wire MODerror;

// Instantiate operational modules

SixteenBitAddSub add1(inputA, inputB, modeSUB, outputADDSUB, Carry, ADDerror);
SixteenBitDivision div1(inputA, inputB, outputDIV, DIVerror);
SixteenBitModulus mod1(inputA, inputB, outputMOD, MODerror); 
SixteenBitMultiplier mul1(inputA, inputB, outputMUL);

SixteenBitAND and1(inputA, inputB, outputAND);
SixteenBitOR or1(inputA, inputB, outputOR);
SixteenBitNOT not1(inputA, outputNOT);
SixteenBitNOR nor1(inputA, inputB, outputNOR);
SixteenBitXOR xor1(inputA, inputB, outputXOR);
SixteenBitNAND nand1(inputA, inputB, outputNAND);
SixteenBitXNOR xnor1(inputA, inputB, outputXNOR);

//=======================================================
// Error Reporting
//=======================================================
reg modeADD;
reg modeSUB;
reg modeDIV;
reg modeMOD;
reg modeMUL;

reg modeNOT;
reg modeXNOR;
reg modeNAND;
reg modeAND;
reg modeOR;
reg modeXOR;
reg modeNOR;

//=======================================================
// Connect the MUX to the OpCodes
// Channel 3, Opcode 0011, Not
// Channel 4, Opcode 0100, Xnor
// Channel 5, Opcode 0101, Nand
// Channel 6, Opcode 0110, And
// Channel 7, Opcode 0111, Or
// Channel 8, Opcode 1000, Xor
// Channel 9, Opcode 1001, Nor
// Channel 10, Opcode 1010, Multiplication
// Channel 11, Opcode 1011, Addition
// Channel 12, Opcode 1100, Subtraction
// Channel 13, Opcode 1101, Division (Behavioral)
// Channel 14, Opcode 1110, Modulus (Behavioral)
//=======================================================
assign channels[ 0]=unknown;
assign channels[ 1]=unknown;
assign channels[ 2]=unknown;
assign channels[ 3]=outputNOT;
assign channels[ 4]=outputXNOR;
assign channels[ 5]=outputNAND;
assign channels[ 6]=outputAND;
assign channels[ 7]=outputOR;
assign channels[ 8]=outputXOR;
assign channels[ 9]=outputNOR;
assign channels[10]=outputMUL;
assign channels[11]=outputADDSUB;
assign channels[12]=outputADDSUB;
assign channels[13]=outputDIV;
assign channels[14]=outputMOD;
assign channels[15]=unknown;

//====================================================
//Perform the gate-level operations in the Breadboard
//====================================================
 // Gate-level operations
   
   always@(*)
   begin
    outputC = b; //Just a jumper
   modeNOT=~opcode[3]&~opcode[2]& opcode[1]& opcode[0];//0011, Channel 3
   modeXNOR=~opcode[3]& opcode[2]&~opcode[1]&~opcode[0];//0100, Channel 4
   modeNAND=~opcode[3]& opcode[2]&~opcode[1]& opcode[0];//0101, Channel 5
   modeAND=~opcode[3]& opcode[2]& opcode[1]&~opcode[0];//0110, Channel 6
   modeOR=~opcode[3]& opcode[2]& opcode[1]& opcode[0];//0111, Channel 7
   modeXOR= opcode[3]&~opcode[2]&~opcode[1]&~opcode[0];//1000, Channel 8
   modeNOR= opcode[3]&~opcode[2]&~opcode[1]& opcode[0];//1001, Channel 9
   modeMUL= opcode[3]&~opcode[2]& opcode[1]&~opcode[0];//1010, Channel 10
   modeADD= opcode[3]&~opcode[2]& opcode[1]& opcode[0];//1011, Channel 11
   modeSUB= opcode[3]& opcode[2]&~opcode[1]&~opcode[0];//1100, Channel 12
   modeDIV= opcode[3]& opcode[2]&~opcode[1]& opcode[0];//1101, Channel 13
   modeMOD= opcode[3]& opcode[2]& opcode[1]&~opcode[0];//1110, Channel 14
   
   error[0]=ADDerror&(modeADD|modeSUB);//Only show overflow if in add or subtract operation
   error[1]=(DIVerror|MODerror)&(modeDIV|modeMOD);//only show divide by zero if in division or modulus operation

end

endmodule

//====================================================
//TEST BENCH
//====================================================
module testbench();
//====================================================
//Local Variables
//====================================================
  reg [15:0] inputA;
  reg [15:0] inputB;
  reg [3:0] opcode; 
  wire [31:0] outputC;
  wire[1:0] error;
//====================================================
// Create Breadboard
//====================================================
	breadboard bb8(
	.inputA(inputA),
	.inputB(inputB),
	.opcode(opcode),
	.outputC(outputC),
	.error(error));

//====================================================
// STIMULOUS
//====================================================

  assign higherC = outputC[31:16];
  assign lowerC = outputC[15:0];

  integer file;


	initial begin//Start Stimulous Thread

	file = $fopen("OnOff.output2.txt");

	#2;	
	//---------------------------------
	$fdisplay(file, "+----------------+----------------+------+----------------+----------------+");
	//---------------------------------

	$fwrite(file, "|INPUT A         ");
	$fwrite(file, "|INPUT B         ");
	$fwrite(file, "|OPCODE");
	$fwrite(file, "|OUTPUT C HIGH   ");
	$fwrite(file, "|OUTPUT C LOW    ");
	$fdisplay(file, "|");

	//---------------------------------
	$fdisplay(file, "+----------------+----------------+------+----------------+----------------+");
	//---------------------------------

	//17409 + 4616
	inputA=16'b100010000000001; //17409
	inputB=16'b1001000001000; //4616
	opcode=4'b0100;//ADD
	#10;
	$fwrite(file, "|%4b",inputA);
	$fwrite(file, "|%4b",inputB);
	$fwrite(file, "|  %4b",opcode);
	$fwrite(file, "|%7b",higherC);	
	$fwrite(file, "|%7b",lowerC);	
	$fdisplay(file, "|");

	//---------------------------------

	//8194 - 6144
	inputA=16'b10000000000010; //8194
	inputB=16'b1100000000000; //6144
	
	opcode=4'b0101;//SUB
	#10;
	$fwrite(file, "|%4b",inputA);
	$fwrite(file, "|%4b",inputB);
	$fwrite(file, "|  %4b",opcode);
	$fwrite(file, "|%7b",higherC);	
	$fwrite(file, "|%7b",lowerC);	
	$fdisplay(file, "|");

	//---------------------------------

	//1024 * 4097
	inputA=16'b10000000000; //1024
	inputB=16'b1000000000001; //4097
	opcode=4'b0110;//MULT
	#10;
	$fwrite(file, "|%4b",inputA);
	$fwrite(file, "|%4b",inputB);
	$fwrite(file, "|  %4b",opcode);
	$fwrite(file, "|%7b",higherC);	
	$fwrite(file, "|%7b",lowerC);	
	$fdisplay(file, "|");

	//---------------------------------

	//16384 / 1024
	inputA=16'b100000000000000; //16384
	inputB=16'b10000000000; //1024
	opcode=4'b0111;//DIV
	#10;
	$fwrite(file, "|%4b",inputA);
	$fwrite(file, "|%4b",inputB);
	$fwrite(file, "|  %4b",opcode);
	$fwrite(file, "|%7b",higherC);	
	$fwrite(file, "|%7b",lowerC);	
	$fdisplay(file, "|");

	//---------------------------------

	//16391 % 1024
	inputA=16'b100000000000111; //16391
	inputB=16'b10000000000; //1024
	opcode=4'b1000;//MOD
	#10;
	$fwrite(file, "|%4b",inputA);
	$fwrite(file, "|%4b",inputB);
	$fwrite(file, "|  %4b",opcode);
	$fwrite(file, "|%7b",higherC);	
	$fwrite(file, "|%7b",lowerC);	
	$fdisplay(file, "|");

	//---------------------------------
	$fdisplay(file, "+----------------+----------------+------+-----------------+---------------+");
	//---------------------------------		
 
	$finish;
	end

endmodule