\name{predPoly}
\alias{predPoly}

\title{
Quadratic Predictor
}
\description{
A quadratic polynomial  fitted to the last n observations. We then extrapolate to estimate f(t + s) with s >= 1.
}
\usage{
predPoly(x, n, s)
}

\arguments{
  \item{x}{
a vector of data X_t.
}
  \item{n}{
the n to define the window size.
}
  \item{s}{
the extrapolation parametr s.
}
}

\value{
a vector with values from the quadratic predictor.
}

\author{
Shelemyahu Zacks
}


%% ~Make other sections like Warning with \section{Warning }{....} ~


\examples{
data(DOW1941)
plot(DOW1941$Date, DOW1941$DOW1941,          
     type="l", 
     ylab="Dow Jones 1941", xlab="Date")
     
lines(DOW1941$Date, predPoly(DOW1941$DOW1941, n = 20, s= 1))

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
