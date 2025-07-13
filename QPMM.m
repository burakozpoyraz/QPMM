%==========================================================================
% SCHEME: Quadrature Permutation Matrix Modulation (QPMM)
% ANALYSIS: Bit Error Rate Simulation of the QPMM Scheme
% AFFILIATION: Koç University - Communications and Research Laboratory
% DEVELOPER: Burak Özpoyraz

% ARGUMENTS
% 1-) num_iterations: Number of iterations for Monte Carlo simulation
% 2-) Nt: Number of transmit antennas
% 3-) Nr: Number of receive antennas
% 4-) M: Modulation level
% 5-) P_tot: Power of the signal transmitted in a time slot (W)
% 6-) SNRdB: Signal-to-noise ratio (dB)
% 7-) mod_type: Modulation type
%               • Input-1: "PSK"
%               • Input-2: "QAM"
% 8-) detector_type: Detector type
%               • Input-1: "JointMLD"
%               • Input-2: "C-MLD"

% OUTPUTS
% 1-) BER: Bit error rate
% 2-) num_bit_errors: Number of bit errors
%==========================================================================

%% MAIN FUNCTION
function [BER, num_bit_errors] = QPMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type)
    % Parameters///////////////////////////////////////////////////////////
    % Data Symbol Set (Constellation)======================================
    switch mod_type
        case "QAM"
            ss = qammod(0 : M-1, M, "Gray", "UnitAveragePower", true);
        case "PSK"
            ss = pskmod(0 : M-1, M, pi / 4, "Gray");
    end
    % =====================================================================
    
    % Data and Permutation Bits============================================
    Nd = min(Nt, Nr); % Number of data symbols transmitted in a time slot
    m = log2(M); % Number of data bits corresponding to a single data symbol
    nd = Nd * m; % Number of data bits transmitted in a time slot
    np = floor(log2(factorial(Nd))); % Number of permutation bits corresponding to a single permutation matrix
    n_tot = nd + 2 * np; % Number of bits transmitted in a time slot
    num_total_bits = num_iterations * n_tot; % Number of total bits transmitted during the Monte Carlo simulation
    % =====================================================================

    % Noise Power==========================================================
    SNR = 10^(SNRdB / 10); % Signal-to-noise ratio (linear)
    N0 = (1 / n_tot) / SNR; % Noise power (W)
    % =====================================================================
    
    % Permutation Matrix Set===============================================
    P_set = PermMatrixSet(Nd, np);
    % =====================================================================
    % /////////////////////////////////////////////////////////////////////
    
    % Monte Carlo Simulation///////////////////////////////////////////////
    num_bit_errors = 0;
    for iter_index = 1 : num_iterations
        % Transmitter======================================================
        data_bits = randi([0, 1], [Nd, m]);
        s = transpose(ss(Bin2Dec(data_bits) + 1)); % Data symbol array
        
        perm_bits = randi([0, 1], [2, np]);
        P_index_array = Bin2Dec(perm_bits) + 1;
        PI = P_set(:, :, P_index_array(1)); % In-phase permutation matrix
        PQ = P_set(:, :, P_index_array(2)); % Quadrature permutation matrix
        % =================================================================
        
        % Channel & Noise==================================================
        H = (randn(Nr, Nt) + 1i * randn(Nr, Nt)) / sqrt(2);
        n = sqrt(N0 / 2) * (randn(Nr, 1) + 1i * randn(Nr, 1));
        % =================================================================
        
        % Precoding========================================================
        % SVD Decomposition~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        [U, A, V] = svd(H, "econ");
        ZI = V * PI * A;
        ZQ = V * PQ * A;
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        % Power Normalization~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        betaI = sqrt((P_tot / 2) / sum(abs(ZI * real(s)).^2));
        betaQ = sqrt((P_tot / 2) / sum(abs(ZQ * imag(s)).^2));
        x = betaI * ZI * real(s) + 1i * betaQ * ZQ * imag(s);
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % =================================================================
        
        % Receiver=========================================================
        y = H * x + n;
        % =================================================================
        
        % Detector=========================================================
        % Post-Processing~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        y_tilde = U' * y;
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        % Detection of Data and Permutation Bits~~~~~~~~~~~~~~~~~~~~~~~~~~~
        [detected_data_bits, detected_perm_bits] = Detector(y_tilde, betaI, betaQ, A, P_set, ss, detector_type);
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        % Error Calculation~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        num_bit_errors = num_bit_errors + sum(sum(xor(detected_data_bits, data_bits)));
        num_bit_errors = num_bit_errors + sum(sum(xor(detected_perm_bits, perm_bits)));
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % =================================================================
    end
    BER = num_bit_errors / num_total_bits;
    % /////////////////////////////////////////////////////////////////////
