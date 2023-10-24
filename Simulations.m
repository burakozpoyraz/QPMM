%==========================================================================
% PAPER: Quadrature Permutation Matrix Modulation
% ANALYSIS: Simulations of the Paper
% AUTHORS: Burak Özpoyraz, Atalay Aydın, Ertuğrul Başar
% AFFILIATION: Koç University - Communications and Research Laboratory
% DEVELOPER: Burak Özpoyraz
%==========================================================================

%% FIGURE-1
clear all;
clc;
fig1_save = false;

% QPMM (2x2, BPSK)/////////////////////////////////////////////////////////
run_simulation = true;
load("Values/QPMM_NT2_NR2_M2_JointMLD.mat");
SNRdB_array = QPMM_NT2_NR2_M2_JointMLD(1, :);
BER_QPMM_NT2_NR2_M2_sim = QPMM_NT2_NR2_M2_JointMLD(3, :);
if run_simulation
    fprintf("QPMM (2x2, BPSK) simulation of Figure-1 has just started.\n");
    num_iterations = 1e5;
    Nt = 2;
    Nr = 2;
    M = 2;
    P_tot = Nt;
    mod_type = "PSK";
    BER_QPMM_NT2_NR2_M2_theo = zeros(1, length(SNRdB_array));
    parfor SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        fprintf("SNR: %ddB\n", SNRdB);

        BER_QPMM_NT2_NR2_M2_theo(SNRdB_index) = ...
            QPMM_Theo(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type);
    end
    fprintf("QPMM (2x2, BPSK) simulation of Figure-1 has just finished.\n\n");
else
    load("Values/QPMM_NT2_NR2_M2_Theoretical.mat");
    BER_QPMM_NT2_NR2_M2_theo = QPMM_NT2_NR2_M2_Theoretical(2, :);
end
% /////////////////////////////////////////////////////////////////////////

% QPMM (2x2, QPSK)/////////////////////////////////////////////////////////
run_simulation = true;
load("Values/QPMM_NT2_NR2_M4.mat");
BER_QPMM_NT2_NR2_M4_sim = QPMM_NT2_NR2_M4(3, :);
if run_simulation
    fprintf("QPMM (2x2, QPSK) simulation of Figure-1 has just started.\n");
    num_iterations = 1e5;
    Nt = 2;
    Nr = 2;
    M = 4;
    P_tot = Nt;
    mod_type = "PSK";
    BER_QPMM_NT2_NR2_M4_theo = zeros(1, length(SNRdB_array));
    parfor SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        fprintf("SNR: %ddB\n", SNRdB);

        BER_QPMM_NT2_NR2_M4_theo(SNRdB_index) = ...
            QPMM_Theo(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type);
    end
    fprintf("QPMM (2x2, QPSK) simulation of Figure-1 has just finished.\n\n");
else
    load("Values/QPMM_NT2_NR2_M4_Theoretical.mat");
    BER_QPMM_NT2_NR2_M4_theo = QPMM_NT2_NR2_M4_Theoretical(2, :);
end
% /////////////////////////////////////////////////////////////////////////

% Figure///////////////////////////////////////////////////////////////////
SetColorPalette()
fig1 = figure;
tiledlayout(1, 1, "TileSpacing", "Compact", "Padding", "Compact");
nexttile
semilogy(SNRdB_array, BER_QPMM_NT2_NR2_M2_sim, "-", "Color", red,...
                                                    "LineWidth", 2);
hold on;
semilogy(SNRdB_array, BER_QPMM_NT2_NR2_M2_theo, "o", "Color", red,...
                                                     "LineWidth", 2,...
                                                     "MarkerEdgeColor", red, ...
                                                     "MarkerFaceColor", red, ...
                                                     "MarkerSize", 10);
hold on;
semilogy(SNRdB_array, BER_QPMM_NT2_NR2_M4_sim, "-", "Color", yellow,...
                                                    "LineWidth", 2);
hold on;
semilogy(SNRdB_array, BER_QPMM_NT2_NR2_M4_theo, "o", "Color", yellow,...
                                                     "LineWidth", 2,...
                                                     "MarkerEdgeColor", yellow, ...
                                                     "MarkerFaceColor", yellow, ...
                                                     "MarkerSize", 10);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 14);
xlabel("$1 / l N_0$", "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend("QPMM Sim, ($2 \times 2$, BPSK, $l=4$)",...
       "QPMM Theo, ($2 \times 2$, BPSK, $l=4$)",...
       "QPMM Sim, ($2 \times 2$, QPSK, $l=6$)",...
       "QPMM Theo, ($2 \times 2$, QPSK, $l=6$)",...
       "Location", "northeast", "FontSize", 14, "Interpreter", "latex");
ylim([1e-3, 3e-1]);
grid;
% /////////////////////////////////////////////////////////////////////////

QPMM_NT2_NR2_M4_Theoretical = [SNRdB_array; BER_QPMM_NT2_NR2_M4_theo];
QPMM_NT2_NR2_M2_Theoretical = [SNRdB_array; BER_QPMM_NT2_NR2_M2_theo];

