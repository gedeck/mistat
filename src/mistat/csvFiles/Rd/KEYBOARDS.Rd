\name{KEYBOARDS}
\alias{KEYBOARDS}
\docType{data}
\title{
New Designs of Feyboards for Desktop Computers
}
\description{
The design of the keyboard might have effect on the speed of 
typing or on the number of typing \code{errors}. Noisy factors 
are \code{typist} or type of \code{job}. Letters A, B, C, D of 
variable \code{keyboard} denote the designs.
}
\usage{data(KEYBOARDS)}
\format{
  A data frame with 25 observations on the following 4 variables.
  \describe{
    \item{\code{typist}}{The typist, a factor with levels \code{1} \code{2} \code{3} \code{4} \code{5}}
    \item{\code{job}}{The type of job, a factor with levels \code{1} \code{2} \code{3} \code{4} \code{5}}
    \item{\code{keyboard}}{Keyboard design, a factor with levels \code{A} \code{B} \code{C} \code{D} \code{E}}
    \item{\code{errors}}{Number of typing errors, a numeric vector}
  }
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(KEYBOARDS)

boxplot(errors ~ keyboard, data=KEYBOARDS, ylab="Errors")
}
\keyword{datasets}
