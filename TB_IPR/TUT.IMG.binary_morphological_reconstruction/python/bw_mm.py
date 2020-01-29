# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 12:20:42 2015
This code illustrates binary mathematical morphology operations

@author: yann
"""

from scipy import ndimage, misc
import numpy as np
import skimage

import matplotlib.pyplot as plt


def disk(radius):
    # defines a circular structuring element with radius given by 'radius'
    x = np.arange(-radius, radius+1, 1)
    xx, yy = np.meshgrid(x, x)
    d = np.sqrt(xx**2 + yy**2)
    return d <= radius


# read binary image (and ensure binarization)
B = skimage.io.imread("B.jpg")
B = B > 100

# Structuring element
square = np.ones((5, 5))

# Erosion
Bsquare_erode = ndimage.morphology.binary_erosion(B, structure=square)
plt.subplot(231)
plt.imshow(Bsquare_erode)
plt.title("erosion")
skimage.io.imsave('erosion.png', 255*Bsquare_erode.astype(np.uint8))

# Dilation
Bsquare_dilate = ndimage.morphology.binary_dilation(B, structure=square)
plt.subplot(232)
plt.imshow(Bsquare_dilate)
plt.title("dilation")
skimage.io.imsave('dilation.png', 255*Bsquare_dilate.astype(np.uint8))

# Opening
Bsquare_open = ndimage.morphology.binary_opening(B, structure=square)
plt.subplot(233)
plt.imshow(Bsquare_open)
plt.title("opening")
skimage.io.imsave('open.png', 255*Bsquare_open.astype(np.uint8))

# Closing
Bsquare_close = ndimage.morphology.binary_closing(B, structure=square)
plt.subplot(234)
plt.imshow(Bsquare_close)
plt.title("closing")
skimage.io.imsave('close.png', 255*Bsquare_close.astype(np.uint8))

# original image
plt.subplot(235)
plt.imshow(B)
plt.title("original image")

plt.show()