% Figure Save//////////////////////////////////////////////////////////////
if fig1_save
    set(fig1, "Units", "Inches");
    pos = get(fig1, "Position");
    set(fig1, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig1, "Figures/Figure1", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-2
clear all;
clc;
fig2_save = false;

% QPMM/////////////////////////////////////////////////////////////////////
run_simulation = false;
load("Values/QPMM_NT4_NR4_M2.mat");
SNRdB_array = QPMM_NT4_NR4_M2(1, :);
if run_simulation
    fprintf("QPMM simulation of Figure-2 has just started.\n");
    num_iterations_array = QPMM_NT4_NR4_M2(2, :);
    Nt = 4;
    Nr = 4;
    M = 2;
    P_tot = Nt;
    mod_type = "PSK";
    detector_type = "C-MLD";
    BER_QPMM_array = zeros(1, length(SNRdB_array));
    num_bit_errors_QPMM_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_QPMM_array(SNRdB_index), num_bit_errors_QPMM_array(SNRdB_index)] = ...
            QPMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("QPMM simulation of Figure-2 has just finished.\n\n");
else
    BER_QPMM_array = QPMM_NT4_NR4_M2(3, :);
    num_bit_errors_QPMM_array = QPMM_NT4_NR4_M2(4, :);
end
% /////////////////////////////////////////////////////////////////////////

% PMM//////////////////////////////////////////////////////////////////////
run_simulation = false;
load("Values/PMM_NT4_NR4_M4.mat");
if run_simulation
    fprintf("PMM simulation of Figure-2 has just started.\n");
    num_iterations_array = PMM_NT4_NR4_M4(2, :);
    Nt = 4;
    Nr = 4;
    M = 4;
    P_tot = Nt;
    mod_type = "PSK";
    detector_type = "C-MLD";
    BER_PMM_array = zeros(1, length(SNRdB_array));
    num_bit_errors_PMM_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_PMM_array(SNRdB_index), num_bit_errors_PMM_array(SNRdB_index)] = ...
            PMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("PMM simulation of Figure-2 has just finished.\n\n");
else
    BER_PMM_array = PMM_NT4_NR4_M4(3, :);
    num_bit_errors_PMM_array = PMM_NT4_NR4_M4(4, :);
end
% /////////////////////////////////////////////////////////////////////////

% Figure///////////////////////////////////////////////////////////////////
SetColorPalette()
fig2 = figure;
tiledlayout(1, 1, "TileSpacing", "Compact", "Padding", "Compact");
nexttile
semilogy(SNRdB_array, BER_QPMM_array, "d-", "Color", red,...
                                            "LineWidth", 2,...
                                            "MarkerEdgeColor", red, ...
                                            "MarkerFaceColor", red, ...
                                            "MarkerSize", 10);
hold on;
semilogy(SNRdB_array, BER_PMM_array, "o-", "Color", yellow,...
                                           "LineWidth", 2,...
                                            "MarkerEdgeColor", yellow, ...
                                            "MarkerFaceColor", yellow, ...
                                            "MarkerSize", 10);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 14);
xlabel("$1 / l N_0$", "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend("QPMM, ($4 \times 4$, BPSK, $l=12$)",...
       "PMM, ($4 \times 4$, QPSK, $l=12$)",...
       "Location", "northeast", "FontSize", 14, "Interpreter", "latex");
ylim([1e-4 2e-1]);
grid;
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig2_save
    set(fig2, "Units", "Inches");
    pos = get(fig2, "Position");
    set(fig2, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig2, "Figures/Figure2", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-3
clear all;
clc;
fig3_save = false;

% QPMM (4x4)///////////////////////////////////////////////////////////////
run_simulation = false;
load("Values/QPMM_NT4_NR4_M2.mat");
SNRdB_array = QPMM_NT4_NR4_M2(1, :);
if run_simulation
    fprintf("QPMM (4x4) simulation of Figure-3 has just started.\n");
    num_iterations_array = QPMM_NT4_NR4_M2(2, :);
    Nt = 4;
    Nr = 4;
    M = 2;
    P_tot = Nt;
    mod_type = "PSK";
    detector_type = "C-MLD";
    BER_QPMM_4x4_array = zeros(1, length(SNRdB_array));
    num_bit_errors_QPMM_4x4_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_QPMM_4x4_array(SNRdB_index), num_bit_errors_QPMM_4x4_array(SNRdB_index)] = ...
            QPMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("QPMM (4x4) simulation of Figure-3 has just finished.\n\n");
else
    BER_QPMM_4x4_array = QPMM_NT4_NR4_M2(3, :);
    num_bit_errors_QPMM_4x4_array = QPMM_NT4_NR4_M2(4, :);
end
% /////////////////////////////////////////////////////////////////////////

% QPMM (2x6)///////////////////////////////////////////////////////////////
run_simulation = false;
load("Values/QPMM_NT2_NR6_M32.mat");
if run_simulation
    fprintf("QPMM (2x6) simulation of Figure-3 has just started.\n");
    num_iterations_array = QPMM_NT2_NR6_M32(2, :);
    Nt = 2;
    Nr = 6;
    M = 32;
    P_tot = Nt;
    mod_type = "QAM";
    detector_type = "C-MLD";
    BER_QPMM_2x6_array = zeros(1, length(SNRdB_array));
    num_bit_errors_QPMM_2x6_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_QPMM_2x6_array(SNRdB_index), num_bit_errors_QPMM_2x6_array(SNRdB_index)] = ...
            QPMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("QPMM (2x6) simulation of Figure-3 has just finished.\n\n");
