\name{pistonSimulation}
\alias{pistonSimulation}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
The Piston Simulator
}
\description{
A simulator of a piston moving whithin a cylinder. The piston's
performance is measured by the time it takes to complete one cycle, in seconds.
Several factors can affect the piston's performance, they are
listed in the arguments section.
}
\usage{
pistonSimulation(m = 60, s = 0.02, v0 = 0.01, 
                 k = 5000, p0 = 110000, t = 296, 
                 t0 = 360, each = 50, seed = NA, 
                 check = TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{m}{
the impact pressure determined by the piston weight (\eqn{kg}). A single value or a vector of length \emph{n}.
}
  \item{s}{
the piston surface area (\eqn{m^2}). A single value or a vector.
}
  \item{v0}{
the initial volume of the gas inside the piston (\eqn{m^3}). A single value or a vector of length \emph{n}.
}
  \item{k}{
the spring coefficient (\eqn{N/m^3}). A single value or a vector of length \emph{n}.
}
  \item{p0}{
the atmospheric pressure (\eqn{N/m^2}). A single value or a vector of length \emph{n}.
}
  \item{t}{
the surrounding ambient temperature (\eqn{K}). A single value or a vector of length \emph{n}.
}
  \item{t0}{
the filling gas temperature (\eqn{K}). A single value or a vector of length \emph{n}.
}
  \item{each}{
non-negative integer. Each element of previous parameters is repeated \code{each} times.
}
  \item{seed}{
a single value, interpreted as an integer. If specified make the simulation replicable.
}
  \item{check}{
if \code{TRUE} (the default) then a formal check on piston parameters is perfomed
}
}
\details{
Factors affect the Cycle Time \eqn{s} via a chain of nonlinear equations:
\deqn{s = 2\pi\sqrt{\frac{M}{k + S^2 \frac{P_0 V_0}{T_0} \frac{T}{V^2}}}}{seconds = 2\pi sqrt(m/(k + s^2 ((p0 v0)/t0) (t/v^2)))}
where
\deqn{V = \frac{S}{2k} \sqrt{A^2 + 4k \frac{P_0 V_0}{T_0} T - a}}{v = (s/2k) (sqrt(a^2 + 4k (p0 v0)/t0 t) - a)}
and
\deqn{A = P_0 S + 19.62M - \frac{k V_0}{S}}{a = p0 s + 19.62m - (k v0)/s}
}
\value{
A data frame, a matrix-like structure, with \code{each} *  \emph{n} rows and with columns:
    \tabular{lll}{
         m       \tab numeric \tab value of \code{m}\cr
         s       \tab numeric \tab value of \code{s}\cr
         v0      \tab numeric \tab value of \code{v0}\cr
         k       \tab numeric \tab value of \code{k}\cr
         p0      \tab numeric \tab value of \code{p0}\cr
         t      \tab numeric \tab value of \code{t}\cr
         t0      \tab numeric \tab value of \code{t0}\cr
         seconds \tab numeric \tab time to complete one cycle (\eqn{s})
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
\code{\link{powerCircuitSimulation}}, 
\code{\link[mistat:simulationGroup]{simulationGroup}}, 
\code{\link{LATHYPPISTON}}
}
\examples{
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
tail(Ps)
plot(Ps$seconds)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ datagen }
\keyword{ math }