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
// OPERATIONS
//=======================================================

    // Operational Outputs and Errors
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

//=======================================================
// Error Reporting
//=======================================================
reg modeADD;
reg modeSUB;
reg modeDIV;
reg modeMOD;
//=======================================================
// Connect the MUX to the OpCodes
// Channel 4, Opcode 0100, Addition
// Channel 5, Opcode 0101, Subtraction
// Channel 6, Opcode 0110, Mulitplication
// Channel 7, Opcode 0111, Division (Behavioral)
// Channel 8, Opcode 1000, Modulus (Behavioral)
//=======================================================
assign channels[ 0]=unknown;
assign channels[ 1]=unknown;
assign channels[ 2]=unknown;
assign channels[ 3]=unknown;
assign channels[ 4]=outputADDSUB;
assign channels[ 5]=outputADDSUB;
assign channels[ 6]=outputMUL;
assign channels[ 7]=outputDIV;
assign channels[ 8]=outputMOD;
assign channels[ 9]=unknown;
assign channels[10]=unknown;
assign channels[11]=unknown;
assign channels[12]=unknown;
assign channels[13]=unknown;
assign channels[14]=unknown;
assign channels[15]=unknown;
//====================================================
//Perform the gate-level operations in the Breadboard
//====================================================
 // Gate-level operations
   
   always@(*)
   begin
    outputC = b; //Just a jumper
   modeADD=~opcode[3]& opcode[2]&~opcode[1]&~opcode[0];//0100, Channel 4
   modeSUB=~opcode[3]& opcode[2]&~opcode[1]& opcode[0];//0101, Channel 5
   modeDIV=~opcode[3]& opcode[2]& opcode[1]& opcode[0];//0111, Channel 7
   modeMOD= opcode[3]&~opcode[2]&~opcode[1]&~opcode[0];//1000, Channel 8
   
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