else
    BER_QPMM_2x6_array = QPMM_NT2_NR6_M32(3, :);
    num_bit_errors_QPMM_2x6_array = QPMM_NT2_NR6_M32(4, :);
end
% /////////////////////////////////////////////////////////////////////////

% QPMM (6x2)///////////////////////////////////////////////////////////////
run_simulation = false;
load("Values/QPMM_NT6_NR2_M32.mat");
if run_simulation
    fprintf("QPMM (6x2) Simulation of Figure-3 has just started.\n");
    num_iterations_array = QPMM_NT6_NR2_M32(2, :);
    Nt = 6;
    Nr = 2;
    M = 32;
    P_tot = Nt;
    mod_type = "QAM";
    detector_type = "C-MLD";
    BER_QPMM_6x2_array = zeros(1, length(SNRdB_array));
    num_bit_errors_QPMM_6x2_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_QPMM_6x2_array(SNRdB_index), num_bit_errors_QPMM_6x2_array(SNRdB_index)] = ...
            QPMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("QPMM (6x2) Simulation of Figure-3 has just finished.\n\n");
else
    BER_QPMM_6x2_array = QPMM_NT6_NR2_M32(3, :);
    num_bit_errors_QPMM_6x2_array = QPMM_NT6_NR2_M32(4, :);
end
% /////////////////////////////////////////////////////////////////////////

% Figure///////////////////////////////////////////////////////////////////
SetColorPalette()
fig3 = figure;
tiledlayout(1, 1, "TileSpacing", "Compact", "Padding", "Compact");
nexttile
semilogy(SNRdB_array, BER_QPMM_4x4_array, "d-", "Color", red,...
                                                "LineWidth", 2,...
                                                "MarkerEdgeColor", red, ...
                                                "MarkerFaceColor", red, ...
                                                "MarkerSize", 10);
hold on;
semilogy(SNRdB_array, BER_QPMM_2x6_array, "o-", "Color", yellow,...
                                                "LineWidth", 2,...
                                                "MarkerEdgeColor", yellow, ...
                                                "MarkerFaceColor", yellow, ...
                                                "MarkerSize", 10);
hold on;
semilogy(SNRdB_array, BER_QPMM_6x2_array, "p-", "Color", blue,...
                                                "LineWidth", 2,...
                                                "MarkerEdgeColor", blue, ...
                                                "MarkerFaceColor", blue, ...
                                                "MarkerSize", 10);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 14);
xlabel("$1 / l N_0$", "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend("QPMM, ($4 \times 4$, BPSK, $l=12$)",...
       "QPMM, ($2 \times 6$, 32-QAM, $l=12$)",...
       "QPMM, ($6 \times 2$, 32-QAM, $l=12$)",...
       "Location", "northeast", "FontSize", 14, "Interpreter", "latex");  
ylim([1e-4 1e-1]);
grid;
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig3_save
    set(fig3, "Units", "Inches");
    pos = get(fig3, "Position");
    set(fig3, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig3, "Figures/Figure3", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-4
clear all;
clc;
fig4_save = false;

% QPMM/////////////////////////////////////////////////////////////////////
run_simulation = false;
load("Values/QPMM_NT4_NR4_M4.mat");
SNRdB_array = QPMM_NT4_NR4_M4(1, :);
if run_simulation
    fprintf("QPMM Simulation of Figure-4 has just started.\n");
    num_iterations_array = QPMM_NT4_NR4_M4(2, :);
    Nt = 4;
    Nr = 4;
    M = 4;
    P_tot = Nt;
    mod_type = "PSK";
    detector_type = "C-MLD";
    BER_QPMM_array = zeros(1, length(SNRdB_array));
    num_bit_errors_QPMM_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_QPMM_array(SNRdB_index), num_bit_errors_QPMM_array(SNRdB_index)] = ...
            QPMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("QPMM Simulation of Figure-2 has just finished.\n\n");
else
    BER_QPMM_array = QPMM_NT4_NR4_M4(3, :);
    num_bit_errors_QPMM_array = QPMM_NT4_NR4_M4(4, :);
end
% /////////////////////////////////////////////////////////////////////////

% PMM//////////////////////////////////////////////////////////////////////
run_simulation = false;
load("Values/PMM_NT5_NR5_M4.mat");
if run_simulation
    fprintf("PMM Simulation of Figure-4 has just started.\n");
    num_iterations_array = PMM_NT5_NR5_M4(2, :);
    Nt = 5;
    Nr = 5;
    M = 4;
    P_tot = Nt;
    mod_type = "PSK";
    detector_type = "C-MLD";
    BER_PMM_array = zeros(1, length(SNRdB_array));
    num_bit_errors_PMM_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_PMM_array(SNRdB_index), num_bit_errors_PMM_array(SNRdB_index)] = ...
            PMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("PMM Simulation of Figure-2 has just finished.\n\n");
else
    BER_PMM_array = PMM_NT5_NR5_M4(3, :);
    num_bit_errors_PMM_array = PMM_NT5_NR5_M4(4, :);
