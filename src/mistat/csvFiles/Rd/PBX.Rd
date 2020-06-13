\name{PBX}
\alias{PBX}
\docType{data}
\title{
Software Errors Found in Testing a PBX
}
\description{
Software errors found in testing a Private Branch Exchange 
electronic switch. Errors are labeled according to the 
software unit where they occurred (e.g. "EKT", Electronic Key 
Telephone).
}
\usage{data(PBX)}
\format{
  The format is:
 Named num [1:5] 473 252 110 100 65
 - attr(*, "names")= chr [1:5] "GEN" "VHS" "HI" "LO" ...
}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(PBX)

barplot(PBX)            
}
\keyword{datasets}
