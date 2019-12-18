# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 14:18:01 2015
mathematical morphology reconstruction
@author: yann
"""

import numpy as np
from scipy import ndimage, misc

import matplotlib.pyplot as plt


def reconstruct(image, mask):
    # should be binary images
    M = np.minimum(mask, image)

    area = ndimage.measurements.sum(M)
    s = 0

    se = np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]])
    while (area != s):
        s = area
        M = np.minimum(
            image, ndimage.morphology.binary_dilation(M, structure=se))
        area = ndimage.measurements.sum(M)

    return M


def killBorders(A):
    # remove cells touching the borders of the image
    m, n = A.shape
    M = np.zeros((m, n))
    M[0, :] = 1
    M[m-1, :] = 1
    M[:, 0] = 1
    M[:, n-1] = 1
    M = reconstruct(A, M)
    return A-M


def closeHoles(A):
    Ac = ~A  # binary NOT for numpy
    m, n = A.shape
    M = np.zeros((m, n))
    M[0, :] = 1
    M[m-1, :] = 1
    M[:, 0] = 1
    M[:, n-1] = 1
    M = reconstruct(Ac, M)
    return ~M


def killSmall(A, n):
    # destroy small objects
    se = np.ones((n, n))
    M = ndimage.morphology.binary_erosion(A, structure=se)
    return reconstruct(A, M)


# read images
A = imageio.imread('A.jpg')
A = A > 100
M = imageio.imread('M.jpg')
M = M > 100
# reconstruction de A par M
AM = reconstruct(A, M)

# display results
plt.figure()
plt.subplot(1, 3, 1)
plt.imshow(A)
plt.subplot(1, 3, 2)
plt.imshow(M)
plt.subplot(1, 3, 3)
plt.imshow(AM)
plt.show()
plt.title("reconstruction")
imageio.imwrite('reconstruct.png', AM)

# kill borders
plt.figure()
B = imageio.imread('B.jpg')
B = B > 100
B2 = killBorders(B)
plt.subplot(1, 2, 1)
plt.imshow(B)
plt.subplot(1, 2, 2)
plt.imshow(B2)
plt.title('kill borders')
plt.show()
imageio.imwrite('borders.png', B2)

# close holes
plt.figure()
B3 = closeHoles(B)
plt.subplot(1, 2, 1)
plt.imshow(B)
plt.subplot(1, 2, 2)
plt.imshow(B3)
plt.title('close holes')
plt.show()
imageio.imwrite('holes.png', B3)

# kill small objects
plt.figure()
B4 = killSmall(B, 8)
plt.subplot(1, 2, 1)
plt.imshow(B)
plt.subplot(1, 2, 2)
plt.imshow(B4)
plt.title('remove small objects')
plt.show()
imageio.imwrite('small.png', B4)


# application to image "cells"
plt.figure()
cells = imageio.imread('cells.jpg') < 98
imageio.imwrite('cellsbw.png', cells)
B = closeHoles(cells)
B = killBorders(B)
B = killSmall(B, 5)
plt.subplot(1, 2, 1)
plt.imshow(cells)
plt.subplot(1, 2, 2)
plt.imshow(B)
plt.title('clean image')
plt.show()
imageio.imwrite('clean.png', B)
