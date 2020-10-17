clear, clc, close all

%LFM信号本身

T = 1;%采样时间
fs =80000;%采样率
t = 0:1/fs:1; % 采样点,0:1/fs:Period*(1/f0),决定了观测长度
n = length(t); % 采样点数
% 线性调频信号 s(t)=a(t)cos[2πf0 t+πkt^2]，a(t)是包络，f0是调频频率
A_lfm = 10;
f_lfm = 20;%起始频率
k_lfm = 40000;
y_lfm = A_lfm*cos(2*pi*f_lfm*t+pi*k_lfm*t.^2);
% y_lfm=A_lfm*cos(2*pi*f_lfm*t+pi/4);
y_lfm=awgn(y_lfm,-10);
plot(y_lfm);


% define analysis parameters
wlen = 2048;                        % window length (recomended to be power of 2)
hop = wlen/4;                       % hop size (recomended to be power of 2)
nfft = 4096;                        % number of fft points (recomended to be power of 2)
% perform STFT
win = blackman(wlen, 'periodic');
[S, f, t] = stft(y_lfm, win, hop, nfft, fs);
% calculate the coherent amplification of the window
C = sum(win)/wlen;
% take the amplitude of fft(x) and scale it, so not to be a
% function of the length of the window and its coherent amplification
S = abs(S)/wlen/C;
% correction of the DC & Nyquist component
if rem(nfft, 2)                     % odd nfft excludes Nyquist point
    S(2:end, :) = S(2:end, :).*2;
else                                % even nfft includes Nyquist point
    S(2:end-1, :) = S(2:end-1, :).*2;
end
% convert amplitude spectrum to dB (min = -120 dB)
S = 20*log10(S + 1e-6);


% plot the spectrogram
figure(2)
surf(t, f, S)
shading interp
axis tight
view(0, 90)
% imwrite(figure(2),'LFM.jpg');
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
% xlabel('Time, s')
% ylabel('Frequency, Hz')
% title('Amplitude spectrogram')
set(gcf,'color','white','paperpositionmode','auto');
saveas(gcf,'LFM_pure','jpg');%png等等
% hcol = colorbar;
% set(hcol, 'FontName', 'Times New Roman', 'FontSize', 14)
% ylabel(hcol, 'Magnitude, dB')