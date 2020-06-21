\name{mistat-package}
\alias{mistat-package}
\alias{mistat}
\docType{package}
\title{
The Modern Industrial Statistics Package
}
\description{
This R package is providing all the data sets and statistical analysis of 
\emph{Modern Industrial Statistics, with applications using R, MINITAB and JMP}
by R.S. Kenett and S.  Zacks with contributions by D. Amberti, 
John Wiley and Sons, 2013. 
This second revised and expanded second edition.
}
\details{
\tabular{ll}{
Package: \tab mistat\cr
Type: \tab Package\cr
Date: \tab 2012-08-22\cr
License: \tab GPL >= 2
}

}
\author{
Daniele Amberti

Maintainer: Daniele Amberti <amberti@inwind.it>
}

\keyword{ package }

\seealso{
\code{\link[boot:boot]{Bootstrap Resampling}}, 
\code{\link[qcc:qcc]{Quality Control Charts}}, 
\code{\link[AcceptanceSampling:OC2c]{Operating Characteristics of an Acceptance Sampling Plan}}, 
\code{\link[qcc:qcc]{Quality Control Charts}}, 
\code{\link[FrF2:FrF2]{Fractional Factorial 2-level designs}}. 
}
\examples{
data(OELECT)
data(OELECT1)

randomizationTest(list(a=OELECT, b=OELECT1), 
                  R=500, calc=mean, 
                  fun=function(x) x[1]-x[2],
                  seed=123)

Ps <- pistonSimulation(
  m = rep(60, 100),
  s = rep(0.02, 100),
  v0 = rep(0.01, 100),
  k = rep(5000, 100),
  p0 = rep(110000, 100),
  t = c(rep(296,35), 296*1.1^(1:65)),
  t0 = rep(360, 100),
  each = 1, 
  seed = 123,
  check = FALSE)

head(Ps)

cusumArl(mean= 0.0, 
         N=100,  
         limit=5000,
         seed=123)

powerCircuitSimulation(seed=123, each=3)

set.seed(123)

Ttf <- rgamma(50, 
              shape=2, 
              scale=100)

Ttr <- rgamma(50, 
              shape=2, 
              scale=1)
              
AvailEbd <- availDis(ttf=Ttf,  
                     ttr=Ttr, 
                     n=1000, seed=123)


RenewEbd <- renewDis(ttf=Ttf, 
                     ttr=Ttr, 
                     time=1000, 
                     n=1000)
}
