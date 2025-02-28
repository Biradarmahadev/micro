%BPSK simulation
Pe_BPSK_id = 0.5 * (1 - sqrt((var * SNR) ./ (1 + var * SNR)));

%BFSK simulation (coherent)
Pe_BFSK_id = 0.5 * (1 - sqrt(var * SNR ./ (2 + (var * SNR)))); 

%DPSK simulation
Pe_DPSK_id = 0.5 ./ (1 + var * SNR);

% Comparison of Error Performance for AWGN and Rayleigh Fading Channels
Pe_BPSK_NF = 0.5 * erfc(sqrt(SNR));
Pe_BFSK_NF = 0.5 * erfc(sqrt(SNR / 2));
Pe_DPSK_NF = 0.5 * exp(-SNR); % Non-coherent

% Plot BER performance
figure(3);
semilogy(SNR_db, Pe_BPSK_id, 'r.-', ...
         SNR_db, Pe_BFSK_id, 'r*-', ...
         SNR_db, Pe_DPSK_id, 'r--', ...
         SNR_db, Pe_BPSK_NF, 'b.-', ...
         SNR_db, Pe_BFSK_NF, 'b*-', ...
         SNR_db, Pe_DPSK_NF, 'b--');

axis([-5 SNR_limit 0.000001 1]);
title('Performance of BPSK, BFSK, DPSK');
xlabel('SNR (dB)');
ylabel('Probability of Error');
legend('Pe of BPSK with fading', 'Pe of BFSK with fading', 'Pe of DPSK with fading', ...
       'Pe of BPSK without fading', 'Pe of BFSK without fading', 'Pe of DPSK without fading');
grid on;
