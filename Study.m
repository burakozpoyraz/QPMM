clear all;
clc;

Nt = 2;
Nr = 2;
M = 2;
Nd = min(Nt, Nr);
np = floor(log2(factorial(Nd)));
Np = 2^np;
num_iter222 = (Np^2 * M^Nd)^2;
time222 = 2.8;

Nt = 2;
Nr = 2;
M = 4;
Nd = min(Nt, Nr);
np = floor(log2(factorial(Nd)));
Np = 2^np;
num_iter224 = (Np^2 * M^Nd)^2;
time224 = (2.8 * num_iter224 / num_iter222);

Nt = 4;
Nr = 4;
M = 2;
Nd = min(Nt, Nr);
np = floor(log2(factorial(Nd)));
Np = 2^np;
num_iter442 = (Np^2 * M^Nd)^2;
time442 = (2.8 * num_iter442 / num_iter222) / 3600;

%%
QPMM_NT2_NR2_M4_Theoretical = [SNRdB_array; BER_QPMM_NT2_NR2_M4_theo];
QPMM_NT2_NR2_M2_Theoretical = [SNRdB_array; BER_QPMM_NT2_NR2_M2_theo];