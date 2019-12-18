/*=================================================================
 * mexfunction.c 
 * 
 * This is a MEX-file for MATLAB.  
 * Copyright 1984-2006 The MathWorks, Inc.
 * All rights reserved.
 *
 * Cette fonction est un exemple simple d'utilisation de code C 
 * avec matlab.
 *
 * la compilation se fait dans matlab
 * avec la ligne suivante: mex mexfunction.c
 *
 * Un fichier mexfunction.mex<arch> est créé (par exemple mexa64).
 *=================================================================*/
/* $Revision: 1.5.6.2 $ */
#include "mex.h"

/// Fonction qui permet le lien avec matlab
///
/// Quand la fonction est invoquée, matlab renseigne lui même les pointeurs et données:
/// (p. ex: [a,b,c,...] = mexfunction(d,e,f,...)
///
/// Cette fonction prend un nombre quelconque d'arguments en entrée,
/// et retourne le nombre d'éléments de chaque entrée en sortie.
/// (ce qui justifie le test if (nlhs > nrhs).
///
/// \param nlhs nombre de tableaux en sortie (left-hand side)
/// \param plhs tableaux en sortie
/// \param nrhs nombre de tableaux en entrée (right-hand side)
/// \param prhs tableaux en entrée
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int i;
       
    /* Arguments en entrée.
       printf n'est pas utilisé, ça évite de linker avec stdio */
    mexPrintf("\nThere are %d right-hand-side argument(s).", nrhs);
    for (i=0; i<nrhs; i++)  {
	mexPrintf("\n\tInput Arg %i is of type:\t%s ",i,mxGetClassName(prhs[i]));
    }
    
    /* Examine output (left-hand-side) arguments. */
    mexPrintf("\n\nThere are %d left-hand-side argument(s).\n", nlhs);
    if (nlhs > nrhs)
      mexErrMsgTxt("Cannot specify more outputs than inputs.\n");

    // boucle sur tous les arguments de sortie
    for (i=0; i<nlhs; i++)  {
      // création du tableau de sortie
      plhs[i]=mxCreateDoubleMatrix(1,1,mxREAL);
      *mxGetPr(plhs[i])=(double)mxGetNumberOfElements(prhs[i]);
    }
}

