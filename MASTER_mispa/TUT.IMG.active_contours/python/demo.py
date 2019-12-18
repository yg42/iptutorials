# -*- coding: utf-8 -*-
"""
Created on Wed Nov 23 14:56:35 2016

@author: yann
"""

import numpy as np
import matplotlib.pyplot as plt
import scipy
import scipy.ndimage.filters
from scipy import interpolate

import progressbar

# disk: number of points
n = 1024
# disk: radius
R = 300

# construct a binary image of a disk
X, Y = np.meshgrid(np.arange(-n/2, n/2, 1), np.arange(-n/2, n/2, 1))
I = X**2+Y**2 <= R**2
del X, Y
I = I.astype('float')
plt.imshow(I)
plt.show()

# intial contour: ellipse
step = .01
x = n/2 + 400 * np.cos(np.arange(0, 2*np.pi+step, step))
y = n/2 + 200 * np.sin(np.arange(0, 2*np.pi+step, step))

fig = plt.figure()
plt.plot(x, y, linewidth=3)
plt.savefig("ellipse.pdf", bbox_inches='tight')

# parameters of the snake
k = .1
alpha = .001 * k
beta = 100*k
gamma = 100
iterations = 1000

# generate of the matrix
N = x.size
X = np.array([-beta, alpha+4*beta, -2*alpha-6*beta, alpha+4 *
              beta, -beta, -beta, alpha+4*beta, -beta, alpha+4*beta])
A = scipy.sparse.diags(X, np.array(
    [-2, -1, 0, 1, 2, N-2, N-1, -N+2, -N+1]), shape=(N, N)).toarray()
AA = np.identity(N)-gamma*A
invAA = np.linalg.inv(AA)

# external forces computation
G = scipy.ndimage.filters.gaussian_gradient_magnitude(I, 30)

# Notice that horizontal axis x is 1, and vertical axis is 0
Fy = scipy.ndimage.prewitt(G, axis=0)
Fx = scipy.ndimage.prewitt(G, axis=1)

plt.figure
plt.imshow(G)
plt.show()

# interpolation methods to get values of the external forces at the
# coordinates of the snake
sx, sy = I.shape
ix = interpolate.interp2d(np.arange(n), np.arange(n), Fx)
iy = interpolate.interp2d(np.arange(n), np.arange(n), Fy)

# display external forces
subx = np.arange(sx, step=20)
suby = np.arange(sy, step=20)
[Xa, Ya] = np.meshgrid(subx, suby)
plt.quiver(Xa, Ya, Fy[Xa, Ya], Fx[Xa, Ya])
plt.savefig("forces.python.pdf")

# loop for convergence of the snake
bar = progressbar.ProgressBar()
for index in bar(range(iterations)):
    fex = np.array([float(ix(XX, YY)) for XX, YY in zip(x, y)])
    fey = np.array([float(iy(XX, YY)) for XX, YY in zip(x, y)])
    #print(np.max(fex), np.min(fex))
    x = np.matmul(invAA, x+gamma*fex)
    y = np.matmul(invAA, y+gamma*fey)

fig = plt.figure()
plt.imshow(I)
plt.plot(x, y, color='red')
plt.show()
fig.savefig("snake.python.pdf", bbox_inches='tight')
