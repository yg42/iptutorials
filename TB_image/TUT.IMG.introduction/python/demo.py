#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 15 11:56:44 2018

@author: yann
"""

import matplotlib.pyplot as plt
from scipy import misc, ndimage

import imageio
import numpy as np
# measure time
import time

###############################################################################
# %%
# load and display images
ascent = misc.ascent()

plt.figure(figsize=(10, 3.6))

# first subplot
plt.subplot(131)
plt.imshow(ascent)

# second subplot
plt.subplot(132)
plt.imshow(ascent, cmap=plt.cm.gray)
plt.axis('off')

# third subplot (zoom)
plt.subplot(133)
plt.imshow(ascent[200:220, 200:220], cmap=plt.cm.gray, interpolation='nearest')

plt.subplots_adjust(wspace=0, hspace=0.,
                    top=0.99, bottom=0.01,
                    left=0.05, right=0.99)
plt.show()


###############################################################################
# %%
# test jpeg quality
p=128
imageio.imwrite("a_25.python.jpeg", ascent[:p, :p], quality=25);
imageio.imwrite("a_100.python.jpeg", ascent[:p, :p], quality=100);
imageio.imwrite("a_50.python.jpeg", ascent[:p, :p], quality=50);
imageio.imwrite("a_75.python.jpeg", ascent[:p, :p], quality=75);
imageio.imwrite("a_1.python.jpeg", ascent[:p, :p], quality=1);

###############################################################################
# %%
# simple stretching
# has almost visually no effect because of imshow that stretches the intensities
def image_stretch(I):
    I = I - np.min(I)
    I = 255 * I / np.max(I)
    return I.astype('int')


a0 = ascent/4
plt.imshow(a0, cmap='gray')
plt.show()
a2 = image_stretch(ascent)
plt.imshow(a2, cmap='gray')
plt.title('image stretching')
plt.show()

###############################################################################
# %%
# color quantization

q4 = ascent//4 *4
q16= ascent//16*16
q32= ascent//32*32

imageio.imwrite('q4.python.png', q4);
imageio.imwrite('q16.python.png', q16);
imageio.imwrite('q32.python.png', q32);


###############################################################################
# %%
# resizing
S = ascent.shape
for s in [2,3,4,5,10,20]:
    r = ascent[::s, ::s]
    plt.imshow(r);
    plt.show()
    imageio.imwrite('r'+str(s)+'.python.png', r)


###############################################################################
# %%
# observation of the different color channels
retine = imageio.imread('retine.png');
plt.imshow(retine);

for c in range(3):
    plt.imshow(retine[:,:,c], cmap=plt.cm.gray)
    plt.show()
    imageio.imwrite('retine_'+str(c)+'.python.png', retine[:,:,c])
    
###############################################################################
# %%
# Histogram function with 2D image


def compute_histogram(image):
    tab = np.zeros((256, ), dtype='I')
    X, Y = image.shape
    for i in range(X):
        for j in range(Y):
            tab[image[i, j]] += 1

    return tab

# Histogram function with flatten image (vector)


def compute_histogram2(image):
    im = image.flatten()
    tab = np.zeros((256, ), dtype='I')
    for i in im:
        tab[i] += 1
    return tab


# --------------------
# beginning of code
# load ascent and compute histograms
ascent = misc.ascent()
t0 = time.clock()
h = compute_histogram(ascent)
t1 = time.clock()
h2 = compute_histogram2(ascent)
t2 = time.clock()

# .... plots
print("execution time 2D: %g s" % (t1-t0))
plt.subplot(131)
plt.plot(h)
plt.title('2D function')

print("execution time 1D: %g s" % (t2-t1))
plt.subplot(132)
plt.plot(h2)
plt.title('1D function')

# last plot: with matplotlib function
plt.subplot(133)
t3 = time.clock()
plt.hist(ascent.flatten(), 256)
t4 = time.clock()
print ("execution time matplotlib: %g s" % (t4-t3))

plt.savefig("histogrammes.pdf")

# display
plt.show()

###############################################################################
# %%
# aliasing effect (Moiré)


def circle(fs, f):
    # Generates an image with aliasing effect
    # fs: sample frequency
    # f : signal frequency
    t = np.arange(0, 1, 1./fs)
    ti, tj = np.meshgrid(t, t)
    C = np.sin(2*np.pi*f*np.sqrt(ti**2 + tj**2))
    return C


C = circle(300, 50)
plt.imshow(C, cmap=plt.cm.gray)
plt.show()

imageio.imwrite('moire.png', C)

###############################################################################
# %% filtering by convolution: uniform (average), prewitt, gaussian
# ascent image
ascent = misc.ascent()

# mean on a 3x3 neighborhood
m3 = ndimage.filters.uniform_filter(ascent)
m25 = ndimage.filters.uniform_filter(ascent, 25)

plt.subplot(121)
plt.imshow(m3, cmap=plt.cm.gray)
plt.axis('off')
plt.title('3x3 mean filter')

plt.subplot(122)
plt.imshow(m25, cmap=plt.cm.gray)
plt.axis('off')
plt.title('25x25 mean filter')

plt.show()

imageio.imwrite('ascent_mean_3.png', m3)
imageio.imwrite('ascent_mean_25.png', m25)

# Prewitt filter
prewitt0 = ndimage.filters.prewitt(ascent, axis=0)
imageio.imwrite('prewitt0.png', prewitt0)
prewitt1 = ndimage.filters.prewitt(ascent, axis=1)
imageio.imwrite('prewitt1.png', prewitt1)

# Gaussian filter
gaussian = ndimage.filters.gaussian_filter(ascent, 5)
imageio.imwrite('gaussian.png', gaussian)

# display results
plt.subplot(131)
plt.imshow(prewitt0, cmap=plt.cm.gray)
plt.axis('off')
plt.title('Prewitt filter axis 0')

plt.subplot(132)
plt.imshow(prewitt1, cmap=plt.cm.gray)
plt.axis('off')
plt.title('Prewitt filter axis 1')

plt.subplot(133)
plt.imshow(gaussian, cmap=plt.cm.gray)
plt.axis('off')
plt.title('Gaussian filter')

plt.show()

# using convolution filter
from scipy.signal import convolve2d
h = np.array([[-1, 0, 1], [-1, 0, 1], [-1, 0, 1] ])
grad1 = convolve2d(ascent, h);
plt.imshow(grad1, cmap=plt.cm.gray)
plt.show()

grad0 = convolve2d(ascent, h.transpose());
plt.imshow(grad0, cmap=plt.cm.gray)
plt.show()

plt.imshow(np.sqrt(grad0**2 + grad1**2), cmap=plt.cm.gray)
plt.show()

# laplacian enhancement
# image sharpening
import skimage

def sharpen(I, alpha):
    
    h = np.array([[-1, -1, -1], [-1, 8, -1], [-1, -1, -1] ])
    L = convolve2d(I, h, mode='same')
    np.max(L)
    E = alpha * I + L
    E = skimage.exposure.rescale_intensity(E, out_range=(0,255))
    E = E.astype(np.uint8)
    
    return E


I = skimage.io.imread('osteoblaste.bmp').astype(np.float)
I = I/255
A = [1, 0.5, 5]

fig = plt.figure(figsize=(12,8))
plt.subplot(221)
plt.imshow(I, cmap=plt.cm.gray)
for i,alpha in enumerate(A):
    plt.subplot(222+i)
    E = sharpen(I, alpha)
    E = skimage.exposure.rescale_intensity(E, out_range=(0,255))
    plt.imshow(E, cmap=plt.cm.gray)
    plt.title('alpha='+str(alpha))
    
    skimage.io.imsave('osteoblaste_rehauss_'+str(alpha)+'.python.png', E)

plt.show()
