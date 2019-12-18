#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 12:20:47 2017

@author: yann
"""

# own functions
import ripley
import spat_pp
import gibbs

# numpy and plots
import numpy as np
import matplotlib.pyplot as plt

N = 200  # number of points
M = 1000  # size of window

# Poisson point process
xp, yp = spat_pp.cond_Poisson(N, 0, M, 0, M)
h = plt.figure()
plt.plot(xp, yp, '.')
plt.title("Conditional Poisson Point Process")
plt.show()
h.savefig("ppp.pdf", bbox_inches="tight")

# Neymann-scott point process
xn, yn = spat_pp.neyman_scott(10, 0, M, 0, M, 10, 10)
h = plt.figure()
plt.plot(xn, yn, '.')
plt.title("Neymann-Scott Point Process")
plt.show()
h.savefig("nspp.pdf", bbox_inches="tight")

# Gibbs Point Process
xg, yg = gibbs.gibbs(N, 0, M, 0, M, 1000)
h = plt.figure()
plt.plot(xg, yg, '.')
plt.title("Gibbs Point Process (Regular)")
plt.show()
h.savefig("gpp.pdf", bbox_inches="tight")

xg, yg = gibbs.gibbs(N, 0, M, 0, M, 2000,
                     eFunction=gibbs.agregatedEnergyFunction)
h = plt.figure()
plt.plot(xg, yg, '.')
plt.title("Gibbs Point Process (Agregated)")
plt.show()
h.savefig("gpp_a.pdf", bbox_inches="tight")


# %% Ripley functions
edges = np.arange(100)
N = 2000
M = 1000
# Poisson
xp, yp = spat_pp.cond_Poisson(N, 0, M, 0, M)
Kp, Lp, valsp = ripley.ripley(xp, yp, 0, M, 0, M, edges)
# Regular
xr, yr = gibbs.gibbs(N, 0, M, 0, M, 2000)
Kr, Lr, valsr = ripley.ripley(xr, yr, 0, M, 0, M, edges)
# Agregated
xa, ya = gibbs.gibbs(N, 0, M, 0, M, 2000,
                     eFunction=gibbs.agregatedEnergyFunction)
Ka, La, valsa = ripley.ripley(xa, ya, 0, M, 0, M, edges)

h = plt.figure()
plt.plot(valsp, Kp, label='Poisson')
plt.plot(valsr, Kr, label='Regular Gibbs')
plt.plot(valsa, Ka, label='Agregated Gibbs')
plt.title("K function")
plt.legend()
plt.show()
h.savefig("ripley_python.pdf", bbox_inches="tight")

h = plt.figure()
plt.plot(valsp, Lp-valsp, label='Poisson')
plt.plot(valsr, Lr-valsr, label='Regular Gibbs')
plt.plot(valsa, La-valsa, label='Agregated Gibbs')
plt.title("L-r function")
plt.legend()
plt.show()
h.savefig("ripley_L_python.pdf", bbox_inches="tight")


# %% marked Poisson Point Process
N = 200
spat_pp.marked(N, 0, M, 0, M)
