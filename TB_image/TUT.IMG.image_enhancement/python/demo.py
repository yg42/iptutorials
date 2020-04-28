#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 25 11:34:54 2018

@author: yann
"""

from scipy import misc
import matplotlib.pyplot as plt
from skimage import exposure,io
import numpy as np
import sys


def displaySaveHisto(I, filename=None):
    """
    Display and save pdf (if filename provided) of histogram of image I
    """
    if np.max(I) <= 1:
        I = 255 * I
    hist, bins = np.histogram(I.flatten(), 256, range=(0, 255))
    fig = plt.figure()
    plt.bar(bins[:-1], hist, width=1)
    plt.show()
    if filename != None:
        fig.savefig(filename, bbox_inches='tight')


I = io.imread("osteoblaste.png")
I = I / np.max(I)
plt.imshow(I)
plt.show()
g = [1, 2, .5]
names = ["osteo_g1.png", "osteo_g2.png", "osteo_g05.png"]
osteo = zip(g, names)
for gamma, name in osteo:

    I2 = exposure.adjust_gamma(I, gamma)
    plt.imshow(I2)
    plt.show()
    io.imsave(name, I2)


def contrast_stretching(I, E):
    epsilon = sys.float_info.epsilon
    m = np.mean(I)
    I = I.astype("float")
    Ar = 1. / (1.+(m/(I+epsilon))**E)
    return Ar


E = [10, 20, 1000]
names = ["osteo_E10.png", "osteo_E20.png", "osteo_E1000.png"]
osteo = zip(E, names)
for e, name in osteo:
    I2 = contrast_stretching(I, e)
    I2 = I2/np.max(I2)
    plt.imshow(I2)
    plt.show()
    io.imsave(name, I2)

# histogram display
displaySaveHisto(I, "histo_osteo.pdf")

# histogram equalization
I2 = exposure.equalize_hist(I)
plt.imshow(I2)
plt.show()
io.imsave("histeq_osteo.png", I2)

displaySaveHisto(I2, "histeq_osteo_histo.pdf")

# LUT computation
hist, bins = np.histogram(255*I.flatten(), 256, range=(0, 255), density=True)
cdf = hist.cumsum()
cdf = (cdf / cdf[-1])
fig = plt.figure()
plt.plot(bins[:-1], cdf)
plt.show()
fig.savefig("lut.pdf", bbox_inches="tight")


def histeq(I):
    """
    histogram equalization, version with look-up-table
    I: original image, with values in 8 bits integer
    """
    hist, bins = np.histogram(I.flatten(), 256, range=(0, 255))
    cdf = hist.cumsum()
    cdf = (cdf / cdf[-1])

    return cdf[I]


def hist_matching(I, cdf_dest):
    """
    Histogram matching of image I, with cumulative histogram cdf_dest
    This should be normalized, between 0 and 1.

    This version uses interpolation
    """
    imhist, bins = np.histogram(I.flatten(), len(cdf_dest))
    cdf = imhist.cumsum()  # cumulative distribution function
    cdf = (cdf / cdf[-1])  # normalize between 0 and 1
    
    plt.step(bins[:-1], cdf, 'b')
    plt.step(bins[:-1], cdf_dest, 'r')
    plt.savefig('histocum_matching.pdf', bbox_inches='tight')
    plt.show()

    # first: histogram equalization
    im2 = np.interp(I.flatten(), bins[:-1], cdf)

    # 2nd: reverse function
    im3 = np.interp(im2, cdf_dest, bins[:-1])

    # reshape into image
    imres = im3.reshape(I.shape)
    return imres


def twomodegauss(m1, sig1, m2, sig2, A1, A2, k):
    """
    generates a 2 modes gaussian functions (sum of 2 gaussian functions)
    m: mean
    sig: sigma
    A: amplitude
    k: constant value

    return value is normalized, so that its sum is 1.
    """
    c1 = A1*(1/((2*np.pi)**2*sig1))
    k1 = 2*sig1**2

    c2 = A2*(1/((2*np.pi)**2*sig2))
    k2 = 2*sig2**2

    z = np.linspace(0, 1, 256)
    p = k + c1*np.exp(-(z-m1)**2/k1) + c2 * np.exp(-(z-m2)**2/k2)
    p = p / np.sum(p)

    return p.cumsum()


# apply results on phobos image
I = io.imread("phobos.jpg")
displaySaveHisto(I, "hist_phobos.pdf")


# target cdf
p = twomodegauss(.05, .1, .8, .2, .04, .01, .002)
fig = plt.figure()
plt.plot(p)
plt.show()
fig.savefig("twomodegauss.pdf", bbox_inches='tight')

# generates a two modes histogram, for testing purposes
# applies it to original image I
I2 = 255*histeq(I)
io.imsave("phobos_histeq.png", I2)
displaySaveHisto(I2, "hist_phobos_histeq.pdf")

# applies matching
I2 = hist_matching(I, p)
io.imsave("phobos_histmatch.png", I2)
plt.imshow(I2)
plt.show()

# displays histogram of resulting image
displaySaveHisto(I2, "hist_phobos_matching.pdf")
