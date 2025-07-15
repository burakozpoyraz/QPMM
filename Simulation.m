%==========================================================================
% PAPER: Quadrature Permutation Matrix Modulation
% AUTHORS: Burak Özpoyraz, Atalay Aydın, Ertuğrul Başar
% ANALYSIS: Simulation Algorithm of the Paper
% AFFILIATION: Koç University - Communications and Research Laboratory
% DEVELOPER: Burak Özpoyraz

% ALGORITHM DESCRIPTION
%==========================================================================

%% SIMULATION ALGORITHM
clear
clc

% Parameters///////////////////////////////////////////////////////////////
% Figure Parameters========================================================
fig_save = true;
fig_name = "FigName";
fig_path = "UserData/Figures";
% =========================================================================

% Simulation Parameters====================================================
scheme = "QPMM";
num_iterations = 1e4;
Nt = 2;
Nr = 2;
M = 2;
P_tot = Nt;
SNRdB_array = 0 : 3 : 30;
mod_type = "PSK";
detector_type = "C-MLD"; % Not necessary for theoretical QPMM analysis
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Simulation///////////////////////////////////////////////////////////////
[BER, num_bit_errors] = RunSimulation(scheme, num_iterations, Nt, Nr, M, P_tot, SNRdB_array, mod_type, detector_type);
% /////////////////////////////////////////////////////////////////////////

% Figure///////////////////////////////////////////////////////////////////
SetLegendText(scheme, Nt, Nr, M, mod_type);
SetColorPalette();
fig = figure;
tiledlayout(1, 1, "TileSpacing", "Compact", "Padding", "Compact");
nexttile
semilogy(SNRdB_array, BER, "-", "Color", red,...
                                "LineWidth", 2,...
                                "MarkerEdgeColor", red, ...
                                "MarkerFaceColor", red, ...
                                "MarkerSize", 10);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 14);
xlabel("$E_b / N_0$", "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend(legend_text,...
       "Location", "southwest", "FontSize", 14, "Interpreter", "latex");
grid;
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig_save
    set(fig, "Units", "Inches");
    pos = get(fig, "Position");
    set(fig, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig, fig_path + "/" + fig_name, "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% INNER FUNCTIONS (TOTAL OF 3)
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


%==========================================================================
%==========================================================================
function SetLegendText(scheme, Nt, Nr, M, mod_type)
    switch scheme
        case {"QPMM", "QPMM Theo"}
            Nd = min(Nt, Nr); % Number of data symbols transmitted in a time slot
            m = log2(M); % Number of data bits corresponding to a single data symbol
            nd = Nd * m; % Number of data bits transmitted in a time slot
            np = floor(log2(factorial(Nd))); % Number of permutation bits corresponding to a single permutation matrix
            l = nd + 2 * np; % Number of bits transmitted in a time slot
        case "PMM"
            Nd = min(Nt, Nr); % Number of data symbols transmitted in a time slot
            m = log2(M); % Number of data bits corresponding to a single data symbol
            nd = Nd * m; % Number of data bits transmitted in a time slot
            np = floor(log2(factorial(Nd))); % Number of permutation bits transmitted in a time slot
            l = nd + np; % Number of bits transmitted in a time slot
        case "SM"
            nd = log2(M); % Number of data bits for APM symbol selection
            ns = log2(Nt); % Number of spatial bits for antenna selection
            l = nd + ns; % Number of total bits transmitted in a time slot
        case "QSM"
            nd = log2(M); % Number of data bits for APM symbol selection
            ns = log2(Nt); % Number of spatial bits for antenna selection corresponding to each component
            l = nd + 2 * ns; % Number of total bits transmitted in a time slot
    end

    if mod_type == "PSK" && M == 2
        mod_text = "BPSK";
    elseif mod_type == "PSK" && M == 4
        mod_text = "QPSK";
    else
        mod_text = M + "-" + mod_type;
    end

    legend_text = scheme + ", ($" + Nt + " \times " + Nr + "$, " + mod_text + ", $l=" + l + "$)";
    assignin("base", "legend_text", legend_text);
end
%==========================================================================


%==========================================================================
%==========================================================================
function SetColorPalette()
    assignin("base", "purple", [126, 47, 142] / 255);
    assignin("base", "red", [162, 20, 47] / 255);
    assignin("base", "yellow", [237, 177, 32] / 255);
    assignin("base", "blue", [0, 114, 189] / 255);
    assignin("base", "green", [119, 172, 48] / 255);
end
%==========================================================================