end

%% INNER FUNCTIONS (TOTAL OF 4)
%==========================================================================
% 1. Creating permutation matrix set

% ARGUMENTS
% 1-) Nd: Number of data symbols transmitted in a time slot
% 2-) np: Number of permutation bits corresponding to a single permutation
%         matrix

% OUTPUT
% - P_set: Set of permutation matrices
%==========================================================================
function P_set = PermMatrixSet(Nd, np)
    num_P = 2^np;
    all_perm_matrix = perms(Nd : -1 : 1);
    legal_perm_matrix = all_perm_matrix(1 : num_P, :);
    P_set = zeros(Nd, Nd, num_P);
    for P_index = 1 : num_P
        perm = legal_perm_matrix(P_index, :);
        P_rows = 1 : Nd;
        P_cols = perm;
        P_size = [Nd, Nd];
        linear_ind_array = sub2ind(P_size, P_rows, P_cols);
        P = zeros(Nd, Nd);
        P(linear_ind_array) = 1;
        P_set(:, :, P_index) = transpose(P);
    end
end
%==========================================================================


%==========================================================================
% 2. Conversion from binary to decimal

% ARGUMENT
% - bit_array: Bit array to be converted to decimal value

% OUTPUT
% - decimal_value: Corresponding decimal value of the bit array
%==========================================================================
function decimal_value = Bin2Dec(bit_array)
    size_bit_array = size(bit_array);
    num_bits = size_bit_array(2);
    decimal_value = bit_array * (2.^((num_bits - 1) : -1 : 0))';
end
%==========================================================================


%==========================================================================
% 3. Detector

% ARGUMENTS
% 1-) y_tilde: Received signal vector after post-processing
% 2-) betaI: Power normalization factor of the in-phase component array
% 3-) betaQ: Power normalization factor of the quadrature component array
% 4-) A: Singular value matrix of the channel matrix
% 5-) P_set: Set of permutation matrices
% 6-) ss: Set of the amplitude-phase modulated complex symbols
% 7-) detector_type: Detector type
%               • Input-1: "JointMLD"
%               • Input-2: "C-MLD"

