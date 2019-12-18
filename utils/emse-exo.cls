\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{emse-exo}[2014/11/19 v1.1
                    EMSE-exo class for LaTeX2e]

\LoadClass[a4paper,12pt]{article}

%% PACKAGES REQUIS %%
%\RequirePackage[utf8]{inputenc}
%\RequirePackage[french]{babel}
\RequirePackage{fancyhdr}
\RequirePackage{amssymb}
\RequirePackage{graphicx} 
%\RequirePackage{subfig}
%\RequirePackage[boxed]{algorithm2e}

\usepackage{subfig}
\usepackage{float}
\usepackage{amsmath} 
\usepackage{amsfonts} 
\usepackage{amssymb}
\usepackage{colortab}
\usepackage{algorithm2e}
\usepackage{tikz}
\usetikzlibrary{arrows,calc,shapes.geometric,plotmarks}

\newcommand{\R}{\mathbb{R}}
\usepackage{listings}
\usepackage{tikz}


\usepackage[%           % Fine in most cases
            pdfpagelabels,hypertexnames=true,
            plainpages=false,
            naturalnames=false,
            pdftitle={Image Processing Tutorials},
				backref=page,
				linktoc=all,
				hidelinks
  			]{hyperref}
  			
\usepackage{tcolorbox}
\tcbuselibrary{listings,skins,breakable}

\usepackage{import}
\import{../../../book/}{couleurs.tex}

\usepackage{graphics}
  
%% OPTION CORRECTION %%
\DeclareOption{correction}{\@correctiontrue}
\newif\if@correction
\@correctionfalse

\ProcessOptions

\newcommand{\true}{$\square$}
\newcommand{\difficulty}[1]{}
\pdfsuppresswarningpagegroup=1

\if@correction
  \newcommand{\solution}[1]
  {\medskip\noindent\fbox{\begin{minipage}{\textwidth}
  {\bf Solution : }\it #1
  \end{minipage}}
  \vspace{0.5cm}}
  \renewcommand{\true}{$\boxtimes$}

\else
        \RequirePackage{verbatim}
        \let\solution\comment
        \let\endsolution\endcomment
\fi


%% MISE EN PAGE %%
\setlength{\oddsidemargin}{10pt} %red�inition de l'espace entre la marge gauche et le texte d'une page impaire
\setlength{\textwidth}{470pt} %red�inition de la largeur du texte dans la page
\setlength{\hoffset}{-20pt} %red�inition de l'offset horizontal
\setlength{\voffset}{-45pt} %red�inition de l'offset vertical
\setlength{\footskip}{45pt} %red�inition de l'espace entre le texte et la fin des pieds de page
\setlength{\textheight}{659pt} %red�inition de la hauteur du texte dans la page
\setlength{\headheight}{28pt} %%red�inition de la hauteur des ent�es de page

\pagestyle{fancy}
\fancyhead[L]{MINES SAINT-ETIENNE \\ \Dannee}
\fancyhead[R]{{\bf\Dmodule} \\ \Dmatiere}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0pt}

\RequirePackage{everypage}
\RequirePackage{tikzpagenodes}