end
% /////////////////////////////////////////////////////////////////////////

% Figure///////////////////////////////////////////////////////////////////
SetColorPalette()
fig4 = figure;
tiledlayout(1, 1, "TileSpacing", "Compact", "Padding", "Compact");
nexttile
semilogy(SNRdB_array, BER_QPMM_array, "d-", "Color", red,...
                                            "LineWidth", 2,...
                                            "MarkerEdgeColor", red, ...
                                            "MarkerFaceColor", red, ...
                                            "MarkerSize", 10);
hold on;
semilogy(SNRdB_array, BER_PMM_array, "o-", "Color", yellow,...
                                           "LineWidth", 2,...
                                           "MarkerEdgeColor", yellow, ...
                                           "MarkerFaceColor", yellow, ...
                                           "MarkerSize", 10);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 14);
xlabel("$1 / l N_0$", "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend("QPMM, ($4 \times 4$, QPSK, $l=16$)",...
       "PMM, ($5 \times 5$, QPSK, $l=16$)",...
       "Location", "northeast", "FontSize", 14, "Interpreter", "latex");
ylim([5e-4 2e-1]);
grid;

axes("position", [0.63 0.5 0.25 0.25]);
semilogy(SNRdB_array(4 : 7), BER_QPMM_array(4 : 7), "d-", "Color", red,...
                                                          "LineWidth", 2,...
                                                          "MarkerEdgeColor", red, ...
                                                          "MarkerFaceColor", red, ...
                                                          "MarkerSize", 10);
hold on;
semilogy(SNRdB_array(4 : 7), BER_PMM_array(4 : 7), "o-", "Color", yellow,...
                                                         "LineWidth", 2,...
                                                         "MarkerEdgeColor", yellow, ...
                                                         "MarkerFaceColor", yellow, ...
                                                         "MarkerSize", 10);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 10);
set(gca, "Color", [0.937, 0.905, 0.843]);
xlim([11 16]);
yticks([]);
grid;

annotation("doublearrow", [0.71 0.8], [0.62 0.62]);
annotation("textbox", [0.67, 0.63, 0.2, 0.05], "String", "\textbf{1.78 dB}",...
                                                  "EdgeColor", "k",...
                                                  "FontSize", 12,...
                                                  "Interpreter", "latex",...
                                                  "HorizontalAlignment", "center",...
                                                  "LineStyle", "none");
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig4_save
    set(fig4, "Units", "Inches");
    pos = get(fig4, "Position");
    set(fig4, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig4, "Figures/Figure4", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-5
clear all;
clc;
fig5_save = false;

% Figure-5a////////////////////////////////////////////////////////////////
% Parameters===============================================================
m = 2;
Nd_array = (2 : 8);
nd_array = Nd_array * m;
% =========================================================================

% Bit Rate of QPMM=========================================================
QPMM_np_array = 2 * floor(log2(factorial(Nd_array)));
QPMM_n_tot_array = QPMM_np_array + nd_array;
% =========================================================================

% Bit Rate of PMM==========================================================
PMM_np_array = floor(log2(factorial(Nd_array)));
PMM_n_tot_array = PMM_np_array + nd_array;
% =========================================================================

% Figure===================================================================
SetColorPalette()
fig5 = figure;
tiledlayout(1, 2, "TileSpacing", "Compact", "Padding", "Compact");
nexttile
plot(Nd_array, QPMM_n_tot_array, "Color", red, "LineWidth", 2);
hold on;
plot(Nd_array, PMM_n_tot_array, "Color", yellow, "LineWidth", 2);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 12);
title("$M=4$", "Interpreter", "latex");
xlabel(["$N_D$", "(a)"], "Interpreter", "latex");
ylabel("Bit Rate (bpcu)", "Interpreter", "latex");
legend("QPMM",...
       "PMM",...
       "Location", "northwest", "FontSize", 12, "Interpreter", "latex");
xlim([2, 8]);
ylim([4, 50]);
grid;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure-5b////////////////////////////////////////////////////////////////
% Parameters===============================================================
Nd_array = (2 : 32);
% =========================================================================

% Modulation Level of QPMM=================================================
m = 2;
QPMM_np_array = 2 * floor(log2(factorial(Nd_array)));
QPMM_nd_array = Nd_array * m;
QPMM_n_tot_array = QPMM_np_array + QPMM_nd_array;
QPMM_M_array = 2 * ones(1, 31);
% =========================================================================

% Modulation Level of PMM==================================================
PMM_np_array = floor(log2(factorial(Nd_array)));
PMM_m_array = floor((QPMM_n_tot_array - PMM_np_array) ./ Nd_array);
PMM_M_array = 2.^(PMM_m_array);
% =========================================================================

% Figure===================================================================
nexttile
plot(Nd_array, QPMM_M_array, "Color", red, "LineWidth", 2);
hold on;
plot(Nd_array, PMM_M_array, "Color", yellow, "LineWidth", 2);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 12);
title("$l_{\mathrm{QPMM}}=l_{\mathrm{PMM}}$", "Interpreter", "latex");
xlabel(["$N_D$", "(b)"], "Interpreter", "latex");
ylabel("Modulation Level", "Interpreter", "latex");
legend("QPMM",...
       "PMM",...
       "Location", "northwest", "FontSize", 12, "Interpreter", "latex");
