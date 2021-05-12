\name{Vdgraph-package}
\alias{Vdgraph-package}
\docType{package}
\title{
This package creates variance dispersion graphs and fraction of design space plots for response surface designs
}
\description{The \pkg{Vdgraph} package provides functions for creating Variance Dispersion Graphs and Fraction of Design Space Plots of a standardized response surface design stored in a matrix or a data frame. 

The function \code{Vdgraph(des)} creates the variance dispersion graph of the response surface design stored in the matrix or data frame \code{des}. The function \code{FDSPlot(des)} creates the fraction of design space plot of the response surface design stored in the matrix or data frame \code{des}. Useful response surface designs are also included as matricies in the package. These include the hexagonal design for two factors \code{Hex2}, the small composite designs for 3 to 6 factors and Roquemore's hybrid designs for 3 to 6 factors. The function Compare2Vdg makes the variance dispersion graphs of two designs on the same scale for comparison.

}

\details{
\tabular{ll}{
Package: \tab Vdgraph\cr
Type: \tab Package\cr
Version: \tab 1.0-1\cr
Date: \tab 2014-05-29\cr
License: \tab GPL2.0\cr
Dependencies: \tab \cr
LazyLoad: \tab yes\cr
Packaged: \tab 2014-05-29 19:54:07 UTC; Lawson\cr
Built: \tab R 3.0.2; i386-pc-mingw32; 2011-03-22 19:54:08 UTC; windows\cr
}

Index:
\preformatted{
Compare2Vdg             this function makes Variance Dispersion Graphs
                        of two response surface designs on the same 
                        graph for comparison
Compare2FDS             this function makes fraction of design space 
                        plots of two response surface designs on the 
                        same graph for comparison
D310                    Roquemore (1976) Hybrid design D310
D311A                   Roquemore (1976) Hybrid design 311A
D311B                   Roquemore (1976) Hybrid design D311B
D416A                   Roquemore (1976) Hybrid design 416A
D416B                   Roquemore (1976) Hybrid design D416B
D416C                   Roquemore (1976) Hybrid design D416C
D628A                   Roquemore (1976) Hybrid design D628A
FDSPlot                 this function makses a fraction of design space 
                        plot of a response surface design
Hex2                    Hexagonal design for two factors
SCDDL5                  Draper and Lin's Small Composite Design for
                        five factors
SCDH2                   Hartley's Small Composite Design for two
                        factors
SCDH3                   Hartley's Small Composite Design for three
                        factors
SCDH4                   Hartley's Small Composite Design for four
                        factors
SCDH5                   Hartley's Small Composite Design for five
                        factors
SCDH6                   Hartley's Small Composite Design for six
                        factors
Vardsgr                 Loads compiled fortran in shared file vdg
Vdgraph                 this function makes a Variance Dispersion Graph
                        of a response surface design
}
}
\author{
John Lawson <lawson@byu.edu>

Maintainer: John Lawson <lawson@byu.edu>
}
\keyword{ package }
