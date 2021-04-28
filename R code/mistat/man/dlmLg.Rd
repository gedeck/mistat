\name{dlmLg}
\alias{dlmLg}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Dynamic Linear Model with linear growth
}
\description{
Dynamic Linear Model with linear growth.
}
\usage{
dlmLg(x, C0, v, W, M0)
}

\arguments{
  \item{x}{
a vector of data X_t.
}
  \item{C0}{
 prior covariance matrix
}
  \item{v}{
 prior variance of V.
}
  \item{W}{
 prior variance of W.
}
  \item{M0}{
 prior mean.
}
}

\value{
a vector with values from the Dynamic Linear Model.
}

\author{
Shelemyahu Zacks
}

\examples{
C0 <- matrix(c(0.22325, -0.00668, -0.00668, 0.00032), nrow = 2, byrow = TRUE)
W <- matrix(c(0.3191, -0.0095, -0.0095, 0.0004), nrow = 2, byrow = TRUE)
M0 <- matrix(c(134.234, -0.3115), nrow = 2)
v <- 0.1

data(DOW1941)
plot(DOW1941$Date, DOW1941$DOW1941,          
     type="l", 
     ylab="Dow Jones 1941", xlab="Date")
     
lines(DOW1941$Date, dlmLg(DOW1941$DOW1941, C0 = C0, v = v, W = W, M0 = M0))


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
