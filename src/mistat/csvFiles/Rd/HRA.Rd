\name{ALMPIN}
\alias{ALMPIN}
\alias{ALMPIN2}
\docType{data}
\title{
Annual customer satisfaction survey (19 dimensions)
}
\description{
Annual customer satisfaction survey directed at customers of an 
electronic product distributed worldwide. The survey assesses 
satisfaction levels regarding different features of the product 
and related services. The questionnaire is composed of 81 questions, 
including demographics and overall satisfaction. The answers 
were aggregated into 19 categories
}
\usage{data(ALMPIN)}
\format{
  A data frame with 58 observations on the following 19 variables.
  \describe{
    \item{\code{PeopleFactor}}{}
    \item{\code{TiredStaff}}{}
    \item{\code{Confidence}}{}
    \item{\code{Age}}{}
    \item{\code{WorkFactor}}{}
    \item{\code{Timeofoperation}}{}
    \item{\code{ProcedureRoutine}}{}
    \item{\code{ProcedurePracticed}}{}
    \item{\code{Noisy}}{}
    \item{\code{Lighting}}{}
    \item{\code{Temperature}}{}
    \item{\code{OrganizationFactor}}{}
    \item{\code{Crewsize}}{}
    \item{\code{Crewexperience}}{}
    \item{\code{Crewstress}}{}
    \item{\code{WellWritten}}{}
    \item{\code{ProcedureUnderstood}}{}
    \item{\code{Inspections}}{}
    \item{\code{humanError}}{}
  }
}
\details{
}
\source{
  Kenett RS, Salini S (eds) (2012) 
  \emph{Modern Analysis of Customer Surveys: With Applications Using R}.
  Wiley.
}
\examples{
data(ALMPIN)

cor(ALMPIN)

plot(ALMPIN)
}
\keyword{datasets}
