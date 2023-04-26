% Program to seperate Human voice and background music from music file
[a,fs]=audioread('C:\Users\YASH PRATAP SINGH\OneDrive - Directorate of School Education, AMU, Aligarh\Desktop\mixed_audio_file.wav');
% setting length of array in order of 2^n and thus accordingly chopping our signal
b=a([1:176400],:);
Length_audio=length(b);
df=fs/Length_audio;
frequency_audio=-fs/2:df:fs/2-df;
figure
% time domain plot 
plot(b)
title(' Input Audio');
xlabel('Time(s)');
ylabel('Amplitude');
%sound(a,fs);

%%
FFT_audio_in=fftshift(fft(b))/length(fft(b));
f4=FFT_audio_in;
figure
plot(frequency_audio,abs(FFT_audio_in));
title('FFT of Input Audio');
xlabel('Frequency(Hz)');
ylabel('Amplitude');
% Initializing zero matrix of same size as that of original matrix
%f2 matrix is for background music and f3 contains human voice
f3=zeros(176400,2);
f2=zeros(176400,2);
%seleting particular band that dominates our signal i.e. has contributed
%maximum to our signal( decided by looking at amplitude in frequency domain)
%and making new matrix
% taking elements of matrix from m to n and 1048576-n to 1048576-m to get
% good result of selection of frequencies.
for i=1:176400
    for j=1:2
       if  (i>=86200 && i<=87000) 
        f2(i,j)=FFT_audio_in(i,1);
      end
      if ((i>=160&&i<=1800))||(i>=3400&&i<=4000)
        f3(i,j)=FFT_audio_in(i,1);
      end
    end
end
%f2 is for background music and f3 (has dominating part )is for voice of singer 
%for converting fft of human voice to audio file
f1=(f3);   
l1=length(f1);
sign=(ifft(ifftshift((f1)*length(b))));
fs=44100;
de=fs/l1;
fa=-fs/2:de:fs/2-de;
figure
plot(fa,abs(f1))
title('FFT of Human Voice Audio');
xlabel('Frequency(Hz)');
ylabel('Amplitude');
% we want real part of our signal, that's why we are extracting that using
% Re(z)=(z+z')/2
outh=(sign+transpose(ctranspose(sign)))*0.5; 
audiowrite('human.wav',outh,fs);

% audioOut = shiftPitch(outh,3);
% audiowrite('human_female.wav',audioOut,fs);

figure
%plot of output 
plot(outh);
%sound(outh,fs);
title('human voice Audio');
xlabel('time');
ylabel('Amplitude');
%%
f1=(f2);     
l1=length(f1);
sign=(ifft(ifftshift((f1)*length(b))));
fs=44100;
de=fs/l1;
fa=-fs/2:de:fs/2-de;
figure
plot(fa,abs(f1))
title('FFT of Background sound ');
xlabel('Frequency(Hz)');
ylabel('Amplitude');

outb=(sign+transpose(ctranspose(sign)))*0.5; 
audiowrite('back.wav',outb,fs);
figure
%plot of output 
plot(outb);
% sound(outb,fs);
title('Background Audio');
xlabel('time');
ylabel('Amplitude');