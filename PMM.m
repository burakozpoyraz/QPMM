%====================== PERMUTATION MATRIX MODULATION =====================
% This function performs a Monte Carlo simulation of the conventional 
% Permutation Matrix Modulation (PMM) scheme in a MIMO system. It evaluates 
% the bit error rate (BER) under various system and modulation parameters 
% by transmitting random data and permutation bits, applying SVD-based 
% precoding, and processing the received signal using one of three 
% detection strategies: JointMLD, LowComplex, or C-MLD. The simulation 
% runs for a specified number of iterations, counts total bit errors, and 
% returns the resulting BER and number of bit errors.
%
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
%               • Input-2: "LowComplex"
%               • Input-3: "C-MLD"
%
% OUTPUTS
% 1-) BER: Bit error rate
% 2-) num_bit_errors: Number of bit errors
%
% DEVELOPER: Burak Özpoyraz
%
% DATE: 19.08.2025
%==========================================================================

%% MAIN FUNCTION
function [BER, num_bit_errors] = PMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type)
    % Parameters///////////////////////////////////////////////////////////
    % Data Symbol Set (Constellation)======================================
    switch mod_type
        case "QAM"
            ss = qammod(0 : M-1, M, "Gray", "UnitAveragePower", true);
        case "PSK"
            ss = pskmod(0 : M-1, M, 0, "Gray");
    end
    % =====================================================================
    
    % Data and Permutation Bits============================================
    Nd = min(Nt, Nr); % Number of data symbols transmitted in a time slot
    m = log2(M); % Number of data bits corresponding to a single data symbol
    nd = Nd * m; % Number of data bits transmitted in a time slot
    np = floor(log2(factorial(Nd))); % Number of permutation bits transmitted in a time slot
    n_tot = nd + np; % Number of bits transmitted in a time slot
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

        perm_bits = randi([0, 1], [1, np]);
        P_index = Bin2Dec(perm_bits) + 1;
        P = P_set(:, :, P_index); % Permutation matrix
        % =================================================================
        
        % Channel & Noise==================================================
        H = (randn(Nr, Nt) + 1i * randn(Nr, Nt)) / sqrt(2);
        n = sqrt(N0 / 2) * (randn(Nr, 1) + 1i * randn(Nr, 1));
        % =================================================================

        % Precoding========================================================
        % SVD Decomposition~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        [U, A, V] = svd(H, "econ");
        Q = V * P * A;
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        % Power Normalization~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        beta = sqrt(P_tot / sum(sum(abs(Q).^2)));
        x = beta * Q * s;
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
        [detected_data_bits, detected_perm_bits] = Detector(y_tilde, beta, A, P_set, ss, detector_type);
        % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        % Error Calculation~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        num_bit_errors = num_bit_errors + sum(sum(xor(detected_data_bits, data_bits)));
        num_bit_errors = num_bit_errors + sum(xor(detected_perm_bits, perm_bits));
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
% 1-) Nd: Number of data symbols transmitted during a time slot
% 2-) np: Number of permutation bits

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
% 2-) beta: Power normalization factor
% 3-) A: Singular value matrix of the channel matrix
% 4-) P_set: Set of permutation matrices
% 5-) ss: Set of the amplitude-phase modulated complex symbols
% 6-) detector_type: Detector type
%               • Input-1: "JointMLD"
%               • Input-2: "LowComplex"
%               • Input-3: "C-MLD"

% OUTPUTS
% 1-) detected_data_bits: Detected data bits
% 2-) detected_perm_bits: Detected permutation bits
%==========================================================================
function [detected_data_bits, detected_perm_bits] = Detector(y_tilde, beta, A, P_set, ss, detector_type)
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
            num_s_comb = M^Nd;
            num_total_combination = Np * num_s_comb;
            metric_matrix = zeros(num_total_combination, Nd + 2);
            comb_index = 1;
            for i = 1 : Np
                P = P_set(:, :, i);
                for s_comb_index = 1 : num_s_comb
                    s_comb_str = dec2base(s_comb_index - 1, M, Nd);
                    s_comb = zeros(1, Nd);
                    for s_index = 1 : Nd
                        s_comb(s_index) = base2dec(s_comb_str(s_index), M) + 1;
                    end
                    s = transpose(ss(s_comb));
    
                    metric = norm(y_tilde - beta * A * P * A * s)^2;
                    metric_matrix(comb_index, 1) = i;
                    metric_matrix(comb_index, 2 : end - 1) = s_comb;
                    metric_matrix(comb_index, end) = metric;
                    comb_index = comb_index + 1;
                end
            end
            metric_array = metric_matrix(:, end);
            [~, min_ind] = min(metric_array);
    
            % Detection of the Permutation Bits============================
            i_hat = metric_matrix(min_ind, 1);
            detected_perm_bits = Dec2Bin(i_hat - 1, np);
            % =============================================================
    
            % Detection of the Data Bits===================================
            detected_data_bits = zeros(Nd, m);
            for k = 1 : Nd
                detected_data = metric_matrix(min_ind, k + 1);
                detected_data_bits(k, :) = Dec2Bin(detected_data - 1, m);
            end
            % =============================================================
        case "LowComplex"
            % Detection of the Permutation Bits============================
            metric_array = zeros(1, Np);
            for i = 1 : Np
                P = P_set(:, :, i);
                metric = transpose(P * A * ones(Nd, 1)) * abs(inv(A) * y_tilde);
                metric_array(i) = metric;
            end
            [~, i_hat] = max(metric_array);
            P_hat = P_set(:, :, i_hat);
            detected_perm_bits = Dec2Bin(i_hat - 1, np);
            % =============================================================
            
            % Detection of the Data Bits===================================
            x_tilde = transpose(P_hat) * y_tilde;
            detected_data_bits = zeros(Nd, m);
            for k = 1 : Nd
                xk_tilde = x_tilde(k);
                [~, min_ind] = min(abs(xk_tilde - ss).^2);
                detected_data_bits(k, :) = Dec2Bin(min_ind - 1, m);
            end
            % =============================================================
        case "C-MLD"
            metric_matrix = zeros(Np, Nd + 1);
            for i = 1 : Np
                P = P_set(:, :, i);
                R = A * P * A;
                perm = legal_perm_matrix(i, :);
                eps_bar_i = 0;
                for k = 1 : Nd
                    r_ik = R(perm(k), k);
                    yk_bar = y_tilde(perm(k));
                    [eps_bar_ik, min_ind] = min(abs(yk_bar - beta * r_ik * ss).^2);
                    eps_bar_i = eps_bar_i + eps_bar_ik;
                    metric_matrix(i, k) = min_ind;
                end
                metric_matrix(i, end) = eps_bar_i;
            end
            metric_array = metric_matrix(:, end);
            
            % Detection of the Permutation Bits============================
            [~, i_hat] = min(metric_array);
            detected_perm_bits = Dec2Bin(i_hat - 1, np);
            % =============================================================
            
            % Detection of the Data Bits===================================
            detected_s_index_array = metric_matrix(i_hat, 1 : Nd);
            detected_data_bits = zeros(Nd, m);
            for k = 1 : Nd
                detected_s_index = detected_s_index_array(k);
                detected_data_bits(k, :) = Dec2Bin(detected_s_index - 1, m);
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