xlim([2, 32]);
ylim([1, 35]);
grid;

annotation("rectangle", [0.82, 0.87, 0.115, 0.05], "FaceColor", yellow,...
                                                   "EdgeColor", yellow);
annotation("textbox", [0.83, 0.875, 0.093, 0.05], "String", "32-QAM",...
                                                  "EdgeColor", yellow,...
                                                  "FontSize", 12,...
                                                  "Interpreter", "latex",...
                                                  "HorizontalAlignment", "center",...
                                                  "LineStyle", "none");
                                              
annotation("rectangle", [0.665, 0.514, 0.115, 0.05], "FaceColor", yellow,...
                                                     "EdgeColor", yellow);
annotation("textbox", [0.675, 0.519, 0.093, 0.05], "String", "16-QAM",...
                                                   "EdgeColor", yellow,...
                                                   "FontSize", 12,...
                                                   "Interpreter", "latex",...
                                                   "HorizontalAlignment", "center",...
                                                   "LineStyle", "none");
                                              
annotation("rectangle", [0.605, 0.335, 0.095, 0.05], "FaceColor", yellow,...
                                                     "EdgeColor", yellow);
annotation("textbox", [0.615, 0.339, 0.076, 0.05], "String", "8-PSK",...
                                                   "EdgeColor", yellow,...
                                                   "FontSize", 12,...
                                                   "Interpreter", "latex",...
                                                   "HorizontalAlignment", "center",...
                                                   "LineStyle", "none");
                                            
annotation("rectangle", [0.605, 0.215, 0.091, 0.05], "FaceColor", yellow,...
                                                     "EdgeColor", yellow);
annotation("textbox", [0.615, 0.22, 0.072, 0.05], "String", "QPSK",...
                                                  "EdgeColor", yellow,...
                                                  "FontSize", 12,...
                                                  "Interpreter", "latex",...
                                                  "HorizontalAlignment", "center",...
                                                  "LineStyle", "none");

annotation("rectangle", [0.8, 0.203, 0.091, 0.05], "FaceColor", red,...
                                                   "EdgeColor", red);
annotation("textbox", [0.81, 0.208, 0.072, 0.05], "String", "BPSK",...
                                                  "Color", "w",...
                                                  "EdgeColor", red,...
                                                  "FontSize", 12,...
                                                  "Interpreter", "latex",...
                                                  "HorizontalAlignment", "center",...
                                                  "LineStyle", "none");
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig5_save
    set(fig5, "Units", "Inches");
    pos = get(fig5, "Position");
    set(fig5, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig5, "Figures/Figure5", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-6
clear all;
clc;
fig6_save = false;

% Figure-6a////////////////////////////////////////////////////////////////
% QPMM - Joint MLD=========================================================
run_simulation = false;
load("Values/QPMM_NT2_NR2_M2_JointMLD.mat");
SNRdB_array = QPMM_NT2_NR2_M2_JointMLD(1, :);
if run_simulation
    fprintf("QPMM - Joint MLD simulation of Figure-6 has just started.\n");
    num_iterations_array = QPMM_NT2_NR2_M2_JointMLD(2, :);
    Nt = 2;
    Nr = 2;
    M = 2;
    P_tot = Nt;
    mod_type = "PSK";
    detector_type = "JointMLD";
    BER_QPMM_JointMLD_array = zeros(1, length(SNRdB_array));
    num_bit_errors_QPMM_JointMLD_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_QPMM_JointMLD_array(SNRdB_index), num_bit_errors_QPMM_JointMLD_array(SNRdB_index)] = ...
            QPMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("QPMM - Joint MLD simulation of Figure-6 has just finished.\n\n");
else
    BER_QPMM_JointMLD_array = QPMM_NT2_NR2_M2_JointMLD(3, :);
    num_bit_errors_QPMM_JointMLD_array = QPMM_NT2_NR2_M2_JointMLD(4, :);
end
% =========================================================================

% QPMM - C-MLD=============================================================
run_simulation = false;
load("Values/QPMM_NT2_NR2_M2_CMLD.mat");
if run_simulation
    fprintf("QPMM - C-MLD simulation of Figure-6 has just started.\n");
    num_iterations_array = QPMM_NT2_NR2_M2_CMLD(2, :);
    Nt = 2;
    Nr = 2;
    M = 2;
    P_tot = Nt;
    mod_type = "PSK";
    detector_type = "C-MLD";
    BER_QPMM_CMLD_array = zeros(1, length(SNRdB_array));
    num_bit_errors_QPMM_CMLD_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_QPMM_CMLD_array(SNRdB_index), num_bit_errors_QPMM_CMLD_array(SNRdB_index)] = ...
            QPMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("QPMM - C-MLD simulation of Figure-6 has just finished.\n\n");
else
    BER_QPMM_CMLD_array = QPMM_NT2_NR2_M2_CMLD(3, :);
    num_bit_errors_QPMM_CMLD_array = QPMM_NT2_NR2_M2_CMLD(4, :);
end
% =========================================================================

