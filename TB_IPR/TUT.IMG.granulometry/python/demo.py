# -*- coding: utf-8 -*-
"""
Created on Thu Mar 26 15:58:51 2015
Granulometry example on powder image

@author: yann
"""


from scipy import ndimage, misc
import numpy as np

import matplotlib.pyplot as plt


def granulometry(BW, T=35, filename="simu"):
    # total original area
    A = ndimage.measurements.sum(BW)

    # number of objects
    label, N = ndimage.measurements.label(BW)

    area = np.zeros((T,), dtype=np.float)
    number = np.zeros((T,), dtype=np.float)

    """
    Warning: the structuring elements must verify B(n) = B(n-1) o B(1).
    """
    se = ndimage.generate_binary_structure(2, 1)
    for i in np.arange(T):
        SE = ndimage.iterate_structure(se, i-1)
        m = ndimage.morphology.binary_erosion(BW, structure=SE)
        G = ndimage.morphology.binary_propagation(m, mask=BW)
        area[i] = 100*ndimage.measurements.sum(G)/A
        label, n = ndimage.measurements.label(G)
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
I = imageio.imread("simulation.png")/255
I = I[:, :, 2] > .5
plt.figure()
plt.imshow(I)
plt.show()

granulometry(I, 35)


# Granulometry of real image
I = imageio.imread("poudre.bmp")

# segmentation
BW = I > 74
BW = ndimage.morphology.binary_fill_holes(BW)

# suppress small objects
se = ndimage.generate_binary_structure(2, 1)
m = ndimage.morphology.binary_opening(BW)
# opening by reconstruction
BW = ndimage.morphology.binary_propagation(m, mask=BW)

imageio.imwrite("segmentation_granulo.python.png", BW.astype('int'))
plt.imshow(BW)
plt.show()

granulometry(BW, 20, filename="poudre")
