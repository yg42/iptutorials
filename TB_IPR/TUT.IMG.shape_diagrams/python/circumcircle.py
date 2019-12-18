#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec  5 11:27:03 2017

Circum circle

@author: yann
"""

import numpy as np
import math


def triangleCircle(A, B, C):
    """
    computes circum circle of 3 points (triangle)
    """
    a = B-C
    a2 = a[0]**2 + a[1]**2
    b = C-A
    b2 = b[0]**2 + b[1]**2
    c = A-B
    c2 = c[0]**2 + c[1]**2

    cosA = (a2 - b2-c2) / (2*math.sqrt(b2)*math.sqrt(c2))

    radius = math.sqrt(a2)/(2*math.sin(math.acos(cosA)))

    return radius


A = np.array([1, 0])
B = np.array([-1, 0])
C = np.array([0, 1])

r = triangleCircle(A, B, C)
print(r)