% Figure===================================================================
SetColorPalette()
fig6 = figure;
tiledlayout(1, 2, "TileSpacing", "Compact", "Padding", "Compact");
nexttile
semilogy(SNRdB_array, BER_QPMM_JointMLD_array, "Color", blue,...
                                               "LineWidth", 2,...
                                               "MarkerEdgeColor", blue, ...
                                               "MarkerFaceColor", blue, ...
                                               "MarkerSize", 8);
hold on;
semilogy(SNRdB_array, BER_QPMM_CMLD_array, "o", "Color", red,...
                                                "LineWidth", 2,...
                                                "MarkerEdgeColor", red, ...
                                                "MarkerFaceColor", red, ...
                                                "MarkerSize", 8);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 12);
title("QPMM", "Interpreter", "latex");
xlabel(["$1 / l N_0$", "(a)"], "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend("Joint MLD",...
       "C-MLD",...
       "Location", "southwest", "FontSize", 12, "Interpreter", "latex");  
ylim([1e-4 1e-1]);
grid;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure-6b////////////////////////////////////////////////////////////////
% PMM - Joint MLD==========================================================
run_simulation = false;
load("Values/PMM_NT2_NR2_M2_JointMLD.mat");
SNRdB_array = PMM_NT2_NR2_M2_JointMLD(1, :);
if run_simulation
    fprintf("PMM - Joint MLD simulation of Figure-6 has just started.\n");
    num_iterations_array = PMM_NT2_NR2_M2_JointMLD(2, :);
    Nt = 2;
    Nr = 2;
    M = 2;
    P_tot = Nt;
    mod_type = "PSK";
    detector_type = "JointMLD";
    BER_PMM_JointMLD_array = zeros(1, length(SNRdB_array));
    num_bit_errors_PMM_JointMLD_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_PMM_JointMLD_array(SNRdB_index), num_bit_errors_PMM_JointMLD_array(SNRdB_index)] = ...
            PMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("PMM - Joint MLD simulation of Figure-6 has just finished.\n\n");
else
    BER_PMM_JointMLD_array = PMM_NT2_NR2_M2_JointMLD(3, :);
    num_bit_errors_PMM_JointMLD_array = PMM_NT2_NR2_M2_JointMLD(4, :);
end
% =========================================================================

% PMM - LCD================================================================
run_simulation = false;
load("Values/PMM_NT2_NR2_M2_LCD.mat");
if run_simulation
    fprintf("PMM - LCD simulation of Figure-6 has just started.\n");
    num_iterations_array = PMM_NT2_NR2_M2_LCD(2, :);
    Nt = 2;
    Nr = 2;
    M = 2;
    P_tot = Nt;
    mod_type = "PSK";
    detector_type = "LCD";
    BER_PMM_LCD_array = zeros(1, length(SNRdB_array));
    num_bit_errors_PMM_LCD_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_PMM_LCD_array(SNRdB_index), num_bit_errors_PMM_LCD_array(SNRdB_index)] = ...
            PMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("PMM - LCD simulation of Figure-6 has just finished.\n\n");
else
    BER_PMM_LCD_array = PMM_NT2_NR2_M2_LCD(3, :);
    num_bit_errors_PMM_LCD_array = PMM_NT2_NR2_M2_LCD(4, :);
end
% =========================================================================

% PMM - C-MLD==============================================================
run_simulation = false;
load("Values/PMM_NT2_NR2_M2_CMLD.mat");
if run_simulation
    fprintf("PMM - C-MLD simulation of Figure-6 has just started.\n");
    num_iterations_array = PMM_NT2_NR2_M2_CMLD(2, :);
    Nt = 2;
    Nr = 2;
    M = 2;
    P_tot = Nt;
    mod_type = "PSK";
    detector_type = "C-MLD";
    BER_PMM_CMLD_array = zeros(1, length(SNRdB_array));
    num_bit_errors_PMM_CMLD_array = zeros(1, length(SNRdB_array));
    for SNRdB_index = 1 : length(SNRdB_array)
        SNRdB = SNRdB_array(SNRdB_index);
        num_iterations = num_iterations_array(SNRdB_index);

        fprintf("SNR: %ddB\n", SNRdB);

        [BER_PMM_CMLD_array(SNRdB_index), num_bit_errors_PMM_CMLD_array(SNRdB_index)] = ...
            PMM(num_iterations, Nt, Nr, M, P_tot, SNRdB, mod_type, detector_type);
    end
    fprintf("PMM - C-MLD simulation of Figure-6 has just finished.\n\n");
else
    BER_PMM_CMLD_array = PMM_NT2_NR2_M2_CMLD(3, :);
    num_bit_errors_PMM_CMLD_array = PMM_NT2_NR2_M2_CMLD(4, :);
end
% =========================================================================

% Figure===================================================================
nexttile
semilogy(SNRdB_array, BER_PMM_JointMLD_array, "Color", blue,...
                                              "LineWidth", 2,...
                                              "MarkerEdgeColor", blue, ...
                                              "MarkerFaceColor", blue, ...
                                              "MarkerSize", 8);
hold on;
semilogy(SNRdB_array, BER_PMM_LCD_array, "-s", "Color", yellow,...
                                               "LineWidth", 2,...
                                               "MarkerEdgeColor", yellow, ...
                                               "MarkerFaceColor", yellow, ...
                                               "MarkerSize", 8);
