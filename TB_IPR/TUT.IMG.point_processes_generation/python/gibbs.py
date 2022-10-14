# -*- coding: utf-8 -*-
"""
Created on Wed Nov  2 10:42:32 2016

@author: Yann GAVET @ Mines Saint-Etienne
"""
import numpy as np
import matplotlib.pyplot as plt
import spat_pp
from scipy.spatial.distance import pdist
from tqdm import tqdm

def exampleEnergyFunction(distance):
    """ This function returns e with the same size as distance
    e takes the value given in the variable energy according to the steps

    Regular energy function
    
    see stairsEnergy for energy definition
    """
    steps = [10]
    energy = [10]
    # displayEnergy(steps, energy)
    e = stairsEnergy(distance, steps, energy)
    
    
    return e


def agregatedEnergyFunction(distance):
    """ This function returns e with the same size as distance
    e takes the value given in the variable energy according to the steps

    Agregated energy function
    """
    steps=[2, 5, 10]
    energy =[ 50, -10, 5]
    # displayEnergy(steps, energy)
    return stairsEnergy(distance, steps, energy)


def displayEnergy(steps, energy):
    # if you want to plot energy function, just uses plt.stairs
    plt.stairs(energy, np.append(0, steps))
    plt.axhline(0, 0, 50, color='red')
    plt.show()


def energy(P, eFunction=exampleEnergyFunction):
    """
    This computes the energy in the set of points P, with the energy function
    given as a parameter.
    return a float value
    """
    P = np.transpose(P)
    d = pdist(P)
    e = eFunction(d)
    return np.sum(e)


def stairsEnergy(distance, steps, energy):
    e = np.zeros_like(distance)
    prev_step = 0
    
    for i, s in enumerate(energy):
        e[np.logical_and(distance>=prev_step, distance<steps[i])] = energy[i]
        
        prev_step = steps[i]

    return e

def energyFromPoint(p, P, eFunction=exampleEnergyFunction):
    """
    Compute energy from point p to all points of P
    """
    dist = np.sqrt((p[0] - P[0, :])**2 + (p[1] - P[1, :])**2)
    ee = eFunction(dist)
    return np.sum(ee)


def gibbs(nb_points, xmin, xmax, ymin, ymax, nbiter, eFunction=exampleEnergyFunction):
    """
    Gibbs point process
    xmin, xmax, ymin, ymax represents the spatial window
    nb_points: number of generated points
    nbiter: number of iterations
    returns (x,y) coordinates of the points
    """

    # start with a Poisson Point Process
    x, y = spat_pp.cond_Poisson(nb_points, xmin, xmax, ymin, ymax)
    nb_moves = 0
    e_prev = energy(np.vstack((x, y)), eFunction)
    print("initial energy: {0:f}".format(e_prev))
    plt.figure()
    
    # ee=[]
    for i in tqdm(range(nbiter)):
        # choose a random point
        j = np.random.randint(0, nb_points)
        
        # x2, y2 are the points coordinates without the point of index j
        x2 = np.delete(x, j)
        y2 = np.delete(y, j)
        # In case you want to show the point to be moved
        # plt.scatter(x, y)
        # plt.plot(x[j], y[j], 'ro')
        # plt.show()

        # P is the set of points without point of index j
        P = np.vstack((x2, y2)) 
        e1 = energyFromPoint([x[j], y[j]], P, eFunction)

        for m in range(10):
            xm, ym = spat_pp.cond_Poisson(1, xmin, xmax, ymin, ymax)

            e2 = energyFromPoint([xm, ym], P, eFunction)
            if e2 < e1:
                nb_moves += 1
                #print(f"Energy before movement:{energy(np.vstack((x, y)), eFunction)} " )
                # takes some time
                x[j] = xm
                y[j] = ym
                #print(f"Energy after movement:{energy(np.vstack((x, y)), eFunction)} " )
                e1 = e2
                
        # ee.append(energy(np.vstack((x, y)), eFunction))

    print("Number of moves: " + str(nb_moves))
    print("Final energy:    " + str(e1))
    # plt.plot(ee)
    # plt.show()
    return x, y


def test_gibbs():
    nb_points = 100 # nombre de points
    nb_iter  = 200  # nombre d'itérations (points à déplacer)
    x, y = gibbs(nb_points, 0, 100, 0, 100, nb_iter, eFunction=agregatedEnergyFunction)
    print("final energy: " + str(energy((x, y))))
    plt.figure()
    plt.plot(x, y, 'o')
    plt.show()

test_gibbs()
