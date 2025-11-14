`timescale 1ns / 1ps

module TS_Controller (
    input  clk,
    input  sensor,
    input  clear,
    output reg R_ctry, G_ctry, Y_ctry,
    output reg R_hiwy, G_hiwy, Y_hiwy
);

    parameter s0 = 2'b00;
    parameter s1 = 2'b01;
    parameter s2 = 2'b10;
    parameter s3 = 2'b11;
    
    parameter CLK_FREQ = 50000000;//Assumed that the clock frequency is 50MHz

    reg [1:0] state, next_state;
    reg [5:0] count;
    reg count_reset;
    
    reg sensor_sync_d;
    reg sensor_sync;
    
    reg [25:0] tick_counter; //26 bit counter to calculate 1sec
    reg sec_tick;

// synchronizer for sensor
    always@(posedge clk) 
    begin
        if (clear) begin
            sensor_sync_d <= 1'b0;
            sensor_sync <= 1'b0;
        end else
         begin
            sensor_sync_d <= sensor;
            sensor_sync <= sensor_sync_d;
         end
    end
    
   
    always@(posedge clk)
    begin
        if(clear)
         begin
            tick_counter <= 0;
            sec_tick <= 1'b0;
         end
        else if(tick_counter == CLK_FREQ - 1)
         begin
            tick_counter <= 0;
            sec_tick<= 1'b1;
         end
        else
         begin
            tick_counter <= tick_counter + 1;
            sec_tick <= 1'b0;
         end
    end


    always@(posedge clk) 
    begin
        if(clear)
            state <= s0;
        else
            state <= next_state;
    end

// seconds counter
    always@(posedge clk) 
    begin
        if(clear)
            count <= 6'b0;
        else if (count_reset)
            count <= 6'b0;
        else if (sec_tick)
            count <= count + 1;
    end
    
    //logic for the next stae
    always@(*) begin
        next_state = state;
        count_reset = 1'b0; 

        case(state)
            s0: begin
                if (count >= 60 && sensor_sync == 1) 
                begin
                    next_state = s1;
                    count_reset = 1'b1;
                end
            end
            
            s1: begin
                if (count >= 10) 
                begin
                    next_state = s2;
                    count_reset = 1'b1;
                end
            end
            
            s2: begin
                if (sensor_sync == 0 || count > 30) 
                begin
                    next_state = s3;
                    count_reset = 1'b1;
                end
            end
            
            s3: begin
                if (count >= 10)
                begin
                    next_state = s0;
                    count_reset = 1'b1;
                end
            end
        endcase
    end

//output logic
    always@(*) begin
        {R_ctry, G_ctry, Y_ctry} = 3'b100;
        {R_hiwy, G_hiwy, Y_hiwy} = 3'b100;
        
        case(state)
            s0: begin
                G_hiwy = 1'b1;
                R_hiwy = 1'b0;
            end
            
            s1: begin
                Y_hiwy = 1'b1;
                R_hiwy = 1'b0;
            end
                
            s2: begin
                G_ctry = 1'b1;
                R_ctry = 1'b0;
            end
                
            s3: begin
                Y_ctry = 1'b1;
                R_ctry = 1'b0;
            end
        endcase
    end

endmodule