hold on;
semilogy(SNRdB_array, BER_PMM_CMLD_array, "o", "Color", red,...
                                               "LineWidth", 2,...
                                               "MarkerEdgeColor", red, ...
                                               "MarkerFaceColor", red, ...
                                               "MarkerSize", 8);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 12);
title("PMM", "Interpreter", "latex");
xlabel(["$1 / l N_0$", "(b)"], "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend("Joint MLD",...
       "LCD",...
       "C-MLD",...
       "Location", "southwest", "FontSize", 12, "Interpreter", "latex");
ylim([5e-4 3e-1]);
grid;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig6_save
    set(fig6, "Units", "Inches");
    pos = get(fig6, "Position");
    set(fig6, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig6, "Figures/Figure6", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-7
clear all;
clc;
fig7_save = false;

% Figure-7a////////////////////////////////////////////////////////////////
% Parameters===============================================================
Nd = 2;
M = 2;
np = floor(log2(factorial(Nd)));
Np = 2^np;
% =========================================================================

% Complexity of Joint MLD for QPMM=========================================
QPMM_JointMLD_complexity = Np^2 * M^Nd * (4 * Nd^3 + 2 * Nd^2 + 4 * Nd);
% =========================================================================

% Complexity of C-MLD for QPMM=============================================
QPMM_CMLD_complexity = Np^2 * Nd * (6 * M + 6);
% =========================================================================

% Figure===================================================================
SetColorPalette()
fig7 = figure("Position", [100 100 1300 800]);
tiledlayout(2, 3, "TileSpacing", "Compact", "Padding", "Compact");
nexttile
x = categorical(["C-MLD", "Joint MLD"]);
x = reordercats(x, ["C-MLD", "Joint MLD"]);
y = [QPMM_CMLD_complexity, QPMM_JointMLD_complexity];
b = bar(x, y, 0.5);
b.FaceColor = "flat";
b.CData(1, :) = red;
b.CData(2, :) = blue;
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(b.YData);
text(xtips, ytips, labels, "HorizontalAlignment", "center", "VerticalAlignment",...
     "bottom", "FontSize", 12, "Interpreter", "latex");
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 12)
title("QPMM $(N_D=2$, BPSK$)$", "Interpreter", "latex");
xlabel("(a)", "Interpreter", "latex");
ylabel("Complexity", "Interpreter", "latex");
ylim([0 1000]);
grid;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure-7b////////////////////////////////////////////////////////////////
% Parameters===============================================================
Nd = 2;
M = 4;
np = floor(log2(factorial(Nd)));
Np = 2^np;
% =========================================================================

% Complexity of Joint MLD for QPMM=========================================
QPMM_JointMLD_complexity = Np^2 * M^Nd * (4 * Nd^3 + 2 * Nd^2 + 4 * Nd);
% =========================================================================

% Complexity of C-MLD for QPMM=============================================
QPMM_CMLD_complexity = Np^2 * Nd * (6 * M + 6);
% =========================================================================

% Figure===================================================================
nexttile
x = categorical(["C-MLD", "Joint MLD"]);
x = reordercats(x, ["C-MLD", "Joint MLD"]);
y = [QPMM_CMLD_complexity, QPMM_JointMLD_complexity];
b = bar(x, y, 0.5);
b.FaceColor = "flat";
b.CData(1, :) = red;
b.CData(2, :) = blue;
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(b.YData);
text(xtips, ytips, labels, "HorizontalAlignment", "center", "VerticalAlignment",...
     "bottom", "FontSize", 12, "Interpreter", "latex");
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 12)
title("QPMM $(N_D=2$, QPSK$)$", "Interpreter", "latex");
xlabel("(b)", "Interpreter", "latex");
ylabel("Complexity", "Interpreter", "latex");
grid;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure-7c////////////////////////////////////////////////////////////////
% Parameters===============================================================
Nd = 4;
M = 2;
np = floor(log2(factorial(Nd)));
Np = 2^np;
% =========================================================================

% Complexity of Joint MLD for QPMM=========================================
QPMM_JointMLD_complexity = Np^2 * M^Nd * (4 * Nd^3 + 2 * Nd^2 + 4 * Nd);
% =========================================================================

% Complexity of C-MLD for QPMM=============================================
QPMM_CMLD_complexity = Np^2 * Nd * (6 * M + 6);
% =========================================================================

% Figure===================================================================
nexttile
x = categorical(["C-MLD", "Joint MLD"]);
x = reordercats(x, ["C-MLD", "Joint MLD"]);
y = [QPMM_CMLD_complexity, QPMM_JointMLD_complexity];
b = bar(x, y, 0.5);
b.FaceColor = "flat";
b.CData(1, :) = red;
b.CData(2, :) = blue;
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(b.YData);
text(xtips, ytips, labels, "HorizontalAlignment", "center", "VerticalAlignment",...
     "bottom", "FontSize", 12, "Interpreter", "latex");
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 12)
title("QPMM $(N_D=4$, BPSK$)$", "Interpreter", "latex");
xlabel("(c)", "Interpreter", "latex");
ylabel("Complexity", "Interpreter", "latex");
grid;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure-7d////////////////////////////////////////////////////////////////
% Parameters===============================================================
Nd = 2;
M = 2;
np = floor(log2(factorial(Nd)));
Np = 2^np;
% =========================================================================

