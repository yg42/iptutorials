# -*- coding: utf-8 -*-
"""
Created on Fri Oct 28 11:06:47 2016

@author: yann
"""

import cv2
import numpy as np

# read image and convert it to gray
img = cv2.imread('TestPR46.png')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
edges = cv2.Canny(gray, 100, 200, apertureSize=3)

# threshold value for lines selection:
# lower value means more lines
threshold = 150

# perform lines detection
lines = cv2.HoughLines(edges, 1, np.pi/180, threshold)

# display lines
for rho, theta in lines[0]:
    print rho, theta
    a = np.cos(theta)
    b = np.sin(theta)
    x0 = a*rho
    y0 = b*rho
    x1 = int(x0 + 1000*(-b))
    y1 = int(y0 + 1000*(a))
    x2 = int(x0 - 1000*(-b))
    y2 = int(y0 - 1000*(a))
    print x1, y1, x2, y2
    cv2.line(img, (x1, y1), (x2, y2), (0, 0, 255), 2)

cv2.imshow('hough transform', img)
cv2.imwrite('cv_hough.png', img)
