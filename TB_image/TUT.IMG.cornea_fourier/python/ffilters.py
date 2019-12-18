# -*- coding: utf-8 -*-
"""
Created on Mon Jan 12 16:59:57 2015
Frequency filters

@author: yann
"""
import numpy as np


def LowPassFilter(spectrum, cut):
    """Low pass filter of the FFT (spectrum)
    The shape of this filter is a square. fftshift has been applied so that 
    frequency 0 lays at center of spectrum image
    @param spectrum: FFT2 transform
    @param cut     : cut value of filter (no physical unit, only number of pixels)
    """
    X, Y = spectrum.shape
    mask = np.zeros((X, Y), "int")

    mask[np.linspace(cut, X-cut, 2*cut+1),
         np.linspace(cut, Y-cut, 2*cut+1)] = 1
    f = spectrum * mask
    return f
