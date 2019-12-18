%% Demo - tutorial wavelet decomposition
s = [4, 8, 2, 3, 5, 18, 19, 20];
C = simpleWaveDec(s, 3);

srec = simpleWaveRec(C);