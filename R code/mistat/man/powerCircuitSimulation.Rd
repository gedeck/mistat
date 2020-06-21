\name{powerCircuitSimulation}
\alias{powerCircuitSimulation}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
The Power Circuit Simulator
}
\description{
A simulator of a voltage conversion power circuit. The target output voltage of the power circuit is 220 volts DC.
The circuit consists of 10 resistances labeled \emph{A} to \emph{J}, and 3 transistors, labeled \emph{K} to \emph{M}. These components can be purchased with different tolerance grades.
}
\usage{
powerCircuitSimulation(rsA = 8200, rsB = 220000, rsC = 1000, 
                       rsD = 33000, rsE = 56000, rsF = 5600, 
                       rsG = 3300, rsH = 58.5, rsI = 1000, 
                       rsJ = 120, trK = 130, trL = 100, 
                       trM = 130, 
                       tlA = 5, tlB = 10, tlC = 10, 
                       tlD = 5, tlE = 5, tlF = 5, 
                       tlG = 10, tlH = 5, tlI = 5, 
                       tlJ = 5, tlK = 5, tlL = 10, 
                       tlM = 5, 
                       each = 50, seed = NA)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{rsA}{
the resistance (\eqn{\Omega}) of \emph{A}. A single value or a vector of length \emph{n}.
}
  \item{rsB}{
the resistance (\eqn{\Omega}) of \emph{B}. A single value or a vector of length \emph{n}.
}
  \item{rsC}{
the resistance (\eqn{\Omega}) of \emph{C}. A single value or a vector of length \emph{n}.
}
  \item{rsD}{
the resistance (\eqn{\Omega}) of \emph{D}. A single value or a vector of length \emph{n}.
}
  \item{rsE}{
the resistance (\eqn{\Omega}) of \emph{E}. A single value or a vector of length \emph{n}.
}
  \item{rsF}{
the resistance (\eqn{\Omega}) of \emph{F}. A single value or a vector of length \emph{n}.
}
  \item{rsG}{
the resistance (\eqn{\Omega}) of \emph{G}. A single value or a vector of length \emph{n}.
}
  \item{rsH}{
the resistance (\eqn{\Omega}) of \emph{H}. A single value or a vector of length \emph{n}.
}
  \item{rsI}{
the resistance (\eqn{\Omega}) of \emph{I}. A single value or a vector of length \emph{n}.
}
  \item{rsJ}{
the resistance (\eqn{\Omega}) of \emph{J}. A single value or a vector of length \emph{n}.
}
  \item{trK}{
the resistance (\eqn{\Omega}) of \emph{K}. A single value or a vector of length \emph{n}.
}
  \item{trL}{
the resistance (\eqn{\Omega}) of \emph{L}. A single value or a vector of length \emph{n}.
}
  \item{trM}{
the resistance (\eqn{\Omega}) of \emph{M}. A single value or a vector of length \emph{n}.
}
  \item{tlA}{
the tolerance of \emph{A}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlB}{
the tolerance of \emph{B}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlC}{
the tolerance of \emph{C}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlD}{
the tolerance of \emph{D}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlE}{
the tolerance of \emph{E}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlF}{
the tolerance of \emph{F}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlG}{
the tolerance of \emph{G}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlH}{
the tolerance of \emph{H}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlI}{
the tolerance of \emph{I}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlJ}{
the tolerance of \emph{J}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlK}{
the tolerance of \emph{K}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlL}{
the tolerance of \emph{L}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{tlM}{
the tolerance of \emph{M}. It is a number > 0 (e.g. 5\% is 5.0)
}
  \item{each}{
non-negative integer. Each element of previous parameters is repeated \code{each} times.
}
  \item{seed}{
a single value, interpreted as an integer. If specified make the simulation replicable.
}
}
\details{
Factors affect the voltage output \eqn{V} via a chain of nonlinear equations:

\deqn{V = \frac{136.67(a+\frac{b}{Z(10)})+d(c+e)\frac{g}{f}-h}{1+d\frac{e}{f}+b[frac{1}{Z(10)+0.006(1+\frac{13.67}{Z(10)})]+0.08202a}}}{volts=(136.67(a+(b/Z(10)))+d(c+e)(g/f)-h)/(1+d(e/f)+b[(1/Z(10))+0.006(1+(13.67/Z(10)))]+0.08202a)}
where
\deqn{a = \frac{Z(2)}{Z(1)+Z(2)}}{a=Z(2)/(Z(1)+Z(2))}
\deqn{b=\frac{1}{Z(12)+Z(13)}(Z(3)+\frac{Z(1)Z(2)}{Z(1)+Z(2)})+Z(9)}{b=(1/(Z(12)+Z(13)))(Z(3)+(Z(1)Z(2)/(Z(1)+Z(2))))+Z(9)}
\deqn{c=Z(5)+Z(7)/2}{c=Z(5)+Z(7)/2}
\deqn{d=Z(11)\frac{Z(1)Z(2)}{Z(1)+Z(2)}}{d=Z(11)(Z(1)Z(2))/(Z(1)+Z(2))}
\deqn{e=Z(6)+Z(7)/2}{e=Z(6)+Z(7)/2}
\deqn{f=(c+e)(1+Z(11))Z(8)+ce}{f=(c+e)(1+Z(11))Z(8)+ce}
\deqn{g=0.6+Z(8)}{g=0.6+Z(8)}
\deqn{h=1.2}{h=1.2}
with \eqn{Z(1),\ldots,Z(10)} resistances in \eqn{\Omega} of the 
10 resistances and \eqn{Z(11),Z(12),Z(13)} are the \eqn{h_{FE}} 
values of three transistors.
}
\value{
A data frame, a matrix-like structure, with \code{each} *  \emph{n} rows and with columns:
    \tabular{lll}{
         rsA       \tab numeric \tab value of \code{rsA}\cr
         rsB       \tab numeric \tab value of \code{rsB}\cr
         rsC       \tab numeric \tab value of \code{rsC}\cr
         rsD       \tab numeric \tab value of \code{rsD}\cr
         rsE       \tab numeric \tab value of \code{rsE}\cr
         rsF       \tab numeric \tab value of \code{rsF}\cr
         rsG       \tab numeric \tab value of \code{rsG}\cr
         rsH       \tab numeric \tab value of \code{rsH}\cr
         rsI       \tab numeric \tab value of \code{rsI}\cr
         rsJ       \tab numeric \tab value of \code{rsJ}\cr
         trK       \tab numeric \tab value of \code{trK}\cr
         trL       \tab numeric \tab value of \code{trL}\cr
         trM       \tab numeric \tab value of \code{trM}\cr
         tlA       \tab numeric \tab value of \code{tlA}\cr
         tlB       \tab numeric \tab value of \code{tlB}\cr
         tlC       \tab numeric \tab value of \code{tlC}\cr
         tlD       \tab numeric \tab value of \code{tlD}\cr
         tlE       \tab numeric \tab value of \code{tlE}\cr
         tlF       \tab numeric \tab value of \code{tlF}\cr
         tlG       \tab numeric \tab value of \code{tlG}\cr
         tlH       \tab numeric \tab value of \code{tlH}\cr
         tlI       \tab numeric \tab value of \code{tlI}\cr
         tlJ       \tab numeric \tab value of \code{tlJ}\cr
         tlK       \tab numeric \tab value of \code{tlK}\cr
         tlL       \tab numeric \tab value of \code{tlL}\cr
         tlM       \tab numeric \tab value of \code{tlM}\cr
         volts     \tab numeric \tab output in volts (\eqn{V})
       }
}
\references{
  Kenett, R., Zacks, S. with contributions by Amberti, D.
  \emph{Modern Industrial Statistics: with applications in R, MINITAB and JMP}.
  Wiley.
}
\author{
Daniele Amberti
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{pistonSimulation}}, 
\code{\link[mistat:simulationGroup]{simulationGroup}}
}
\examples{
powerCircuitSimulation(seed=123, each=3)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ datagen }
\keyword{ math }
