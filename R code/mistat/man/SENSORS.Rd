\name{SENSORS}
\alias{SENSORS}
\docType{data}
\title{
SENSORS
}
\description{
 174 measurements from 63 sensors tracking performance of a system under test. Each test generates values for these 63 sensors and a status determined by the automatic test equipment. The test results are coded as Pass (corresponding to 'Good' and Fail (all other categories).
}
\usage{data("SENSORS")}
\format{
  A data frame with 174 observations on the following 65 variables.
  \describe{
    \item{\code{sensor01}}{a numeric vector}
    \item{\code{sensor02}}{a numeric vector}
    \item{\code{sensor03}}{a numeric vector}
    \item{\code{sensor04}}{a numeric vector}
    \item{\code{sensor05}}{a numeric vector}
    \item{\code{sensor06}}{a numeric vector}
    \item{\code{sensor07}}{a numeric vector}
    \item{\code{sensor08}}{a numeric vector}
    \item{\code{sensor09}}{a numeric vector}
    \item{\code{sensor10}}{a numeric vector}
    \item{\code{sensor11}}{a numeric vector}
    \item{\code{sensor12}}{a numeric vector}
    \item{\code{sensor13}}{a numeric vector}
    \item{\code{sensor14}}{a numeric vector}
    \item{\code{sensor15}}{a numeric vector}
    \item{\code{sensor16}}{a numeric vector}
    \item{\code{sensor17}}{a numeric vector}
    \item{\code{sensor18}}{a numeric vector}
    \item{\code{sensor19}}{a numeric vector}
    \item{\code{sensor20}}{a numeric vector}
    \item{\code{sensor21}}{a numeric vector}
    \item{\code{sensor22}}{a numeric vector}
    \item{\code{sensor23}}{a numeric vector}
    \item{\code{sensor24}}{a numeric vector}
    \item{\code{sensor25}}{a numeric vector}
    \item{\code{sensor26}}{a numeric vector}
    \item{\code{sensor27}}{a numeric vector}
    \item{\code{sensor28}}{a numeric vector}
    \item{\code{sensor29}}{a numeric vector}
    \item{\code{sensor30}}{a numeric vector}
    \item{\code{sensor31}}{a numeric vector}
    \item{\code{sensor32}}{a numeric vector}
    \item{\code{sensor33}}{a numeric vector}
    \item{\code{sensor34}}{a numeric vector}
    \item{\code{sensor35}}{a numeric vector}
    \item{\code{sensor36}}{a numeric vector}
    \item{\code{sensor37}}{a numeric vector}
    \item{\code{sensor38}}{a numeric vector}
    \item{\code{sensor39}}{a numeric vector}
    \item{\code{sensor40}}{a numeric vector}
    \item{\code{sensor41}}{a numeric vector}
    \item{\code{sensor42}}{a numeric vector}
    \item{\code{sensor43}}{a numeric vector}
    \item{\code{sensor44}}{a numeric vector}
    \item{\code{sensor45}}{a numeric vector}
    \item{\code{sensor46}}{a numeric vector}
    \item{\code{sensor47}}{a numeric vector}
    \item{\code{sensor48}}{a numeric vector}
    \item{\code{sensor49}}{a numeric vector}
    \item{\code{sensor50}}{a numeric vector}
    \item{\code{sensor51}}{a numeric vector}
    \item{\code{sensor52}}{a numeric vector}
    \item{\code{sensor53}}{a numeric vector}
    \item{\code{sensor54}}{a numeric vector}
    \item{\code{sensor55}}{a numeric vector}
    \item{\code{sensor56}}{a numeric vector}
    \item{\code{sensor57}}{a numeric vector}
    \item{\code{sensor58}}{a numeric vector}
    \item{\code{sensor59}}{a numeric vector}
    \item{\code{sensor60}}{a numeric vector}
    \item{\code{sensor61}}{a numeric vector}
    \item{\code{sensor62}}{a numeric vector}
    \item{\code{sensor63}}{a numeric vector}
    \item{\code{testResult}}{a factor with levels \code{Brake} \code{Good} \code{Grippers} \code{IMP} \code{ITM} \code{Motor} \code{SOS} \code{Velocity Type I} \code{Velocity Type II}}
    \item{\code{status}}{a factor with levels \code{Fail} \code{Pass}}
  }
}


\examples{
data(SENSORS)
library(rpart)
rpart(status ~ . , data=SENSORS[, c("status", "sensor18", "sensor55")])
} 
\keyword{datasets}