% OUTPUTS
% 1-) detected_data_bits: Detected data bits
% 2-) detected_perm_bits: Detected permutation bits
%==========================================================================
function [detected_data_bits, detected_perm_bits] = Detector(y_tilde, betaI, betaQ, A, P_set, ss, detector_type)
    % Parameters///////////////////////////////////////////////////////////
    Nd = size(P_set, 1);
    Np = size(P_set, 3);
    np = log2(Np);
    all_perm_matrix = perms(Nd : -1 : 1);
    legal_perm_matrix = all_perm_matrix(1 : Np, :);
    
    M = length(ss);
    m = log2(M);
    % /////////////////////////////////////////////////////////////////////
    
    % Detector/////////////////////////////////////////////////////////////
    switch detector_type
        case "JointMLD"
            num_P_comb = Np^2;
            num_s_comb = M^Nd;
            num_total_combination = num_P_comb * num_s_comb;
            metric_matrix = zeros(num_total_combination, Nd + 3);
            comb_index = 1;
            for i = 1 : Np
                PI = P_set(:, :, i);
                for j = 1 : Np
                    PQ = P_set(:, :, j);
                    for s_comb_index = 1 : num_s_comb
                        s_comb_str = dec2base(s_comb_index - 1, M, Nd);
                        s_comb = zeros(1, Nd);
                        for s_index = 1 : Nd
                            s_comb(s_index) = base2dec(s_comb_str(s_index), M) + 1;
                        end
                        s = transpose(ss(s_comb));
                        
                        metric = norm(y_tilde - betaI * A * PI * A * real(s) - 1i * betaQ * A * PQ * A * imag(s))^2;
                        metric_matrix(comb_index, 1) = i;
                        metric_matrix(comb_index, 2) = j;
                        metric_matrix(comb_index, 3 : end - 1) = s_comb;
                        metric_matrix(comb_index, end) = metric;
                        comb_index = comb_index + 1;
                    end
                end
            end
            metric_array = metric_matrix(:, end);
            [~, min_ind] = min(metric_array);
    
            % Detection of the Permutation Bits============================
            detected_perm_bits = zeros(2, np);
            
            i_hat = metric_matrix(min_ind, 1);
            detected_perm_bits(1, :) = Dec2Bin(i_hat - 1, np);
            
            j_hat = metric_matrix(min_ind, 2);
            detected_perm_bits(2, :) = Dec2Bin(j_hat - 1, np);
            % =============================================================
    
            % Detection of the Data Bits===================================
            detected_data_bits = zeros(Nd, m);
            for k = 1 : Nd
                detected_data = metric_matrix(min_ind, k + 2);
                detected_data_bits(k, :) = Dec2Bin(detected_data - 1, m);
            end
            % =============================================================
        case "C-MLD"
            num_P_comb = Np^2;
            metric_matrix = zeros(num_P_comb, Nd + 3);
            comb_index = 1;
            for i = 1 : Np
                PI = P_set(:, :, i);
                permI = legal_perm_matrix(i, :);
                for j = 1 : Np
                    PQ = P_set(:, :, j);
                    permQ = legal_perm_matrix(j, :);
                    eps_bar_ij = 0;
                    for k = 1 : Nd
                        RI = A * PI * A;
                        rI_ik = RI(permI(k), k);
                        yk_bar_I = real(y_tilde(permI(k)));
    
                        RQ = A * PQ * A;
                        rQ_jk = RQ(permQ(k), k);
                        yk_bar_Q = imag(y_tilde(permQ(k)));
                        yk_bar = yk_bar_I + 1i * yk_bar_Q;
    
                        diff_val = yk_bar - betaI * rI_ik * real(ss) - 1i * betaQ * rQ_jk * imag(ss);
                        [eps_ijk, min_data_ind] = min(abs(diff_val).^2);
    
                        eps_bar_ij = eps_bar_ij + eps_ijk;
    
                        metric_matrix(comb_index, 1) = i;
                        metric_matrix(comb_index, 2) = j;
                        metric_matrix(comb_index, k + 2) = min_data_ind;
                    end
                    metric_matrix(comb_index, end) = eps_bar_ij;
                    comb_index = comb_index + 1;
                end
            end
            metric_array = metric_matrix(:, end);
            [~, min_ind] = min(metric_array);
    
            % Detection of the Permutation Bits============================
            detected_perm_bits = zeros(2, np);
            
            i_hat = metric_matrix(min_ind, 1);
            detected_perm_bits(1, :) = Dec2Bin(i_hat - 1, np);
    
            j_hat = metric_matrix(min_ind, 2);
            detected_perm_bits(2, :) = Dec2Bin(j_hat - 1, np);
            % =============================================================
    
            % Detection of the Data Bits===================================
            detected_data_bits = zeros(Nd, m);
            for k = 1 : Nd
                detected_data = metric_matrix(min_ind, k + 2);
                detected_data_bits(k, :) = Dec2Bin(detected_data - 1, m);
            end
            % =============================================================
    end
    % /////////////////////////////////////////////////////////////////////
end
%==========================================================================


%==========================================================================
% 4. Conversion from decimal to binary

% ARGUMENTS
% 1-) decimal: Decimal value to be converted to bit array
% 2-) n: Number of bits in the resulting bit array

% OUTPUT
% - bit_array: Corresponding bit array of the decimal value
%==========================================================================
function bit_array = Dec2Bin(decimal, n)
    decreasing_pow_array = (n - 1 : -1 : 0);
    bit_array = zeros(length(decimal), n);
    for bit_index = 1 : n
        pow_val = decreasing_pow_array(bit_index);
        comparison = (decimal / 2^pow_val) >= 1;
        bit_array(comparison == 0, bit_index) = 0;
        bit_array(comparison == 1, bit_index) = 1;
        decimal(comparison == 1) = decimal(comparison == 1) - 2^pow_val;
    end
end
%==========================================================================