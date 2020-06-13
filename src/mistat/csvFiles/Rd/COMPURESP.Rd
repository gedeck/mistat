\name{COMPURESP}
\alias{COMPURESP}
\docType{data}
\title{
Computer Response Time Optimization
}
\description{
The experiment described here was part of an extensive effort to optimize a
UNIX operating system.
}
\usage{data(COMPURESP)}
\format{
  A data frame with 18 observations on the following 10 variables.
  \describe{
    \item{\code{F}}{a factor with levels \code{1} \code{2}, representing KMCs used}
    \item{\code{B}}{a factor with levels \code{1} \code{2} \code{3}, representing File Distribution}
    \item{\code{C}}{a factor with levels \code{1} \code{2} \code{3}, representing Memory Size}
    \item{\code{D}}{a factor with levels \code{1} \code{2} \code{3}, representing System Buffers}
    \item{\code{E}}{a factor with levels \code{1} \code{2} \code{3}, representing  Sticky Bits}
    \item{\code{A}}{a factor with levels \code{1} \code{2} \code{3}, representing Disk Drives}
    \item{\code{G}}{a factor with levels \code{1} \code{2} \code{3}, representing INODE Table Entries}
    \item{\code{H}}{a factor with levels \code{1} \code{2} \code{3}, representing Other System Tables}
    \item{\code{Mean}}{mean time taken for the system to complete commands execution}
    \item{\code{SN}}{S/N ratio \eqn{\eta = -10 log_{10}(\frac{1}{n} \sum_i y_i^2 )}{\eta = -10 log10(1/n \sum y^2 )}}
  }
}
\details{
The experiment described here was part of an extensive effort to
optimize a UNIX operating system running on a VAX 11-780 machine.  The
machine had 48 user terminal ports, two remote job entry links, four
megabytes of memory, and five disk drives.  The typical number of users
logged on at a given time was between 20 to 30.  

\bold{1. Problem Definition}.  Users complained that the system
performance was very poor, especially in the afternoon.  The objective
of the improvement effort was to both minimize response time and reduce
variability in response.

\bold{2. Response variable}.  In order to get an objective
measurement of the
response time two specific representative commands called \sQuote{standard}
and \sQuote{trivial} were used.  The \sQuote{standard} command consisted of
creating, editing and removing a file.  The \sQuote{trivial} command was
the UNIX system \sQuote{date} command.  Response times were measured by
submitting these commands every 10 minutes and clocking the time taken
for the system to complete their execution.
}
\source{
  Pao, Phadke and Sherrerd (1985)
}
\examples{
data(COMPURESP)

layout(matrix(1:4, 2, byrow=TRUE))

with(COMPURESP,
     interaction.plot(
       x.factor=F, 
       trace.factor=rep(0, length(F)), 
       response=SN, 
       legend=FALSE,
       type="b",
       pch=15:18,
       ylim=c(-17, -10)))

with(COMPURESP,
     interaction.plot(
       x.factor=B, 
       trace.factor=rep(0, length(B)), 
       response=SN, 
       legend=FALSE,
       type="b",
       pch=15:18,
       ylim=c(-17, -10)))

with(COMPURESP,
     interaction.plot(
       x.factor=C, 
       trace.factor=rep(0, length(C)), 
       response=SN, 
       legend=FALSE,
       type="b",
       pch=15:18,
       ylim=c(-17, -10)))

with(COMPURESP,
     interaction.plot(
       x.factor=D, 
       trace.factor=rep(0, length(D)), 
       response=SN, 
       legend=FALSE,
       type="b",
       pch=15:18,
       ylim=c(-17, -10)))

layout(1)
}
\keyword{datasets}
