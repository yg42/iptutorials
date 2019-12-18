% sumsin wavelet decomposition
t=0:.001:10;
signal = sin(2*pi*3*t)+2*sin(2*pi*50*t);

plot(signal); title('original')

ondelette = 'db1';
[C, S] = wavedec(signal, 5, ondelette);
A1 = appcoef(C, S, ondelette, 5);
d = detcoef(C, S, 5);

figure, plot(d); title('5th approx')

newc = wthcoef('d', C, S, 5);

s2 = waverec(newc, S, ondelette);
figure; plot(s2); title('reconstruction with ')