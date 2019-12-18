# -*- coding: utf-8 -*-
"""
Created on Wed Nov  2 09:17:35 2016

@author: yann @ Mines Saint-Etienne
"""
import numpy as np
from scipy.stats import poisson
import matplotlib.pyplot as plt


def cond_Poisson(nb_points, xmin, xmax, ymin, ymax):
    # Conditional Poisson Point Process
    # uniform distribution
    # nb_points: number of points
    # xmin, xmax, ymin, ymax: defined the domain (window)
    x = xmin + (xmax-xmin)*np.random.rand(nb_points)
    y = ymin + (ymax-ymin)*np.random.rand(nb_points)
    return x, y


def normal_distribution(nb_points, mu, sigma):
    # Normal distribution centered around the point mu with stdev sigma
    x = mu[0] + sigma[0]*np.random.randn(nb_points)
    y = mu[1] + sigma[1]*np.random.randn(nb_points)
    return x, y


def neyman_scott(nRoot, xmin, xmax, ymin, ymax, lambdaS, rSon):
    # Neyman-scott process simulation
    # nRoot: number of agregates
    # xmin, xmax, ymin, ymax: domain
    # lambdaS: number of points. lambda is a density, S is the spatial domain
    # rSon: radius around agregate (points are distributed in a square)

    # number of sons
    nSons = poisson.rvs(lambdaS, size=nRoot)

    # results
    x = []
    y = []

    # father points coordinates
    xf, yf = cond_Poisson(nRoot, xmin, xmax, ymin, ymax)
    for i in range(nRoot):
        # loop over all agregates

        xs, ys = cond_Poisson(nSons[i], xf[i]-rSon,
                              xf[i]+rSon, yf[i]-rSon, yf[i]+rSon)
        x = np.concatenate((x, xs), axis=0)
        y = np.concatenate((y, ys), axis=0)

    return x, y


def marked(nb_points, xmin, xmax, ymin, ymax, filename="marked.pdf"):
    """
    marked point process
    """

    # points
    x, y = cond_Poisson(nb_points, xmin, xmax, ymin, ymax)

    # first mark: radii
    sigma = 5
    mu = 10
    r = sigma * np.random.randn(nb_points) + mu
    r[r < 0.1] = 0.1

    # second mark: colors
    nb_colors = 10
    c = np.random.randint(nb_colors, size=nb_points)

    # plot
    plt.scatter(x, y, r**2, c, alpha=.5)
    plt.savefig(filename)


def test_ney():
    x, y = neyman_scott(10, 0, 100, 0, 100, 10, 10)
    print("{0:d}, {1:d}".format(x.size, y.size))

    plt.plot(x, y, '+')


def test_ppp():
    x, y = cond_Poisson(100, 0, 100, 0, 100)
    plt.plot(x, y, '+')


def test_npp():
    x, y = normal_distribution(100, (0, 0), (10, 20))
    plt.plot(x, y, '+')
    plt.xlim((-100, 100))
    plt.ylim((-100, 100))
    plt.title("Normal distribution")


h = plt.figure()
test_npp()
h.savefig("npp.pdf")
