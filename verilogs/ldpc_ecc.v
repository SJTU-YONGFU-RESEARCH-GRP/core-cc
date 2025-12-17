// LDPC ECC Module - Real Implementation
// Matches Python LDPCECC (Hard Decision Bit-Flipping)
// N=16, K=8
/* verilator lint_off WIDTHTRUNC */
/* verilator lint_off WIDTHEXPAND */
module ldpc_ecc #(
    parameter DATA_WIDTH = 8
) (
    input  wire                    clk,
    input  wire                    rst_n,
    input  wire                    encode_en,
    input  wire                    decode_en,
    input  wire [DATA_WIDTH-1:0]  data_in,
    input  wire [15:0]            codeword_in,
    output reg  [15:0]            codeword_out,
    output reg  [DATA_WIDTH-1:0]  data_out,
    output reg                     error_detected,
    output reg                     error_corrected,
    output reg                     valid_out
);

    // H Matrix (8x16) Structure from Python:
    // Rows 0-7 are Parity Checks.
    // Cols 0-7 are Parity Part (since we use [P|I] form for H? No, Python H has I at cols 8-15)
    // Wait, Python: self.P = self.H[:, 0:8]. self.G = [I | P.T].
    // So Encoder inputs u (8 bits). 
    // x = u * G = u * [I | P.T] = [u | u * P.T]
    // So first 8 bits of codeword are Data (u). Last 8 bits are Parity.
    // Verilog usually expects Data then Parity or Parity then Data?
    // Let's stick to Python: lower indices = Data?
    // Python encode:
    // for i, bit in enumerate(x): codeword |= (bit << i)
    // x = [u0, u1, ..., u7, p0, ..., p7]
    // So codeword = {parity, data} if bit 0 is LSB?
    // x[0] is LSB. x[0] is u[0].
    // So codeword LSB is Data. MSB is Parity.
    // codeword_out = {parity, data}
    
    // Parity Calculation (P.T * u)
    // P is lower-left 8x8 of H? No, P is cols 0-7 of H (8x8).
    // H = [P | I].
    // Syndrome s = H * r.
    // r = [p, u]? No. Standard systematic is G=[I|P]. r=[u, p]. H=[-P.T | I].
    // Python code: H = [P | I].
    // If H = [P | I], and we want H*r^T = 0.
    // [P | I] * [u_part, p_part]^T = P*u + I*p = 0 => p = P*u.
    // So p bits are P * u.
    // r vector constructed in Python: x = [u | u*G_parity].
    // If G = [I | P^T], then x = [u | u*P^T].
    // Check H*x^T = [P | I] * [u | u*P^T]^T = P*u + I*(u*P^T) = P*u + P^T*u? 
    // This requires P = P^T (Symmetric).
    // Is my Python P symmetric?
    // Row 0: 11110000. Col 0: 11110001. No.
    // Python code said: G = [I | P.T].
    // H*x^T = [P | I] * [u | (P.T*u)]^T ?? No.
    // If G = [I | A], then H = [-A.T | I].
    // My Python: H = [P | I]. So A.T must be P. So A = P.T.
    // So G = [I | P.T].
    // x = [u, p]. p = u * P.T.
    // In Verilog: p[j] = sum(u[i] * P.T[i,j]) = sum(u[i] * P[j,i])
    // So p[j] is dot product of u with Row j of P.
    
    // Hardcoded P matrix (8x8) from Python H[:, 0:8]
    // Row 0: 11110000
    // Row 1: 11001100
    // Row 2: 10101010
    // Row 3: 10011001
    // Row 4: 01100110
    // Row 5: 01010101
    // Row 6: 00110011
    // Row 7: 11101000
    
    wire [7:0] u;
    assign u = data_in; // u[0] is LSB
    
    wire [7:0] p;
    assign p[0] = u[0]^u[1]^u[2]^u[3];             // Row 0 of P
    assign p[1] = u[0]^u[1]^u[4]^u[5];             // Row 1
    assign p[2] = u[0]^u[2]^u[4]^u[6];             // Row 2
    assign p[3] = u[0]^u[3]^u[4]^u[7];             // Row 3
    assign p[4] = u[1]^u[2]^u[5]^u[6];             // Row 4
    assign p[5] = u[1]^u[3]^u[5]^u[7];             // Row 5
    assign p[6] = u[2]^u[3]^u[6]^u[7];             // Row 6
    assign p[7] = u[0]^u[1]^u[2]^u[4]^u[6];        // Row 7
    
    wire [15:0] encoded_cw;
    assign encoded_cw = {p, u}; // p is MSB byte, u is LSB byte
    
    // Decoder FSM
    localparam IDLE = 0;
    localparam CALC_SYNDROME = 1;
    localparam CHECK_SYNDROME = 2;
    localparam VOTE = 3;
    localparam FLIP = 4;
    localparam FINISH = 5;
    
    reg [2:0] state;
    reg [3:0] iter_count;
    reg [15:0] current_cw;
    reg [7:0] syndrome;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            codeword_out <= 16'b0;
            data_out <= 8'b0;
            valid_out <= 0;
            error_detected <= 0;
            error_corrected <= 0;
            iter_count <= 0;
            current_cw <= 0;
            syndrome <= 0;
        end else begin
            case (state)
                IDLE: begin
                    valid_out <= 0;
                    if (encode_en) begin
                        codeword_out <= encoded_cw;
                        valid_out <= 1;
                    end else if (decode_en) begin
                        current_cw <= codeword_in;
                        iter_count <= 0;
                        state <= CALC_SYNDROME;
                        error_detected <= 0;
                        error_corrected <= 0;
                    end
                end
                
                CALC_SYNDROME: begin
                    // Calculate Syndrome s = H * current_cw
                    // H = [P | I]
                    // s = P*u_curr + I*p_curr = P*current_cw[7:0] + current_cw[15:8]
                    // Wait, current_cw[7:0] is 'u' part (cols 0-7 of G -> but cols 8-15 of H?)
                    // In Python G = [I | P.T]. x = [u, p]. 
                    // u is first 8 bits (LSB in integer). p is last 8 bits.
                    // H = [P | I]. This implies H multiplies [p, u]^T = 0?
                    // [P|I] * [p over u] = P*p + u = 0? No.
                    // If G=[I|P.T], generated vector is [u, p].
                    // We need H such that H*[u, p]^T = 0.
                    // [A | B] * [u, p]^T = A*u + B*p = 0.
                    // If B=I, then p = A*u. (This matches G=[I|A^T] generation p=u*A^T? No)
                    // Let's re-verify Python H logic.
                    // Python: G = [I | P.T]. x = [u, p].
                    // Python Syndrome: s = H * x. H = [P | I].
                    // s = P*u + I*p = P*u + p.
                    // So we need p = P*u for s=0.
                    // But G generation used G = [I | P.T] => p = u * P.T = (P * u^T)^T.
                    // So vector p = vector (P*u).
                    // So yes, s = P*u + p = P*u + P*u = 0 (mod 2). 
                    // Correct.
                    // So Syndrome s[i] = (Row i of P dot u) XOR p[i].
                    
                    syndrome[0] <= (current_cw[0]^current_cw[1]^current_cw[2]^current_cw[3]) ^ current_cw[8];
                    syndrome[1] <= (current_cw[0]^current_cw[1]^current_cw[4]^current_cw[5]) ^ current_cw[9];
                    syndrome[2] <= (current_cw[0]^current_cw[2]^current_cw[4]^current_cw[6]) ^ current_cw[10];
                    syndrome[3] <= (current_cw[0]^current_cw[3]^current_cw[4]^current_cw[7]) ^ current_cw[11];
                    syndrome[4] <= (current_cw[1]^current_cw[2]^current_cw[5]^current_cw[6]) ^ current_cw[12];
                    syndrome[5] <= (current_cw[1]^current_cw[3]^current_cw[5]^current_cw[7]) ^ current_cw[13];
                    syndrome[6] <= (current_cw[2]^current_cw[3]^current_cw[6]^current_cw[7]) ^ current_cw[14];
                    syndrome[7] <= (current_cw[0]^current_cw[1]^current_cw[2]^current_cw[4]^current_cw[6]) ^ current_cw[15];
                    
                    state <= CHECK_SYNDROME;
                end
                
                CHECK_SYNDROME: begin
                    if (syndrome == 0) begin
                        // Converged / Valid
                        data_out <= current_cw[7:0];
                        // Corrected if different from input
                        if (current_cw != codeword_in) error_corrected <= 1;
                        state <= FINISH;
                    end else if (iter_count == 10) begin
                        // Max iterations reached, fail
                        data_out <= current_cw[7:0];
                        error_detected <= 1; 
                        state <= FINISH;
                    end else begin
                        state <= VOTE;
                    end
                end
                
                VOTE: begin
                    // Simplified Bit Flipping: Flip bit participating in most failed checks.
                    // Since implementing a full voting network is large, let's use a simpler heuristic for HW size?
                    // Or implement full voting. It's only 16 bits * 8 checks.
                    // Variable Node i votes = sum(syndrome[j]) for all j where H[j,i]=1.
                    
                    // Implementation of Vote Calculation (Combinational) could be done here if extracted function.
                    // We'll proceed to FLIP state directly or do it here. 
                    // Let's do it in FLIP state using wire definitions (see below module).
                    state <= FLIP;
                end
                
                FLIP: begin
                    // Flip logic will be comb logic determined by current syndrome
                    // We register the flip here.
                    current_cw <= next_cw_flipped;
                    iter_count <= iter_count + 1;
                    state <= CALC_SYNDROME;
                end
                
                FINISH: begin
                    valid_out <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

    // Combinational Voting Logic for FLIP state
    reg [3:0] votes [15:0];
    reg [3:0] max_vote;
    reg [15:0] flip_mask;
    reg [15:0] next_cw_flipped;
    
    integer i, j;
    always @(*) begin
        max_vote = 0;
        flip_mask = 0;
        next_cw_flipped = current_cw;
        
        // Calculate Votes
        // U bits (0-7) - involved in P matrix
        // P bits (8-15) - involved in I matrix (only 1 check each)
        
        // U[0] in checks 0,1,2,3,7
        votes[0] = syndrome[0] + syndrome[1] + syndrome[2] + syndrome[3] + syndrome[7];
        // U[1] in checks 0,1,4,5,7
        votes[1] = syndrome[0] + syndrome[1] + syndrome[4] + syndrome[5] + syndrome[7];
        // U[2] in checks 0,2,4,6,7
        votes[2] = syndrome[0] + syndrome[2] + syndrome[4] + syndrome[6] + syndrome[7];
        // U[3] in checks 0,3,5,6
        votes[3] = syndrome[0] + syndrome[3] + syndrome[5] + syndrome[6];
        // U[4] in checks 1,2,3,7
        votes[4] = syndrome[1] + syndrome[2] + syndrome[3] + syndrome[7];
        // U[5] in checks 1,4,5
        votes[5] = syndrome[1] + syndrome[4] + syndrome[5];
        // U[6] in checks 2,4,6,7
        votes[6] = syndrome[2] + syndrome[4] + syndrome[6] + syndrome[7];
        // U[7] in checks 3,5,6
        votes[7] = syndrome[3] + syndrome[5] + syndrome[6];
        
        // P bits (8-15) - P[k] only in check k
        votes[8] = syndrome[0];
        votes[9] = syndrome[1];
        votes[10] = syndrome[2];
        votes[11] = syndrome[3];
        votes[12] = syndrome[4];
        votes[13] = syndrome[5];
        votes[14] = syndrome[6];
        votes[15] = syndrome[7];
        
        // Find Max Vote
        for (i=0; i<16; i=i+1) begin
            if (votes[i] > max_vote) max_vote = votes[i];
        end
        
        // Determine Flip Mask (Threshold strategy: must be > 0)
        if (max_vote > 0) begin
            for (j=0; j<16; j=j+1) begin
                if (votes[j] == max_vote) flip_mask[j] = 1;
            end
        end
        
        next_cw_flipped = current_cw ^ flip_mask;
    end

endmodule
/* verilator lint_on WIDTHTRUNC */
/* verilator lint_on WIDTHEXPAND */