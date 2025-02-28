%% Performance of Binary Modulation in Rayleigh Fading Channel
%% Transmission through a frequency nonselective channel
clc;
clear;
Eb = 1; % Energy per bit
EbNo_dB = 0:5:35; % Vary the average SNR
No_over_2 = Eb * 10.^(-EbNo_dB/10); % Noise power
sigma = 1; % Rayleigh parameter
var = sigma^2;
BER = zeros(1, length(EbNo_dB));

% Monte Carlo simulation for Error Probability Calculation
for i = 1:length(EbNo_dB)
    no_errors = 0;
    no_bits = 0;

    % Assume all-zero codeword is transmitted (m = 0)
    while no_errors <= 10 % Ensuring at least 10 errors for accuracy
        u = rand;
        alpha = sigma * sqrt(-2 * log(u)); % Rayleigh-distributed variable
        noise = sqrt(No_over_2(i)) * randn; % Gaussian noise with variance No/2
        y = alpha * sqrt(Eb) + noise; % Received signal

        % Decision Rule
        if y <= 0
            y_d = 1; % Error occurs
        else
            y_d = 0;
        end

        no_bits = no_bits + 1;
        no_errors = no_errors + y_d;
    end

    BER(i) = no_errors / no_bits; % Estimated error probability
end

% Theoretical Error Probability Calculation
rho_b = (Eb ./ No_over_2) * var;
P2 = 0.5 * (1 - sqrt(rho_b ./ (1 + rho_b))); % Theoretical value

% Plot the Results
figure;
semilogy(EbNo_dB, BER, '-*', EbNo_dB, P2, '-o');
title('Monte Carlo Simulation for BPSK Performance in Rayleigh Channel');
xlabel('Average SNR/bit (dB)');
ylabel('Error Probability');
legend('Monte Carlo Simulation', 'Theoretical Value');
grid on;
