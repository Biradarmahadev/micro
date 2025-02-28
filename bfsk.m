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

% Histogram plot of Rayleigh random variable
figure(1);
histogram(r, 100);
title('Rayleigh Random Variable Histogram Plot');
xlabel('Random Variable R');
ylabel('Frequency');

% Rayleigh PDF plot
a = 0:0.01:10;
R = (a / var) .* exp(-(a .* a) / (2 * var));

figure(2);
plot(a, R);
title('Rayleigh PDF');
xlabel('Random Variable');
ylabel('Probability');
legend('Variance = 1');
grid on;
