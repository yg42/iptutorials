import numpy as np

import scipy
import scipy.ndimage
import imageio
import matplotlib.pyplot as plt
import matplotlib.patches as pat
import skimage.measure
import skimage

import glob

import smallestenclosingcircle

from sklearn.cluster import KMeans


def crofton_perimeter(I):
    """ Computation of crofton perimeter
    """
    inter = []
    h = np.array([[1, -1]])
    for i in range(4):
        II = np.copy(I)
        I2 = skimage.transform.rotate(II, angle=45*i, order=0)
        I3 = scipy.ndimage.convolve(I2, h)

        inter.append(0.5*np.sum(np.abs(I3)))

    crofton = np.pi/4. * (inter[0]+inter[2] + (inter[1]+inter[3])/np.sqrt(2))
    return crofton


def feret_diameter(I):
    """ 
    Computation of the Feret diameter
    minimum: d (meso-diameter)
    maximum: D (exo-diameter)

    Input: I binary image
    """
    d = np.max(I.shape)
    D = 0

    for a in np.arange(0, 180, 30):
        I2 = skimage.transform.rotate(I, angle=a, order=0)
        F = np.max(I2, axis=0)
        measure = np.sum(F )

        if (measure < d):
            d = measure
        if (measure > D):
            D = measure
    return d, D


def inscribedRadius(I):
    """
    computes the radius of the inscribed circle
    """
    dm = scipy.ndimage.morphology.distance_transform_cdt(I > 100)
    radius = np.max(dm)
    return radius


def diagrams():
    """
    Loads all images, compute the parameters (inscribed circle radius,
    feret largest and smallest diameters, crofton perimeter, area), and then 
    computes the shape parameters as ratios.
    """
    name = ['apple-*.bmp', 'Bone-*.bmp', 'camel-*.bmp']
    elongation = []
    thinness = []
    roundness = []
    z = []
    for pattern in name:
        namesList = glob.glob(pattern)
        for fichier in namesList:
            I = imageio.imread(fichier)
            radius = inscribedRadius(I)
            d, D = feret_diameter(I)
            crofton = crofton_perimeter(I)

            elongation.append(d/D)
            thinness.append(2*radius / D)
            roundness.append(4*np.sum(I > 100)/(np.pi * D**2))
            z.append(crofton / (np.pi * D))

    plt.plot(elongation[0:20], thinness[0:20], "o", label='Apple')
    plt.plot(elongation[20:40], thinness[20:40], "+", label='Bone')
    plt.plot(elongation[40:60], thinness[40:60], ".", label='Camel')
    plt.legend(name)
    plt.show()
    evaluateQuality(elongation, thinness, "elongation", "thinness")

    plt.figure()
    plt.plot(z[0:20], roundness[0:20], "o", label='Apple')
    plt.plot(z[20:40], roundness[20:40], "+", label='Bone')
    plt.plot(z[40:60], roundness[40:60], ".", label='Camel')
    plt.legend(name)
    plt.show()
    evaluateQuality(z, roundness, "perimeter circle ratio", "roundness")

    plt.figure()
    plt.plot(thinness[0:20], z[0:20], "o", label='Apple')
    plt.plot(thinness[20:40], z[20:40], "+", label='Bone')
    plt.plot(thinness[40:60], z[40:60], ".", label='Camel')
    plt.legend(name)
    plt.show()
    evaluateQuality(thinness, z, "$2r/d$", "$P/(\pi d)$")


def evaluateQuality(x, y, lx, ly):
    """
    this functions evaluates the number of correctly classified objects
    """
    global i  # this value is used to keep an index of calls
    n = 3
    k_means = KMeans(init='k-means++', n_clusters=n)
    X = np.asarray(x)
    Y = np.asarray(y)
    pts = np.stack((X, Y))
    pts = pts.T
    # print(pts)
    k_means.fit(pts)

    k_means_labels = k_means.labels_
    k_means_cluster_centers = k_means.cluster_centers_

    # plot
    fig = plt.figure()
    ax = fig.add_subplot(111)
    colors = ['#4EACC5', '#FF9C34', '#4E9A06']

    # KMeans
    for k, col in zip(range(n), colors):
        my_members = k_means_labels == k
        cluster_center = k_means_cluster_centers[k]
        plt.plot(pts[my_members, 0], pts[my_members, 1], 'o',
                 markerfacecolor=col,  markeredgecolor=col, markersize=6)
        plt.plot(cluster_center[0], cluster_center[1], 'o', markerfacecolor=col,
                 markeredgecolor='k', markersize=12)
    plt.title('KMeans')
    ax.set_xlabel(lx)
    ax.set_ylabel(ly)
    plt.show()
    fig.savefig("kmeans"+str(i)+".pdf")
    i += 1

    """
    Evaluation of the quality: count the number of shapes correctly detected
    """
    accuracy = np.sum(k_means_labels[0:20] ==
                      scipy.stats.mode(k_means_labels[0:20]))
    accuracy += np.sum(k_means_labels[20:40] ==
                       scipy.stats.mode(k_means_labels[20:40]))
    accuracy += np.sum(k_means_labels[40:60] ==
                       scipy.stats.mode(k_means_labels[40:60]))
    accuracy = accuracy / 60 * 100
    print('Accuracy: {0:.2f}%'.format(accuracy))


def circumCircle(I):
    """
    this version uses a function provided by Project Nayuki
    under GNU Lesser General Public License
    """
    points = np.argwhere(I > 100)
    c = smallestenclosingcircle.make_circle(points)
    return c


i = 0
# examples on first image
I = imageio.imread('apple-1.bmp')
bw = I > 100
plt.imshow(I)

# perimeter
p = skimage.measure.perimeter(bw)
print(p)
crofton = crofton_perimeter(I)
print(crofton)

plt.show()
plt.figure()
d, D = feret_diameter(I)
print("min Feret diameter:", d)
print("max Feret diameter:", D)

# %% display shape diagrams
diagrams()

# %% test circumcircle: out of the scope of this tutorial
c = circumCircle(I)
fig, ax = plt.subplots(1)
ax.imshow(I)
circ = pat.Circle((c[1], c[0]), radius=c[2], fill=False, color='w',)
ax.add_patch(circ)
plt.show()
fig.savefig("circum.pdf", bbox_inches='tight')
print('Circumcircle of center ({0:.2f},{1:.2f}) and radius {2:.2f}'.format(
    c[0], c[1], c[2]))
