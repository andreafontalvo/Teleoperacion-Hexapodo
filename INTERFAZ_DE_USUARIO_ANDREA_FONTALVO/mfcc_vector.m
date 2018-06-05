function [output] = mfcc_vector(comando,fs)
tt = 0.025;     %tiempo en ms de muestras de voz 25ms
n = tt*fs;      %Ancho ventana
nover = 0.25*n; %overlap
n_coefs = 14;   %MFCCs a tomar
comando_mfcc = melcepst(comando,fs,'Mta',n_coefs,floor(3*log(fs)),n,n-nover);
comando_vector=comando_mfcc';
comando_vector=comando_vector(:)';
comando_vector=comando_vector';
load('Net7.mat')
output = net7(comando_vector);
