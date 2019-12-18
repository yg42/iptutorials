# -*- coding: utf-8 -*-
"""
Created on Wed Feb 18 16:20:41 2015
K-means segmentation of an image

@author: yann
"""

import numpy as np
import imageio
import matplotlib.pyplot as plt  # plots
from mpl_toolkits.mplot3d import Axes3D  # 3D scatter plot
import time
from sklearn.cluster import KMeans

cells = imageio.imread('Tv16.png')

fig = plt.figure()
plt.imshow(cells)
plt.show

# kmeans clustering
n = 3

k_means = KMeans(init='k-means++', n_clusters=n, n_init=10)
t0 = time.time()

[nLines, nCols, channels] = cells.shape

data = np.reshape(cells, (nLines*nCols, channels))
k_means.fit(data)

t_batch = time.time() - t0
k_means_labels = k_means.labels_
k_means_cluster_centers = k_means.cluster_centers_

# plot
colors = ['#4EACC5', '#FF9C34', '#4E9A06']

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# KMeans
for k, col in zip(range(n), colors):
    my_members = k_means_labels == k
    cluster_center = k_means_cluster_centers[k]
    ax.scatter(data[my_members, 0], data[my_members, 1], data[my_members, 2],
               c=col)
    ax.scatter(cluster_center[0], cluster_center[1], cluster_center[2], s=30,
               c=col)

# plt.title('KMeans')
# plt.show()
# fig.savefig("kmeans_image.pdf"); # takes really long time

segmentation = np.reshape(k_means_labels, (nLines, nCols))

fig = plt.figure()
plt.imshow(segmentation, cmap=plt.cm.gray)
imageio.imwrite("segmentation_kmeans.png", segmentation)

print("train time " + str(t_batch))
