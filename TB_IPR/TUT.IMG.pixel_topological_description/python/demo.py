#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 18 12:15:40 2017

@author: yann
"""

import numpy as np
import scipy.ndimage.measurements as mes
import skimage.morphology as morpho
import imageio
import matplotlib.pyplot as plt


def nc(A):
    # A : block 3x3, binary

    # complementary set of A
    invA = 1-A

    # neighborhoods
    V8 = np.ones((3, 3)).astype(int)
    V8_star = np.copy(V8)
    V8_star[1, 1] = 0
    V4 = np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]]).astype(int)

    # intersection is done by the min operation
    X1 = np.minimum(V8_star, A)
    TT8 = np.sum(X1)
    L, T8 = mes.label(X1, structure=V8)

    # The C-ajd-4 might introduce some problems if a pixel is not 4-connected
    # to the central pixel
    X2 = np.minimum(V8, invA)
    Y = np.minimum(X2, V4)
    X = morpho.reconstruction(Y, X2, selem=V4)
    L, T8c = mes.label(X, structure=V4)

    #print("T8={0}, T8c={1}, TT8={2}\n".format(T8, T8c, TT8))
    return T8, T8c, TT8


def nc_type(X):
    # evaluates the connectivity numbers

    a, b, c = nc(X)
    if (a == 0):
        y = 1  # isoloated point
    if ((a == 1) and (b == 1) and (c > 1)):
        y = 5  # border point
    if (b == 0):
        y = 7  # interior point
    if ((a == 1) and (b == 1) and (c == 1)):
        y = 6  # end point
    if (a == 2):
        y = 2  # 2-junction point
    if (a == 3):
        y = 3  # 3-junction point
    if (a == 4):
        y = 4  # 4-junction point:
    return y


def classification(A):
     # for the whole image
    m, n = A.shape
    B = np.zeros((m, n))
    for i in range(1, m-1):
        for j in range(1, n-1):
            if A[i, j] > 0:
                X = A[i-1:i+2, j-1:j+2]
                B[i, j] = nc_type(X)
    return B


A = np.array([[1, 0, 0], [0, 1, 1], [0, 1, 0]]).astype(int)
nc(A)

# 1 - Connexity number
# reading image
A = imageio.imread('test.bmp')
A = A[:, :, 0]
A = A/255
A = A.astype(int)
x = (1, 4)
X = A[x[0]-1:x[0]+2, x[1]-1:x[1]+2]
plt.imshow(A)
plt.show()

plt.imshow(X)
plt.show()
# connectivity numbers
nc1, nc2, nc3 = nc(X)
print("T8={0}, T8c={1}, TT8={2}\n".format(nc1, nc2, nc3))

# 2 - Points classification
nc_type(X)

# For the entire image
B = classification(A)

plt.subplot(331)
plt.imshow(A)
plt.title('original image')
plt.subplot(3, 3, 2)
plt.imshow(B)
plt.title('point classification')
plt.subplot(3, 3, 3)
plt.imshow(B == 5)
plt.title('border points')
plt.subplot(3, 3, 4)
plt.imshow(B == 7)
plt.title('interior points')
plt.subplot(3, 3, 5)
plt.imshow(B == 1)
plt.title('isolated points')
plt.subplot(3, 3, 6)
plt.imshow(B == 6)
plt.title('end points')
plt.subplot(3, 3, 7)
plt.imshow(B == 2)
plt.title('2-junction points')
plt.subplot(3, 3, 8)
plt.imshow(B == 3)
plt.title('3-junction points')
plt.subplot(3, 3, 9)
plt.imshow(B == 4)
plt.title('4-junction points')
plt.show()