% Complexity of Joint MLD for PMM==========================================
PMM_JointMLD_complexity = Np * M^Nd * (2 * Nd^3 + 2 * Nd^2 + 4 * Nd);
% =========================================================================

% Complexity of LCD for PMM================================================
PMM_LCD_complexity = Np * (2 * Nd^3 + 2 * Nd^2 + 2 * Nd) + Nd^2 + 2 * M * Nd;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Complexity of C-MLD for PMM==============================================
PMM_CMLD_complexity = Np * Nd * (4 * M + 4);
% =========================================================================

% Figure===================================================================
nexttile
x = categorical(["LCD", "C-MLD", "Joint MLD"]);
x = reordercats(x, ["LCD", "C-MLD", "Joint MLD"]);
y = [PMM_LCD_complexity, PMM_CMLD_complexity, PMM_JointMLD_complexity];
b = bar(x, y, 0.5);
b.FaceColor = "flat";
b.CData(1, :) = yellow;
b.CData(2, :) = red;
b.CData(3, :) = blue;
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(b.YData);
text(xtips, ytips, labels, "HorizontalAlignment", "center", "VerticalAlignment",...
     "bottom", "FontSize", 12, "Interpreter", "latex");
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 12)
title("PMM $(N_D=2$, BPSK$)$", "Interpreter", "latex");
xlabel("(d)", "Interpreter", "latex");
ylabel("Complexity", "Interpreter", "latex");
grid;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure-7e////////////////////////////////////////////////////////////////
% Parameters===============================================================
Nd = 2;
M = 4;
np = floor(log2(factorial(Nd)));
Np = 2^np;
% =========================================================================

% Complexity of Joint MLD for PMM==========================================
PMM_JointMLD_complexity = Np * M^Nd * (2 * Nd^3 + 2 * Nd^2 + 4 * Nd);
% =========================================================================

% Complexity of LCD for PMM================================================
PMM_LCD_complexity = Np * (2 * Nd^3 + 2 * Nd^2 + 2 * Nd) + Nd^2 + 2 * M * Nd;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Complexity of C-MLD for PMM==============================================
PMM_CMLD_complexity = Np * Nd * (4 * M + 4);
% =========================================================================

% Figure===================================================================
nexttile
x = categorical(["LCD", "C-MLD", "Joint MLD"]);
x = reordercats(x, ["LCD", "C-MLD", "Joint MLD"]);
y = [PMM_LCD_complexity, PMM_CMLD_complexity, PMM_JointMLD_complexity];
b = bar(x, y, 0.5);
b.FaceColor = "flat";
b.CData(1, :) = yellow;
b.CData(2, :) = red;
b.CData(3, :) = blue;
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(b.YData);
text(xtips, ytips, labels, "HorizontalAlignment", "center", "VerticalAlignment",...
     "bottom", "FontSize", 12, "Interpreter", "latex");
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 12)
title("PMM $(N_D=2$, QPSK$)$", "Interpreter", "latex");
xlabel("(e)", "Interpreter", "latex");
ylabel("Complexity", "Interpreter", "latex");
grid;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure-7f////////////////////////////////////////////////////////////////
% Parameters===============================================================
Nd = 4;
M = 2;
np = floor(log2(factorial(Nd)));
Np = 2^np;
% =========================================================================

% Complexity of Joint MLD for PMM==========================================
PMM_JointMLD_complexity = Np * M^Nd * (2 * Nd^3 + 2 * Nd^2 + 4 * Nd);
% =========================================================================

% Complexity of LCD for PMM================================================
PMM_LCD_complexity = Np * (2 * Nd^3 + 2 * Nd^2 + 2 * Nd) + Nd^2 + 2 * M * Nd;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Complexity of C-MLD for PMM==============================================
PMM_CMLD_complexity = Np * Nd * (4 * M + 4);
% =========================================================================

% Figure===================================================================
nexttile
x = categorical(["LCD", "C-MLD", "Joint MLD"]);
x = reordercats(x, ["LCD", "C-MLD", "Joint MLD"]);
y = [PMM_LCD_complexity, PMM_CMLD_complexity, PMM_JointMLD_complexity];
b = bar(x, y, 0.5);
b.FaceColor = "flat";
b.CData(1, :) = yellow;
b.CData(2, :) = red;
b.CData(3, :) = blue;
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(b.YData);
text(xtips, ytips, labels, "HorizontalAlignment", "center", "VerticalAlignment",...
     "bottom", "FontSize", 12, "Interpreter", "latex");
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 12)
title("PMM $(N_D=4$, BPSK$)$", "Interpreter", "latex");
xlabel("(f)", "Interpreter", "latex");
ylabel("Complexity", "Interpreter", "latex");
grid;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig7_save
    set(fig7, "Units", "Inches");
    pos = get(fig7, "Position");
    set(fig7, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig7, "Figures/Figure7", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% COLOR PALETTE
function SetColorPalette()
    assignin("base", "red", [162, 20, 47] / 255);
    assignin("base", "yellow", [237, 177, 32] / 255);
    assignin("base", "blue", [0, 114, 189] / 255);
end

















