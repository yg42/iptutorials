#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 15:09:32 2017

@author: yann
"""

import disks
import matplotlib.pyplot as plt
import imageio

I = disks.popDisks(50, 1000, 50)
plt.imshow(I)
plt.show()
imageio.imwrite("disques.png", 255*I.astype('uint8'))

# Classical measurements of stereology
disks.renderPopSpheres()
# compute results
disks.verifyAreaFraction()
disks.verifyLengthPerArea()
disks.verifyVolumeFraction()

import section_disks
