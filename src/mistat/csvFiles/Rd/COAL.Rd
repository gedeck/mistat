\name{COAL}
\alias{COAL}
\docType{data}
\title{
Number of Coal Mine Disasters
}
\description{
Data on the number of coal mine disasters
(explosions) in England, per year, for the period 1850 to 1961.
}
\usage{data(COAL)}
\source{
  Kenett, R. and Zacks, S. (1998)
  \emph{Modern Industrial Statistics: The Design and Control of Quality and Reliability}.
  Duxbury Press.
}
\examples{
data(COAL)
Bp <- barplot(COAL)                  
                                     
axis(side=1,                         
     labels=seq(
       from=1850, 
       to=1960, 
       by=10),  
     at=Bp[rep(c(TRUE,               
                 rep(FALSE, 9)),     
               10)])                 
                                     
rm(Bp)
}
\keyword{datasets}
