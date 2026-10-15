*Two-Request Round-Robin Arbiter*

Design a two-request arbiter with these ports:
- Inputs: clk, active-high asynchronous rst, req[1:0]
- Output: grant[1:0]
Requirements:
1. If only one requester is active, grant it.
2. If both requesters are active, alternate priority between them.
3. If neither request is active, grant = 2'b00.
4. After reset, requester 0 has priority.
5. A grant should be asserted for the currently selected requester; priority should advance after a successful grant.
