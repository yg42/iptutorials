#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr  9 15:20:30 2018

@author: yann
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import ndimage as ndi

from scipy import misc

from skimage import morphology
from skimage.morphology import watershed
from skimage.feature import peak_local_max


def regionalmaximum(I):
    """
    Own version of regional maximum
    This avoids plateaus problems of peak_local_max
    I: original image, int values
    returns: binary array, with 1 for the maxima
    """
    h = 1
    rec = morphology.reconstruction(I, I+h)
    maxima = I + h - rec
    return maxima


def rmax(I):
    """
    Own version of regional maximum
    This avoids plateaus problems of peak_local_max
    I: original image, int values
    returns: binary array, with 1 for the maxima
    """
    I = I.astype('float')
    I = I / np.max(I) * 2**31
    I = I.astype('int32')
    h = 1
    rec = morphology.reconstruction(I, I+h)
    maxima = I + h - rec
    return maxima


def rmax2(I):
    """
    Own version of regional maximum
    This avoids plateaus problems of peak_local_max
    I: original image, int values
    returns: binary array, with 1 for the maxima
    """
    m = np.min(I)
    M = np.max(I)
    maxima = np.zeros(I.shape, dtype=bool)
    for t in np.arange(m, M+1, .1):
        CSt = I >= t
        CSt2 = I > t
        rec = morphology.reconstruction(CSt2, CSt)
        maxima = maxima | CSt & np.logical_not(rec)
    return maxima


# Generate an initial image with two overlapping circles
x, y = np.indices((80, 80))
x1, y1, x2, y2 = 28, 28, 44, 52
r1, r2 = 20.7, 24.7
mask_circle1 = (x - x1)**2 + (y - y1)**2 < r1**2
mask_circle2 = (x - x2)**2 + (y - y2)**2 < r2**2
image = np.logical_or(mask_circle1, mask_circle2)

# Now we want to separate the two objects in image
# Generate the markers as local maxima of the distance to the background
distance = ndi.distance_transform_cdt(image)
imageio.imwrite("dm.png", distance)
# local_maxi = peak_local_max(distance, indices=False, footprint=np.ones((3, 3)),
#                            labels=image)
local_maxi = morphology.local_maxima(distance)
markers = ndi.label(local_maxi, np.ones((3, 3)))[0]
labels = watershed(-distance, markers, mask=image)
plt.imshow(markers)
plt.show()

fig, axes = plt.subplots(ncols=3, figsize=(9, 3), sharex=True, sharey=True)
ax = axes.ravel()

ax[0].imshow(image, cmap=plt.cm.gray, interpolation='nearest')
ax[0].set_title('Overlapping objects')
ax[1].imshow(-distance, cmap=plt.cm.gray, interpolation='nearest')
ax[1].set_title('Distances')
ax[2].imshow(labels, cmap=plt.cm.nipy_spectral, interpolation='nearest')
ax[2].set_title('Separated objects')

for a in ax:
    a.set_axis_off()

fig.tight_layout()
plt.show()
