#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar  7 10:56:07 2018

@author: yann
"""

import numpy as np
import matplotlib.pyplot as plt
from scipy import misc, ndimage
from skimage import morphology

# read image
A = imageio.imread('follicle.png')
plt.imshow(A)
plt.show()

# Antrum
# segmentation by mathematical morphology
# manual selection of the antrum
B = A[:, :, 2]
antrum = B > 220

L = morphology.label(antrum, connectivity=2)
antrum = L == L[300, 300]
antrum = ndimage.morphology.binary_fill_holes(antrum)
plt.imshow(antrum)
plt.imsave("antrum.png", antrum)
plt.title('Antrum')
plt.show()

# Theca
se40 = morphology.disk(40)
theca = morphology.binary_dilation(antrum, selem=se40)
theca = theca - antrum
plt.imshow(theca)
plt.imsave("theca.png", theca)
plt.title('Theca')
plt.show()

# vascularization
vascularization = B < 140
vascularization = vascularization * theca
plt.imshow(vascularization)
plt.imsave("vascularization.png", vascularization)
plt.title('vascularization')
plt.show()

# Granulosa cells
se10 = morphology.disk(10)
dil = 1-morphology.binary_closing(vascularization, se10)
L = morphology.label(dil, connectivity=1)
dil = L == L[300, 300]
granulosa = dil - antrum
plt.imshow(granulosa)
plt.imsave('granulosa.png', granulosa)
plt.title('granulosa')
plt.show()

# Quantification
result = antrum + 2*granulosa + 3*vascularization
plt.imshow(result, cmap='jet')
plt.show()
plt.imsave("result_python.png", result, cmap='jet')

follicle = antrum + theca
q_vascularization = np.sum(vascularization) / np.sum(follicle)
print('vascularization: ', q_vascularization)
q_granulosa = np.sum(granulosa)/np.sum(follicle)
print('Granulosa: ', q_granulosa)
