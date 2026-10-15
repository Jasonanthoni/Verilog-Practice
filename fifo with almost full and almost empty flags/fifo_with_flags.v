module fifo(
    input clk, rst, wr_en, rd_en,
    input [7:0]data_in,

    output reg[7:0] data_out,
    output reg almost_full, almost_empty, full, empty
);

reg [7:0] registers [0:3];
reg [1:0] rd_ptr, wr_ptr;
reg [2:0] count;
reg [7:0] data_output;

//flag output
    always @(*)
        begin
           data_out = data_output;
            if(count == 0)
                begin
                    empty = 1;
                    almost_empty = 1;
                    full = 0;
                    almost_full = 0;
                end
            else if (count <= 1)
                begin
                    empty = 0;
                    almost_empty = 1;
                    full = 0;
                    almost_full = 0;
                end
            else if(count == 4)
                begin
                    empty = 0;
                    almost_empty = 0;
                    full = 1;
                    almost_full = 1;
                end
            else if(count >= 3)
                begin
                    empty = 0;
                    almost_empty =0;
                    full = 0;
                    almost_full = 1;
                end
            else
                begin
                    empty = 0;
                    almost_empty = 0;
                    full = 0;
                    almost_full = 0;
                end
         
        end

    always @(posedge clk or posedge rst)
        begin
            if(rst)
                begin
                    count <= 3'd0;
                    rd_ptr <= 2'd0;
                    wr_ptr <= 2'd0;
                    data_output <= 8'd0;
                end
            else if(count == 0)
                begin
                    if(wr_en && rd_en)
                        begin
                            // allow only write
                            wr_ptr <= wr_ptr + 1'b1;
                            registers[wr_ptr] <= data_in ;
                            count <= count + 1;
                        end
                    else if(wr_en && ~rd_en)
                        begin
                            // allow only write
                            wr_ptr <= wr_ptr + 1'b1;
                            registers[wr_ptr] <= data_in ;
                            count <= count + 1;
                        end
                    else if(~wr_en && rd_en)
                        begin
                            // nothing allowed
                        end
                end
            else if(count >=1 && count <= 3)
                begin
                    if(wr_en && rd_en)
                        begin
                            // allow both read and write
                            data_output <= registers[rd_ptr];
                            rd_ptr <= rd_ptr + 1'b1;

                            registers[wr_ptr] <= data_in;
                            wr_ptr <= wr_ptr + 1;
                            //count remains the same
                        end
                    else if(wr_en && ~rd_en)
                        begin
                            registers[wr_ptr] <= data_in;
                            wr_ptr <= wr_ptr + 1;
                            count <= count + 1;
                        end
                    else if(~wr_en && rd_en)
                        begin
                            data_output <= registers[rd_ptr];
                            rd_ptr <= rd_ptr + 1'b1;
                            count <= count - 1;
                        end
                end
            else if(count == 4)
                begin
                    if(wr_en && rd_en)
                        begin
                            // allow only read
                            data_output <= registers[rd_ptr];
                            rd_ptr <= rd_ptr + 1;
                            count <= count - 1;
                        end
                    else if(wr_en && !rd_en)
                        begin
                            // write not allowed becuse it is full
                        end
                    else if(~wr_en && rd_en)
                        begin
                            // allow only read
                            data_output <= registers[rd_ptr];
                            rd_ptr <= rd_ptr + 1;
                            count <= count - 1;
                        end
                end
        end
endmodule
