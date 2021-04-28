\name{masPred1}
\alias{masPred1}

\title{
Moving Average Smoothing Predictor
}
\description{
A moving average smoother is a sequence which replaces X_t by a fitted polynomial based on the window of size n = 2m + s around X_t. The simplest smoother is the linear one.
}
\usage{
masPred1(x, m, s)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
a vector of data X_t.
}
  \item{m}{
the m to define the window size.
}
  \item{s}{
the s to define the window size.
}
}

\value{
a vector with values form the linear smoother predictor.
}


\author{
Shelemyahu Zacks
}

\examples{
set.seed(123)
x <- 1:20 + rnorm(20, 0, 0.1)
masPred1(x, m = 3, s= 1)
masPred1(x, m = 3, s= 3)

data(DOW1941)
plot(DOW1941$Date, DOW1941$DOW1941,          
     type="l", 
     ylab="Dow Jones 1941", xlab="Date")
lines(DOW1941$Date, masPred1(DOW1941$DOW1941, m = 3, s= 1))
}

