#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 12 14:39:57 2018

@author: yann
"""

from scipy import ndimage


def LaplacianPyramidDecomposition(Image, levels, mode):
    """
    """

    pyrL = []
    pylG = []

    sigma = 3
    for l in range(levels):
        g = ndimage.gaussian_filter(Image, sigma)
