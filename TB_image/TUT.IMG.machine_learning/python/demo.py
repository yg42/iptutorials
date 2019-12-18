#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar  7 14:16:41 2018

@author: yann
"""
import glob
from skimage import measure, io
import numpy as np
import matplotlib.pyplot as plt

# preprocessing data and normalization
from sklearn.preprocessing import scale
from sklearn.preprocessing import MinMaxScaler
from sklearn.preprocessing import minmax_scale
from sklearn.preprocessing import MaxAbsScaler
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import RobustScaler
from sklearn.preprocessing import Normalizer
from sklearn.preprocessing.data import QuantileTransformer

# learning methods
from sklearn import svm
from sklearn.cluster import KMeans
from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix

# plot confusion matrix
import seaborn as sn
import pandas as pd


def plot_cm(cm, classes, normalize=False, cmap=plt.cm.Blues):
    """
    Plot confusion matrix
    cm: confusion matrix, as ouput by sklearn.metrics.confusion_matrix
    classes: labels to be used
    normalize: display number (False by default) or fraction (True)
    cmap: colormap

    returns: figure that can be used for pdf export
    """
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
    fmt = '.1f' if normalize else 'd'
    df_cm = pd.DataFrame(cm, index=classes, columns=classes)

    fig = plt.figure()
    sn.set(font_scale=.8)
    sn.heatmap(df_cm, annot=True, cmap=cmap, fmt=fmt)
    plt.xlabel('Target label')
    plt.ylabel('True label')

    return fig


# Definitions of the database, classes and images
rep = '../matlab/images_Kimia216/'
classes = ['bird', 'bone', 'brick', 'camel', 'car', 'children',
           'classic', 'elephant', 'face', 'fork', 'fountain',
           'glass', 'hammer', 'heart', 'key', 'misk', 'ray', 'turtle']
nbClasses = len(classes)
nbImages = 12

# The features are manually computed
properties = np.zeros((nbClasses*nbImages, 9))
target = np.zeros(nbClasses * nbImages)
index = 0
for ind_c, c in enumerate(classes):
    filelist = glob.glob(rep+c+'*')
    for filename in filelist:
        I = io.imread(filename)
        prop = measure.regionprops(I)
        properties[index, 0] = prop[0].area
        properties[index, 1] = prop[0].convex_area
        properties[index, 2] = prop[0].eccentricity
        properties[index, 3] = prop[0].equivalent_diameter
        properties[index, 4] = prop[0].extent
        properties[index, 5] = prop[0].major_axis_length
        properties[index, 6] = prop[0].minor_axis_length
        properties[index, 7] = prop[0].perimeter
        properties[index, 8] = prop[0].solidity
        target[index] = ind_c

        index = index+1

# percentage of the data used for splitting into train/test
percentTest = .25
#%%##############################################################################
# MLP Classifier (Multi-Layer Perceptron)
# the data are first scaled
propertiesMLP = StandardScaler().fit_transform(properties)
prop_train, prop_test, target_train, target_test = train_test_split(propertiesMLP, target, test_size=percentTest,
                                                                    random_state=0)
# feedforward neural network
# max_iter should be extended max_iter=100000 for adam or sgd solvers
mlp = MLPClassifier(hidden_layer_sizes=(100,), solver='lbfgs')

target_pred = mlp.fit(prop_train, target_train).predict(prop_test)

print("Training set score: %f" % mlp.score(prop_train, target_train))

print(confusion_matrix(target_test, target_pred))
print(classification_report(target_test, target_pred, target_names=classes))
# Compute confusion matrix
cnf_matrix = confusion_matrix(target_test, target_pred)
fig = plot_cm(cnf_matrix, classes, normalize=True)
fig.savefig("confusion_norm_mlp.pdf", bbox_inches='tight')
fig = plot_cm(cnf_matrix, classes)
fig.savefig("confusion_mlp.pdf", bbox_inches='tight')

#%%##############################################################################
# SVM classifier
prop_train, prop_test, target_train, target_test = train_test_split(properties, target, test_size=percentTest,
                                                                    random_state=0)
classifier = svm.SVC(kernel='linear')
target_pred = classifier.fit(prop_train, target_train).predict(prop_test)
print("Training set score: %f" % classifier.score(prop_train, target_train))

print(classification_report(target_test, target_pred, target_names=classes))
# Compute confusion matrix
cnf_matrix = confusion_matrix(target_test, target_pred)
fig = plot_cm(cnf_matrix, classes, normalize=True)
fig.savefig("confusion_norm_svm.pdf", bbox_inches='tight')
fig = plot_cm(cnf_matrix, classes)
fig.savefig("confusion_svm.pdf", bbox_inches='tight')
