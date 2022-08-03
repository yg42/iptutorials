#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 11 14:49:19 2018

@author: yann
"""


from skimage import morphology as m

import matplotlib.pyplot as plt
from skimage.measure import regionprops
from skimage.measure import label
import numpy as np
from skimage.io import imread, imsave

I = imread("toy.png")
I = I[:, :, 1]
plt.imshow(I)
plt.show()


def bwFilter(bw, attribute, thresholds):
    """
    binary filtering according to attribute
    bw: binary image
    attribute: string representing attribute, defined by regionprops
    thresholds: threshold values, inside which objects are removed
    returns binary image
    """
    F = bw.copy()
    L = label(bw)
    for region in regionprops(L):
        a = getattr(region, attribute)
        if a < thresholds[1] and a >= thresholds[0]:
            F[L == region.label] = False
    return F


def grayFilter(I, attribute, thresholds):
    """
    grayscale image filtering by attribute
    for 8 bits unsigned images
    I: original grayscale image (N, M) ndarray
    attribute: string representing attribute, defined by regionprops
    thresholds: threshold values, inside which objects are removed
    returns grayscale filtered image
    """
    N, M = I.shape
    F = np.zeros((N, M, 256))
    for s in range(256):
        F[:, :, s] = s * \
            bwFilter(I >= s, attribute=attribute, thresholds=thresholds)

    # reconstruction
    R = np.amax(F, axis=2)
    return R


def shapeFilter(I, selem=m.square(25)):
    """
    image filtering when attribute is a shape of a given size, defined by selem
    I: grayscale image
    selem: structuring element
    returns: grayscale filtered image
    """
    N, M = I.shape
    F = np.zeros((N, M, 256))
    for s in range(256):
        F[:, :, s] = s * \
            m.reconstruction(m.opening(I >= s, selem=selem), I >= s)

    # reconstruction
    R = np.amax(F, axis=2)
    return R


F = bwFilter(I > 50, 'area', (0, 5000))
plt.imshow(F)
plt.show()
imsave('toy_binary_areaOpening.python.png', 255*np.uint8(F))

F = grayFilter(I, 'area', (0, 1000))
plt.imshow(F)
plt.show()
imsave('toy_areaOpening.python.png', F)

F = grayFilter(I, 'eccentricity', (0, 0.75))
plt.imshow(F)
plt.show()
imsave('toy_elongThinning.python.png', F)


F = grayFilter(I, 'solidity', (0, 0.75))
plt.imshow(F)
plt.show()
imsave('toy_convThinning.python.png', F)

F = shapeFilter(I)
plt.imshow(F)
plt.show()
imsave('toy_recOpening.python.png', F)
