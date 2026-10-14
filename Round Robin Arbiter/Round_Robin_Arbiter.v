module round_robin_arbiter(
    input clk, rst,
    input [3:0] request,
    output reg [3:0] grant
);

reg [1:0] priority_ptr , next_priority ;

// states
    always @(posedge clk or posedge rst)
        begin
           if(rst)
                begin
                    priority_ptr <= 2'b00;
                end 
            else
                begin
                    priority_ptr <= next_priority;
                end
        end

//grant logic
    always @(*)
        begin
            case (priority_ptr)
                2'b00 :
                        begin
                            if     (request[0] == 1 )
                                begin
                                    grant = 4'b0001;
                                    next_priority = 2'b01;
                                end
                            else if(request[1] == 1)
                                begin
                                    grant = 4'b0010;
                                    next_priority = 2'b10;
                                end
                            else if(request[2] == 1)
                                begin
                                    grant = 4'b0100;
                                    next_priority = 2'b11;
                                end
                            else if(request[3] == 1)
                                begin
                                    grant = 4'b1000;
                                    next_priority = 2'b00;
                                end
                            else    
                                begin
                                    grant = 4'b0000;
                                    next_priority = 2'b00;
                                end
                        end
                2'b01 :
                        begin
                            if     (request[1] == 1 )
                                begin
                                    grant = 4'b0010;
                                    next_priority = 2'b10;
                                end
                            else if(request[2] == 1)
                                begin
                                    grant = 4'b0100;
                                    next_priority = 2'b11;
                                end
                            else if(request[3] == 1)
                                begin
                                    grant = 4'b1000;
                                    next_priority = 2'b00;
                                end
                            else if(request[0] == 1)
                                begin
                                    grant = 4'b0001;
                                    next_priority = 2'b01;
                                end
                            else    
                                begin
                                    grant = 4'b0000;
                                    next_priority = 2'b01;
                                end 
                        end
                2'b10 :
                        begin
                            if     (request[2] == 1 )
                                begin
                                    grant = 4'b0100;
                                    next_priority = 2'b11;
                                end
                            else if(request[3] == 1)
                                begin
                                    grant = 4'b1000;
                                    next_priority = 2'b00;
                                end
                            else if(request[0] == 1)
                                begin
                                    grant = 4'b0001;
                                    next_priority = 2'b01;
                                end
                            else if(request[1] == 1)
                                begin
                                    grant = 4'b0010;
                                    next_priority = 2'b10;
                                end
                            else    
                                begin
                                    grant = 4'b0000;
                                    next_priority = 2'b10;
                                end 
                        end
                2'b11 :
                        begin
                            if(request[3] == 1)
                                begin
                                    grant = 4'b1000;
                                    next_priority = 2'b00;
                                end
                            else if(request[0] == 1)
                                begin
                                    grant = 4'b0001;
                                    next_priority = 2'b01;
                                end
                            else if(request[1] == 1)
                                begin
                                    grant = 4'b0010;
                                    next_priority = 2'b10;
                                end
                            else if (request[2] == 1 )
                                begin
                                    grant = 4'b0100;
                                    next_priority = 2'b11;
                                end
                            else    
                                begin
                                    grant = 4'b0000;
                                    next_priority = 2'b11;
                                end 
                        end
                default:
                        begin
                            grant = 4'b0000;           //nobody gets the grant
                            next_priority = 2'b00;     //next priority is given to the first requester
                        end
            endcase
        end

endmodule
