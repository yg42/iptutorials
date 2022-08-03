#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 24 14:18:55 2020

@author: yann
"""

from skimage.io import imread,imsave
import numpy as np
import matplotlib.pyplot as plt


A = imread('camel.png')
m,n = A.shape


pts = np.where(A)
pts = np.array(pts).transpose()

indices = np.arange(len(pts))
np.random.shuffle(indices)

# Pay attention to reference: points and image have not the same coordinates
pts = pts[indices]
pts = np.fliplr(pts)
pts[:,1] = m - pts[:,1]

# Generate points
density =.01
nbPoints = int(len(pts)*density)

points = pts[:nbPoints]
plt.scatter(*zip(*points), s=1)
plt.savefig("points.pdf", bbox_inches='tight')
plt.show()

from scipy.spatial import Delaunay

tri = Delaunay(points)
plt.triplot(points[:,0], points[:,1], tri.simplices, lw=.5)
#plt.plot(points[:,0], points[:,1], 'o')
ax = plt.gca()
ax.set_xlim(-2, n+10)
ax.set_ylim(-2, m+10)
plt.savefig("delaunay.pdf", bbox_inches='tight')
plt.show()

from sympy.geometry import Triangle
radius=[]
import progressbar
count=0

# takes a long time because of symbolic computation
with progressbar.ProgressBar(max_value=len(tri.simplices)) as bar:
    for t in tri.simplices:
        count+=1
        tt = Triangle(points[t[0], :], points[t[1], :], points[t[2], :] )
        radius.append(tt.circumradius)
        bar.update(count)


output = 'alphashape_{:d}.pdf'
for R in progressbar.progressbar([5,10, 50, 100, 100000]):
    
    r = np.array(radius)<R
    fig = plt.figure()
    ax = plt.gca()
    ax.set_xlim(-2, n+10)
    ax.set_ylim(-2, m+10)
    plt.triplot(points[:,0], points[:,1], tri.simplices[r], lw=.5)
    plt.scatter(points[:,0], points[:,1], c='y', s=10)
    plt.savefig(output.format(R), bbox_inches='tight')
    plt.show()


## Usage of alphashape module
import alphashape
import matplotlib.pyplot as plt
from descartes import PolygonPatch


for R in progressbar.progressbar([5, 10, 50, 100, 100000]):
    # Generate the alpha shape
    alpha_shape = alphashape.alphashape(points, 1/R)
    
    # Initialize plot
    fig, ax = plt.subplots()
    
    # Plot input points
    ax.scatter(*zip(*points), s=1)
    
    # Plot alpha shape
    ax.add_patch(PolygonPatch(alpha_shape, alpha=.2))
    
    plt.show()