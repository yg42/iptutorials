#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 12 15:18:48 2015
Example of cell density analysis (ECD - Endothelial cell density)

@author: yann
"""
import imageio
import numpy as np
from scipy import misc
from scipy import ndimage
import matplotlib.pyplot as plt  # plots
from matplotlib.backends.backend_pdf import PdfPages


plt.close('all')

# Display spectrum and phase in an image (grayscale)


def viewSpectrumPhase(amplitude, phase):
    plt.figure()
    plt.subplot(1, 2, 1)
    plt.imshow(np.log(1+amplitude), plt.cm.gray)
    plt.title('amplitude')
    imageio.imwrite('amplitude.png', np.log(1+amplitude))
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
print (cornea.shape)
X, Y = cornea.shape

spectre = np.fft.fftshift(np.fft.fft2(cornea))
amplitude = abs(spectre)

# filter amplitude
Blurred = ndimage.filters.gaussian_filter(amplitude, 5)
plt.figure
plt.imshow(np.log(1+Blurred), plt.cm.gray)
plt.title('filtered amplitude')

h = plt.figure()
plt.plot(np.log(1+Blurred[:, int(Y/2)]))
plt.title('peak observation and cells frequency')
pp = PdfPages('analyse_cornee.pdf')
h.savefig('analyse_cornee.pdf')
pp.close
