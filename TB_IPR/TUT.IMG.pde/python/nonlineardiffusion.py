# -*- coding: utf-8 -*-
"""
Created on Fri Feb 27 14:30:18 2015

@author: yann
"""

import numpy as np
from scipy import ndimage, misc
import matplotlib.pyplot as plt
import skimage


def c(I, alpha):
    # diffusion coefficient
    # I: image
    # alpha: diffusion parameter
    return np.exp(-(I/alpha)**2)


def nonlinearDiffusion(I, nbIter, alpha, dt):
    # linear diffusion
    # I: image
    # nbIter: number of iterations
    # dt: step time
    hW = np.array([[1, -1, 0]])
    hE = np.array([[0, -1, 1]])
    hN = np.transpose(hW)
    hS = np.transpose(hE)

    Z = I

    for i in range(nbIter):
        #print "%d" % i
        gW = ndimage.convolve(Z, hW, mode='constant')
        gE = ndimage.convolve(Z, hE, mode='constant')
        gN = ndimage.convolve(Z, hN, mode='constant')
        gS = ndimage.convolve(Z, hS, mode='constant')

        Z = Z + dt*(c(np.abs(gW), alpha)*gW + c(np.abs(gE), alpha)*gE
                    + c(np.abs(gN), alpha)*gN + c(np.abs(gS), alpha)*gS)

    return Z


alpha = 0.1
dt = .05
I = skimage.io.imread("cerveau.png")/255.

F = nonlinearDiffusion(I, 10, alpha, dt)
F2 = nonlinearDiffusion(I, 50, alpha, dt)
skimage.io.imsave("cerveau_nld_10.png", F)
skimage.io.imsave("cerveau_nld_50.png", F2)
plt.subplot(1, 3, 1)
plt.imshow(I, cmap=plt.cm.gray)
plt.subplot(1, 3, 2)
plt.imshow(F, cmap=plt.cm.gray)
plt.subplot(1, 3, 3)
plt.imshow(F2, cmap=plt.cm.gray)
