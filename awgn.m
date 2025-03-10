clc;
close all;
N = 20000;
SNR_limit = 35;
SNR_db = -5:0.5:SNR_limit;
SNR = 10.^(SNR_db/10);
u = rand(1, N);
m = floor(2 * rand(1, N));
var = 1; % sigma^2
nstd = sqrt(var);
y = zeros(1, N);
Pe_BPSK_sim = zeros(1, length(SNR));
Pe_BFSK_sim = zeros(1, length(SNR));
Pe_DPSK_sim = zeros(1, length(SNR));

% Generate Rayleigh random variable
r = sqrt(-2 * var * log(u));

figure(1);
histogram(r, 100);
title('Rayleigh Random Variable Histogram Plot');
xlabel('Random Variable R');
ylabel('Frequency');

a = 0:0.01:10;
R = (a / var) .* exp(-(a .* a) / (2 * var));

figure(2);
plot(a, R);
title('Rayleigh PDF');
xlabel('Random Variable');
ylabel('Probability');
legend('Variance = 1');

% BPSK Simulation
Pe_BPSK_id = 0.5 * (1 - sqrt((var * SNR) ./ (1 + var * SNR)));

% BFSK Simulation (Coherent)
Pe_BFSK_id = 0.5 * (1 - sqrt(var * SNR ./ (2 + (var * SNR))));

% DPSK Simulation
Pe_DPSK_id = 0.5 ./ (1 + var * SNR);

% Comparison of Error Performance for AWGN and Rayleigh Fading Channels
Pe_BPSK_NF = 0.5 * erfc(sqrt(SNR));
Pe_BFSK_NF = 0.5 * erfc(sqrt(SNR / 2));
Pe_DPSK_NF = 0.5 * exp(-SNR); % Non-coherent

figure(3);
semilogy(SNR_db, Pe_BPSK_id, 'r.-', ...
         SNR_db, Pe_BFSK_id, 'r*-', ...
         SNR_db, Pe_DPSK_id, 'r--', ...
         SNR_db, Pe_BPSK_NF, 'b.-', ...
         SNR_db, Pe_BFSK_NF, 'b*-', ...
         SNR_db, Pe_DPSK_NF, 'b--');
axis([-5 SNR_limit 1e-6 1]);
title('Performance of BPSK, BFSK, DPSK');
xlabel('SNR (dB)');
ylabel('Probability of Error');
legend('Pe of BPSK with Fading', 'Pe of BFSK with Fading', 'Pe of DPSK with Fading', ...
       'Pe of BPSK without Fading', 'Pe of BFSK without Fading', 'Pe of DPSK without Fading');
grid on;
