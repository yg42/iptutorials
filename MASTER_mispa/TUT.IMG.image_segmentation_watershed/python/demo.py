#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr  9 14:44:13 2018

@author: yann
"""


import numpy as np
from scipy import misc
import matplotlib.pyplot as plt
from scipy import ndimage as ndi
from scipy.ndimage.morphology import distance_transform_edt
from scipy.ndimage.morphology import distance_transform_cdt
from skimage import morphology


def rmax(I):
    """
    Own version of regional maximum
    This avoids plateaus problems of peak_local_max
    I: original image, int values
    returns: binary array, with True for the maxima
    """
    I = I.astype('float')
    I = I / np.max(I) * 2**31
    I = I.astype('int32')
    h = 1
    rec = morphology.reconstruction(I-h, I)
    maxima = I - rec
    return maxima > 0


###############################################################################
# %% Separation of synthetic grains
A = imageio.imread('circles.tif')
plt.imshow(A)
plt.show()

# chamfer distance gives integer distances
dm = distance_transform_edt(A)
plt.imshow(dm)
plt.show()
imageio.imwrite("dm.python.png", dm)

# regional maxima
local_maxi = morphology.local_maxima(dm)
plt.imshow(local_maxi)
plt.show()

# watershed segmentation for separating the circles
markers = ndi.label(local_maxi, np.ones((3, 3)))[0]
plt.imshow(markers)
plt.show()
imageio.imwrite("markers.python.png", markers)
W = morphology.watershed(-dm, markers, watershed_line=True)
plt.imshow(W == 0)
plt.show()

# separation of the grains
B = A & W == 0
separation = ndi.label(B, np.ones((3, 3)))[0]
plt.imshow(separation)
plt.show()
imageio.imwrite("separation.python.png", separation)

###############################################################################
# %% use markers on gradient: result is over-segmented


def sobel_mag(im):
    """
    Returns Sobel gradient magnitude
    im: image array of type float
    returns: magnitude of gradient (L2 norm)
    """
    dx = ndi.sobel(im, axis=1)   # horizontal derivative
    dy = ndi.sobel(im, axis=0)   # vertical derivative
    mag = np.hypot(dx, dy)  # magnitude
    return mag


gel = imageio.imread('gel.jpg')
g = sobel_mag(gel.astype('float'))
plt.imshow(g)
plt.show()
local_maxi = morphology.local_maxima(g)
imageio.imwrite("sobel.python.png", g)
imageio.imwrite("markers_gel.python.png", 255*local_maxi.astype('uint8'))

markers = ndi.label(local_maxi, np.ones((3, 3)))[0]
plt.imshow(markers)
plt.show()
W = morphology.watershed(g, markers, watershed_line=True)
plt.imshow(W)
plt.show()
imageio.imwrite("gel_gradient.python.png", W)

###############################################################################
# %%
# filter image before computing gradient
# result should be better
SE = morphology.disk(2)
O = morphology.opening(gel, selem=SE)
F = morphology.closing(O,   selem=SE).astype('float')
g = sobel_mag(F).astype('float')
local_maxi = morphology.local_maxima(g)

markers = ndi.label(local_maxi, np.ones((3, 3)))[0]

W = morphology.watershed(g, markers, watershed_line=True)
plt.imshow(W)
plt.show()

imageio.imwrite("gel_gradient_filtered.python.png", W)
###############################################################################
# %%
# mark the background and the objects
imageio.imwrite("filtered_gel.python.png", 255-F)
local_maxi = morphology.local_maxima(255-F)
plt.imshow(local_maxi)
plt.show()

markers = ndi.label(local_maxi, np.ones((3, 3)))[0]
plt.imshow(markers)
plt.show()

W = morphology.watershed(F, markers, watershed_line=True)
plt.imshow(W == 0)
plt.show()
imageio.imwrite("watershed_background_filtered.python.png", W)

markers2 = local_maxi | (W == 0)
plt.imshow(markers2)
plt.show()
plt.imsave("markers_filtered.python.png", markers2)
M = ndi.label(markers2, np.ones((3, 3)))[0]
plt.imshow(M)
plt.show()
segmentation = morphology.watershed(g, M, watershed_line=True)

gel[segmentation == 0] = 255
plt.imshow(gel)
plt.show()
imageio.imwrite("segmentation.python.png", gel)
