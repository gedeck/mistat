\name{SYSTEMFAILURE}
\alias{SYSTEMFAILURE}
\docType{data}
\title{
SYSTEMFAILURE
}
\description{
208 observations on systems operating at 90 geographically dispersed sites.
}
\usage{data("SYSTEMFAILURE")}
\format{
  A data frame with 208 observations on the following 5 variables.
  \describe{
    \item{\code{CustomerNumber}}{a factor, customer ID}
    \item{\code{Censor}}{a numeric vector}
    \item{\code{TimeStamp}}{a numeric vector}
    \item{\code{SystemMaturity}}{a factor with levels \code{Mature} \code{Young}}
    \item{\code{Country}}{a factor with levels \code{AUSTRALIA} \code{AUSTRIA} \code{BELGIUM} \code{BRAZIL} \code{BULGARIA} \code{CANADA} \code{CHINA} \code{DENMARK} \code{FINLAND} \code{GERMANY} \code{HUNGARY} \code{INDIA} \code{ITALY} \code{JAPAN} \code{NETHERLANDS} \code{NEW ZEALAND} \code{POLAND} \code{PORTUGAL} \code{REPUBLIC OF KOREA} \code{ROMANIA} \code{RUSSIAN FEDERATION} \code{SOUTH AFRICA} \code{SPAIN} \code{SWITZERLAND} \code{TURKEY} \code{UNITED KINGDOM} \code{UNITED STATES}}
  }
}
\details{
Twelve systems are new installed and are labeled as 'Young'. All the other systems are labeled 'Mature'. Out of the 208 observations, 68 report time stamps of a failure (uncensored). The other observations are censored, as indicated by the value 1 in the Censor variable column. A measure of time, the time stamp, is recorded for each observation in the data. This variable presented in operational units (activity time), at time of observation. The bigger the time, the longer the system performed. The observations with a value 0 of the Censor variable, represent length of operation till failure of the systems.
}

\examples{
data(SYSTEMFAILURE)
summary(subset(SYSTEMFAILURE, subset = Censor == 0, select = "TimeStamp"))
}
\keyword{datasets}
