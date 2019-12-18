# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 12:20:42 2015

@author: yann
"""

from scipy import ndimage, misc
import numpy as np

import matplotlib.pyplot as plt


def disk(radius):
    # defines a circular structuring element with radius given by 'radius'
    x = np.arange(-radius, radius+1, 1)
    xx, yy = np.meshgrid(x, x)
    d = np.sqrt(xx**2 + yy**2)
    return d <= radius


# read binary image (and ensure binarization)
B = imageio.imread("B.jpg")
B = B > 100

# Structuring element
square = np.ones((5, 5))

# Erosion
Bsquare_erode = ndimage.morphology.binary_erosion(B, structure=square)
plt.subplot(231)
plt.imshow(Bsquare_erode)
plt.title("erosion")
imageio.imwrite('erosion.png', Bsquare_erode)

# Dilation
Bsquare_dilate = ndimage.morphology.binary_dilation(B, structure=square)
plt.subplot(232)
plt.imshow(Bsquare_dilate)
plt.title("dilation")
imageio.imwrite('dilation.png', Bsquare_dilate)

# Opening
Bsquare_open = ndimage.morphology.binary_opening(B, structure=square)
plt.subplot(233)
plt.imshow(Bsquare_open)
plt.title("opening")
imageio.imwrite('open.png', Bsquare_open)

# Closing
Bsquare_close = ndimage.morphology.binary_closing(B, structure=square)
plt.subplot(234)
plt.imshow(Bsquare_close)
plt.title("closing")
imageio.imwrite('close.png', Bsquare_close)

# original image
plt.subplot(235)
plt.imshow(B)
plt.title("original image")

plt.show()
