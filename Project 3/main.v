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