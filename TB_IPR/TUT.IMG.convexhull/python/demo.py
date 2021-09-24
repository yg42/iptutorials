#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov  8 16:19:24 2018

convex hull illustration

@author: yann
"""

import numpy as np
import matplotlib.pyplot as plt


def crossProduct(hull, p3):
    """
    Cross product
    hull : list that should contain at least 2 points
    p3   : point
    """
    p1 = hull[-2]
    p2 = hull[-1]

    c = (p2[0] - p1[0])*(p3[1] - p1[1]) - (p3[0] - p1[0])*(p2[1] - p1[1])
    return c


def conv_hull(points):
    """
    Graham scan for convex hull
    algorithm
    1- find lowest y-axis point
    2- sort points by angle
    3- proceed in this order and check left or right turn

    points: np array
    """

    points = np.round(points, decimals=4)

    # sort first by y, then x. get first point
    ind = np.lexsort(points.transpose())
    P = points[ind[0], :]

    # all points but first one
    points = points[ind]
    pp = points[1:,:]

    # sort all points by angle
    hypothenuse = np.sqrt((pp[:, 0]-P[0])**2 + (pp[:, 1]-P[1])**2)
    adj_side = pp[:, 0] - P[0]
    # as cos is decreasing, we use minus
    cosinus = -adj_side/hypothenuse
    ind = cosinus.argsort()

    # display
    #displaySortedPoints( pp[ind,:].tolist(), P.tolist());
    # construct ordered list of points
    list_points = []
    list_points.append(P.tolist())
    list_points = list_points + pp[ind, :].tolist()
    list_points.append(P.tolist())
    first = list_points.pop(0)
    second = list_points.pop(0)
    hull = []  # convex hull
    hull.append(first)
    hull.append(second)
    for i, p in enumerate(list_points):
        while len(hull) >= 2 and crossProduct(hull, p) < 0:
            hull.pop()

        hull.append(p)

        # display result every 10 points
        if i % 10 == 0:
            displayPointsAndHull(
                points, P, hull, 'chull_'+str(i)+'.python.pdf')

    return hull


def displayPointsAndHull(points, P, hull, filename=None):
    """
    Fonction for display points and hull
    optionally save figure into pdf file
    """
    fig = plt.figure()
    if P is not(None):
        for i in np.arange(points.shape[0]):
            plt.plot([P[0], points[i, 0]], [P[1], points[i, 1]], 'C0')
    plt.scatter(points[:, 0], points[:, 1])

    hull = np.array(hull)
    plt.plot(hull[:, 0], hull[:, 1], 'C2')
    plt.show()
    if filename:
        fig.savefig(filename, bbox_inches='tight')


# %% sample points
Points = np.array([[1,  2],
                   [1, -4],
                   [2, -1],
                   [3, -4],
                   [4,  1],
                   [3,  0]])

H = conv_hull(Points)
displayPointsAndHull(Points, None, H, 'sample_hull.python.pdf')

# %% 50 random points
nb = 50
Points = np.random.rand(nb, 2)
H = conv_hull(Points)
displayPointsAndHull(Points, None, H, 'random_hull.python.pdf')
