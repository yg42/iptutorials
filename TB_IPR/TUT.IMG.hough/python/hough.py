# -*- coding: utf-8 -*-
"""
Hough transform

@author: yann gavet Mines Saint-Etienne
"""

import numpy as np
import cv2
import matplotlib.pyplot as plt
from skimage.feature import peak_local_max

# load the image
img = cv2.imread('TestPR46.png')
plt.figure()
plt.imshow(img)

# perform contours detection
edges = cv2.Canny(img, 100, 200)
plt.figure()
plt.imshow(edges)
cv2.imwrite("edges_hough.python.png", edges);

# Hough transform
# size of image
X = img.shape[0]
Y = img.shape[1]

angular_sampling = 0.002  # angles in radians

# initialization of matrix H
rho_max = np.hypot(X, Y)
rho = np.arange(-rho_max, rho_max, 1)
theta = np.arange(0, np.pi, angular_sampling)
cosTheta = np.cos(theta)
sinTheta = np.sin(theta)
H = np.zeros([rho.size, theta.size])

# Hough transform
# loop on all contour pixels
for i in range(X):
    for j in range(Y):
        if (edges[i, j] != 0):
            R = i*cosTheta + j*sinTheta
            R = np.round(R + rho.size/2).astype(int)
            H[R, range(theta.size)] += 1

# Maxima detection
G = cv2.GaussianBlur(H, (5, 5), 5)
maxima = peak_local_max(H, 5, threshold_abs=150, num_peaks=5)
plt.figure()
plt.imshow(G)

rho_peaks = rho[maxima[:, 0]]
theta_peaks = theta[maxima[:, 1]]
plt.scatter(maxima[:, 1], maxima[:, 0], c='r')

plt.savefig("sinogram_hough.python.pdf", bbox_inches='tight', dpi=300);
plt.show()

# display the results as lines in image
for i_rho, i_theta in maxima:
    #print (rho[i_rho], theta[i_theta])
    a = np.cos(theta[i_theta])
    b = np.sin(theta[i_theta])
    y0 = a*rho[i_rho]
    x0 = b*rho[i_rho]
    y1 = int(y0 + 1000*(-b))
    x1 = int(x0 + 1000*(a))
    y2 = int(y0 - 1000*(-b))
    x2 = int(x0 - 1000*(a))

    cv2.line(img, (x1, y1), (x2, y2), (0, 0, 255), 2)

# display in window
plt.imshow(img, cmap=plt.cm.gray);

# write resulting image
cv2.imwrite('cv_hough.png', img)
