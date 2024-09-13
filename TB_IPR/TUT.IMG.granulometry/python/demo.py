# -*- coding: utf-8 -*-
"""
Created on Thu Mar 26 15:58:51 2015
Granulometry example on powder image

@author: yann
"""


from scipy import ndimage
import numpy as np
from skimage.io import imread, imsave

import matplotlib.pyplot as plt


def granulometry(BW, T=35, filename="simu"):
    # total original area
    A = ndimage.sum(BW)

    # number of objects
    label, N = ndimage.label(BW)

    area = np.zeros((T,), dtype=float)
    number = np.zeros((T,), dtype=float)

    """
    Warning: the structuring elements must verify B(n) = B(n-1) o B(1).
    """
    se = ndimage.generate_binary_structure(2, 1)
    for i in np.arange(T):
        SE = ndimage.iterate_structure(se, i-1)
        m = ndimage.binary_erosion(BW, structure=SE)
        G = ndimage.binary_propagation(m, mask=BW)
        area[i] = 100*ndimage.sum(G)/A
        label, n = ndimage.label(G)
        number[i] = 100*n/N  # beware of integer division

    plt.figure()
    plt.plot(area, label='Area')
    plt.plot(number, label='Number')
    plt.legend()
    plt.savefig("granulo_"+filename+"1.pdf", bbox_inches='tight')
    plt.show()

    plt.figure()
    plt.plot(-np.diff(area), label='Area derivative')
    plt.plot(-np.diff(number), label='Number derivative')
    plt.legend()
    plt.savefig("granulo_"+filename+"2.pdf", bbox_inches='tight')
    plt.show()


# Granulometry of synthetic image
# read binary simulated image, normalize it
I = imread("simulation.png")/255
I = I > .5
plt.figure()
plt.imshow(I)
plt.show()

granulometry(I, 35)


# Granulometry of real image
I = imread("poudre.bmp")

# segmentation
BW = I > 74
BW = ndimage.binary_fill_holes(BW)

# suppress small objects
se = ndimage.generate_binary_structure(2, 1)
m = ndimage.binary_opening(BW)
# opening by reconstruction
BW = ndimage.binary_propagation(m, mask=BW)

imsave("segmentation_granulo.python.png", BW.astype('int'))
plt.imshow(BW)
plt.show()

granulometry(BW, 20, filename="poudre")