%% DONNEES PREAMBULE %%
\def\Dannee{~}
\def\Dmodule{~}
\def\Dmatiere{~}
\def\Dtype{~}
\newcommand{\annee}[1]{\def\Dannee{#1}}
\newcommand{\module}[1]{\def\Dmodule{#1}}
\newcommand{\matiere}[1]{\def\Dmatiere{#1}}
\newcommand{\type}[1]{\def\Dtype{#1}}


%% NOUVEAUX ENVIRONNEMENTS %%
%\newcommand{\sujet}[1]{\vspace*{0.0cm}\begin{center}{\LARGE{\bfseries \Dtype : #1}}\end{center}\vspace{0.75cm}}
\makeatletter
\newcommand{\sujet}[1]{\vspace*{0.0cm}\begin{center}{\LARGE{\bfseries \Dtype : #1}}\end{center}\vspace{0.75cm}}

\makeatletter
\def\sujet{\@ifnextchar[{\@sujetwith}{\@sujetwithout}}
\def\@sujetwith[#1]#2{\vspace*{0.0cm}\begin{center}{\LARGE{\bfseries \Dtype : #2}}\end{center}\vspace{0.75cm}}
\def\@sujetwithout#1{\vspace*{0.0cm}\begin{center}{\LARGE{\bfseries \Dtype : #1}}\end{center}\vspace{0.75cm}}

\makeatother
% \newcommand{\note}[1]
% {\noindent\fbox{\begin{minipage}{\textwidth}
% \it #1
% \end{minipage}}
% \vspace{0.5cm}}

\newcommand{\correctionsection}[1]
{\section{#1}}
\newcommand{\mcorrectionsection}[2]
{\section{#1}}
\newcommand{\pcorrectionsection}[2]
{\section{#1}}

\newcommand{\matlabregistered}{MATLAB\textsuperscript{\textregistered}}

% commandes communes entre book et tutorials

\makeatletter
% commande utilisée pour faire une référence croisée entre tutoriels
\newcommand{\iflabelexists}[3]{\@ifundefined{r@#1}{#3}{#2}}
\makeatother
\usepackage{placeins}

\usepackage{pgfplots}
  \pgfplotsset{compat=newest}
  %% the following commands are sometimes needed
  \usetikzlibrary{plotmarks}
  \usepackage{grffile}
  \usepackage{amsmath}
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % box et listings
  \usepackage{import}
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COULEURS
\usepackage{xcolor}

\definecolor{black}{rgb}{0,0,0}
\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}
% colors
\definecolor{darkblue}{rgb}{0,0.1,0.5}
\definecolor{blueemse}{RGB}{0 63 135} % bleu pantone 294 CV / EMSE
\definecolor{ocre}{RGB}{243,102,25} % Define the orange color used for highlighting 

% couleurs automne
\definecolor{automne_primaire0}{RGB}{ 95, 57, 65}
\definecolor{automne_primaire1}{RGB}{208,193,196}
\definecolor{automne_primaire2}{RGB}{152,112,121}
\definecolor{automne_primaire3}{RGB}{86, 21, 35}
\definecolor{automne_primaire4}{RGB}{64,  0, 14}

\definecolor{automne_complement0}{RGB}{ 66, 89, 54}
\definecolor{automne_complement1}{RGB}{187,196,182}
\definecolor{automne_complement2}{RGB}{119,143,106}
\definecolor{automne_complement3}{RGB}{ 41, 81, 19}
\definecolor{automne_complement4}{RGB}{ 21, 60,  0}

%%% couleurs a utiliser

% code informatique
\colorlet{c_code_numberstyle}{gray}
\colorlet{c_code_keyword}{blueemse}
\colorlet{c_code_rule}{automne_complement4}
\colorlet{c_code_comment}{red}
\colorlet{c_code_string}{automne_complement0}
\colorlet{c_code_colback}{automne_complement1!10} % fond des fenetres
\colorlet{c_code_colframe}{automne_complement3} % bordure des fenetres
\colorlet{c_code_icon_fill}{automne_complement1}
\colorlet{c_code_title}{automne_complement3}

% fenetres de questions
\colorlet{c_qbox_colback}{orange!10} % fond des fenetres
\colorlet{c_qbox_colframe}{automne_complement3} % bordure des fenetres
\colorlet{c_qbox_icon_colback}{orange!20}
\colorlet{c_qbox_icon_colframe}{automne_complement3}

% document
\colorlet{c_title}{automne_primaire3}
\colorlet{c_rule}{automne_primaire3}
\colorlet{c_page}{automne_primaire4}
\colorlet{c_section}{automne_primaire0}
\colorlet{c_section_colframe}{automne_primaire4} % bordure des fenetres
\colorlet{c_section_colback}{automne_primaire1}  % fond des fenetres

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% boites et boxes et listings


\lstdefinestyle{MatlabStyle} { %
  language=Matlab,                % the language of the code
%  float,
%  floatplacement=htbp,
  basicstyle=\footnotesize,           % the size of the fonts that are used for the code
  numbers=left,                   % where to put the line-numbers
  numberstyle=\tiny\color{c_code_numberstyle},  % the style that is used for the line-numbers
  stepnumber=2,                   % the step between two line-numbers. If it's 1, each line 
                                  % will be numbered
  numbersep=5pt,                  % how far the line-numbers are from the code
  %backgroundcolor=\color{white},      % choose the background color. You must add \usepackage{color}
  showspaces=false,               % show spaces adding particular underscores
  showstringspaces=false,         % underline spaces within strings
  showtabs=false,                 % show tabs within strings adding particular underscores
  %frame=single,                   % adds a frame around the code
  %rulecolor=\color{blueemse},        % if not set, the frame-color may be changed on line-breaks within not-black text (e.g. commens (green here))
  tabsize=2,                      % sets default tabsize to 2 spaces
  captionpos=b,                   % sets the caption-position to bottom
  breaklines=true,                % sets automatic line breaking
  breakatwhitespace=false,        % sets if automatic breaks should only happen at whitespace
  title=\lstname,         % show the filename of files included with \lstinputlisting;
                                  % also try caption instead of title
  keywordstyle=\color{c_code_keyword},          % keyword style
  commentstyle=\color{c_code_comment},       % comment style
  stringstyle=\color{c_code_string},         % string literal style
  escapeinside={\%*}{*)},            % if you want to add a comment within your code
  morekeywords={*,...}               % if you want to add more keywords to the set
}

\lstdefinestyle{PythonStyle}{ %
  language=Python,                % the language of the code
  basicstyle=\footnotesize,       % the size of the fonts that are used for the code
  numbers=left,                   % where to put the line-numbers
%  float,
%  floatplacement=htbp,
  numberstyle=\tiny\color{c_code_numberstyle},  % the style that is used for the line-numbers
  stepnumber=2,                   % the step between two line-numbers. If it's 1, each line 
                                  % will be numbered
  numbersep=5pt,                  % how far the line-numbers are from the code
  %backgroundcolor=\color{white},  % choose the background color. You must add \usepackage{color}
  showspaces=false,               % show spaces adding particular underscores
  showstringspaces=false,         % underline spaces within strings
  showtabs=false,                 % show tabs within strings adding particular underscores
  %frame=single,                   % adds a frame around the code
  rulecolor=\color{c_code_rule},        % if not set, the frame-color may be changed on line-breaks within not-black text (e.g. commens (green here)) 
  tabsize=2,                      % sets default tabsize to 2 spaces
  captionpos=b,                   % sets the caption-position to bottom
  breaklines=true,                % sets automatic line breaking
  breakatwhitespace=false,        % sets if automatic breaks should only happen at whitespace
  title=\lstname,                   % show the filename of files included with \lstinputlisting;
                                  % also try caption instead of title
  keywordstyle=\color{c_code_keyword},          % keyword style
  commentstyle=\color{c_code_comment},       % comment style
  stringstyle=\color{c_code_string},         % string literal style
  escapeinside={\%*}{*)},            % if you want to add a comment within your code
  morekeywords={*,...},               % if you want to add more keywords to the set
  tabsize=3
}

\newenvironment{matlab}{%
  \tcblisting{listing only,colback=c_code_colback,colframe=c_code_colframe, enlarge top by=5.5mm,enhanced,breakable,boxrule=1pt,%
     overlay={\node[anchor=west,xshift=10pt,draw=c_code_colframe, line width=2pt, rectangle, rounded corners=2pt,fill=c_code_icon_fill,inner sep=2pt,outer sep=0pt, minimum size=20pt] at (frame.north west) {\includegraphics[width=16pt]{matlab-logo.png}};},%
     listing options={basicstyle=\footnotesize\ttfamily,breaklines=true,%
                      postbreak={\mbox{$\hookrightarrow\space$}},%
                      language=Matlab,style=MatlabStyle},%
  }%
 }%
 {\endtcblisting}

\newenvironment{python}{%
  \tcblisting{listing only,colback=c_code_colback,colframe=c_code_colframe, enlarge top by=5.5mm,enhanced,boxrule=1pt,%
     overlay={\node[anchor=west,xshift=10pt,draw=c_code_colframe, line width=2pt, rectangle, rounded corners=2pt,fill=c_code_icon_fill,inner sep=2pt,outer sep=0pt, minimum size=20pt] at (frame.north west) {\includegraphics[width=16pt]{python-logo.pdf}};},%
     listing options={basicstyle=\footnotesize\ttfamily,breaklines=true,%
                      postbreak={\mbox{$\hookrightarrow\space$}},language=Python,style=PythonStyle},%
  }%
 }%
 {\endtcblisting}
\newenvironment{sh}{%
  \tcblisting{listing only,colback=c_code_colback,colframe=c_code_colframe, enlarge top by=5.5mm,enhanced,boxrule=1pt,%
     overlay={\node[anchor=west,xshift=10pt,draw=c_code_colframe, line width=2pt, rectangle, rounded corners=2pt,fill=c_code_icon_fill,inner sep=2pt,outer sep=0pt, minimum size=20pt] at (frame.north west) {\includegraphics[width=16pt]{sh-logo.pdf}};},%
     listing options={basicstyle=\footnotesize\ttfamily,breaklines=true,%
                      postbreak={\mbox{$\hookrightarrow\space$}},language=sh,style=PythonStyle},%
  }%
 }%
 {\endtcblisting}


\definecolor{DarkBlue}{rgb}{.11,.23,.60}

\newcommand{\triangcirc}{\tikz{
\node[circle,white,draw,inner sep=3pt] (c) {};
\node[isosceles triangle,
      white,
      fill,
      rotate=-90,
      anchor=apex,
      isosceles triangle apex angle=60,
      inner sep=1.5pt] (t) at ([yshift=0.5pt]c.south) {};}}
% 
% \makeatletter
% \renewcommand*\thelstnumber{\makebox[3em][r]{\ifnum\value{lstnumber}<10 0\fi\the\value{lstnumber}}}
% 
% \def\three@digits#1{\ifnum#1<10 00\else\ifnum#1<100 0\fi\fi\number#1}
% \makeatother

\newenvironment{mwindow}{%
  \tcblisting{   
  enhanced,
  arc = 0pt,
  outer arc = 2pt,
  colback = white,
  colframe = blue!50!black,
   listing only,
  fonttitle = \bfseries,
  listing options = {%
    language = matlab,
    style=MatlabStyle
  },
  overlay = {%
    \fill[gray!30] 
      (interior.north west)
      rectangle 
      ([xshift = 1em]interior.south west);
  },%
%   /utils/exec = {%
%     \def\thelstnumber{%
%       \texttt{\csname three@digits\endcsname{\the\value{lstnumber}}}}},
  title = {\ttfamily Command window\hfill\triangcirc}
  }%
 }%
 {\endtcblisting}

% langage par défaut
\lstset{language=Matlab, style=MatlabStyle}

\def\minline{\lstinline[language=Matlab,breaklines=true]}
\def\pinline{\lstinline[language=Python,breaklines=true]}

%----------------------------------------------------------------------------------------
%	REMARK ENVIRONMENT
%----------------------------------------------------------------------------------------

% Remark with matlab logo
\newenvironment{mremark}{\par\vskip10pt\small % Vertical white space above the remark and smaller font size
\noindent\ignorespaces\begin{minipage}{20pt} 
   \begin{tikzpicture}[overlay]
   \node[anchor=east,draw=c_code_colframe, line width=1pt, rectangle, rounded corners=2pt,fill=c_code_icon_fill,inner sep=2pt,outer sep=0pt, minimum size=20pt] at (-10pt,0pt){\includegraphics[width=16pt]{matlab-logo.png}};
   \end{tikzpicture}%
  \end{minipage}%
	\begin{minipage}{.8\textwidth}\flushleft
  }
{
\end{minipage}\par\noindent%
\ignorespacesafterend
\vskip12pt} % Tighter line spacing and white space after remark

% Remark with python logo
\newenvironment{premark}{\par\vskip10pt\small % Vertical white space above the remark and smaller font size
\noindent\ignorespaces\begin{minipage}{20pt}   
   \begin{tikzpicture}[overlay]
   \node[anchor=east,draw=c_code_colframe, line width=1pt, rectangle, rounded corners=2pt,fill=c_code_icon_fill,inner sep=2pt,outer sep=0pt, minimum size=20pt] at (-10pt,0pt){\includegraphics[width=16pt]{python-logo.pdf}};
   \end{tikzpicture}%
  \end{minipage}%
	\begin{minipage}{.8\textwidth}\flushleft
  }
{
\end{minipage}\par\noindent%
\ignorespacesafterend
\vskip12pt} % Tighter line spacing and white space after remark


\newtcolorbox{qbox}[1][]{
	enhanced jigsaw,
  %width=0.5\textwidth,  %% change
  colback=c_qbox_colback,
  colframe=c_qbox_colframe,
  title={\includegraphics[width=10pt]{interrogation.pdf}},
  boxrule=2pt,
  breakable,
  %left=10pt,right=10pt,top=20pt,bottom=20pt,
  attach boxed title to top left= {xshift=10pt,yshift*=-\tcboxedtitleheight/2},
  boxed title style={boxrule=0pt,size=small,colback=c_qbox_icon_colback,colframe=c_qbox_icon_colframe},
  before=\par\vspace{3mm},
%   after=\par\vspace{5cm},
%   overlay unbroken and first ={
%     \node[rounded corners, rotate=90] at (frame.west) {Questions};
%     },
  #1
}

\newtcolorbox{mhelp}[1][]{
	enhanced jigsaw,
  %width=0.5\textwidth,  %% change
  colback=c_code_colback,
  colframe=c_code_colframe,
  coltitle=c_code_title,
  title={\includegraphics[width=16pt]{matlab-logo.png} Informations},
  boxrule=1pt,
  breakable,
  attach boxed title to top left= {xshift=10pt,yshift*=-\tcboxedtitleheight/2},
  boxed title style={size=small,colback=c_code_colback,colframe=c_code_colframe},
  #1
}

\newtcolorbox{phelp}[1][]{
	enhanced jigsaw,
  %width=0.5\textwidth,  %% change
  colback=c_code_colback,
  colframe=c_code_colframe,
  coltitle=c_code_title,
  title={\includegraphics[width=16pt]{python-logo.pdf} Informations},
  boxrule=1pt,
  breakable,
  %left=10pt,right=10pt,top=20pt,bottom=20pt,
  attach boxed title to top left= {xshift=10pt,yshift*=-\tcboxedtitleheight/2},
  boxed title style={size=small,colback=c_code_colback,colframe=c_code_colframe},
  #1
}


\tikzstyle{mybox} = [draw=c_qbox_colframe, fill=c_qbox_colback, very thick,
    rectangle, rounded corners, inner sep=10pt, inner ysep=20pt]
\tikzstyle{fancytitle} =[fill=c_qbox_colframe, text=white]


\newtcolorbox{note}[1][]{%
  colback=c_section_colback,colframe=c_section_colframe,
  #1}

\newtcolorbox{rmq}[1][]{%
  colback=lightgray,colframe=black,
  #1}


% \newcommand{\note}[1]
% {\begin{tikzpicture}%
% \node [mybox, text width=.9\textwidth, align=justify] (box){%
%   %  \begin{minipage}{.95\textwidth}%
%      \color{black}{#1} %
%   %  \end{minipage}%
%     };%
% \node[fancytitle, right=10pt] at (box.north west) {Note};%
% \end{tikzpicture}%
% \vspace*{0.5cm}}

% bandeau header
\AddEverypageHook{\begin{tikzpicture}[remember picture,overlay]
\fill[c_qbox_colback] ([yshift=-7ex]current page.north west) rectangle ([xshift=+50ex,yshift=+200ex]current page.north east);
%\node[fill=white] at (current page header area) {Insert pretty much anything anywhere};
\end{tikzpicture}}



\newtcolorbox{wikipedia}{
  enhanced,
  left=0pt,
  right=0pt,
  top=8pt,
  bottom=8pt,
  colback=white!90!black,
  colframe=white,
  width=\textwidth,
  enlarge left by=0mm,
  boxsep=5pt,
  arc=4pt,
  outer arc=4pt,
  leftupper=2cm,
  overlay={
    \node[anchor=north west] 
      at ([xshift=10pt,yshift=-.65\baselineskip]frame.north west)
       {\includegraphics[height=1cm]{wikipedia.pdf}};}
}



\usepackage{etoolbox}

% definit un booleen pour inclure ou non les corrections
% par defaut a true
\newtoggle{includematlabcorrection}
\toggletrue{includematlabcorrection}
\newtoggle{includepythoncorrection}
\toggletrue{includepythoncorrection}
\newtoggle{matlabbook}
\toggletrue{matlabbook}
\newtoggle{pythonbook}
\toggletrue{pythonbook}


\newcommand{\inputmatlabcorrection}[1]{\iftoggle{includematlabcorrection}{\input{#1}}{}
}
\newcommand{\inputpythoncorrection}[1]{\iftoggle{includepythoncorrection}{\input{#1}}{}
}
\newcommand{\ifmatlab}[1]{\iftoggle{matlabbook}{#1}{}
}
\newcommand{\ifpython}[1]{\iftoggle{pythonbook}{#1}{}
}

\usepackage{comment}

\includecomment{mcomment}
\includecomment{pcomment}
