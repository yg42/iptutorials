/// This illustrates the use of an extern library (written in C++) 
/// within matlab. A executable file is generated (file mex<arch>) and called with 
/// a particular syntax
///
/// Compilation is called by (not necessarily within matlab):
/// 
/// mex -I/appli/include -L/appli/lib -lCGAL convhullCGAL_mex.cpp
/// 

// matlab instructions
#include "mex.h"
extern void _main();

// STL c++
#include <list>
#include <iterator>
#include <iostream>

// CGAL must be installed
// include files for CGAL
#include <CGAL/Exact_predicates_inexact_constructions_kernel.h>
#include <CGAL/ch_graham_andrew.h>

typedef CGAL::Exact_predicates_inexact_constructions_kernel K;
typedef K::Point_2 Point_2;

/// Reads n points in tables X and Y, and insert them into
/// the points structure.
///
/// Lecture de n points dans les tableaux X et Y, et insertion
/// dans la structure points
/// \param n nombre de points
/// \param X tableau des abscisses
/// \param Y tableau des ordonnées
/// \param points liste de points à la mode STL c++
void matlab_input(int n, double *X, double *Y, std::list<Point_2> &points)
{
  for (int i=0; i<n; ++i)
    {
      points.push_back(Point_2(X[i], Y[i]));
    }
  
}

/// Writes the list of points into matlab datas.
/// \param points liste of points
/// \param x X coordinates to write
/// \param y Y coordinates to write
void matlab_output(std::list<Point_2> &points,double* x,double* y)
{
  // iterateur sur la liste de points
  std::list<Point_2>::const_iterator it = points.begin();
  int compteurIt=0;
  while(it != points.end())
    {
      x[compteurIt]=(*it).x();
      y[compteurIt]=(*it).y();
      ++compteurIt;
      ++it;
    }
}

/// Link with matlab
/// When this function is called, matlab defines the pointers and datas:
/// for ex: [a,b,c,...] = fun(d,e,f,...)
///
///
/// Fonction qui permet le lien avec matlab
///
/// Quand la fonction est invoquée, matlab renseigne lui même les pointeurs et données:
/// p. ex: [a,b,c,...] = fun(d,e,f,...)
///
/// \param nlhs number of ouput tables
/// \param plhs output tables 
/// \param nrhs number of input tables 
/// \param prhs input tables 
void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
  /* Check for proper number of arguments */
  if (nrhs != 2)
    {
      mexErrMsgTxt("MEXCPP requires two input arguments.");
    }

  // number of points for the convex hull
  int nElts = mxGetM(prhs[0]);

  // X coordinates
  double *X = (double *) mxGetPr(prhs[0]);

  // Y coordinates
  double *Y = (double *) mxGetPr(prhs[1]);

  // structures for the coordinates, to be passed to CGAL
  std::list<Point_2> points;
  std::list<Point_2> resPoints;

  // Creation of the list of points
  matlab_input(nElts, X, Y, points);
 
  // Computation of the convex hull.
  // the result is stored into resPoints
  CGAL::ch_graham_andrew( points.begin(), points.end(),std::back_inserter(resPoints));
 
  // Results: we create 2 tables with the right size.
  plhs[0] = mxCreateDoubleMatrix(resPoints.size(), 1, mxREAL); //mxReal is our data-type
  plhs[1] = mxCreateDoubleMatrix(resPoints.size(), 1, mxREAL); //mxReal is our data-type
  double* x = mxGetPr(plhs[0]);
  double* y = mxGetPr(plhs[1]);

  // On écrit les points dans les tableaux matlab, ce qui permet de les récupérer
  // The results are written into the output tables.
  matlab_output(resPoints,x,y);
}








