`timescale 1ns / 1ps


module TS_Controller(
input clk,sensor,clear,
output reg R_ctry,G_ctry,Y_ctry,R_hiwy,G_hiwy,Y_hiwy
    );
    
    reg [1:0]state=2'b00,next_state;
    parameter s0=2'b00,s1=2'b01,s2=2'b10,s3=2'b11;
    
    integer count=0;
    reg count_reset;
    
    always@(posedge clk)
    begin
      if(count_reset==1)
      begin
        count=0;
        count_reset=0;
      end
      else
      begin
        count = count+1;
      end
    end
    
    always@(posedge clk)
    begin
      if(clear)
      state<=s0;
      else
      state<=next_state;
    end
    
    always@(*)
    begin
      case(state)
      s0:
         if(count>=60 & sensor==1)
          next_state<=s1;
         else
          next_state<=s0;
          
      s1:
         if(count>=10)
          next_state<=s2;
         else
          next_state<=s1;
          
      s2:
         if(count<=30 & sensor==1)
          next_state<=s2;
         else
          next_state<=s3;
          
      s3:
         if(count>=10)
          next_state<=s0;
         else
          next_state<=s3;
      endcase
    end
    
    always@(*)
    begin
      count_reset=1;
      {R_ctry,G_ctry,Y_ctry,R_hiwy,G_hiwy,Y_hiwy}=6'b000000;
      case(state)
        s0:
           begin
             R_ctry<=1'b1;
             G_hiwy<=1'b1;
           end
           
        s1:
           begin
             R_ctry<=1'b1;
             Y_hiwy<=1'b1;
           end
           
        s2:
           begin
             G_ctry<=1'b1;
             R_hiwy<=1'b1;
           end
           
        s3:
           begin
             Y_ctry<=1'b1;
             R_hiwy<=1'b1;
           end   
      endcase
    end
    
endmodule
