module FIFO_4_Handshaking(
    input clk, rst, valid_in, ready_in,            
    input [7:0] data_in,                            
    output reg ready_out, valid_out,                 
    output reg [7:0] data_out                      
);

reg [7:0] registers [0:3];
reg [1:0] rd_ptr, wr_ptr;
reg [2:0] count;

// flag updation
    always @(*)
        begin
           data_out = registers[rd_ptr];

           if(rst)
                begin
                    // show that the fifo is empty
                    ready_out    = 1'b1; // ready to accept
                    valid_out   = 1'b0; // not ready to send data
                end 
            else if(count == 3'd0)
                begin
                    ready_out    = 1'b1; // ready to accept
                    valid_out   = 1'b0; // not ready to send data
                end
            else if(count == 3'd4)
                begin
                    ready_out    = 1'b0;
                    valid_out   = 1'b1;
                end
            else    //somewhere between empty and full
                begin
                    ready_out    = 1'b1;
                    valid_out   = 1'b1;
                end
        end

// computation and memory
    always @(posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    rd_ptr <= 2'b00;
                    wr_ptr <= 2'b00;
                    count  <= 3'b000;
                end
            else if(valid_out && ready_in && valid_in && ready_out)
                begin
                    registers[wr_ptr]   <=  data_in;
                    wr_ptr              <=  wr_ptr + 1'b1;

                    rd_ptr      <= rd_ptr + 1'b1;
                end
            else if(valid_in && ready_out)   // data is valid at the input and fifo is not empty
                begin
                    registers[wr_ptr]   <=  data_in;
                    count               <=  count + 1'b1;
                    wr_ptr              <=  wr_ptr + 1'b1;
                end
            else if(valid_out && ready_in)
                begin
                    count       <= count - 1'b1;
                    rd_ptr      <= rd_ptr + 1'b1;
                end
        end
endmodule
  
