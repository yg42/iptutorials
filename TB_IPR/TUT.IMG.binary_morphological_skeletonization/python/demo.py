
from scipy import ndimage
import numpy as np

import imageio
import matplotlib.pyplot as plt


def hitormiss(X, T):
    """
    hit or miss transform
    X: binary image
    T: structuring element (values -1, 0 and 1)

    return: result of hit or miss transform (binary image)
    """
    T1 = (T == 1)
    T2 = (T == -1)
    E1 = ndimage.morphology.binary_erosion(X, T1)
    E2 = ndimage.morphology.binary_erosion(np.logical_not(X), T2)
    B = np.minimum(E1, E2)
    return B


def elementary_thinning(X, T):
    """
    thinning function
    X: binary image
    T: structuring element (values -1, 0 and 1)

    return: result of thinning
    """
    B = np.minimum(X, np.logical_not(hitormiss(X, T)))
    return B


def elementary_thickening(X, T):
    """
    thickening function
    X: binary image
    T: structuring element (values -1, 0 and 1)

    return: result of thickening
    """
    B = not(elementary_thinning(not(X), T))
    return B


def thinning(X, TT):
    """
    morphological thinning
    TT is a configuration of 8 pairs of structuring elements
    """
    for T in TT:
        X = elementary_thinning(X, T)

    return X


def topological_skeleton(X, TT):
    """
    Topological skeleton: preserves topology
    X: binary image to be transformed
    TT: set of pairs of structuring elements
    return skeleton
    """
    B = np.logical_not(np.copy(X))
    while not(np.all(X == B)):
        B = X
        X = thinning(X, TT)
    return B


def disk(radius):
    # defines a circular structuring element with radius given by 'radius'
    x = np.arange(-radius, radius+1, 1)
    xx, yy = np.meshgrid(x, x)
    d = np.sqrt(xx**2 + yy**2)
    return d <= radius


def morphological_skeleton(X):
    """ 
    morphological skeleton 
    X: binary image
    using disk structuring elements

    in order to perform the reconstruction from the skeleton, one has to store 
    the value of S for each size of structuring element

    return: S, morphological skeleton, grayscale image
    """
    strel_size = -1
    pred = True
    S = np.zeros(X.shape)
    se = ndimage.generate_binary_structure(2, 1)
    E = np.copy(X)
    while pred:
        strel_size += 1
        E = ndimage.morphology.binary_erosion(X, se)
        if np.all(E == 0):
            pred = False
        D = ndimage.morphology.binary_dilation(E, se)
        S = np.maximum(S, (strel_size+1)*np.minimum(X, np.logical_not(D)))
        X = E
    return S


def reconstruction_skeleton(S):
    """
    Reconstruction of the original image from the morphological skeleton
    S: Skeleton, as constructed by morphological_skeleton

    return: original image I
    """
    X = np.zeros(S.shape).astype("bool")
    n = np.max(S)
    se = ndimage.generate_binary_structure(2, 1)

    for strel_size in range(int(n)):
        Sn = S == strel_size+1

        # this is for preserving homothetic structuring elements
        for k in range(strel_size):
            Sn = ndimage.morphology.binary_dilation(Sn, se)

        X = np.maximum(X, Sn)
    return X


I = imageio.imread("mickey.png")
I = I > 100
TT = []
TT.append(np.array([[-1, -1, -1], [0, 1, 0], [1, 1, 1]]))
TT.append(np.array([[0, -1, -1], [1, 1, -1], [0, 1, 0]]))
TT.append(np.array([[1, 0, -1], [1, 1, -1], [1, 0, -1]]))
TT.append(np.array([[0, 1, 0], [1, 1, -1], [0, -1, -1]]))
TT.append(np.array([[1, 1, 1], [0, 1, 0], [-1, -1, -1]]))
TT.append(np.array([[0, 1, 0], [-1, 1, 1], [-1, -1, 0]]))
TT.append(np.array([[-1, 0, 1], [-1, 1, 1], [-1, 0, 1]]))
TT.append(np.array([[-1, -1, 0], [-1, 1, 1], [0, 1, 0]]))

# %% test Hit-or-miss transformation
T = np.array([[1, 1, 1], [0, 1, 0], [-1, -1, -1]])
B = hitormiss(I, T)
imageio.imwrite('hitormiss.python.png', 255-255*B.astype('uint8'))

# %% thinning and thickening
B = thinning(I, TT)
B = thinning(B, TT)
imageio.imwrite('thinning.python.png', 255*B.astype('uint8'))

C = 1-thinning(1-I, TT)
C = 1-thinning(1-C, TT)
imageio.imwrite('thickening.python.png', 255*C.astype('uint8'))

# %% skeletons
St = topological_skeleton(I, TT)
plt.imshow(St)
plt.show()
imageio.imwrite("topological_skeleton.python.png", 255-255*St.astype('uint8'))
Sm = morphological_skeleton(I)
plt.imshow(Sm)
plt.show()
imageio.imwrite("morphological_skeleton.python.png", 255-Sm)
R = reconstruction_skeleton(Sm)
plt.imshow(R)
plt.show()
imageio.imwrite("reconstruction.png", 255*R.astype('uint8'))

# check if images are equal
plt.imshow(np.logical_not(I == R))
plt.show()
