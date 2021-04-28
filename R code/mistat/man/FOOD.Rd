\name{FOOD}
\alias{FOOD}
\docType{data}
\title{
FOOD
}
\description{
Nutritional data from 961 different food items 
}
\usage{data("FOOD")}
\format{
  A data frame with 961 observations on the following 7 variables.
  \describe{
    \item{\code{Fat.grams}}{a numeric vector, fat in grams}
    \item{\code{FoodEnergy.calories}}{a numeric vector, food energy in calories}
    \item{\code{Carbohydrates.grams}}{a numeric vector, carbohydrates in grams}
    \item{\code{Protein.grams}}{a numeric vector, protein in grams}
    \item{\code{Cholesterol.mg}}{a numeric vector, cholesterol in milligrams}
    \item{\code{Weight.grams}}{a numeric vector, weight in grams}
    \item{\code{SaturatedFat.grams}}{a numeric vector, saturated fat in grams}
  }
}

\examples{
data(FOOD)
plot(FOOD)
}
\keyword{datasets}
