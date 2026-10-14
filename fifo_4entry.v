module fifo_4entry(
    input clk, rst, rd_en, wr_en,
    input [7:0] data_in,
    output reg [7:0] data_o,
    output reg full_o ,empty_o
);

reg [7:0] register [0:3];
reg [1:0] rd_ptr , wr_ptr;
reg [2:0] count;
reg [7:0] data_out;

//output flags
always @(*) begin
    full_o  = (count == 3'd4);
    empty_o = (count == 3'd0);
    data_o  = data_out;
end


// computation block
    always @(posedge clk or posedge rst)
        begin
                if (rst)
                        begin
                                count   <= 3'd0;
                                rd_ptr  <= 2'd0;
                                wr_ptr  <= 2'd0;
                                data_out <= 8'd0;
                        end
                else
                    begin
                            if(rd_en == 0 && wr_en == 0)
                                begin
                                // no operations requested
                                end
                            else if(rd_en == 0 && wr_en == 1)
                                begin
                                    case(count)
                                        3'd0 : 
                                                begin
                                                    register[wr_ptr] <= data_in;
                                                    wr_ptr <= wr_ptr + 1'b1;
                                                    count <= count + 1'b1;
                                                end
                                        3'd4  :
                                                begin
                                                    // not allowed to write 
                                                end
                                        default   :
                                                begin
                                                    register[wr_ptr] <= data_in;
                                                    wr_ptr <= wr_ptr + 1'b1;
                                                    count <= count + 1'b1;
                                                end
                                    endcase
                                end
                            else if(rd_en == 1 && wr_en == 0)
                                begin
                                    case(count)
                                        3'd0 : 
                                                // nothing to read
                                        3'd4  :
                                                begin
                                                    data_out <= register[rd_ptr];
                                                    rd_ptr <= rd_ptr + 1'b1;
                                                    count <= count - 1'b1;
                                                end
                                        default   :
                                                begin
                                                    data_out <= register[rd_ptr];
                                                    rd_ptr <= rd_ptr + 1'b1;
                                                    count <= count - 1'b1;
                                                end
                                    endcase
                                end
                            else if(rd_en == 1 && wr_en == 1)
                                begin
                                    case(count)
                                        3'd0 : 
                                                begin
                                                    register[wr_ptr] <= data_in;
                                                    wr_ptr <= wr_ptr + 1'b1;
                                                    count <= count + 1'b1;
                                                end
                                        3'd4  :
                                                begin
                                                    data_out <= register[rd_ptr];
                                                    rd_ptr <= rd_ptr + 1'b1;
                                                    count <= count - 1'b1;
                                                end
                                        default   :
                                                begin
                                                    data_out <= register[rd_ptr];
                                                    rd_ptr <= rd_ptr + 1'b1 ;
                                                    register[wr_ptr] <= data_in;
                                                    wr_ptr <= wr_ptr + 1'b1;
                                                    //count does not change
                                                end
                                    endcase
                                end
                    end
        end

endmodule
