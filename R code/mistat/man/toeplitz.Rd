\name{toeplitz}
\alias{toeplitz}

\title{
Toeplitz matrix
}
\description{
partial lag correlation Toeplitz matrix.
}
\usage{
toeplitz(a)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{a}{
An array containing the estimated acf from function \code{acf}.
}
}

\value{
a matrix.
}

\author{
Shelemyahu Zacks
}

\examples{

toeplitz(acf(nottem, 5)$acf)

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
