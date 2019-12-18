# -*- coding: utf-8 -*-
"""
Created on Wed Feb 18 11:17:37 2015
Segmentation by threshold with the Otsu method for calculating automatic 
threshold value.

@author: yann
"""

import numpy as np
from scipy import misc
import imageio
import matplotlib.pyplot as plt  # plots
from skimage import filters  # otsu thresholding

# automatic threshold


def autothresh(image):
    """ Automatic threshold method
    @param image: image to segment
    @return : threshold value
    """
    s = 0.5*(np.amin(image) + np.amax(image))
    done = False
    while ~done:
        B = image >= s
        sNext = .5*(np.mean(image[B]) + np.mean(image[~B]))
        done = abs(s-sNext) < .5
        s = sNext
    return s


# START -------------------------------
cells = imageio.imread('cells.png')

# display histogram
fig = plt.figure()
plt.hist(cells.flatten(), 256)
fig.show()
fig.savefig("histo.pdf", bbox_inches='tight')

# manual segmentation
fig = plt.figure()
plt.subplot(1, 2, 1)
plt.imshow(cells, plt.cm.gray)
plt.title('Original image')
plt.subplot(1, 2, 2)
plt.imshow(cells > 80, plt.cm.gray)
plt.title('Manual segmentation')
fig.savefig("manual.pdf")

# Automatic threshold
s_auto = autothresh(cells)

# Otsu thresholding
s_otsu = filters.threshold_otsu(cells)

fig = plt.figure()
plt.subplot(1, 2, 1)
plt.imshow(cells > s_auto, plt.cm.gray)
plt.title('Automatic thresholding')
plt.subplot(1, 2, 2)
imageio.imwrite("autothresh.png", (cells > s_auto).astype('int'))
plt.imshow(cells > s_otsu, plt.cm.gray)
plt.title('Otsu thresholding')
plt.show()
imageio.imwrite("otsuthresh.png", (cells > s_otsu).astype('int'))
# K-means clustering on synthetic data
