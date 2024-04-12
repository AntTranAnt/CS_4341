// Language: Verilog
// Editor: Visual Studio Code

// Define the breadboard module with combinational logic
module breadboard(input wire w, x, y, z, output wire f0, f1, f2, f3, f4, f5, f6, f7, f8, f9);
    // maxterm equation for f0 to f9
    assign f0 = (!w | !y | z) & (w | !y | !z) & (!x | !y) & (!x | z) & (x | y | !z);
    assign f1 = (!w | x | !y | z) & (w | !x | !y | z) & (w | !x | y | !z);
    assign f2 = (!w | !y) & (w | x | !z) & (!x | !y) & (y | z);
    assign f3 = (!w | x | !z) & (!w | !y) & (w | y | z) & (!y | !z);
    assign f4 = (!w | x) & (!w | !y | !z) & (w | !x | y) & (x | y | z);
    assign f5 = (!w | !x | !y | !z) & (!w | x | y | z) & (w | !x | y | z);
    assign f6 = (!w | y | z) & (w | x | !z) & (w | y | !z) & (!x | !y | z);
    assign f7 = (!w | !x | !y | z) & (!w | y | !z) & (w | x | z) & (x | !y | !z) & (x | y | z);
    assign f8 = (!w | !x) & (w | !y) & (!x | z) & (x | y | !z);
    assign f9 = (!w | x | !y) & (!w | y | !z) & (w | !x | !y) & (w | x | z);
endmodule

// Testbench for simulating the breadboard module
module testbench;
    // Input and output signals
    reg w, x, y, z;
    wire f0, f1, f2, f3, f4, f5, f6, f7, f8, f9;
    integer file;

    // Instantiate breadboard
    breadboard bb(.w(w), .x(x), .y(y), .z(z), .f0(f0), .f1(f1), .f2(f2), .f3(f3), .f4(f4), .f5(f5), .f6(f6), .f7(f7), .f8(f8), .f9(f9));

    // Initial block for setting inputs and recording outputs
    initial begin
        // Open file
        file = $fopen("OffOn.output1.txt", "w");

        // Write outputs if file opened successfully
        if(file) begin
            // Print first line
            $fwrite(file, "w x y z | f0 f1 f2 f3 f4 f5 f6 f7 f8 f9\n");

            // Use for loop to go through 0-16 in binary
            for (integer i = 0; i < 16; i = i + 1) begin
                {w, x, y, z} = i[3:0];
                #1;
                // Write the outputs to the file
                $fwrite(file, "%b %b %b %b | %b  %b  %b  %b  %b  %b  %b  %b  %b  %b\n", w, x, y, z, f0, f1, f2, f3, f4, f5, f6, f7, f8, f9);
            end

            $fclose(file);
        end
        else begin
            // Output error if file failed to open
            $display("Error, file not opened.");
        end
    end
endmodule
