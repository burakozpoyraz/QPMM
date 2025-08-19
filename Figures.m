%======================== QPMM FIGURE REPRODUCTION ========================
% This algorithm is used to reproduce the BER and complexity figures
% presented in the paper, as well as to visualize any user-generated
% simulation stored in the UserData/Values/ folder. This script ensures
% consistent styling across all plots.
%
% The algorithm includes two primary functionalities:
%
% 1) Custom Figure Plotting
%   • The user can specify a `.mat` file that contains simulation data.
%   • The script loads the data and automatically generates a BER plot
%     with LaTeX formatting, consistent color schemes, and styled markers.
%   • The figure is optionally saved in PDF format.
%
% 2) Paper Figure Reproduction
%   • Figures 6 through 13 correspond to the main results of the paper.
%   • Each figure section loads predefined simulation or theoretical data
%      and visualizes it using consistent figure styling.
%
% DEVELOPER: Burak Özpoyraz
%
% DATE: 19.08.2025
%==========================================================================

%% CUSTOM FIGURE
clear all;
clc;

% Parameters///////////////////////////////////////////////////////////////
% Figure Parameters========================================================
fig_save = true;
fig_name = "FigName";
fig_path = "UserData/Figures";
% =========================================================================

% Simulation Parameters====================================================
data_name = "DataName";
data_path = "UserData/Values/" + data_name + ".mat";
if isfile(data_path)
    load(data_path);
    scheme = sim_data_st.scheme;
    Nt = sim_data_st.Nt;
    Nr = sim_data_st.Nr;
    M = sim_data_st.M;
    mod_type = sim_data_st.mod_type;
    SNRdB_array = sim_data_st.SNRdB_array;
    BER_array = sim_data_st.BER_array;
    num_bit_error_array = sim_data_st.num_bit_error_array;
else
    error("The data file '%s' does not exist in the specified path.", data_name);
end
% =========================================================================

% Figure///////////////////////////////////////////////////////////////////
SetLegendText(scheme, Nt, Nr, M, mod_type);
SetColorPalette();
fig = figure;
tiledlayout(1, 1, "TileSpacing", "Compact", "Padding", "Compact");
nexttile
semilogy(SNRdB_array, BER_array, "o-", "Color", red,...
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

%% FIGURE-6
clear all;
clc;
fig6_save = true;

% QPMM (2x2, BPSK)/////////////////////////////////////////////////////////
load("Values/QPMM_NT2_NR2_M2_JointMLD.mat");
SNRdB_array = QPMM_NT2_NR2_M2_JointMLD(1, :);
BER_QPMM_NT2_NR2_M2_sim = QPMM_NT2_NR2_M2_JointMLD(3, :);

load("Values/QPMM_NT2_NR2_M2_Theoretical.mat");
BER_QPMM_NT2_NR2_M2_theo = QPMM_NT2_NR2_M2_Theoretical(2, :);
% /////////////////////////////////////////////////////////////////////////

% QPMM (2x2, QPSK)/////////////////////////////////////////////////////////
load("Values/QPMM_NT2_NR2_M4.mat");
BER_QPMM_NT2_NR2_M4_sim = QPMM_NT2_NR2_M4(3, :);

load("Values/QPMM_NT2_NR2_M4_Theoretical.mat");
BER_QPMM_NT2_NR2_M4_theo = QPMM_NT2_NR2_M4_Theoretical(2, :);
% /////////////////////////////////////////////////////////////////////////

% QPMM (2x2, 32-QAM)///////////////////////////////////////////////////////
load("Values/QPMM_NT2_NR2_M32.mat");
BER_QPMM_NT2_NR2_M32_sim = QPMM_NT2_NR2_M32(3, :);

load("Values/QPMM_NT2_NR2_M32_Theoretical.mat");
BER_QPMM_NT2_NR2_M32_theo = QPMM_NT2_NR2_M32_Theoretical(2, :);
% /////////////////////////////////////////////////////////////////////////

% Figure///////////////////////////////////////////////////////////////////
SetColorPalette()
fig6 = figure;
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
hold on;
semilogy(SNRdB_array, BER_QPMM_NT2_NR2_M32_sim, "-", "Color", blue,...
                                                     "LineWidth", 2);
hold on;
semilogy(SNRdB_array, BER_QPMM_NT2_NR2_M32_theo, "o", "Color", blue,...
                                                      "LineWidth", 2,...
                                                      "MarkerEdgeColor", blue, ...
                                                      "MarkerFaceColor", blue, ...
                                                      "MarkerSize", 10);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 14);
