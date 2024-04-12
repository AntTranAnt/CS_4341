//-------------------------------------------------
// Cohort: OnOff
// Tony Tran, Hasan Kadado, Anthony Tran, Angel Gomez
//-------------------------------------------------

module SixteenBitMultiplier(input [15:0] A, input [15:0] B, output reg [31:0] C);

    wire [31:0] partial [15:0];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_partial_products
            assign partial[i] = A * B[i] << i; 
        end
    endgenerate
    
    integer j;
    always @(*) begin
        C = 0;
        for (j = 0; j < 16; j = j + 1) begin
            C = C + partial[j];
        end
    end
    
endmodule

/* 

module testbench();

reg [5:0]row;
reg [5:0]col;
reg [15:0] mark;

//Data Inputs
reg [5:0]dataA;
reg [5:0]dataB;
 

//Outputs
wire[7:0]result;
 

//Instantiate the Modules
FourBitMultiplier F4M(row[3:0],col[3:0],result);
initial
begin
//        0123456789ABCDEF
 

 
for (row=0;row<16;row++)
begin
	for (col=0;col<16;col++)
	begin
		#60;
		$write("%4d",result);
	end
$display();
end



end

endmodule
*/