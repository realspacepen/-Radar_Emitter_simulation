%finished:2020-10-17 20:42:18
%created by hjr
% clear all; 
% close all;
% clc;
function Bpsk_barker13=barker13(fc,fs,Baud)
%要求信号脉宽0.65us，也就是Baud=2e7
%脉宽=码元数*码元宽度
g=[1,1,1,1,1,0,0,1,1,0,1,0,1];%13位巴克码
% fc=2e8;                  %载波频率
% fs=2e9;                  %采样率
% Baud=2e7;                  %波特率

t=0:1/fs:(fs/Baud-1)/fs;               %这一步是关键，它决定了载波采样点和码元采样点长度一致

%生成序列
cp=[];
mod1=[];
for n=1:length(g)
    if g(n)==0
        A=zeros(1,fs/Baud);
    else 
        A=ones(1,fs/Baud);
    end
    c=sin(2*pi*fc*t);
    cp=[cp A];%code sequence generated
    mod1=[mod1 c];
end
cm=[];
mod=[];
% subplot(311);plot(cp);
%% 根据序列进行sin反相
for n=1:length(g)
    if g(n)==0
        B=ones(1,fs/Baud);     %每个值100个点 
       c=sin(2*pi*fc*t);         %载波信号
    else 
        B=ones(1,fs/Baud);
        c=sin(2*pi*fc*t+pi);     %载波信号
    end
    cm=[cm B];              %s(t)码元宽度100   
    mod=[mod c];          %与s(t)等长的载波信号
end
Bpsk_barker13=cm.*mod;
% subplot(312);plot(Bpsk_barker13);

% y=fft(Bpsk_barker13);
% f = (0:length(y)-1)*fs/length(y);
% n = length(Bpsk_barker13);
% fshift = (-n/2:n/2-1)*(fs/n);
% yshift = fftshift(y);
% subplot(313);plot(fshift,(abs(yshift)));