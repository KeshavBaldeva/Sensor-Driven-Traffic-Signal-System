`timescale 1ns / 1ps

module TS_Controller_tb();

    wire R_ctry,G_ctry,Y_ctry,R_hiwy,G_hiwy,Y_hiwy;
    reg clk=0;
    reg sensor=0;
    reg clear=1;


    TS_Controller Traffic_light(
        .clk(clk),.sensor(sensor),.clear(clear),
        .R_ctry(R_ctry),.G_ctry(G_ctry),.Y_ctry(Y_ctry),
        .R_hiwy(R_hiwy),.G_hiwy(G_hiwy),.Y_hiwy(Y_hiwy) 
    );
     
    defparam Traffic_light.CLK_FREQ = 50;

    always #10 clk = ~clk;

    initial 
    begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, TS_Controller_tb);

 clear <= 1;
        sensor <= 0;
        #200;
        clear <= 0;

        // wait for 61 sec
        #(61 * 1000); 
        
        sensor <= 1;
        
        //wait for 11 sec
        #(11 * 1000); 
        
        // Wait for 31 sec
        #(31 * 1000); 

        sensor <= 0; 
        #(11 * 1000); //11sec
        #(10 * 1000); // 10sec for yellow
        
        //random tests
        #(51 * 1000); 
        sensor <= 1; 
        #(11 * 1000); 
        
        #(15 * 1000); 
        sensor <= 0; 
        
        
        #(11 * 1000); 
        #(10 * 1000);
        $display("--- Simulation complete ---");
        $finish;
    end

endmodule
