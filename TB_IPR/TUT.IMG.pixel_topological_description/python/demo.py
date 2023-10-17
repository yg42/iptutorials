#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 18 12:15:40 2017

@author: yann

Demonstration of the connectivity numbers

"""

import numpy as np
from scipy.ndimage import label
import skimage.morphology as morpho
from skimage.io import imread, imsave
import matplotlib.pyplot as plt


def nc(A):
    """
    Connectivity numbers
    
    A : block 3x3, binary
    """
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
    L, T8 = label(X1, structure=V8)

    # The C-ajd-4 might introduce some problems if a pixel is not 4-connected
    # to the central pixel
    X2 = np.minimum(V8, invA)
    Y = np.minimum(X2, V4)
    X = morpho.reconstruction(Y, X2, footprint=V4)
    L, T8c = label(X, structure=V4)

    #print("T8={0}, T8c={1}, TT8={2}\n".format(T8, T8c, TT8))
    return T8, T8c, TT8


def nc_type(X):
    """
    Evaluates the connectivity numbers of a pixel in an image.

    Args:
        X (numpy.ndarray): A 3x3 numpy array representing the pixel neighborhood.

    Returns:
        int: The connectivity number of the pixel, which can be one of the following:
            1 - isolated point
            2 - 2-junction point
            3 - 3-junction point
            4 - 4-junction point
            5 - border point
            6 - end point
            7 - interior point
    """
    T8, T8c, TT8 = nc(X)
    if (T8 == 0):
        y = 1  # isolated point
    if ((T8 == 1) and (T8c == 1) and (TT8 > 1)):
        y = 5  # border point
    if (T8c == 0):
        y = 7  # interior point
    if ((T8 == 1) and (T8c == 1) and (TT8 == 1)):
        y = 6  # end point
    if (T8 == 2):
        y = 2  # 2-junction point
    if (T8 == 3):
        y = 3  # 3-junction point
    if (T8 == 4):
        y = 4  # 4-junction point:
    return y


import numpy as np

def classification(A):
    """
    Classifies the pixels in an image based on their topological properties.

    Args:
    A (numpy.ndarray): The input image as a 2D numpy array.

    Returns:
    numpy.ndarray: A 2D numpy array containing the classification results.
    """
    # for the whole image
    m, n = A.shape
    B = np.zeros((m, n))
    for i in range(1, m-1):
        for j in range(1, n-1):
            if A[i, j] > 0:
                X = A[i-1:i+2, j-1:j+2]
                B[i, j] = nc_type(X)
    return B

def translate_type(type):
    """
    Translates the type of a pixel to a human-readable string.

    Args:
        type (int): The type of the pixel.

    Returns:
        str: The human-readable string.
    """
    if type == 1:
        return "isolated point"
    if type == 2:
        return "2-junction point"
    if type == 3:
        return "3-junction point"
    if type == 4:
        return "4-junction point"
    if type == 5:
        return "border point"
    if type == 6:
        return "end point"
    if type == 7:
        return "interior point"
    return "unknown"


A = np.array([[1, 0, 0], [0, 1, 1], [0, 1, 0]]).astype(int)
nc(A)

# 1 - Connectivity number
# reading image
A = imread('test.bmp')
A = A[:, :, 0]
A = A/255
A = A.astype(int)
plt.imshow(A)
plt.title("A")
plt.show()

# Example of a 3x3 block
x = (1, 4)
X = A[x[0]-1:x[0]+2, x[1]-1:x[1]+2]
plt.imshow(X)
plt.show()
# connectivity numbers of X
nc1, nc2, nc3 = nc(X)
print("T8={0}, T8c={1}, TT8={2}\n".format(nc1, nc2, nc3))
X_type = nc_type(X)
print(f"Type of connectivity is {X_type}, which means {translate_type(X_type)}")

# 2 - Points classification
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
