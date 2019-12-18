#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 24 11:49:13 2018

@author: yann
"""


import matplotlib.pyplot as plt
import numpy as np
from scipy import ndimage
from scipy import signal
from scipy import misc
from scipy import spatial
from skimage import measure


def countIntercepts(I, h):
    B = np.abs(signal.convolve2d(I, h, mode='same'))
    n = np.sum(B) / 2
    return n


def perimCrofton(I):
    """
    Approximate the Crofton perimeter with 4 directions
    I is the input binary image
    return the perimeter, float value
    """
    # defines an orientation
    h = np.array([[-1, 1]])
    n1 = countIntercepts(I, h)

    n2 = countIntercepts(I, h.transpose())

    h = np.array([[1, 0], [0, -1]])
    n3 = countIntercepts(I, h.transpose())

    h = np.array([[0, 1], [-1, 0]])
    n4 = countIntercepts(I, h.transpose())

    perim_Crofton = np.pi/4 * (n1+n2 + 1/np.sqrt(2)*(n3+n4))
    return perim_Crofton


# Feret Diameter
def feretDiameter(I):
    """
    I: input binary image
    Returns min, max and mean Feret diameter, which is the length of the 
    projected object in one direction
    """
    diameter = []
    for angle in range(180):
        I2 = ndimage.interpolation.rotate(I, angle, mode='nearest')
        I3 = I2.max(axis=0)
        diameter.append(np.sum(I3 > 0))

    return np.min(diameter), np.max(diameter), np.mean(diameter)


def disk(t, r):
    """
    Generates a binary array representing a disk, centered, of radius r
    an array of size [2t,2t] is generated
    """
    x = np.arange(-t, t, 1)
    X, Y = np.meshgrid(x, x)
    I = (X**2 + Y**2) <= r**2
    return I


def circularity(I):
    """
    Circularity criterion
    4*pi*A/P**2
    returns crofton and classic
    """
    P = perimCrofton(I)
    print("Perimeter by crofton: ", P)
    A = np.sum(I)
    C = np.pi*4*A/P**2

    p = measure.perimeter(I, neighbourhood=4)
    print("Usual perimeter: ", p)
    c = np.pi*4*A/p**2
    return C, c


def convexity(I):
    """
    Evaluates the convexity criterion
    I is a binary image (np array)
    return convexity
    """
    # be careful that coordinates between images and arrays are inversed
    # thus, image is flipped before extracting points coordinates
    points = np.transpose(np.where(np.flip(I, 0)))
    hull = spatial.ConvexHull(points)
    A = np.sum(I)
    Ah = hull.volume

    fig = plt.figure()
    plt.scatter(points[:, 1], points[:, 0])
    for simplex in hull.simplices:
        plt.plot(points[simplex, 1], points[simplex, 0], 'k-')
    plt.axis('equal')
    plt.show()
    #fig.savefig("convhull.pdf", bbox_inches='tight')
    return A/Ah


# tests on binary image
# load the image
I = imageio.imread("camel-5.png")
I = I[:, :, 0] > 100
plt.imshow(I)
plt.axis('equal')
plt.show()

# Perimeter
perim_Crofton = perimCrofton(I)
print("Crofton perimeter: ", perim_Crofton)

perims = measure.perimeter(I, neighbourhood=4)
print("Classical perimeter in N4: ", perims)
perims = measure.perimeter(I, neighbourhood=8)
print("Classical perimeter in N8: ", perims)

m, M, a = feretDiameter(I)
print("min, Max, average Feret diameters: ", m, M, a)

# circularity of a disk
D = disk(500, 400)
C, c = circularity(D)
print("circularity by crofton: ", C)
print("circularity usual ", c)

# convexity
c = convexity(I)
print("convexity of Camel object: ", c)
