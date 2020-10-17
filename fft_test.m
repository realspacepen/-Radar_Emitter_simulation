% --------------------------------------------------------

clc
clear
close all
f0=100;%f0=100Hz
fs = 2000;%采样率
ts = 1/fs;%采样周期
t=0:ts:2/f0;%t决定了序列长度，f0/fs=一个周期，
%X(nT)=sin(2pi*f*nT)=sin(2pi*f*n/fs)
x = sin(2*pi*f0*t) ;
plot(x)
y=fft(x);
f = (0:length(y)-1)*fs/length(y);
% figure;
% plot(f,abs(y));
% 该变换还会生成尖峰的镜像副本，该副本对应于信号的负频率。
% 为了更好地以可视化方式呈现周期性，可以使用 fftshift 函数对变换执行以零为中心的循环平移。
n = length(x);
fshift = (-n/2:n/2-1)*(fs/n);
yshift = fftshift(y);
figure;
plot(fshift,abs(yshift));
% --------------------------------------------------------