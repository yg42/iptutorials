#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov  7 15:26:56 2018
LBP: Local Binary Patterns

@author: yann
"""
import numpy as np
from scipy import misc
import matplotlib.pyplot as plt
import glob
import seaborn as sn
import pandas as pd
import os

from sklearn.cluster import KMeans


def plot_dists(dists, classes, cmap=plt.cm.Blues):
    """
    Plot matrix of distances
    dists: all computed distances
    classes: labels to be used
    cmap: colormap

    returns: figure that can be used for pdf export
    """
    df_cm = pd.DataFrame(dists, index=classes, columns=classes)

    fig = plt.figure()
    sn.set(font_scale=.8)
    sn.heatmap(df_cm, annot=True, cmap=cmap, fmt='.2f')

    return fig


def LBP(I):
    """
    Local Binary Pattern of image I
    construct descriptor for each pixel, then evaluate histogram
    I: grayscale image (size nxm)
    """
    B = np.zeros(np.shape(I))

    code = np.array([[1, 2, 4], [8, 0, 16], [32, 64, 128]])

    # loop over all pixels except border pixels
    for i in np.arange(1, I.shape[0]-2):
        for j in np.arange(1, I.shape[1]-2):
            w = I[i-1:i+2, j-1:j+2]
            w = w >= I[i, j]
            w = w * code
            B[i, j] = np.sum(w)

    h, edges = np.histogram(B[1:-1, 1:-1], density=True, bins=256)
    return h, edges


# test LBP on 1 image
I = imageio.imread("../matlab/images/Metal.1.bmp")
I = I[:, :, 1]
h, edges = LBP(I)
fig = plt.figure()
plt.plot(h)
plt.show()
fig.savefig('lbp_Metal_1.python.pdf', bbox_inches='tight')

classes = ['Terrain', 'Metal', 'Sand']
names = []
hh = []

for c in classes:
    print(c)
    fig = plt.figure()
    for file in sorted(glob.glob('../matlab/images/' + c + '*.bmp')):
        names.append(os.path.basename(file))
        I = imageio.imread(file)
        I = I[:, :, 1]
        h, edges = LBP(I)
        plt.plot(h)
        hh.append(h)
    plt.show()
    fig.savefig('lbp_' + c + '.python.pdf', bbox_inches='tight')

# compute distance between LBPs
n = len(hh)
dists = np.zeros((n, n))
for i in np.arange(n):
    for j in np.arange(n):
        dists[i, j] = np.sum(np.abs(hh[i]-hh[j]))

fig = plot_dists(dists, names)
fig.savefig('distances.python.pdf', bbox_inches='tight')

# kmeans clustering
n = 3
k_means = KMeans(init='k-means++', n_clusters=n, n_init=10)
k_means.fit(hh)
print(k_means.labels_)
