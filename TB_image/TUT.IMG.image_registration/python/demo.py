#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb  8 16:30:26 2018

@author: yann
"""


from scipy import misc
import matplotlib.pyplot as plt
import numpy as np
import cv2
from scipy.spatial import cKDTree

###############################################################################
# %%
# initialize the list of reference points
pts = []


def on_mouse(event, x, y, flags, param):
    """
    callback method for detecting click on image
    It draws a circle on the global variable image I
    """
    global pts, I
    if event == cv2.EVENT_LBUTTONUP:
        pts.append((x, y))
        cv2.circle(I, (x, y), 2, (0, 0, 255), -1)


def cpselect():
    """
    method for manually selecting the control points
    It waits until 'q' key is pressed.
    """
    cv2.namedWindow("image")
    cv2.setMouseCallback("image", on_mouse)
    print("press 'q' when finished")
    # keep looping until the 'q' key is pressed
    while True:
        # display the image and wait for a keypress
        cv2.imshow("image", I)
        key = cv2.waitKey(1) & 0xFF

        # if the 'c' key is pressed, break from the loop
        if key == ord("q"):
            break

    # close all open windows
    cv2.destroyAllWindows()
    return pts

###############################################################################
# %%


def rigid_registration(data1, data2):
    """
    Rigid transformation estimation between n pairs of points
    This function returns a rotation R and a translation t
    data1 : array of size nx2
    data2 : array of size nx2
    returns transformation matrix T of size 2x3
    """
    data1 = np.array(data1)
    data2 = np.array(data2)

    # computes barycenters, and recenters the points
    m1 = np.mean(data1, 0)
    m2 = np.mean(data2, 0)
    data1_inv_shifted = data1-m1
    data2_inv_shifted = data2-m2

    # Evaluates SVD
    K = np.matmul(np.transpose(data2_inv_shifted), data1_inv_shifted)
    U, S, V = np.linalg.svd(K)

    # Computes Rotation
    S = np.eye(2)
    S[1, 1] = np.linalg.det(U)*np.linalg.det(V)
    R = np.matmul(U, S)
    R = np.matmul(R, np.transpose(V))

    # Computes Translation
    t = m2-np.matmul(R, m1)

    T = np.zeros((2, 3))
    T[0:2, 0:2] = R
    T[0:2, 2] = t
    return T


def totuple(a):
    """
    function that transforms an array into tuple
    a: array
    """
    try:
        return tuple(totuple(i) for i in a)
    except TypeError:
        return a


def superimpose(G1, G2, filename=None):
    """
    superimpose 2 images, supposing they are grayscale images and of same shape
    """
    r, c = G1.shape
    S = np.zeros((r, c, 3))
    S[:, :, 0] = np.maximum(G1-G2, 0)+G1
    S[:, :, 1] = np.maximum(G2-G1, 0)+G2
    S[:, :, 2] = (G1+G2) / 2
    S = 255 * S / np.max(S)
    S = S.astype('uint8')
    plt.imshow(S)
    plt.show()
    if filename != None:
        cv2.imwrite(filename, S)
    return S


def applyTransform(points, T):
    """
    Apply transform to a list of points
    points: list of points
    T: rigid transformation matrix (shape 2x3)
    """
    dataA = np.array(points)
    src = np.array([dataA])
    data_dest = cv2.transform(src, T)
    a, b, c = data_dest.shape
    data_dest = np.reshape(data_dest, (b, c))
    return data_dest


def composeTransform(T1, T2):
    """
    Composition of transformations
    It basically uses a matrix multiplication, but a silent row is first added
    to both matrices
    T1 and T2: arrays of shape 2x3
    returns an array of shape 2x3
    """
    T1b = np.eye(3)
    T1b[0:2, 0:3] = T1
    T2b = np.eye(3)
    T2b[0:2, 0:3] = T2
    T = np.matmul(T1b, T2b)
    return T[0:2, 0:3]


def icp_transform(dataA, dataB):
    """
    Find a transform between A and B points
    with an ICP (Iterative Closest Point) method.
    dataA and dataB are of size nx2, with the same number of points n 
    returns the transformation matrix of shape 2x3
    """
    data2A = dataA.copy()
    data2B = np.zeros(data2A.shape)
    T = np.zeros((2, 3))
    T[0:2, 0:2] = np.eye(2)
    T[0:2, 2] = 0

    nb_loops = 5
    tree = cKDTree(dataB)

    for loop in range(nb_loops):
        # search for closest points and reorganise array of points accordingly

        d, inds = tree.query(data2A)

        data2B = dataB[inds, :]
        # find rigid registration with reordered points
        t_loop = rigid_registration(data2A, data2B)

        T = composeTransform(t_loop, T)

        # evaluates transform on control points, to make the iteration
        data2A = applyTransform(dataA, T)
        #print("data2A: ", data2A);

    return T


###############################################################################
# %%
# Read images and display
A = imageio.imread("brain1.png")
B = imageio.imread("brain2.png")
plt.imshow(A, cmap='gray')
plt.show()
plt.imshow(B, cmap='gray')
plt.show()
superimpose(A, B, "superimpose.png")

# define control points
A_points = np.array([[136, 100], [127, 153], [96, 156], [87, 99]])
B_points = np.array([[144, 99], [109, 140], [79, 128], [100, 74]])

# in case you need an interactive window for points selection...
# do not forget to clear the array pts
#I = A.copy();
#A_points = cpselect(A).copy();
# A_points = np.array(A_points);
# pts.clear();
#I = B.copy();
#B_points = cpselect(B).copy();
#B_points = np.array(B_points);
# pts.clear();

###############################################################################
# 1st case, rigid registration, with pairs of points in the correct order
T = rigid_registration(A_points, B_points)

# Apply transformation on control points and display the results
data_dest = applyTransform(A_points, T)
I = B.copy()
for pb, pa in zip(data_dest, B_points):
    cv2.circle(I, totuple(pa), 1, (255, 0, 0), -1)
    cv2.circle(I, totuple(pb), 1, (0, 0, 255), -1)
plt.imshow(I)
plt.show()
# Apply transformation on image
rows, cols = B.shape
dst = cv2.warpAffine(A, T, (cols, rows))
plt.imshow(dst)
superimpose(dst, B, "rigid_manual.png")

###############################################################################
# 2nd case, points are not in the correct order
p = np.random.permutation(np.arange(4))
A_points = A_points[p]
T = rigid_registration(A_points, B_points)
# Apply transformation on control points and display the results
data_dest = applyTransform(A_points, T)
I = B.copy()
for pb, pa in zip(data_dest, B_points):
    cv2.circle(I, totuple(pa), 1, (255, 0, 0), -1)
    cv2.circle(I, totuple(pb), 1, (0, 0, 255), -1)
plt.imshow(I)
plt.show()
# Apply transformation on image
rows, cols = B.shape
dst = cv2.warpAffine(A, T, (cols, rows))
plt.imshow(dst)
superimpose(dst, B, "rigid_random_manual.png")

###############################################################################
# 3rd case, ICP rigid registration
T2 = icp_transform(np.array(A_points), np.array(B_points))
# Apply transformation on points
data_dest = applyTransform(A_points, T2)
# Transform image and display result
rows, cols = B.shape
dst = cv2.warpAffine(A, T2, (cols, rows))
plt.imshow(I)
plt.show()
superimpose(dst, B, "random_icp_manual.png")

###############################################################################
# %% Harris corners detection or Shi and Tomasi
# this method do not ensure the correct order in the points (A_points and
# B_points)

nb_points = 4  # number of points to detect
corners = cv2.goodFeaturesToTrack(
    A, nb_points, 0.01, 10, blockSize=3, useHarrisDetector=False)
corners = np.int0(corners)
a, b, c = corners.shape
A_points = np.reshape(corners, (a, c))
corners = cv2.goodFeaturesToTrack(
    B, nb_points, 0.01, 10, blockSize=3, useHarrisDetector=False)
corners = np.int0(corners)
a, b, c = corners.shape
B_points = np.reshape(corners, (a, c))

# simple registration
T3 = rigid_registration(A_points, B_points)
data_dest = applyTransform(A_points, T3)
I = B.copy()
for pb, pa in zip(data_dest, B_points):
    cv2.circle(I, totuple(pa), 2, (255, 0, 0), -1)
    cv2.circle(I, totuple(pb), 2, (0, 0, 255), -1)
plt.imshow(I)
plt.show()
# Apply transformation on image
rows, cols = B.shape
dst = cv2.warpAffine(A, T3, (cols, rows))
plt.imshow(dst)
superimpose(dst, B, "rigid_shitomasi.png")

# ICP registration
T4 = icp_transform(A_points, B_points)
data_dest = applyTransform(A_points, T4)
I = B.copy()
for pb, pa in zip(data_dest, B_points):
    cv2.circle(I, totuple(pa), 2, (255, 0, 0), -1)
    cv2.circle(I, totuple(pb), 2, (0, 0, 255), -1)
plt.imshow(I)
plt.show()
# Apply transformation on image
rows, cols = B.shape
dst = cv2.warpAffine(A, T4, (cols, rows))
plt.imshow(dst)
superimpose(dst, B, "icp_shitomasi.png")
