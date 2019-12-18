#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 12 12:05:44 2017

@author: yann
"""
import matplotlib.pyplot as plt
import imageio
import numpy as np
from scipy import signal


X = imageio.imread('X.bmp')
X = X > 0
plt.imshow(X)
plt.show()

# Number of faces, edges and vertices
#  verification of the manual counting method !
f_intra = 50
e_intra = 158
v_intra = 107

f_inter = 4
e_inter = 42
v_inter = 50

Area = f_intra
Perimeter = -4*f_intra + 2*e_intra
EulerNb8 = v_intra - e_intra + f_intra
EulerNb4 = v_inter - e_inter + f_inter

# Neighborhood configuration
F = np.array([[0, 0, 0], [0, 1, 4], [0, 2, 8]])
XF = signal.convolve2d(X, F, mode='same')
edges = np.arange(0, 17, 1)
h, edges = np.histogram(XF[:], bins=edges)
plt.bar(edges[0:-1], h)
plt.title("Histogram of the different configurations")
plt.show()


def minkowski_functionals(I):
    F = np.array([[0, 0, 0], [0, 1, 4], [0, 2, 8]])
    I = np.pad(I, ((1, 1),), mode='constant')
    XF = signal.convolve2d(I, F, mode='same')
    edges = np.arange(0, 17, 1)
    h, edges = np.histogram(XF[:], bins=edges)

    # Computation of the functionals
    f_intra = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
    e_intra = [0, 2, 1, 2, 1, 2, 2, 2, 0, 2, 1, 2, 1, 2, 2, 2]
    v_intra = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    EulerNb8 = np.sum(h*v_intra - h*e_intra + h*f_intra)
    f_inter = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
    e_inter = [0, 0, 0, 1, 0, 1, 0, 2, 0, 0, 0, 1, 0, 1, 0, 2]
    v_inter = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
    EulerNb4 = np.sum(h*v_inter - h*e_inter + h*f_inter)
    Area = np.sum(h*f_intra)
    Perimeter = np.sum(-4*h*f_intra + 2*h*e_intra)

    return Area, Perimeter, EulerNb4, EulerNb8


Area, Perimeter, EulerNb4, EulerNb8 = minkowski_functionals(X)
print("E_4:{0}, A:{1}, P:{2}".format(EulerNb4, Area, Perimeter))

# Crofton perimeter


def crofton_perimeter(I):
    """
    Crofton perimeter in 2 and 4 directions
    """
    I = np.pad(I, ((1, 1),), mode='constant')
    F = np.array([[0, 0, 0], [0, 1, 4], [0, 2, 8]])

    XF = signal.convolve2d(X, F, mode='same')
    edges = np.arange(0, 17, 1)
    h, edges = np.histogram(XF[:], bins=edges)
    P4 = [0, np.pi/2, 0, 0, 0, np.pi/2, 0, 0,
          np.pi/2, np.pi, 0, 0, np.pi/2, np.pi, 0, 0]
    Perimeter4 = sum(h*P4)
    P8 = [0, np.pi/4*(1+1/(np.sqrt(2))), np.pi/(4*np.sqrt(2)), np.pi/(2*np.sqrt(2)), 0, np.pi/4*(1+1/(np.sqrt(2))),
          0, np.pi/(4*np.sqrt(2)), np.pi/4, np.pi/2, np.pi/(4*np.sqrt(2)), np.pi/(4*np.sqrt(2)), np.pi/4, np.pi/2, 0, 0]
    Perimeter8 = sum(h*P8)

    return Perimeter4, Perimeter8


Perimeter4, Perimeter8 = crofton_perimeter(X)
print("Perimeter4: {0}, Perimeter8: {1}".format(Perimeter4, Perimeter8))
