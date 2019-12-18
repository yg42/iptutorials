#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 12 15:18:48 2015

@author: yann
"""

import numpy as np
from scipy import misc
import matplotlib.pyplot as plt  # plots
import imageio

# Display spectrum and phase in an image (grayscale)


def viewSpectrumPhase(amplitude, phase):
    plt.figure()
    plt.subplot(1, 2, 1)
    plt.imshow(np.log(1+amplitude), plt.cm.gray)

    plt.subplot(1, 2, 2)
    mmax = np.max(phase)
    mmin = np.min(phase)
    if (mmax == mmin):
        B = 0
    else:
        B = 255*(phase-mmin)/(mmax-mmin)

    plt.imshow(B, plt.cm.gray)


def enhancement(image):
    mmax = np.max(image)
    mmin = np.min(image)
    B = np.zeros(image.shape, "int")
    if (mmax != mmin):
        B = np.round(255*(image-mmin)/(mmax-mmin))

    return B


cornea = imageio.imread('cornee.png')

plt.subplot(131)
plt.imshow(cornea, cmap=plt.cm.gray)

# Transformée de Fourier
# complex spectrum
spectre = np.fft.fftshift(np.fft.fft2(cornea))

A = abs(spectre)
G = np.angle(spectre)

viewSpectrumPhase(A, G)

# Transformée de Fourier inverse
cornee2 = np.real(np.fft.ifft2(np.fft.fftshift(spectre)))
plt.figure()
plt.imshow(cornee2, cmap=plt.cm.gray)
plt.title('TF inverse')

# Transformée de Fourier inverse, sans la phase
cornee_sansphase = np.real(np.fft.ifft2(np.fft.fftshift(A)))
plt.figure()
plt.imshow(cornee_sansphase, cmap=plt.cm.gray)
plt.title('TF inverse sans la phase')
imageio.imwrite('sansphase.png', cornee_sansphase)

# Transformée de Fourier inverse avec la phase uniquement
complex_phase = np.exp(1j*G)
cornee_phase = np.real(np.fft.ifft2(np.fft.fftshift(complex_phase)))
cornee_phase = enhancement(cornee_phase)
plt.figure()
plt.imshow(cornee_phase, cmap=plt.cm.gray)
plt.title('TF inverse phase uniquement')
imageio.imwrite('phase.png', enhancement(cornee_phase))
# save file
#imageio.imwrite('test.png', brain)
