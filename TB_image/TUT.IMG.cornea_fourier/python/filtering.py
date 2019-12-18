#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 12 15:18:48 2015

@author: yann
"""
import imageio
import numpy as np
from scipy import misc
import matplotlib.pyplot as plt  # plots


def LowPassFilter(spectrum, cut):
    """Low pass filter of the FFT (spectrum)
    The shape of this filter is a square. fftshift has been applied so that 
    frequency 0 lays at center of spectrum image
    @param spectrum: FFT2 transform
    @param cut     : cut value of filter (no physical unit, only number of pixels)
    """
    X, Y = spectrum.shape
    mask = np.zeros((X, Y), "int")
    mx = int(X/2)
    my = int(Y/2)
    mask[mx-cut:mx+cut, my-cut:my+cut] = 1
    f = spectrum * mask
    plt.figure
    plt.imshow(abs(f))
    plt.title('Low pass filter')
    return f


def HighPassFilter(spectrum, cut):
    """High pass filter of the FFT (spectrum)
    The shape of this filter is a square. fftshift has been applied so that 
    frequency 0 lays at center of spectrum image
    @param spectrum: FFT2 transform
    @param cut     : cut value of filter (no physical unit, only number of pixels)
    """
    X, Y = spectrum.shape
    mask = np.ones((X, Y), "int")
    mx = int(X/2)
    my = int(Y/2)
    mask[mx-cut:mx+cut, my-cut:my+cut] = 0
    f = spectrum * mask
    plt.figure
    plt.imshow(abs(f))
    plt.title('High pass filter')
    return f

# Display spectrum and phase in an image (grayscale)


def viewSpectrumPhase(amplitude, phase):
    plt.figure()
    plt.subplot(1, 2, 1)
    plt.imshow(np.log(1+amplitude), plt.cm.gray)
    plt.title('amplitude')

    plt.subplot(1, 2, 2)
    mmax = np.max(phase)
    mmin = np.min(phase)
    if (mmax == mmin):
        B = 0
    else:
        B = 255*(phase-mmin)/(mmax-mmin)

    plt.imshow(B, plt.cm.gray)
    plt.title('phase')


cornea = imageio.imread('cornee.png')

spectre = np.fft.fftshift(np.fft.fft2(cornea))

L = LowPassFilter(spectre, 30)
viewSpectrumPhase(abs(L), np.angle(L))
corneaLP = np.real(np.fft.ifft2(np.fft.fftshift(L)))

H = HighPassFilter(spectre, 30)
viewSpectrumPhase(abs(H), np.angle(H))
corneaHP = np.real(np.fft.ifft2(np.fft.fftshift(H)))

plt.figure()
plt.subplot(1, 2, 1)
plt.imshow(corneaLP, plt.cm.gray)
plt.title('reconstruction after LP filtering')
plt.subplot(1, 2, 2)
plt.imshow(corneaHP, plt.cm.gray)
plt.title('reconstruction after HP filtering')

# save
imageio.imwrite('corneaLP.png', corneaLP)
imageio.imwrite('corneaHP.png', corneaHP)
