# -*- coding: utf-8 -*-
"""
Created on Thu Nov  3 14:47:09 2016

@author: Yann GAVET @ Mines Saint-Etienne
"""

import numpy as np
import matplotlib.pyplot as plt

h = plt.figure()
N = 10000000
nBins = 1000
R = 1.

# first simulation method: random radius
d = R * np.random.rand(N)
radii = np.sqrt(R**2 - d**2)
probaSimu = np.histogram(radii, bins=nBins)
plt.plot(probaSimu[1][:-1], probaSimu[0]/N, linewidth=2)


# 2nd method: random angles defining points on the circle
# from 2 random angles
theta = np.pi*2*np.random.rand(N, 2)

dX = np.diff(R * np.cos(theta))
dY = np.diff(R * np.sin(theta))
radii = 1./2 * np.sqrt(dX**2 + dY**2)
probaSimu2 = np.histogram(radii, bins=nBins)
plt.plot(probaSimu2[1][:-1], probaSimu2[0]/N, linewidth=2)

# analytical values
step = .05
r2 = np.arange(0, R, step)
probaReal = 1./R * r2 / np.sqrt(R**2-r2**2)
probaReal = probaReal * R / nBins  # approximation of the integral

plt.scatter(r2, probaReal, 50)

# display results
plt.legend(["Random radius", "2 endpoints", "Analytical values"])
plt.title("Random sections of a disk")
plt.show()
h.savefig('sections_disk.pdf')
