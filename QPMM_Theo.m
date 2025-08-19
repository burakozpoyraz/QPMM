%=========== THEORETICAL QUADRATURE PERMUTATION MATRIX MODULATION==========
% Computes the theoretical bit error rate (BER) upper bound for the
% Quadrature Permutation Matrix Modulation (QPMM) scheme under specified
% system parameters. The analysis is performed by calculating the average
% pairwise error probabilities (PEPs) between all possible transmission
% combinations, including different symbol vectors and permutation matrix
% pairs. Each PEP is evaluated over a large number of random MIMO channel
% realizations using a closed-form bound, and the total BER is then
% estimated using union-bound techniques. This function serves as a
% benchmark to validate the accuracy and efficiency of the proposed QPMM
% scheme without performing full Monte Carlo simulations.
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
%
% OUTPUT
% - Pb: Theoretical bit error rate upper bound
%
% DEVELOPER: Burak Özpoyraz
%
% DATE: 19.08.2025
%==========================================================================

%% MAIN FUNCTION
function Pb = QPMM_Theo(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type)
    % Parameters///////////////////////////////////////////////////////////
    % Symbol Set (Constellation)===========================================
    if mod_type == "QAM"
        ss = qammod(0 : M-1, M, "Gray", "UnitAveragePower", true);
    elseif mod_type == "PSK"
        ss = pskmod(0 : M-1, M, pi / 4, "Gray");
    end
    % =====================================================================

    % Data and Permutation Bits============================================
    Nd = min(Nt, Nr); % Number of data symbols transmitted in a time slot
    m = log2(M); % Number of data bits corresponding to a single data symbol
    nd = Nd * m; % Number of data bits transmitted in a time slot
    np = floor(log2(factorial(Nd))); % Number of permutation bits corresponding 
                                     % to a single permutation matrix
    n_tot = nd + 2 * np; % Number of bits transmitted in a time slot
    % =====================================================================

    % Number of All Combinations===========================================
    Np = 2^np; % Number of legitimate permutation matrices
    N_tot = Np^2 * M^Nd;
    % =====================================================================

    % Noise Power==========================================================
    SNR = 10^(SNRdB / 10); % Signal-to-noise ratio (linear)
    N0 = (1 / n_tot) / SNR; % Noise power (W)
    % =====================================================================

    % Permutation Matrix, Data Symbol Vector, and Data Bit Vector Sets=====
    P_set = PermMatrixSet(Nd, np);
    [s_set, bit_set] = DataSymBitVecSet(Nd, ss);
    % =====================================================================

    % Theoretical Bit Error Rate Upper Bound///////////////////////////////
    Pb_sum = 0;
    Pb_matrix = zeros(Np^4 * M^(2*Nd), 7);
    Pb_iter_index = 1;
    for i = 1 : Np
        bi = Dec2Bin(i - 1, np);
        PI = P_set(:, :, i);
        for j = 1 : Np
            bj = Dec2Bin(j - 1, np);
            PQ = P_set(:, :, j);
            for k = 1 : M^Nd
                bs = bit_set(k, :);
                s = s_set(:, k);
                for i_bar = 1 : Np
                    bi_bar = Dec2Bin(i_bar - 1, np);
                    PI_bar = P_set(:, :, i_bar);
                    for j_bar = 1 : Np
                        bj_bar = Dec2Bin(j_bar - 1, np);
                        PQ_bar = P_set(:, :, j_bar);
                        for k_bar = 1 : M^Nd
                            bs_bar = bit_set(k_bar, :);
                            s_bar = s_set(:, k_bar);

                            % Number of Bit Errors=========================
                            b = [bi bj bs];
                            b_bar = [bi_bar bj_bar bs_bar];
                            e = sum(xor(b, b_bar));
                            % =============================================

                            % Pairwise Error Probability===================
                            CPEP_sum = 0;
                            for iter_index = 1 : num_iterations
                                H = (randn(Nr, Nt) + 1i * randn(Nr, Nt)) / sqrt(2);
                                [~, A, V] = svd(H, "econ");

                                ZI = V * PI * A;
                                ZQ = V * PQ * A;
                                betaI = sqrt((P_tot / 2) / sum(abs(ZI * real(s)).^2));
                                betaQ = sqrt((P_tot / 2) / sum(abs(ZQ * imag(s)).^2));
                                r = betaI * A * PI * A * real(s) +...
                               1i * betaQ * A * PQ * A * imag(s);

                                ZI_bar = V * PI_bar * A;
                                ZQ_bar = V * PQ_bar * A;
                                betaI_bar = sqrt((P_tot / 2) / sum(abs(ZI_bar * real(s_bar)).^2));
                                betaQ_bar = sqrt((P_tot / 2) / sum(abs(ZQ_bar * imag(s_bar)).^2));
                                r_bar = betaI_bar * A * PI_bar * A * real(s_bar) +...
                                   1i * betaQ_bar * A * PQ_bar * A * imag(s_bar);

                                zita = norm(r - r_bar, "fro")^2;
                                gamma = sqrt(zita / (2 * N0));

                                CPEP_sum = CPEP_sum + exp(-gamma^2 / 2) / 12 + exp(-2 * gamma^2 / 3) / 4;
                            end
                            PEP = CPEP_sum / num_iterations;
                            Pb_sum = Pb_sum + e * PEP / log2(N_tot);
                            Pb_matrix(Pb_iter_index, :) = [i, j, k, i_bar, j_bar, k_bar, M^Nd * e * PEP / log2(N_tot)];
                            Pb_iter_index = Pb_iter_index + 1;
                            % =============================================
                        end
                    end
                end
            end
        end
    end
    Pb = M^Nd * Pb_sum / N_tot;
    % /////////////////////////////////////////////////////////////////////
end

%% INNER FUNCTIONS (TOTAL OF 3)
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
% 2. Creating data symbol and bit vector sets

% ARGUMENTS
% 1-) Nd: Number of data symbols transmitted in a time slot
% 2-) ss: Set of the amplitude-phase modulated complex symbols

% OUTPUTS
% 1-) s_set: Set of data symbol vectors
% 2-) bit_set: Set of data bit vectors
%==========================================================================
function [s_set, bit_set] = DataSymBitVecSet(Nd, ss)
    M = length(ss);
    m = log2(M);
    num_s = M^Nd;
    index_set = transpose(dec2base(0 : num_s - 1, M, Nd) - '0');
    index_set(index_set > 9) = index_set(index_set > 9) - 7; 
    s_set = ss(index_set + 1);
    bit_set = reshape(reshape(Dec2Bin(index_set, log2(M))', [1, num_s * Nd * m]), [m * Nd, num_s])';
end
%==========================================================================


%==========================================================================
% 3. Conversion from decimal to binary

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