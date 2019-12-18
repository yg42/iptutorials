#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jun 11 14:59:47 2018

@author: yann
"""

import numpy as np
import matplotlib.pyplot as plt

from skimage.io import imread
from skimage.transform import radon, rescale, rotate
from scipy.signal import convolve
import skimage.io


def imsave(filename, A):
    """
    save image A in filename
    performs histogram stretching
    """
    A[A < 0] = 0
    A = A / np.max(A)
    skimage.io.imsave(filename, A)


def RamLak(width):
    """
    Ramlak filter of size width
    width must be odd
    """
    ramlak = np.zeros((2*width+1,))
    for indice, val in enumerate(np.arange(-width, width+1)):
        val = np.abs(val)

        if val == 0:  # center
            ramlak[indice] = np.pi/4
        else:
            if val % 2 == 1:  # even indices
                ramlak[indice] = -1/(np.pi*val**2)
            else:  # odd indices
                ramlak[indice] = 0

    return ramlak


def simuProjection(I, theta):
    """
    simulation of the generation of a sinogram
    I : original image (phantom for example)
    theta: angles of projection
    """
    N = I.shape[1]
    M = len(theta)
    S = np.zeros((N, M))

    for i, ang in enumerate(theta):
        image1 = rotate(I, ang)
        S[:, i] = np.sum(image1, axis=1)

    return S


def backprojection(P, theta, filtre):
    """
    Backprojection of
    P: image
    theta: list of projection angles
    filtre: bool, True if filtered
    """

    N = P.shape[0]
    R = np.zeros((N, N))

    # in case of filtered back-projection
    if filtre:
        h = RamLak(31)
        fig = plt.figure()
        plt.plot(h)
        fig.savefig('ramlak.pdf', bbox_inches='tight')

    # loops over all angles
    for i, ang in enumerate(theta):
        proj = P[:, i]

        # filtered back-projection
        if filtre:
            proj = convolve(proj, h, mode='same')

        proj2 = np.matlib.repmat(proj, N, 1)
        proj2 = rotate(proj2, ang)
        R = R + proj2
    return R.transpose()


# Read image
image = imread("phantom.png", as_gray=True)
image = image[:, :, 0]
plt.imshow(image, cmap='gray')


# simulate projection
theta = np.linspace(0, 180, 180)
P = simuProjection(image, theta)
plt.figure()
plt.imshow(P, cmap='gray')
plt.show()
imsave('sinogram.python.png', P)

# Performs unfiltered backprojection
ubp = backprojection(P, theta, False)
plt.figure()
plt.imshow(ubp, cmap='gray')
plt.show()
imsave('unfiltered_backprojection.python.png', ubp)

# Performs filtered backprojection
fbp = backprojection(P, theta, True)
plt.figure()
plt.imshow(fbp, cmap='gray')
plt.show()
imsave('filtered_backprojection.python.png', fbp)
