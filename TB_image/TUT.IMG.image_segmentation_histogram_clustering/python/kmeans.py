# -*- coding: utf-8 -*-
"""
Created on Wed Feb 18 13:41:40 2015
K-means clustering of point clouds in 2D
http://scikit-learn.org/stable/modules/clustering.html

@author: yann
"""

import numpy as np
import matplotlib.pyplot as plt
import time

from sklearn.cluster import KMeans


def generation(n, x, y):
    Y = np.random.randn(n, 2) + np.array([[x, y]])
    return Y


"""
def generation(n, x, y):
    Y = np.random.randn(n, 2) + np.dot(np.ones((n, 2)), np.array( ((x,0), (0,y)) ) ) ;
    return Y
"""

points1 = generation(100, 0, 0)
points2 = generation(100, 3, 4)
points3 = generation(100, -5, -3)

pts = np.concatenate((points1, points2, points3))
fig = plt.figure()
plt.plot(pts[:, 0], pts[:, 1], 'ro')

plt.show()
fig.savefig("points.pdf")

# kmeans clustering
n = 3

k_means = KMeans(init='k-means++', n_clusters=n, n_init=10)
t0 = time.time()
k_means.fit(pts)

t_batch = time.time() - t0
k_means_labels = k_means.labels_
k_means_cluster_centers = k_means.cluster_centers_

# plot
fig = plt.figure()
colors = ['#4EACC5', '#FF9C34', '#4E9A06']

# KMeans
for k, col in zip(range(n), colors):
    my_members = k_means_labels == k
    cluster_center = k_means_cluster_centers[k]
    plt.plot(pts[my_members, 0], pts[my_members, 1], 'w',
             markerfacecolor=col, marker='.')
    plt.plot(cluster_center[0], cluster_center[1], 'o', markerfacecolor=col,
             markeredgecolor='k', markersize=6)
plt.title('KMeans')
plt.show()
fig.savefig("kmeans.pdf")

print("train time: " + str(t_batch))
