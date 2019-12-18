# -*- coding: utf-8 -*-
"""
Created on Thu Nov  3 11:13:47 2016

@author: Yann GAVET @ Mines Saint-Etienne
"""


import numpy as np
import matplotlib.pyplot as plt
import skimage.measure
import scipy
import scipy.io

# povray output
import vapory


def popDisks(nb_disks, S, Rmax):
    """ Generates an image with random disks, with uniform distribution of 
    the centers, and of the radii.
    @param nb_disks: number of disks
    @type S: int
    @param S: Size of spatial support
    @param rmax: maximum radius of disks
    @return: binary image of disks
    """
    centers = np.random.randint(S, size=(nb_disks, 2))
    radii = Rmax * np.random.rand(nb_disks)

    N = 1000
    x = np.linspace(0, S, 1000)
    y = np.linspace(0, S, 1000)
    X, Y = np.meshgrid(x, y)
    I = np.zeros((N, N))
    for i in range(nb_disks):
        I2 = (X-centers[i, 0])**2 + (Y-centers[i, 1]) ** 2 <= radii[i]**2
        I = np.logical_or(I, I2)

    return I


def areaFraction(nb_probes, I):
    """
    Evaluates area fraction via point probes
    @param nb_probes: number of probes
    @param I: binary image, square
    """
    P = np.random.randint(I.shape[0], size=(nb_probes, 2))

    # count the number of probes in phase
    count = np.sum(I[P[:, 0], P[:, 1]])

#    fig=plt.figure();
#    plt.imshow(I);
#    plt.plot(P[:,0], P[:,1], '+');
#    plt.show();
#    fig.savefig('areaFrac.pdf', bbox_inches='tight');
    return float(count) / nb_probes


def verifyAreaFraction():
    """
    Verify area fraction
    """
    I = popDisks(50, 1000, 20)
    plt.imshow(I)
    AA = float(np.sum(I)) / np.size(I)
    PP = areaFraction(3000, I)

    print("AA (true number of pixels): {:.2%}".format(AA))
    print("PP (evaluated fraction)   : {:.2%}".format(PP))


def lengthPerArea(I):
    """
    Evaluates the length per area
    """
    perim = skimage.measure.perimeter(I.astype(int), 8)
    LA = perim / np.sum(I)
    print("LA (true count): {:.2%}".format(LA))

    # lines probes, every 40 pixels
    probe = np.zeros(I.shape)
    probe[20:-20:40, 20:-20] = 1
    lines = I.astype(int) * probe

    # count number of intercepts
    h = np.array([[1, -1, 0]])
    points = scipy.signal.convolve2d(lines, h, mode='same')

    nb_lines = np.sum(lines)
    nb_points = np.sum(np.abs(points))
    PL = float(nb_points) / nb_lines
    print("pi/2*PL (evaluation): {:.2%}".format(np.pi/2*PL))
#
#    fig=plt.figure();
#    plt.imshow(I);
#    P = np.where(np.abs(points)==1);
#    plt.plot(P[1], P[0], '+')
#    plt.show();
#    fig.savefig('lengthPerArea.pdf', bbox_inches='tight');


def verifyLengthPerArea():
    I = popDisks(50, 1000, 100)
    plt.imshow(I)
    plt.show()
    lengthPerArea(I)


def volumeFraction(volume):
    """
    """
    VV = float(np.sum(volume)) / np.size(volume)
    probe = np.zeros(volume.shape)
    probe[10:-10:50, 10:, 10:] = 1

    s = np.sum(probe)
    probe = probe * volume
    AA = float(np.sum(probe)) / s

    print("VV (true count): {:.2%}".format(VV))
    print("AA (evaluation): {:.2%}".format(AA))


def verifyVolumeFraction():
    sphere = scipy.io.loadmat("spheres.mat")
    volumeFraction(sphere['A'])


""" povray rendering of the spheres
"""


def renderPopSpheres():
    nb_spheres = 50
    R = 5.
    centers = np.random.randint(100, size=(nb_spheres, 3))
    radius = np.random.randn(nb_spheres) * R + R
    couleurs = np.random.randint(255, size=(nb_spheres, 4))/255.

    camera = vapory.Camera('location', [150, 150, 150], 'look_at', [0, 0, 0])
    bg = vapory.Background('color', [1, 1, 1])
    light = vapory.LightSource([100, 100, 100], 'color', [1, 1, 1])
    light3 = vapory.LightSource([0, 0, 0], 'color', [1, 1, 1])
    light2 = vapory.LightSource([50, 50, 50], 'color', [1, 1, 1])

    obj = [light, light2, light3, bg]
    for i in range(nb_spheres):
        sphere = vapory.Sphere(centers[i, ], radius[i], vapory.Texture(vapory.Finish(
            'ambient', 0, 'reflection', 0, 'specular', 0, 'diffuse', 1), vapory.Pigment('color', couleurs[i, ])))
        obj.append(sphere)
    scene = vapory.Scene(camera, objects=obj)
    scene.render("spheres.png", width=3000, height=3000)
