#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 18 14:29:48 2018

@author: yann
"""

import matplotlib.pyplot as plt
import numpy as np
from scipy import ndimage

import imageio


def hist_stretch(I):
    # histogram stretching
    # returns values of I linearly stretched to range [0;1]
    I = I - np.min(I)
    I = I / np.max(I)
    return I


def amf(I, Smax):
    """
    Adaptive median filter
    I: grayscale image
    Smax: maximal size of neighborhood. Limits the effect of median filter
    """
    f = np.copy(I)
    nx, ny = I.shape

    sizes = np.arange(1, Smax, 2)
    zmin = np.zeros((nx, ny, len(sizes)))
    zmax = np.zeros((nx, ny, len(sizes)))
    zmed = np.zeros((nx, ny, len(sizes)))

    for k, s in enumerate(sizes):
        zmin[:, :, k] = ndimage.minimum_filter(I, s)
        zmax[:, :, k] = ndimage.maximum_filter(I, s)
        zmed[:, :, k] = ndimage.median_filter(I, s)

    isMedImpulse = np.logical_or(zmin == zmed, zmax == zmed)

    for i in range(nx):
        for j in range(ny):
            k = 0
            while k < len(sizes)-1 and isMedImpulse[i, j, k]:
                k += 1

            if I[i, j] == zmin[i, j, k] or I[i, j] == zmax[i, j, k] or k == len(sizes):
                f[i, j] = zmed[i, j, k]
    return f


# uniform noise
fig = plt.figure()
S = 32
a = 0
b = 255
R1 = a + (b-a) * np.random.rand(S, S)
plt.imshow(R1)
imageio.imwrite("uniform_noise.png", R1)
# plt.show()
fig = plt.figure()
plt.hist(R1.flatten(), 256)
# plt.show()
fig.savefig("histo_uniform.pdf", bbox_inches='tight')

# gaussian noise
fig = plt.figure()
a = 0
b = 1
R2 = a + (b-a)*np.random.randn(S, S)
R2 = hist_stretch(R2)
plt.imshow(R2)
# plt.show()
fig = plt.figure()
plt.hist(R2.flatten(), 256)
fig.savefig("histo_gaussian.pdf", bbox_inches='tight')
# plt.show()
imageio.imwrite("gaussian_noise.png", R2)

# salt and pepper noise
fig = plt.figure()
a = 0.05
b = 0.05
R3 = 0.5 * np.ones((S, S))
X = np.random.rand(S, S)
R3[X <= a] = 0
R3[(X > a) & (X <= (a+b))] = 1
R3 = hist_stretch(R3)
plt.imshow(R3)
fig = plt.figure()
# plt.show()
plt.hist(R3.flatten(), 256)
fig.savefig("histo_sp.pdf", bbox_inches='tight')
# plt.show()
imageio.imwrite("sp_noise.png", R3)

# exponential noise
fig = plt.figure()
a = 1
R4 = -1/a * np.log(1-np.random.rand(32, 32))
R4 = hist_stretch(R4)
plt.imshow(R4)
# plt.show()
fig = plt.figure()
plt.hist(R4.flatten(), 256)
fig.savefig("histo_exponential.pdf", bbox_inches='tight')
# plt.show()
imageio.imwrite("exponential_noise.png", R4)

# noise estimation
fig = plt.figure()
A = imageio.imread('jambe.png')
roi = A[160:200, 200:240]
plt.hist(roi.flatten(), 255)
fig.savefig("histo_roi_leg.pdf", bbox_inches='tight')
# plt.show()

# add exponential noise to image
nx, ny = A.shape
expnoise = -1/.5 * np.log(1-np.random.rand(nx, ny))
expnoise = expnoise / np.max(expnoise)
B = A + 255*expnoise
B = hist_stretch(B)
fig = plt.figure()
plt.imshow(B, cmap='gray')
imageio.imwrite("leg_exponential.png", B)
roi = B[160:200, 200:240]
fig = plt.figure()
plt.hist(roi.flatten()*255, 255)
fig.savefig("hist_exp.pdf", bbox_inches='tight')
# plt.show()

# add gaussian noise to image
nx, ny = A.shape
gaussnoise = 50*np.random.rand(nx, ny)
B = A + gaussnoise
B = hist_stretch(B)
fig = plt.figure()
plt.imshow(B, cmap='gray')
imageio.imwrite("leg_gaussian.png", B)
roi = B[160:200, 200:240]
fig = plt.figure()
plt.hist(roi.flatten()*255, 255)
fig.savefig("hist_gauss.pdf", bbox_inches='tight')
# plt.show()

# add salt and pepper noise and perform restoration
# salt and pepper noise
a = 0.05
b = 0.05
spnoise = 0.5 * np.ones((nx, ny))
X = np.random.rand(nx, ny)
B = A.copy()
B[X <= a] = 0
B[(X > a) & (X <= (a+b))] = 255
fig = plt.figure()
plt.imshow(B, cmap='gray')
imageio.imwrite("leg_sp.png", B)
# plt.show()

# filtering by convolution
# average filtering
B1 = ndimage.uniform_filter(B, 5)
imageio.imwrite("leg_uniform.png", B1)
B2 = ndimage.minimum_filter(B, 3)
imageio.imwrite("leg_minimum.png", B2)
B3 = ndimage.maximum_filter(B, 3)
imageio.imwrite("leg_maximum.png", B3)
B4 = ndimage.median_filter(B, 7)
imageio.imwrite("leg_median.png", B4)
B5 = amf(B, 7)
plt.imshow(B5, cmap='gray')
imageio.imwrite("leg_amf.png", B5)
# plt.show()
