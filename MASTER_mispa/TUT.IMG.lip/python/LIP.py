# -*- coding: utf-8 -*-
"""
LIP simple module
USAGE: import LIP

@author: yann
"""
import numpy as np


def graytone(F, M):
    # graytone function transform
    # M: maximal value
    # F: image function
    f = M-np.finfo(float).eps-F
    return f


def phi(f, M):
    # LIP isomorphism
    # f: graytone function
    # M: maximal value
    l = -M * np.log(-f/M+1)
    return l


def invphi(l, M):
    # inverse isomorphism
    f = M*(1-np.exp(-l/M))
    return f


def plusLIP(a, b, M):
    # LIP addition
    z = a+b-(a*b)/M
    return z


def timesLIP(alpha, x, M):
    # LIP multiplication by a real
    z = M-M*(np.ones(x.shape)-x/M)**alpha
    return z


def computeLambda(f, M):
    # compute optimal value for dynamic expansion
    B = np.log(1-f.min()/M)
    C = np.log(1-f.max()/M)
    l = np.log(C/B)/(B-C)
    return l
