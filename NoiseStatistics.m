%============ NOISE STATISTICS ANALYSIS AFTER POST-PROCESSING =============
% This algorithm evaluates the impact of the post-processing operation
% (unitary transformation using SVD) on the statistical properties of
% complex Gaussian noise in a MIMO system. Specifically, it checks whether
% the mean and variance of the noise remain unchanged after applying the
% Hermitian of the left singular vectors of the channel matrix (U' * n).
%
% DEVELOPER: Burak Özpoyraz
%
% DATE: 19.08.2025
%==========================================================================

clear all;
clc;

%% PARAMETERS
num_iterations = 1e5; % Number of iterations for Monte Carlo simulation
Nt = 4; % Number of transmit antennas
Nr = 4; % Number of receive antennas
N0 = 1; % Noise power (W)

%% MONTE CARLO SIMULATION
mean_n_sum = 0;
var_n_sum = 0;
mean_n_tilde_sum = 0;
var_n_tilde_sum = 0;
for iter_index = 1 : num_iterations
    % Channel & Noise//////////////////////////////////////////////////////
    H = (randn(Nr, Nt) + 1i * randn(Nr, Nt)) / sqrt(2);
    n = sqrt(N0 / 2) * (randn(Nr, 1) + 1i * randn(Nr, 1));
    % /////////////////////////////////////////////////////////////////////

    % SVD Decomposition////////////////////////////////////////////////////
    [U, ~, ~] = svd(H, "econ");
    % /////////////////////////////////////////////////////////////////////

    % Post-Processing//////////////////////////////////////////////////////
    n_tilde = U' * n;
    % /////////////////////////////////////////////////////////////////////
    
    % Noise Statistics/////////////////////////////////////////////////////
    % Before Post-Processing===============================================
    mean_n_sum = mean_n_sum + mean(n);
    var_n_sum = var_n_sum + var(n);
    % =====================================================================

    % After Post-Processing================================================
    mean_n_tilde_sum = mean_n_tilde_sum + mean(n_tilde);
    var_n_tilde_sum = var_n_tilde_sum + var(n_tilde);
    % =====================================================================
    % /////////////////////////////////////////////////////////////////////
end

%% ERROR CALCULATION
% Average Noise Statistics/////////////////////////////////////////////////
% Before Post-Processing===================================================
mean_n = mean_n_sum / num_iterations;
var_n = var_n_sum / num_iterations;
% =========================================================================

% After Post-Processing====================================================
mean_n_tilde = mean_n_tilde_sum / num_iterations;
var_n_tilde = var_n_tilde_sum / num_iterations;
% =========================================================================
% /////////////////////////////////////////////////////////////////////////

% Error Calculation////////////////////////////////////////////////////////
% Note: The post-processing does not change the noise statistics since U is
%       a unitary matrix. Hence errors calculated below are expected to be
%       significantly close to zero depending on the number of iterations.

error_mean = norm(mean_n - mean_n_tilde)^2;
error_var = norm(var_n - var_n_tilde)^2;
% /////////////////////////////////////////////////////////////////////////