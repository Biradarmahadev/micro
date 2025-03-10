clc; clear; close all;

nFFT = 64;
nDSC = 52;
nBitPerSym = 52;
nSym = 10^4;

EbN0dB = 0:10;
EsN0dB = EbN0dB + 10*log10(nDSC/nFFT) + 10*log10(64/80);

nErr = zeros(1, length(EbN0dB));

for ii = 1:length(EbN0dB)
    ipBit = rand(1, nBitPerSym * nSym) > 0.5;
    ipMod = 2 * ipBit - 1;
    ipMod = reshape(ipMod, nBitPerSym, nSym).';
    
    xF = [zeros(nSym, 6), ipMod(:, 1:nBitPerSym/2), zeros(nSym, 1), ipMod(:, nBitPerSym/2+1:nBitPerSym), zeros(nSym, 5)];
    
    xt = (nFFT/sqrt(nDSC)) * ifft(fftshift(xF.')).';
    xt = [xt(:, 49:64), xt];
    xt = reshape(xt.', 1, nSym * 80);
    
    nt = (1/sqrt(2)) * (randn(1, nSym * 80) + 1j * randn(1, nSym * 80));
    yt = sqrt(80/64) * xt + 10^(-EsN0dB(ii)/20) * nt;
    
    yt = reshape(yt.', 80, nSym).';
    yt = yt(:, 17:80);
    
    yF = (sqrt(nDSC)/nFFT) * fftshift(fft(yt.')).';
    yMod = yF(:, [6+[1:nBitPerSym/2], 7+[nBitPerSym/2+1:nBitPerSym]]);
    
    ipModHat = sign(real(yMod));
    ipBitHat = (ipModHat + 1) / 2;
    ipBitHat = reshape(ipBitHat.', nBitPerSym * nSym, 1).';
    
    nErr(ii) = sum(ipBitHat ~= ipBit);
end

simBer = nErr / (nSym * nBitPerSym);
theoryBer = (1/2) * erfc(sqrt(10.^(EbN0dB/10)));

figure;
semilogy(EbN0dB, theoryBer, 'bs-', 'LineWidth', 2);
hold on;
semilogy(EbN0dB, simBer, 'mx-', 'LineWidth', 2);
axis([0 10 10^-5 1]);
grid on;
legend('Theoretical BER', 'Simulated BER');
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate (BER)');
title('BER Curve for BPSK using OFDM in AWGN Channel');
