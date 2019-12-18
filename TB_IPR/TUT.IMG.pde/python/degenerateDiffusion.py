# -*- coding: utf-8 -*-
"""
Created on Fri Mar  6 14:31:52 2015

@author: yann
"""
import numpy as np
from scipy import ndimage, misc
import matplotlib.pyplot as plt


def degenerateDiffusion1(image, nbIter, dt):
    # degenerate diffusion
    # I: image
    # nbIter: number of iterations
    # dt: step time
    h = np.array([[-1, 0, 1]])
    ht = np.transpose(h)

    Zdilation = image
    Zerosion = image
    for i in range(nbIter):
        gH = ndimage.convolve(Zdilation, h, mode='constant')
        gV = ndimage.convolve(Zdilation, ht, mode='constant')

        jH = ndimage.convolve(Zerosion, h, mode='constant')
        jV = ndimage.convolve(Zerosion, ht, mode='constant')

        Zdilation = Zdilation + dt*np.sqrt(gV**2 + gH**2)
        Zerosion = Zerosion + dt*np.sqrt(jV**2 + jH**2)

    return (Zdilation, Zerosion)


def degenerateDiffusion2(image, nbIter, dt):
    # degenerate diffusion
    # I: original image
    # nbIter: number of iterations
    # dt: step time
    hW = np.array([[1, -1, 0]])
    hE = np.array([[0, -1, 1]])
    hN = np.transpose(hW)
    hS = np.transpose(hE)
    Zdilation = image
    Zerosion = image
    for i in range(nbIter):
        gW = ndimage.convolve(Zdilation, hW, mode='constant')
        gE = ndimage.convolve(Zdilation, hE, mode='constant')
        gN = ndimage.convolve(Zdilation, hN, mode='constant')
        gS = ndimage.convolve(Zdilation, hS, mode='constant')

        jW = ndimage.convolve(Zerosion, hW, mode='constant')
        jE = ndimage.convolve(Zerosion, hE, mode='constant')
        jN = ndimage.convolve(Zerosion, hN, mode='constant')
        jS = ndimage.convolve(Zerosion, hS, mode='constant')

        g = np.sqrt(np.minimum(0, -gW)**2 + np.maximum(0, gE) **
                    2 + np.minimum(0, -gN)**2 + np.maximum(0, gS)**2)
        j = np.sqrt(np.maximum(0, -jW)**2 + np.minimum(0, jE) **
                    2 + np.maximum(0, -jN)**2 + np.minimum(0, jS)**2)

        Zdilation = Zdilation + dt * g
        Zerosion = Zerosion - dt * j

    return Zdilation, Zerosion


I = imageio.imread("cerveau.png")/255.
plt.figure()
plt.subplot(2, 3, 1)
plt.imshow(I, cmap=plt.cm.gray)

(dil10, ero10) = degenerateDiffusion1(I, 10, .05)
imageio.imwrite("cerveau_dil_10.png", dil10)
imageio.imwrite("cerveau_ero_10.png", ero10)
plt.subplot(2, 3, 2)
plt.imshow(dil10, cmap=plt.cm.gray)
plt.subplot(2, 3, 3)
plt.imshow(ero10, cmap=plt.cm.gray)

(dil50, ero50) = degenerateDiffusion1(I, 50, .05)
imageio.imwrite("cerveau_dil_50.png", dil50)
imageio.imwrite("cerveau_ero_50.png", ero50)
plt.subplot(2, 3, 5)
plt.imshow(dil50, cmap=plt.cm.gray)
plt.subplot(2, 3, 6)
plt.imshow(ero50, cmap=plt.cm.gray)

##############################################################################
# more sophisticated
plt.figure()
plt.subplot(2, 3, 1)
plt.imshow(I, cmap=plt.cm.gray)

(dil10, ero10) = degenerateDiffusion2(I, 10, .05)
imageio.imwrite("cerveau_dil2_10.png", dil10)
imageio.imwrite("cerveau_ero2_10.png", ero10)
plt.subplot(2, 3, 2)
plt.imshow(dil10, cmap=plt.cm.gray)
plt.subplot(2, 3, 3)
plt.imshow(ero10, cmap=plt.cm.gray)

(dil50, ero50) = degenerateDiffusion2(I, 50, .05)
imageio.imwrite("cerveau_dil2_50.png", dil50)
imageio.imwrite("cerveau_ero2_50.png", ero50)
plt.subplot(2, 3, 5)
plt.imshow(dil50, cmap=plt.cm.gray)
plt.subplot(2, 3, 6)
plt.imshow(ero50, cmap=plt.cm.gray)
