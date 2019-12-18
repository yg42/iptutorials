# -*- coding: utf-8 -*-
"""
Created on Fri Nov  4 09:50:35 2016

@author: Yann GAVET @ Mines Saint-Etienne
"""

import numpy as np
import numpy.matlib as ml
import matplotlib.pyplot as plt


def generatePointsOnSphere(nb_points, R):
    """
    Generate points on a sphere
    @param nb_points: number of points
    @return n: array of size nb_points x 3
    """
    n = np.random.randn(nb_points, 3)
    mynorm = np.linalg.norm(n, axis=1)
    n = R * n / np.transpose(ml.repmat(mynorm, 3, 1))

    return n


def dot(A, B, ax=1):
    """ dot product for arrays
    """
    return np.sum(A.conj()*B, axis=ax)


h = plt.figure()
N = 10000000
R = 1
nBins = 1000

# first simulation method: random radius
d = R * np.random.rand(int(N))
radii = np.sqrt(R**2 - d**2)
probaSimu = np.histogram(radii, bins=nBins)
plt.plot(probaSimu[1][:-1], probaSimu[0]/N, linewidth=2)


# second simulation
# choose 3 endpoints to define a plane,
# then, compute the distance from the origin to this plane
n1 = generatePointsOnSphere(N, R)
n2 = generatePointsOnSphere(N, R)
n3 = generatePointsOnSphere(N, R)

# u and v belong to the plane
u = n2-n1
v = n3-n1
# n: normal vector to the plane
n = np.cross(u, v)
x = dot(n, n1) / np.linalg.norm(n, axis=1)
# distance from the origin to the plane:
r = np.sqrt(R**2 - x**2)
probaSimu = np.histogram(r, bins=nBins)
plt.plot(probaSimu[1][:-1], probaSimu[0]/N, linewidth=2)

# 3rd case:
# 2 endpoints on the sphere and distance between them
n1 = generatePointsOnSphere(N, R)
n2 = generatePointsOnSphere(N, R)
r = 1./2 * np.linalg.norm(n1-n2, axis=1)
probaSimu = np.histogram(r, bins=nBins)
plt.plot(probaSimu[1][:-1], probaSimu[0]/N, linewidth=2)

# analytical values
step = .05
r2 = np.arange(0, R, step)
probaReal = 1./R * r2 / np.sqrt(R**2-r2**2)
probaReal = probaReal * R / nBins  # approximation of the integral
plt.scatter(r2, probaReal, 50)

# display
plt.legend(["random radius", "random plane by 3 endpoints",
            "2 endpoints", "Analytical values"])
plt.title("Random chords of a sphere")
plt.show()
h.savefig("sections_sphere.pdf")
