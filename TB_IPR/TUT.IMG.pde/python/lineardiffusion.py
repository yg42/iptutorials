# -*- coding: utf-8 -*-
"""
Created on Fri Feb 27 11:56:57 2015

@author: yann
"""
import numpy as np
from scipy import ndimage, misc
import matplotlib.pyplot as plt


def linearDiffusion(I, nbIter, dt):
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
        gW = ndimage.convolve(Z, hW, mode='constant')
        gE = ndimage.convolve(Z, hE, mode='constant')
        gN = ndimage.convolve(Z, hN, mode='constant')
        gS = ndimage.convolve(Z, hS, mode='constant')
        Z = Z + dt*(gW+gE+gN+gS)
    return Z


I = imageio.imread("cerveau.png")/255.
F = linearDiffusion(I, 10, .05)
F2 = linearDiffusion(I, 50, .05)
imageio.imwrite("cerveau_ld_10.png", F)
imageio.imwrite("cerveau_ld_50.png", F2)

plt.subplot(1, 3, 1)
plt.imshow(I, cmap=plt.cm.gray)
plt.subplot(1, 3, 2)
plt.imshow(F, cmap=plt.cm.gray)
plt.subplot(1, 3, 3)
plt.imshow(F2, cmap=plt.cm.gray)
