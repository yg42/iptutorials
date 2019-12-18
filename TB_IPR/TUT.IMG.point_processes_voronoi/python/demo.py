#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec 20 16:17:58 2017

@author: yann
"""

from scipy.spatial import Voronoi, voronoi_plot_2d, Delaunay, distance
import numpy as np

import matplotlib.pyplot as plt
from shapely import geometry
from scipy.sparse import csgraph  # for MST


def RFH(vor):
    """
    Evaluates Round Factor Homogeneity from voronoi diagram
    It considers only closed cells
    """
    rfs = []
    for cell in vor.regions:
        if cell and -1 not in cell:
            poly = geometry.Polygon([(vor.vertices[p]) for p in cell])
            rfs.append(4*np.pi*poly.area/(poly.length**2))
    res = 1 - np.std(rfs) / np.mean(rfs)
    return res


def AD(vor):
    """
    Evaluates Area Disorder from voronoi diagram
    It considers only closed cells
    """
    areas = []
    for cell in vor.regions:
        if cell and -1 not in cell:
            poly = geometry.Polygon([(vor.vertices[p]) for p in cell])
            areas.append(poly.area)
    res = 1 - 1/(1+np.std(areas) / np.mean(areas))
    return res


def triToMat(tri, value=0.):
    """
    Transforms the triangulation into a matrix representation, 
    for simplicity
    """
    M = np.full((tri.npoints, tri.npoints), value)
    d = distance.pdist(tri.points)
    distances = distance.squareform(d)
    for s in tri.simplices:
        M[s[0], s[1]] = distances[s[0], s[1]]
        M[s[1], s[2]] = distances[s[1], s[2]]
        M[s[2], s[0]] = distances[s[2], s[0]]
    return M


def characterization(tri):
    """
    Characterization of the Delaunay triangulation 
    (mean and std dev of edges lengths)
    """
    M = triToMat(tri)
    m = np.mean(M[M > 0])
    s = np.std(M[M > 0])
    return m, s


def mst(tri):
    """
    Construction of the minimum spanning tree from the Delaunay triangulation
    retuns mean and std of lengths of edges of the MST.
    """
    M = triToMat(tri, np.inf)
    graph = csgraph.csgraph_from_dense(M, null_value=np.inf)
    Tcsr = csgraph.minimum_spanning_tree(graph)
    mat = Tcsr.toarray()
    it = np.nditer(mat, flags=['multi_index'])
    # plt.figure()
    Lstar = []
    while not it.finished:
        if it[0] != 0:
            #plt.plot(tri.points[it.multi_index,0], tri.points[it.multi_index,1]);
            Lstar.append(it[0])
        it.iternext()
    #plt.title("Minimum spanning tree")
    # plt.show();

    return np.mean(Lstar), np.std(Lstar)


def dist_uniform(N=100):
    points = np.random.rand(N, 2)
    return points


def dist_gaussian(N=100):
    points = np.random.randn(N, 2)
    return points


def dist_regular(N=100):
    c = np.floor(np.sqrt(N))
    x2, y2 = np.meshgrid(range(int(c)), range(int(c)))
    points = np.vstack([x2.ravel(), y2.ravel()])
    return points.transpose()


def analyse_distributions(n=100):
    means = []
    sigmas = []
    mean = []
    sigma = []
    rfh = []
    ad = []
    all_points = []
    colors = plt.cm.get_cmap('Set1', 8)
    N = 500
    labs = ['uniform distribution',
            'Gaussian distribution', 'Regular distribution']
    dists = [dist_uniform, dist_gaussian]

    for idx, f in enumerate(dists):
        for i in range(n):
            points = f(N)
            vor = Voronoi(points)
            tri = Delaunay(points)
            ms, ss = mst(tri)
            means.append(ms)
            sigmas.append(ss)

            m, s = characterization(tri)
            mean.append(m)
            sigma.append(s)

            rfh.append(RFH(vor))
            ad.append(AD(vor))

        plt.figure(0)
        plt.plot(means, sigmas, 'o', c=colors(idx), label=labs[idx])
        plt.xlabel('mean')
        plt.ylabel('standard deviation')
        means.clear()
        sigmas.clear()

        plt.figure(1)
        plt.plot(mean, sigma, 'o', c=colors(idx), label=labs[idx])
        plt.xlabel('mean')
        plt.ylabel('standard deviation')
        mean.clear()
        sigma.clear()

        plt.figure(2)
        plt.plot(ad, rfh, 'o', c=colors(idx), label=labs[idx])
        plt.xlabel('AD')
        plt.ylabel('RFH')
        rfh.clear()
        ad.clear()

        all_points.clear()

    # regular distribution, computed only once (constant value)
    idx = 2

    points = dist_regular(N)
    vor = Voronoi(points)
    tri = Delaunay(points)
    ms, ss = mst(tri)
    means.append(ms)
    sigmas.append(ss)

    m, s = characterization(tri)
    mean.append(m)
    sigma.append(s)

    rfh.append(RFH(vor))
    ad.append(AD(vor))
    plt.figure(0)
    plt.plot(means, sigmas, 'o', c=colors(idx), label=labs[idx])
    means.clear()
    sigmas.clear()

    plt.figure(1)
    plt.plot(mean, sigma, 'o', c=colors(idx), label=labs[idx])
    mean.clear()
    sigma.clear()

    plt.figure(2)
    plt.plot(ad, rfh, 'o', c=colors(idx), label=labs[idx])
    rfh.clear()
    ad.clear()

    # titles and savefig
    fig = plt.figure(0)
    plt.legend(loc=1)
    #plt.title("mean s / sigma s")
    fig.savefig("charac_diagrams.pdf", bbox_inches='tight')
    fig = plt.figure(1)
    plt.legend(loc=1)
    #plt.title("mean / sigma")
    fig.savefig("charac_mst.pdf", bbox_inches='tight')
    fig = plt.figure(2)
    plt.legend(loc=1)
    #plt.title("AD / RFH")
    fig.savefig("ad_rfh.pdf", bbox_inches='tight')
    plt.show()


def illustrations():
    """
    This code is used to generate illustrations of the voronoi diagram, 
    delaunay graph and minimum spanning tree
    """
    N = 15
    # np.random.seed(0); # in order to generate the same distribution each time
    points = np.random.randint(50, size=(N, 2))
    fig = plt.figure()
    plt.plot(points[:, 0], points[:, 1], 'o')
    plt.show()
    fig.savefig("points.pdf", bbox_inches='tight')

    vor = Voronoi(points)
    tri = Delaunay(points)
    fig = voronoi_plot_2d(vor)
    fig.savefig("voronoi.pdf", bbox_inches='tight')

    fig = plt.figure()
    plt.triplot(points[:, 0], points[:, 1], tri.simplices.copy())
    plt.plot(points[:, 0], points[:, 1], 'o')
    plt.show()
    fig.savefig("delaunay.pdf", bbox_inches='tight')

    print(RFH(vor))
    print(AD(vor))

    mu, sigma = mst(tri)
    print(mu, sigma)

    m, s = characterization(tri)
    print(m, s)

    # MST
    M = triToMat(tri, np.inf)
    graph = csgraph.csgraph_from_dense(M, null_value=np.inf)
    Tcsr = csgraph.minimum_spanning_tree(graph)
    mat = Tcsr.toarray()
    it = np.nditer(mat, flags=['multi_index'])
    fig = plt.figure()
    Lstar = []
    while not it.finished:
        if it[0] != 0:
            plt.plot(tri.points[it.multi_index, 0],
                     tri.points[it.multi_index, 1])
            Lstar.append(it[0])
        it.iternext()
    plt.plot(points[:, 0], points[:, 1], 'o')
    plt.show()
    fig.savefig("mst.pdf", bbox_inches='tight')


def illustrateDistributions():
    """
    This function generates figures of the different patterns
    """
    points = dist_uniform()
    fig = plt.figure()
    plt.plot(points[:, 0], points[:, 1], 'o')
    plt.show()
    fig.savefig("uniform.pdf", bbox_inches='tight')

    points = dist_gaussian()
    fig = plt.figure()
    plt.plot(points[:, 0], points[:, 1], 'o')
    plt.show()
    fig.savefig("gaussian.pdf", bbox_inches='tight')

    points = dist_regular()
    fig = plt.figure()
    plt.plot(points[:, 0], points[:, 1], 'o')
    plt.show()
    fig.savefig("regular.pdf", bbox_inches='tight')


analyse_distributions()
