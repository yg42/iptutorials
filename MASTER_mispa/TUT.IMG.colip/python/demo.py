#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 24 17:39:14 2018

@author: yann
"""
import numpy as np
import matplotlib.pyplot as plt
import skimage.color as color


def graytone(F, M):
    # graytone function transform
    # M: maximal value
    # F: image function
    f = M-np.finfo(np.float32).eps-F
    return f


def phi(f, M):
    # LIP isomorphism
    # f: graytone function
    # M: maximal value
    l = -M * np.log(1.-f/M)
    return l


def invphi(l, M):
    # inverse isomorphism
    f = M*(1-np.exp(-l/M))
    return f


def getColipM0():
    # return M0 value
    return 100

# colors conversions


def lmstone(LMS):
    M0 = getColipM0()
    return (M0-np.finfo(np.float32).eps)*(1-LMS/M0)


def XYZ2LMS(XYZ):
    """
    conversion function
    XYZ: data in XYZ space
    """
    U = np.array([[0.38971, 0.68898, -0.07869],
                  [-0.22981, 1.18340, 0.04641], [0, 0, 1]])
    m, n = XYZ[:, :, 0].shape
    XYZ = XYZ.reshape((m*n, 3)).transpose()
    LMS = np.matmul(U, XYZ)

    return LMS.transpose().reshape((m, n, 3))


def LMS2ARGYBtilde(LMS):
    """
    conversion function
    LMS: data in LMS space
    """
    M0 = getColipM0()
    m, n, p = LMS.shape
    LMStone = lmstone(LMS)
    LMStilde = phi(LMStone, M0)
    P = [[40/61, 20/61, 1/61], [1, -12/11, 1/11], [1/9, 1/9, -2/9]]

    LMStilde = LMStilde.reshape((m*n, 3)).transpose()
    ARGYBtilde = np.matmul(P, LMStilde).transpose()
    return ARGYBtilde.reshape((m, n, 3))


def ARGYBtilde2ARGYBhat(ARGYBtilde):
    """
    conversion into ARGYB tilde space
    ARGYBtilde: data in ARGYB tilde space

    """
    M0 = getColipM0()

    ARGYBhat = np.zeros(ARGYBtilde.shape)
    ARGYBhat[:, :, 0] = invphi(ARGYBtilde[:, :, 0], M0)

    for c in (1, 2):
        tmp = np.abs(ARGYBtilde[:, :, c])

        ARGYBhat[:, :, c] = np.sign(ARGYBtilde[:, :, c]) * invphi(tmp, M0)

    return ARGYBhat


def LMS2ARGYBhat(LMS):
    """
    conversion into ARGYB hat space
    LMS: data in LMS space
    """
    ARGYBtilde = LMS2ARGYBtilde(LMS)
    return ARGYBtilde2ARGYBhat(ARGYBtilde)

""" 
# Load CMF functions
"""
with np.load('cmf.npz') as data:
    cmap = data['cmap']
    pourpresLMS = data['pourpresLMS']
    SpecXYZ = data['SpecXYZ']
    SpecLMS = data['SpecLMS']
    SpecRGB = data['SpecRGB']
    l = data['l']

"""
# Display classical CMF in xy

"""
xn = SpecXYZ[:, :, 0]/np.sum(SpecXYZ, axis=2)
yn = SpecXYZ[:, :, 1]/np.sum(SpecXYZ, axis=2)
zn = 1-xn-yn
plt.scatter(xn, yn, c=cmap)
plt.savefig("xy.python.pdf", bbox_inches='tight')

# CMF in a, ^rg, ^yb
ARGYB_hat = LMS2ARGYBhat(SpecLMS)
plt.figure()
plt.scatter(ARGYB_hat[:, 0, 1], ARGYB_hat[:, 0, 2], c=cmap)
# purple line
purple_ARGYB_hat = LMS2ARGYBhat(pourpresLMS)
plt.scatter(purple_ARGYB_hat[:, 0, 1], purple_ARGYB_hat[:, 0, 2], c='black')

"""
# Construction of the RGB cube
"""
N = 10
cols = np.linspace(0, 255, num=N)
R, G, B = np.meshgrid(cols, cols, cols)

R = R.reshape((R.size, 1))
G = G.reshape((G.size, 1))
B = B.reshape((B.size, 1))
NN = R.size
colRGB = np.concatenate((R, G, B), axis=1)
cubeRGB = colRGB.reshape((NN, 1, 3))
colRGB = colRGB / 255
cubeXYZ = color.rgb2xyz(cubeRGB)
cubeLMS = XYZ2LMS(cubeXYZ)
cubeARGYBhat = LMS2ARGYBhat(cubeLMS)
plt.scatter(cubeARGYBhat[:, 0, 1], cubeARGYBhat[:, 0, 2], c=colRGB)
plt.savefig("argyb.python.pdf", bbox_inches='tight')
