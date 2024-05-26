`timescale 1ns / 1ps


module TS_Controller_tb();

wire R_ctry,G_ctry,Y_ctry,R_hiwy,G_hiwy,Y_hiwy;
reg clk=0;
reg sensor=0;
reg clear=1;

TS_Controller Traffic_light(.clk(clk),.sensor(sensor),.clear(clear),
              .R_ctry(R_ctry),.G_ctry(G_ctry),.Y_ctry(Y_ctry),
              .R_hiwy(R_hiwy),.G_hiwy(G_hiwy),.Y_hiwy(Y_hiwy) );
                     
always #1 clk = ~clk;
 

initial 
begin
  #4
  clear <= 0;
  #100;
  sensor <= 1;
  #20;
  sensor <= 0;
  #140;
end

endmodule
