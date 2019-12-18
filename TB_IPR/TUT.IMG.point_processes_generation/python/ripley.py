# -*- coding: utf-8 -*-
"""
Created on Wed Nov  2 15:30:14 2016

@author: yann
"""
import numpy as np
from scipy.spatial.distance import pdist
import matplotlib.pyplot as plt


def ripley(x, y, xmin, xmax, ymin, ymax, edges):
    """
    Ripley K and L functions, vals is values of radius
    this function has border effects!
    x, y: coordinates of points
    xmin, xmax, ymin, ymax: window
    edges: values of bins for histogram evaluation
    """

    # number of points
    nb_points = x.size

    # compute pairwise distances
    P = np.transpose(np.vstack((x, y)))
    d = pdist(P)

    # compute cumulative histogram
    h, edges = np.histogram(d, edges)
    H = np.cumsum(h)

    # normalization of K
    K = 2*H/nb_points
    area = (xmax-xmin) * (ymax-ymin)
    density = float(nb_points) / area
    K = K / density

    # L
    L = np.sqrt(K/np.pi)

    # edge values
    vals = edges[:-1] + np.diff(edges)

    return K, L, vals