xlabel("$E_b / N_0$", "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend("QPMM Sim, ($2 \times 2$, BPSK, $l=4$)",...
       "QPMM Theo, ($2 \times 2$, BPSK, $l=4$)",...
       "QPMM Sim, ($2 \times 2$, QPSK, $l=6$)",...
       "QPMM Theo, ($2 \times 2$, QPSK, $l=6$)",...
       "QPMM Sim, ($2 \times 2$, 32-QAM, $l=6$)",...
       "QPMM Theo, ($2 \times 2$, 32-QAM, $l=6$)",...
       "Location", "northeast", "FontSize", 14, "Interpreter", "latex");
ylim([1e-3, 10]);
grid;
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig6_save
    set(fig6, "Units", "Inches");
    pos = get(fig6, "Position");
    set(fig6, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig6, "Figure6", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-7
clear all;
clc;
fig7_save = true;

% QPMM/////////////////////////////////////////////////////////////////////
load("Values/QPMM_NT4_NR4_M2.mat");
SNRdB_array = QPMM_NT4_NR4_M2(1, :);
BER_QPMM_array = QPMM_NT4_NR4_M2(3, :);
% /////////////////////////////////////////////////////////////////////////

% PMM//////////////////////////////////////////////////////////////////////
load("Values/PMM_NT4_NR4_M4.mat");
BER_PMM_array = PMM_NT4_NR4_M4(3, :);
% /////////////////////////////////////////////////////////////////////////

% SM//////////////////////////////////////////////////////////////////////
load("Values/SM_NT4_NR4_M1024_JointMLD.mat");
SNRdB_array_SM_JointMLD = SM_NT4_NR4_M1024_JointMLD(1, :);
BER_SM_JointMLD_array = SM_NT4_NR4_M1024_JointMLD(3, :);

load("Values/SM_NT4_NR4_M1024_ZF.mat");
SNRdB_array_SM_ZF = SM_NT4_NR4_M1024_ZF_JointMLD(1, :);
BER_SM_ZF_array = SM_NT4_NR4_M1024_ZF_JointMLD(3, :);
% /////////////////////////////////////////////////////////////////////////

% QSM//////////////////////////////////////////////////////////////////////
load("Values/QSM_NT4_NR4_M256_JointMLD.mat");
SNRdB_array_QSM_JointMLD = QSM_NT4_NR4_M256(1, :);
BER_QSM_JointMLD_array = QSM_NT4_NR4_M256(3, :);

load("Values/QSM_NT4_NR4_M256_ZF.mat");
SNRdB_array_QSM_ZF = QSM_NT4_NR4_M256_ZF(1, :);
BER_QSM_ZF_array = QSM_NT4_NR4_M256_ZF(3, :);
% /////////////////////////////////////////////////////////////////////////

% Figure///////////////////////////////////////////////////////////////////
SetColorPalette()
fig7 = figure;
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
hold on;
semilogy(SNRdB_array_SM_JointMLD, BER_SM_JointMLD_array, "p-", "Color", blue,...
                                                               "LineWidth", 2,...
                                                               "MarkerEdgeColor", blue, ...
                                                               "MarkerFaceColor", blue, ...
                                                               "MarkerSize", 10);
hold on;
semilogy(SNRdB_array_QSM_JointMLD, BER_QSM_JointMLD_array, "s-", "Color", green,...
                                                                 "LineWidth", 2,...
                                                                 "MarkerEdgeColor", green, ...
                                                                 "MarkerFaceColor", green, ...
                                                                 "MarkerSize", 10);
hold on;
semilogy(SNRdB_array_SM_ZF, BER_SM_ZF_array, "p--", "Color", blue,...
                                                    "LineWidth", 2,...
                                                    "MarkerEdgeColor", blue, ...
                                                    "MarkerFaceColor", blue, ...
                                                    "MarkerSize", 10);
hold on;
semilogy(SNRdB_array_QSM_ZF, BER_QSM_ZF_array, "s--", "Color", green,...
                                                      "LineWidth", 2,...
                                                      "MarkerEdgeColor", green, ...
                                                      "MarkerFaceColor", green, ...
                                                      "MarkerSize", 10);
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 14);
xlabel("$E_b / N_0$", "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend("QPMM, ($4 \times 4$, BPSK, $l=12$)",...
       "PMM, ($4 \times 4$, QPSK, $l=12$)",...
       "SM-JMLD, ($4 \times 4$, 1024-QAM, $l=12$)",...
       "QSM-JMLD, ($4 \times 4$, 256-QAM, $l=12$)",...
       "SM-ZF, ($4 \times 4$, 1024-QAM, $l=12$)",...
       "QSM-ZF, ($4 \times 4$, 256-QAM, $l=12$)",...
       "Location", "northeast", "FontSize", 14, "Interpreter", "latex");
