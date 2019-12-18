#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 10 16:36:15 2018

@author: yann
"""

from skimage.util import random_noise
from scipy import misc
import matplotlib.pyplot as plt
from skimage import morphology as m
from skimage import filters
import numpy as np

L = imageio.imread('lena512.png')
#L = imageio.imread('ciment.png')
plt.imshow(L, cmap='gray')
plt.show()

A = random_noise(L, mode='s&p', amount=.04)
# A = L.copy(); A = A[:,:,1]; # case of cement image
plt.imshow(A, cmap='gray')
plt.show()

########################################
# %% Morphological center


def morphoCenter(I, c, o, selem=m.disk(1)):
    """
    """
    coc = c(o(c(I, selem=selem), selem=selem), selem=selem)
    oco = o(c(o(I, selem=selem), selem=selem), selem=selem)
    cMin = np.minimum(oco, coc)
    cMax = np.maximum(oco, coc)
    F = np.minimum(np.maximum(A, cMin), cMax)
    return F


B = morphoCenter(A, m.closing, m.opening)
Bmed = filters.median(A, selem=np.ones((3, 3)))

imageio.imwrite("noisy_lena.python.png", A)
imageio.imwrite("morpho_center.python.png", B)
imageio.imwrite("median.python.png", Bmed)
plt.imshow(B, cmap='gray')
plt.show()
plt.imshow(Bmed, cmap='gray')
plt.show()

########################################
# %% Alternate sequential filters


def asf_m(I, order=3):
    """

    """
    F = I.copy()
    for r in np.arange(1, order+1):
        se = m.disk(r)
        F = m.closing(m.opening(F, selem=se), selem=se)
    return F


def asf_n(I, order=3):
    """

    """
    F = I.copy()
    for r in np.arange(1, order+1):
        se = m.disk(r)
        F = m.opening(m.closing(F, selem=se), selem=se)
    return F


fc3 = asf_n(A)
fo3 = asf_m(A)
plt.imshow(fc3, cmap='gray')
plt.show()
plt.imshow(fo3, cmap='gray')
plt.show()

imageio.imwrite("asf_n.python.png", fc3)
imageio.imwrite("asf_m.python.png", fo3)
########################################
# %% Opening and closing by reconstruction
# defined for 8bits images


def openrec(I, selem=m.disk(1)):
    B = m.erosion(I, selem=selem)
    F = m.reconstruction(B, I)
    return F


def closerec(I, selem=m.disk(1)):
    """
    warning: this codes only works for 8 bits images
    """
    F = 255-openrec(255-I, selem=selem)
    return F


D = openrec(A, m.disk(3))
E = closerec(A, m.disk(3))
plt.imshow(D, cmap='gray')
plt.show()

plt.imshow(E, cmap='gray')
plt.show()
imageio.imwrite("lena_openrec.python.png", D)
imageio.imwrite("lena_closerec.python.png", E)


########################################
# %% ASF by reconstruction
def asfrec(I, order=3):
    """
    """
    A = I.copy()
    for r in np.arange(1, order+1):
        se = m.disk(r)
        A = closerec(openrec(A, selem=se), selem=se)
    return A


B = asfrec(A, 3)
plt.imshow(B, cmap='gray')
plt.show()
imageio.imwrite('asfrec.python.png', B)

########################################
# %% morpho center by reconstruction


def centerrec(I, selem=m.disk(1)):
    """
    """
    B = morphoCenter(I, closerec, openrec, selem=selem)
    return B


B = centerrec(A)
plt.imshow(B, cmap='gray')
plt.show()
imageio.imwrite("centerrec.python.png", B)
