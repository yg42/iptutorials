#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 14 13:43:55 2018

@author: yann
"""
#%%
import numpy as np
from skimage import draw
from scipy import misc, signal
import matplotlib.pyplot as plt
import progressbar
import skimage.io

def booleanModel(Wsize, gamma, radius):
    """
    Generation of a 2D boolean model of disks, in a window of size Wsize
    Wsize: 2x1 array
    gamma: numerical value to control the Poisson process
    radius: min and max values of radii, 2x1 array
    returns: boolean array of size Wsize
    """
    edgeEffect = 2 * np.max(radius) + 100
    WsizeExtended = Wsize + 2*edgeEffect

    # nb of points
    areaW = WsizeExtended[0] * WsizeExtended[1]
    nbPoints = np.random.poisson(lam=gamma * areaW)

    # positions of the germs
    x = np.random.randint(0, WsizeExtended[0], nbPoints)
    y = np.random.randint(0, WsizeExtended[1], nbPoints)

    # grains
    rGrains = np.random.randint(radius[0], radius[1], nbPoints)

    # union of grains
    Z = np.zeros((WsizeExtended[0], WsizeExtended[1])).astype('int')
    for r, xx, yy in zip(rGrains, x, y):
        rr, cc = draw.disk((xx, yy), radius=r, shape=Z.shape)
        Z[rr, cc] = 1
    # restrain window for side effects
    Z = Z[edgeEffect:edgeEffect+Wsize[0], edgeEffect:edgeEffect+Wsize[1]]

    return Z


def minkowskiFunctionals(X):
    """
    Evaluation of the Minkowski functionals
    X: boolean 2D array
    returns area, perimeter, euler number N8, euler number n4

    Notice: regionprops from skimage.measure is not a good solution because
            it computes properties of each object of a labelled image
    """
    Area = np.sum(X>0)
    Perimeter = skimage.measure.perimeter(X, neighbourhood=4)
    EulerNb = skimage.measure.euler_number(X, connectivity=2)

    return Area, Perimeter, EulerNb


def realizations(Wsize, gamma, radius, n=100):
    """
    This function iterates the different realizations
    Wsize: window size
    gamma: value of gamma, see booleanModel
    radius: min and max values of the radii of the generated disks
    """
    W = np.zeros((n, 3))
    areaWsize = Wsize[0] * Wsize[1]
    bar = progressbar.ProgressBar()
    for i in bar(range(n)):
        Z = booleanModel(Wsize, gamma, radius)
        a, p, chi = minkowskiFunctionals(Z)
        W[i, :] = np.array([a, p/2, chi*np.pi]) / areaWsize

    return W


###############################################################################
# %%
Wsize = [1000, 1000]
gamma = 100 / (Wsize[0] * Wsize[1])
radius = [10, 30]
Z = booleanModel(Wsize, gamma, radius)
plt.imshow(Z)
plt.show()

skimage.io.imsave('boolean_model.python.png', Z)

W = realizations(Wsize, gamma, radius, 10000)
W = np.mean(W, axis=0)

# comparison with
rMean = np.mean(radius)
areaMean = np.pi*rMean**2
perMean = 2*np.pi*rMean

W_X = gamma * np.array([areaMean, perMean/2, np.pi])
W_0 = 1-np.exp(-W_X[0])
W_1 = np.exp(-W_X[0]) * W_X[1]
W_2 = np.exp(-W_X[0]) * (W_X[2] - W_X[1]**2)

error_0 = np.abs(W_0-W[0]) / W_0
error_1 = np.abs(W_1-W[1]) / W_1
error_2 = np.abs(W_2-W[2]) / W_2
print("errorW0: ", error_0)
print("errorW1: ", error_1)
print("errorW2: ", error_2)

# %%
# Another way to compare with the theoretical values
# Theoretical values
rMean = np.mean(radius)
areaMean = np.pi*rMean**2
perMean = 2*np.pi*rMean

# By inversing the formulas
# Warning, perimeter has been divided by 2
W[1] = W[1]*2
# Also, euler number is multiplied by pi
W[2] = W[2]/np.pi

x = 1 # Euler characteristic for a disk, no hole
gamma_measured = 1/np.pi/x * ( np.pi*W[2] *1/(1-W[0]) + 1/4*(W[1]/(1-W[0]))**2)
perim_measured = 1/gamma_measured * 1/(1-W[0]) * W[1]
area_measured  = -1/gamma_measured * np.log(1-W[0])


print('rMean', rMean)
print("gamma_measured: ", gamma_measured, gamma)
print("perim_measured: ", perim_measured)
print("area_measured: ", area_measured)

print('radius measured', perim_measured/2/np.pi)

# %%
