#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 14 16:56:31 2018

@author: yann
"""

import matplotlib.pyplot as plt
import numpy as np
from skimage.morphology import binary_erosion, disk, rectangle
from skimage.measure import perimeter

A = np.zeros((20, 20)).astype('bool')
A[4:14, 9:17] = True
A[1:18, 11:16] = True
A[8,8] = True;

plt.imshow(A)
plt.show()


def bwperim(I, connectivity=8):
    """
    Morphological inner contour, in 4 or 8 connectivity
    I: binary image
    return: binary image representing the contour
    """
    if connectivity == 8:
        SE = disk(1)
    else:
        SE = rectangle(3, 3)

    E = binary_erosion(I, selem=SE)

    return I ^ E


def firstPoint(C):
    """
    find first point of contour
    returns point (as array)
    """
    p = np.argwhere(C)
    return p[0]


def freeman(C, p, connectivity=8):
    """
    Freeman chain code. Start at point p (should be on the contour) and 
    follow the contour. At each step, evaluates the direction
    C: contour image
    p: initial point
    connectivity: 4,8. Connectivity of the contour
    returns: Freeman chain code
    """
    def getIndex(contour, point, connectivity):
        """ subfunction
        """
        if connectivity == 8:
            lut = np.array([[1, 2, 3], [8, 0, 4], [7, 6, 5]])
        else:
            lut = np.array([[0, 2, 0], [8, 0, 4], [0, 6, 0]])

        window = contour[point[0]-1:point[0]+2, point[1]-1:point[1]+2]
        window = window * lut
        index = np.max(window)
        return index-1

    # Be careful that these LUTs consider coordinates from left to rith, top to bottom
    lutx = np.array([-1, -1, -1, 0, 1, 1, 1, 0])
    luty = np.array([-1, 0, 1, 1, 1, 0, -1, -1])
    lutcode = np.array([3, 2, 1, 0, 7, 6, 5, 4])

    nbrpoints = np.sum(C)
    code = []
    point = p.copy()
    C2 = C.copy()

    for i in np.arange(nbrpoints):
        C2[point[0], point[1]] = 0

        index = getIndex(C2, point, connectivity)

        if (index == 0):
            C2[p[0], p[1]] = 1
            index = getIndex(C2, point, connectivity)

        # new point
        point[0] = point[0] + lutx[index]
        point[1] = point[1] + luty[index]

        # add code
        code.append(lutcode[index])

    return code


def codediff(fcc, connectivity=8):
    """
    Differential code: keep only turns and not directions.
    fcc: Freeman chain code
    connectivity: 4,8 connectivity of the contour
    returns: differential code
    """
    sr = np.roll(fcc, 1)
    d = fcc - sr
    return d % connectivity


def minmag(code):
    """
    computes a minimum in the configuration of the code, 
    in order to be invariant toward first point.

    code: differential code
    returns: final invariant code
    """

    # high value for min computing
    codemin = np.max(code) * np.ones(code.shape)
    nb = len(code)
    for i in np.arange(len(code)):
        C = np.roll(code, i)

        for j in np.arange(nb):
            if C[j] > codemin[j]:
                break
            elif C[j] < codemin[j]:
                codemin = C
                break
            if j == nb:
                codemin = C

    return codemin


def invariantShapeCode(I, connectivity=8):
    """
    Invariant shape code, based on Freeman code
    I: binary image
    connectivity: 8 or 4, connectivity of the resulting contour
    returns shape number and Freeman code
    """

    # 1- find the contour
    C8 = bwperim(A, connectivity)

    # 2- find the first point
    p = firstPoint(C8)

    # 3- evaluates the Freeman code by following the contour
    code = freeman(C8, p)

    # 4 - evaluates differential: invariance to starting point
    c = codediff(code, connectivity)

    # 5 - invariance to rotation
    shapenumber8 = minmag(c)

    return shapenumber8, code


def Perimeter(fcode):
    """
    Perimeter. Evaluate the number of diagonals and applies a coefficient sqrt(2), 
               a coefficient 1 in other values. 
               turnback points are not specifically considered.
    fcode: Freeman code
    refurn perimeter value
    """
    nb_diag = np.sum(np.array(fcode) % 2)
    perim = nb_diag*np.sqrt(2) + len(fcode)-nb_diag
    return perim


def Area(fcode):
    """
    Area of the object. Increment the area when turning in one sense, 
    and decrement when turning in the other sense.
    fcode: Freeman code
    return area value.
    """
    area = 0
    B = 0
    lutB = np.array([0, 1, 1, 1, 0, -1, -1, -1])
    for i in np.arange(len(fcode)):
        lutArea = np.array([-B, -(B+0.5), 0, (B+0.5), B, (B-0.5), 0, -(B-0.5)])
        area = area + lutArea[fcode[i]]
        B = B + lutB[fcode[i]]
    return area


###############################################################################
# %%
# compute invariant shape number based on Freeman code
shapenumber8, fcode = invariantShapeCode(A, 8)
print(shapenumber8)

# %% check results
# change starting point
p = np.array([4, 9])
C8 = bwperim(A, 8)
C4 = bwperim(A, 4)


code = freeman(C8, p)
c = codediff(code, 8)
shapenumber8bis = minmag(c)

if np.all(shapenumber8 == shapenumber8bis):
    print("OK: different starting points invariance")
else:
    print("ERROR: not invariant by starting point")

# rotation invariance
B = A.transpose()
shapenumber8ter, fcodeter = invariantShapeCode(B, 8)
if np.all(shapenumber8 == shapenumber8ter):
    print("OK: rotation invariance")
else:
    print("ERROR: not invariant by rotation")
    print(shapenumber8ter)

# %% Perimeter and Area
shapenumber8, fcode = invariantShapeCode(A, 8)
perim = Perimeter(fcode)
print("Perimeter: ", perim)
print("skimage.measure.perimeter: ", perimeter(A))

area = Area(fcode)
print("Area: ", area)
print("Number of pixels (area): ", np.sum(A))