ylim([1e-4 1]);
grid;
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig7_save
    set(fig7, "Units", "Inches");
    pos = get(fig7, "Position");
    set(fig7, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig7, "Figures/Figure7", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-8
clear all;
clc;
fig8_save = true;

% Complexity of QPMM with C-MLD////////////////////////////////////////////
Nd = 4;
M = 2;
np = floor(log2(factorial(Nd)));
Np = 2^np;
QPMM_CMLD_complexity = Np^2 * Nd * (6 * M + 6);
% /////////////////////////////////////////////////////////////////////////

% Complexity of SM with ZF/////////////////////////////////////////////////
Nt = 4;
Nr = 4;
M = 1024;
SM_ZF_complexity = 2 * Nt * M + 2 * Nt + 8 * Nt^2 * Nr + Nt * Nr;
% /////////////////////////////////////////////////////////////////////////

% Complexity of QSM with ZF////////////////////////////////////////////////
Nt = 4;
Nr = 4;
M = 256;
QSM_ZF_complexity = 4 * Nt^2 * M + 2 * Nt + 8 * Nt^2 * Nr + Nt * Nr;
% /////////////////////////////////////////////////////////////////////////

% Complexity of SM with Joint MLD//////////////////////////////////////////
Nt = 4;
Nr = 4;
M = 1024;
SM_JMLD_complexity = 8 * Nr * Nt * M;
% /////////////////////////////////////////////////////////////////////////

% Complexity of QSM with Joint MLD/////////////////////////////////////////
Nt = 4;
Nr = 4;
M = 256;
QSM_JMLD_complexity = 8 * Nr * Nt^2 * M;
% /////////////////////////////////////////////////////////////////////////

% Figure///////////////////////////////////////////////////////////////////
SetColorPalette()
fig8 = figure;
tiledlayout(1, 1, "TileSpacing", "Compact", "Padding", "Compact");
nexttile
x = categorical(["QPMM", "SM-ZF", "QSM-ZF", "SM-JMLD", "QSM-JMLD"]);
x = reordercats(x, ["QPMM", "SM-ZF", "QSM-ZF", "SM-JMLD", "QSM-JMLD"]);
y = [QPMM_CMLD_complexity, SM_ZF_complexity, QSM_ZF_complexity, SM_JMLD_complexity, QSM_JMLD_complexity];
b = bar(x, y, 0.5);
b.FaceColor = "flat";
b.CData(1, :) = red;
b.CData(2, :) = blue;
b.CData(3, :) = green;
b.CData(4, :) = yellow;
b.CData(5, :) = purple;
xtips = b.XEndPoints;
ytips = b.YEndPoints;
labels = string(b.YData);
text(xtips, ytips, labels, "HorizontalAlignment", "center", "VerticalAlignment",...
     "bottom", "FontSize", 14, "Interpreter", "latex");
set(gca, "TickLabelInterpreter", "latex");
set(gca, "FontSize" , 14)
title("$N_T=4$, $N_R=4$, $l=12$", "Interpreter", "latex");
xlabel("Scheme", "Interpreter", "latex");
ylabel("Complexity", "Interpreter", "latex");
grid;
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig8_save
    set(fig8, "Units", "Inches");
    pos = get(fig8, "Position");
    set(fig8, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig8, "Figures/Figure8", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-9
clear all;
clc;
fig9_save = false;

% QPMM (4x4)///////////////////////////////////////////////////////////////
load("Values/QPMM_NT4_NR4_M2.mat");
SNRdB_array = QPMM_NT4_NR4_M2(1, :);
BER_QPMM_4x4_array = QPMM_NT4_NR4_M2(3, :);
% /////////////////////////////////////////////////////////////////////////

% QPMM (2x6)///////////////////////////////////////////////////////////////
load("Values/QPMM_NT2_NR6_M32.mat");
BER_QPMM_2x6_array = QPMM_NT2_NR6_M32(3, :);
% /////////////////////////////////////////////////////////////////////////

% QPMM (6x2)///////////////////////////////////////////////////////////////
load("Values/QPMM_NT6_NR2_M32.mat");
BER_QPMM_6x2_array = QPMM_NT6_NR2_M32(3, :);
% /////////////////////////////////////////////////////////////////////////

% Figure///////////////////////////////////////////////////////////////////
SetColorPalette()
fig9 = figure;
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
xlabel("$E_b / N_0$", "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend("QPMM, ($4 \times 4$, BPSK, $l=12$)",...
       "QPMM, ($2 \times 6$, 32-QAM, $l=12$)",...
       "QPMM, ($6 \times 2$, 32-QAM, $l=12$)",...
       "Location", "northeast", "FontSize", 14, "Interpreter", "latex");  
ylim([1e-4 1e-1]);
grid;
% /////////////////////////////////////////////////////////////////////////

% Figure Save//////////////////////////////////////////////////////////////
if fig9_save
    set(fig9, "Units", "Inches");
    pos = get(fig9, "Position");
    set(fig9, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig9, "Figures/Figure9", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-10
clear all;
clc;
fig10_save = false;

% QPMM/////////////////////////////////////////////////////////////////////
load("Values/QPMM_NT4_NR4_M4.mat");
SNRdB_array = QPMM_NT4_NR4_M4(1, :);
BER_QPMM_array = QPMM_NT4_NR4_M4(3, :);
% /////////////////////////////////////////////////////////////////////////

% PMM//////////////////////////////////////////////////////////////////////
load("Values/PMM_NT5_NR5_M4.mat");
BER_PMM_array = PMM_NT5_NR5_M4(3, :);
% /////////////////////////////////////////////////////////////////////////

% Figure///////////////////////////////////////////////////////////////////
SetColorPalette()
fig10 = figure;
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
xlabel("$E_b / N_0$", "Interpreter", "latex");
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
if fig10_save
    set(fig10, "Units", "Inches");
    pos = get(fig10, "Position");
    set(fig10, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig10, "Figures/Figure10", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-11
clear all;
clc;
fig11_save = false;

% Figure-11a///////////////////////////////////////////////////////////////
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
fig11 = figure;
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

% Figure-11b///////////////////////////////////////////////////////////////
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
if fig11_save
    set(fig11, "Units", "Inches");
    pos = get(fig11, "Position");
    set(fig11, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig11, "Figures/Figure11", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-12
clear all;
clc;
fig12_save = false;

% Figure-12a///////////////////////////////////////////////////////////////
% QPMM - Joint MLD=========================================================
load("Values/QPMM_NT2_NR2_M2_JointMLD.mat");
SNRdB_array = QPMM_NT2_NR2_M2_JointMLD(1, :);
BER_QPMM_JointMLD_array = QPMM_NT2_NR2_M2_JointMLD(3, :);
% =========================================================================

% QPMM - C-MLD=============================================================
load("Values/QPMM_NT2_NR2_M2_CMLD.mat");
BER_QPMM_CMLD_array = QPMM_NT2_NR2_M2_CMLD(3, :);
% =========================================================================

% Figure===================================================================
SetColorPalette()
fig12 = figure;
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
xlabel(["$E_b / N_0$", "(a)"], "Interpreter", "latex");
ylabel("BER", "Interpreter", "latex");
legend("Joint MLD",...
       "C-MLD",...
       "Location", "southwest", "FontSize", 12, "Interpreter", "latex");  
ylim([1e-4 1e-1]);
grid;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Figure-12b///////////////////////////////////////////////////////////////
% PMM - Joint MLD==========================================================
load("Values/PMM_NT2_NR2_M2_JointMLD.mat");
SNRdB_array = PMM_NT2_NR2_M2_JointMLD(1, :);
BER_PMM_JointMLD_array = PMM_NT2_NR2_M2_JointMLD(3, :);
% =========================================================================

% PMM - LCD================================================================
load("Values/PMM_NT2_NR2_M2_LCD.mat");
BER_PMM_LCD_array = PMM_NT2_NR2_M2_LCD(3, :);
% =========================================================================

% PMM - C-MLD==============================================================
load("Values/PMM_NT2_NR2_M2_CMLD.mat");
BER_PMM_CMLD_array = PMM_NT2_NR2_M2_CMLD(3, :);
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
xlabel(["$E_b / N_0$", "(b)"], "Interpreter", "latex");
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
if fig12_save
    set(fig12, "Units", "Inches");
    pos = get(fig12, "Position");
    set(fig12, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig12, "Figures/Figure12", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% FIGURE-13
clear all;
clc;
fig13_save = false;

% Figure-13a///////////////////////////////////////////////////////////////
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
fig13 = figure("Position", [100 100 1300 800]);
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

% Figure-13b///////////////////////////////////////////////////////////////
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

% Figure-13c///////////////////////////////////////////////////////////////
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

% Figure-13d///////////////////////////////////////////////////////////////
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

% Figure-13e///////////////////////////////////////////////////////////////
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

% Figure-13f///////////////////////////////////////////////////////////////
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
if fig13_save
    set(fig13, "Units", "Inches");
    pos = get(fig13, "Position");
    set(fig13, "PaperPositionMode", "Auto", "PaperUnits", "Inches", "PaperSize", [pos(3), pos(4)]);
    print(fig13, "Figures/Figure13", "-dpdf", "-r0");
end
% /////////////////////////////////////////////////////////////////////////

%% INNER FUNCTIONS (TOTAL OF 2)
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