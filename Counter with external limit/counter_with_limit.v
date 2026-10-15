module counter_with_limit(
    input clk, rst, enable, 
    input [7:0] limit,
    output reg [7:0] count
);


always @(posedge clk or posedge rst)
    begin
       if(rst)
            begin
                count <= 8'd0;
            end 
        else if(enable)
            begin
                if(count == limit)
                    begin
                        count <= 8'd0;
                    end
                else    
                    begin
                         count <= count + 1'b1;
                    end
            end
        else if(~enable)
            begin
                count <= count;
            end
    end

endmodule
