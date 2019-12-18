#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 12 14:39:57 2018

@author: yann
"""

from scipy import ndimage, misc
import matplotlib.pyplot as plt
import numpy as np
from skimage import morphology


def LaplacianPyramidDecomposition(Image, levels, interp='bilinear'):
    """
    Laplacian / Gaussian Pyramid
    The last image of the laplacian pyramid allows a full reconstruction of the original image.
    Image: original image, float32
    levels: number of levels of decomposition
    interp: interpolation mode for downsizing the image

    returns: pyrL, pyrG: Laplacian and Gaussian pyramids, respectively, as a list of arrays
    """

    pyrL = []
    pyrG = []

    sigma = 3.
    for l in range(levels):
        prevImage = Image.copy()
        g = ndimage.gaussian_filter(Image, sigma)

        Image = misc.imresize(g, .5, interp=interp, mode='F')
        primeImage = misc.imresize(
            Image, prevImage.shape, interp=interp, mode='F')

        pyrL.append(prevImage - primeImage)
        pyrG.append(prevImage)

    pyrL.append(Image)
    pyrG.append(Image)
    return pyrL, pyrG


def LaplacianPyramidReconstruction(pyr, interp='bilinear'):
    """
    Reconstruction of the Laplacian pyramid, starting from the last image
    pyr: pyramid of images (list of arrays)
    interp: interpolation mode, for upsizing the image
    returns: Image, reconstructed image
    """

    Image = pyr[-1]
    for i in range(len(pyr)-2, -1, -1):
        Image = pyr[i] + \
            misc.imresize(Image, pyr[i].shape, interp=interp, mode='F')

    return Image


def morphoMultiscale(I, levels):
    """
    Morphological multiscale decomposition
    I: original image, float32
    levels: number of levels, int

    returns: pyrD, pyrE: pyramid of Dilations/Erosions, respectively
    """
    pyrD = []
    pyrE = []
    for r in np.arange(1, levels):
        se = morphology.disk(r)
        pyrD.append(morphology.dilation(I, selem=se))
        pyrE.append(morphology.erosion(I, selem=se))
    return pyrD, pyrE


def kb(I, r):
    """
    Elementary Kramer/Brckner filter. Also called toggle filter.
    I: image
    r: radius of structuring element (disk), for max/min evaluation
    """
    se = morphology.disk(r)
    D = morphology.dilation(I, selem=se)
    E = morphology.erosion(I, selem=se)
    difbool = D-I < I-E
    k = D*difbool + E * (~difbool)
    return k


def KBmultiscale(I, levels, r=1):
    """
    Kramer and Bruckner multiscale decomposition

    I: original image, float32
    pyrD: pyramid of Dilations
    pyrE: pyramid of Erosions

    returns: MKB: Kramer/Bruckner filters
    """
    MKB = []
    MKB.append(I)
    for i in np.arange(1, levels):
        MKB.append(kb(MKB[i-1], r))
    return MKB


def displayPyr(pyr, filename=None):
    """
    Display all images of pyramid and stores them in files
    pyr: list of images (np arrays)
    filename: generic name for saving images, in a file: <filename><i>.png
    """

    for counter, im in enumerate(pyr):
        plt.imshow(im/np.max(im), cmap='gray')
        plt.show()
        if filename:
            plt.imsave(filename + str(counter) + '.python.png',
                       im/np.max(im), cmap='gray')


I = imageio.imread('cerveau.jpg')
I = I[:, :, 0]  # grayscale image
I = I.astype('float32')
pyrL, pyrG = LaplacianPyramidDecomposition(I, 3)

displayPyr(pyrL, 'laplacian')
displayPyr(pyrG, 'gaussian')

R = LaplacianPyramidReconstruction(pyrL)
plt.imshow(R.astype('uint8'))
plt.show()
plt.imsave("lPyrRec.python.png", R/np.max(R), cmap='gray')

# reconstruction of the pyramid when filtering (avoiding) the details
for i in np.arange(0, len(pyrL)-1):
    pyrL[i] = np.zeros(pyrL[i].shape)
R2 = LaplacianPyramidReconstruction(pyrL)
plt.imshow(R2)
plt.show()
plt.imsave("lPyrnodetails.python.png", R2/np.max(R2), cmap='gray')

pyrD, pyrE = morphoMultiscale(I, 4)
displayPyr(pyrD, 'dilation')
displayPyr(pyrE, 'erosion')

MKB = KBmultiscale(I, 4, r=5)
displayPyr(MKB, 'mkb')
