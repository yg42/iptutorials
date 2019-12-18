# -*- coding: utf-8 -*-
"""
Created on Wed Feb 22 16:15:51 2017

@author: yann
"""
import numpy as np
import matplotlib.pyplot as plt
from scipy import misc, signal
from scipy.special import erfc
import skimage
from skimage import measure
import progressbar


def grf2D(N, sigma):
    # Discrete space
    x = np.arange(-N/2, N/2)
    [X, Y] = np.meshgrid(x, x)

    # Covariance function
    C = np.exp(-1/2 * ((X / sigma / np.sqrt(2))**2+(Y/sigma/np.sqrt(2)) ** 2))
    Cmat = np.fft.fftshift(C)

    # real positive part, then square root
    Cf = np.real(np.fft.fft2(Cmat))
    Cf = np.sqrt(np.maximum(np.zeros(Cf.shape), Cf))
    # Complex white noise
    W = np.random.randn(N, N)
    A = Cf * np.fft.fft2(W)
    G = np.real(np.fft.ifft2(A))
    return G


N = 2**10
sigma = 10
G = grf2D(N, sigma)
plt.imshow(G)
plt.show()

# check some stats properties
m = np.mean(G)
s = np.std(G)
#print("mean: ", m, " std: ", s);

imageio.imwrite("grf.python.png", G)


def bwminko(X):
    """
    This code is part of another tutorial
    """

    # zero padding of input
    X = np.pad(X, ((1, 1), (1, 1)), mode='constant')
    # Neighborhood configuration
    F = np.array([[0, 0, 0], [0, 1, 4], [0, 2, 8]])
    XF = signal.convolve2d(X, F, mode='same')
    edges = np.arange(0, 17, 1)
    h, edges = np.histogram(XF[:], bins=edges)

    f_intra = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
    e_intra = [0, 2, 1, 2, 1, 2, 2, 2, 0, 2, 1, 2, 1, 2, 2, 2]
    v_intra = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    f_inter = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
    e_inter = [0, 0, 0, 1, 0, 1, 0, 2, 0, 0, 0, 1, 0, 1, 0, 2]
    v_inter = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1]
    EulerNb4 = np.sum(h*v_inter - h*e_inter + h*f_inter)
    Area = np.sum(h*f_intra)
    Perimeter = np.sum(-4*h*f_intra + 2*h*e_intra)
    return Area, Perimeter, EulerNb4


def minkoMeasured(G, sigma, hmin, hmax):
    H = np.arange(hmin, hmax, .1)
    A = []
    P = []
    E = []

    bar = progressbar.ProgressBar()
    for h in bar(H):
        levelset = G >= h
#        A[i] = np.sum(levelset);
#        P[i] = measure.perimeter(levelset);# perimeter in 4-neighborhood
#        E[i] = eulerNb4(levelset) # euler number
        a, p, e = bwminko(levelset)
        p = measure.perimeter(levelset)
        A.append(a)
        P.append(p)
        E.append(e)
    return A, P, E


def minkoAnalytical(N, sigma, hmin, hmax):
    l = 1/(2*sigma**2)
    # analytical values
    H = np.arange(hmin, hmax, .1)
    rho_0 = 1/2 * erfc(H / np.sqrt(2))
    rho_1 = np.sqrt(l) * np.exp(- H**2 / 2) / (2*np.pi)
    rho_2 = l / (2*np.pi)**(3/2) * np.exp(- H**2 / 2) * H

    Aa = N**2 * rho_0
    Pa = 4*N*rho_0 + np.pi*N**2*rho_1
    Ea = rho_0 + 2*N*rho_1 + N**2*rho_2
    return Aa, Pa, Ea


hmin = np.min(G)
hmax = np.max(G)
A, P, E = minkoMeasured(G, sigma, hmin, hmax)
Aa, Pa, Ea = minkoAnalytical(N, sigma, hmin, hmax)
plt.plot(np.arange(hmin, hmax, .1), A, label="measured")
plt.plot(np.arange(hmin, hmax, .1), Aa, label="analytic")
# plt.title('Area')
plt.legend()
plt.savefig("area.python.pdf", bbox_inches="tight")
plt.show()

plt.plot(np.arange(hmin, hmax, .1), P, label="measured")
plt.plot(np.arange(hmin, hmax, .1), Pa, label="analytic")
# plt.title('Perimeter')
plt.legend()
plt.savefig("perimeter.python.pdf", bbox_inches="tight")
plt.show()

plt.plot(np.arange(hmin, hmax, .1), E, label="measured")
plt.plot(np.arange(hmin, hmax, .1), Ea, label="analytic")
#plt.title('Euler number')
plt.legend()
plt.savefig("euler.python.pdf", bbox_inches="tight")
plt.show()
