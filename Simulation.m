%==========================================================================
% PAPER: Quadrature Permutation Matrix Modulation
% AUTHORS: Burak Özpoyraz, Atalay Aydın, Ertuğrul Başar
% ANALYSIS: Simulation Algorithm of the Paper
% AFFILIATION: Koç University - Communications and Research Laboratory
% DEVELOPER: Burak Özpoyraz
%==========================================================================

%% SIMULATION ALGORITHM
clear
clc

% Simulation Parameters////////////////////////////////////////////////////
data_save = true;
data_name = "DataName";
data_path = "UserData/Values/" + data_name + ".mat";

scheme = "QPMM";
num_iterations = 1e4;
Nt = 2;
Nr = 2;
M = 2;
P_tot = Nt;
SNRdB_array = 0 : 3 : 30;
mod_type = "PSK";
detector_type = "C-MLD"; % Not necessary for theoretical QPMM analysis
% /////////////////////////////////////////////////////////////////////////

% Simulation///////////////////////////////////////////////////////////////
[BER_array, num_bit_error_array] = RunSimulation(scheme, num_iterations, Nt, Nr, M, P_tot, SNRdB_array, mod_type, detector_type);
% /////////////////////////////////////////////////////////////////////////

% Data Save////////////////////////////////////////////////////////////////
if data_save
    sim_data_st.scheme = scheme;
    sim_data_st.Nt = Nt;
    sim_data_st.Nr = Nr;
    sim_data_st.M = M;
    sim_data_st.mod_type = mod_type;
    sim_data_st.SNRdB_array = SNRdB_array;
    sim_data_st.BER_array = BER_array;
    sim_data_st.num_bit_error_array = num_bit_error_array;
    save(data_path, "sim_data_st");
end
% /////////////////////////////////////////////////////////////////////////

%% INNER FUNCTIONS (TOTAL OF 1)
%==========================================================================
%==========================================================================
function varargout = RunSimulation(scheme, num_iterations, Nt, Nr, M, P_tot, SNRdB_array, mod_type, varargin)
    % Input Arguments Error Check//////////////////////////////////////////
    num_varargin = length(varargin);

    % ERROR CHECK DESCRIPTION
    if scheme ~= "QPMM Theo" && num_varargin == 0
        error(sprintf("Too few input arguments!!!\n" + ...
            "The detector_type is required for the Monte Carlo simulation of " + scheme + "."));
    end

    % ERROR CHECK DESCRIPTION
    if scheme == "QPMM Theo" && num_varargin == 1
        error(sprintf("Too many input arguments!!!\n" + ...
            "The detector_type is not required for the theoretical analysis of QPMM."));
    end

    % ERROR CHECK DESCRIPTION
    detector_type = varargin{1};
    detector_error_QPMM = scheme == "QPMM" && detector_type ~= "JointMLD" && detector_type ~= "C-MLD";
    detector_error_PMM = scheme == "PMM" && detector_type ~= "JointMLD" && detector_type ~= "LowComplex" && detector_type ~= "C-MLD";
    detector_error_SM_QSM = (scheme == "SM" || scheme == "QSM") && (detector_type ~= "JointMLD" && detector_type ~= "ZF");
    if detector_error_QPMM || detector_error_PMM || detector_error_SM_QSM
        error(sprintf("Wrong detector_type is defined for " + scheme + "!!!\n" + ...
            detector_type + " is not a detector for " + scheme));
    end
    % /////////////////////////////////////////////////////////////////////

    % Theoretical Analysis / Monte Carlo Simulation////////////////////////
    switch num_varargin
        case 0 % Theoretical Analysis of QPMM
            BER = zeros(1, length(SNRdB_array));
            fprintf("QPMM theoretical analysis for NT=%d, NR=%d, M=%d, " + mod_type + " has just started.\n", Nt, Nr, M);
            for SNRdB_index = 1 : length(SNRdB_array)
                SNRdB = SNRdB_array(SNRdB_index);
                fprintf("SNR: %ddB\n", SNRdB);
            
                BER(SNRdB_index) = QPMM_Theo(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type);
            end
            fprintf("QPMM theoretical analysis for NT=%d, NR=%d, M=%d, " + mod_type + " has just finished.\n\n", Nt, Nr, M);
            varargout{1} = BER;
        case 1 % Monte Carlo Simulation
            func_name = str2func(scheme);
            BER = zeros(1, length(SNRdB_array));
            num_bit_errors = zeros(1, length(SNRdB_array));
            fprintf(scheme + " simulation for NT=%d, NR=%d, M=%d, " + mod_type + " has just started.\n", Nt, Nr, M);
            for SNRdB_index = 1 : length(SNRdB_array)
                SNRdB = SNRdB_array(SNRdB_index);
                fprintf("SNR: %ddB\n", SNRdB);
            
                [BER(SNRdB_index), num_bit_errors(SNRdB_index)] = ...
                    func_name(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
            end
            fprintf(scheme + " simulation for NT=%d, NR=%d, M=%d, " + mod_type + " has just finished.\n\n", Nt, Nr, M);
            varargout{1} = BER;
            varargout{2} = num_bit_errors;
    end
    % /////////////////////////////////////////////////////////////////////
end
%==========================================================================