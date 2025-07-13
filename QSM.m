%==========================================================================
% SCHEME: Quadrature Spatial Modulation (QSM)
% ANALYSIS: Bit Error Rate Simulation of the QSM Scheme
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
%               • Input-2: "ZF"

% OUTPUTS
% 1-) BER: Bit error rate
% 2-) num_bit_errors: Number of bit errors
%==========================================================================

%% MAIN FUNCTION
function [BER, num_bit_errors] = QSM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type)
    % Parameters///////////////////////////////////////////////////////////
    % Data Symbol Set (Constellation)======================================
    switch mod_type
        case "QAM"
            ss = qammod(0 : M-1, M, "Gray", "UnitAveragePower", true);
        case "PSK"
            ss = pskmod(0 : M-1, M, pi / 4, "Gray");
    end
    % =====================================================================

    % Data and Spatial Bits================================================
    nd = log2(M); % Number of data bits for APM symbol selection
    ns = log2(Nt); % Number of spatial bits for antenna selection corresponding to each component
    n_tot = nd + 2 * ns; % Number of total bits transmitted in a time slot
    num_bits = num_iterations * n_tot; % Number of total bits transmitted during the Monte Carlo simulation
    % =====================================================================

    % Noise Power==========================================================
    SNR = 10^(SNRdB / 10); % Signal-to-noise ratio (linear)
    N0 = (1 / n_tot) / SNR; % Noise power (W)
    % =====================================================================
    % /////////////////////////////////////////////////////////////////////

    % Monte Carlo Simulation///////////////////////////////////////////////
    num_bit_errors = 0;
    for iter_index = 1 : num_iterations
        % Transmitter======================================================
        data_bits = randi([0, 1], [1, nd]);
        s = ss(Bin2Dec(data_bits) + 1); % Data symbol

        spatial_bits = randi([0, 1], [2, ns]);
        iI = Bin2Dec(spatial_bits(1, :)) + 1; % In-phase antenna index
        iQ = Bin2Dec(spatial_bits(2, :)) + 1; % Quadrature antenna index

        [xI, xQ] = deal(zeros(Nt, 1));
        xI(iI) = sqrt(P_tot) * real(s); % In-phase symbol array
        xQ(iQ) = sqrt(P_tot) * imag(s); % Quadrature symbol array
        x = xI + 1i * xQ; % Transmitted symbol array
        % =================================================================

        % Channel & Noise==================================================
        H = (randn(Nr, Nt) + 1i * randn(Nr, Nt)) / sqrt(2);
        n = sqrt(N0 / 2) * (randn(Nr, 1) + 1i * randn(Nr, 1));
        % =================================================================

        % Receiver=========================================================
        y = H * x + n;
        [detected_data_bits, detected_spatial_bits] = Detector(ss, H, y, Nt, M, P_tot, detector_type);

        num_data_bit_errors = sum(xor(data_bits, detected_data_bits));
        num_spatial_bit_errors = sum(xor(spatial_bits, detected_spatial_bits), "all");
        num_bit_errors = num_bit_errors + num_data_bit_errors + num_spatial_bit_errors;
        % =================================================================
    end
    BER = num_bit_errors / num_bits;
    % /////////////////////////////////////////////////////////////////////
end

%% INNER FUNCTIONS (TOTAL OF 3)
% =========================================================================
% 1. Conversion from binary to decimal

% ARGUMENT
% - bit_array: Bit array to be converted to decimal value

% OUTPUT
% - decimal_value: Corresponding decimal value of the bit array
% =========================================================================
function decimal_value = Bin2Dec(bit_array)
    size_bit_array = size(bit_array);
    num_bits = size_bit_array(2);
    decimal_value = bit_array * (2.^((num_bits - 1) : -1 : 0))';
end
% =========================================================================


% =========================================================================
% 2. Detecting the transmitted data and spatial bits

% ARGUMENTS
% 1-) ss: Data symbol set
% 2-) H: Rayleigh fading channel
% 3-) y: Received symbol array
% 4-) Nt: Number of transmit antennas
% 5-) M: Modulation level
% 6-) P_tot: Power of the signal transmitted in a time slot (W)
% 7-) detector_type: Detector type
%               • Input-1: "JointMLD"
%               • Input-2: "ZF"

% OUTPUTS
% 1-) detected_data_bits: Detected data bits
% 2-) detected_spatial_bits: Detected spatial bits
% =========================================================================
function [detected_data_bits, detected_spatial_bits] = Detector(ss, H, y, Nt, M, P_tot, detector_type)
    nd = log2(M);
    ns = log2(Nt);

    error_matrix = zeros(Nt^2 * M, 4);
    switch detector_type
        case "JointMLD"
            comb_index = 1;
            for iI = 1 : Nt
                hiI = H(:, iI);
                for iQ = 1 : Nt
                    hiQ = H(:, iQ);
                    for k = 1 : M
                        sk = ss(k);
                        skI = real(sk);
                        skQ = imag(sk);
        
                        error_matrix(comb_index, 1) = iI;
                        error_matrix(comb_index, 2) = iQ;
                        error_matrix(comb_index, 3) = k;
        
                        error_value = norm(y - sqrt(P_tot) * hiI * skI - 1i * sqrt(P_tot) * hiQ * skQ, "fro")^2;
                        error_matrix(comb_index, 4) = error_value;
                        comb_index = comb_index + 1;
                    end
                end
            end
        case "ZF"
            x_hat = (H' * H) \ (H' * y);
            comb_index = 1;
            for iI = 1 : Nt
                for iQ = 1 : Nt
                    for k = 1 : M
                        sk = ss(k);
                        [xI, xQ] = deal(zeros(Nt, 1));
                        xI(iI) = sqrt(P_tot) * real(sk);
                        xQ(iQ) = sqrt(P_tot) * imag(sk);
                        x = xI + 1i * xQ;
        
                        error_matrix(comb_index, 1) = iI;
                        error_matrix(comb_index, 2) = iQ;
                        error_matrix(comb_index, 3) = k;
        
                        error_value = norm(x_hat - x, "fro")^2;
                        error_matrix(comb_index, 4) = error_value;
                        comb_index = comb_index + 1;
                    end
                end
            end
    end
    
    error_array = error_matrix(:, end);
    [~, min_error_index] = min(error_array);

    detected_iI = error_matrix(min_error_index, 1);
    detected_iQ = error_matrix(min_error_index, 2);
    detected_i_array = [detected_iI; detected_iQ];
    detected_spatial_bits = Dec2Bin(detected_i_array - 1, ns);

    detected_s_index = error_matrix(min_error_index, 3);
    detected_data_bits = Dec2Bin(detected_s_index - 1, nd);
end
% =========================================================================


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