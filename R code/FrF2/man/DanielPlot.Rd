\name{DanielPlot}
\alias{DanielPlot}
\alias{DanielPlot.design}
\alias{DanielPlot.default}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Normal or Half-Normal Effects Plots }
\description{
  The function is modified from the same-name function in packge \pkg{BsMD}
  with the purpose of providing more usage comfort (correct effect sizes 
  in case of factors, automatic annotation, 
  automatic labelling of the most significant factors only).
}
\usage{
DanielPlot(fit, ...)
\method{DanielPlot}{design}(fit, ..., response = NULL)
\method{DanielPlot}{default}(fit, code = FALSE, autolab = TRUE, alpha = 0.05, faclab = NULL, 
       block = FALSE, datax = TRUE, half = FALSE, pch = "*", 
       cex.fac = par("cex.lab"), cex.lab = par("cex.lab"), 
       cex.pch = par("cex"), cex.legend = par("cex.lab"), 
       main = NULL, subtitle=NULL, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{fit}{an experimental design of class \code{\link[DoE.base:class-design]{design}} 
              with the \code{type} element of the \code{design.info} attribute 
              containing \dQuote{FrF2} or \dQuote{pb}\cr
              OR\cr
              object of class \code{lm}. Fitted model from \code{lm} or \code{aov}.}
  \item{\dots}{further arguments to be passed to the default function, 
      or graphical parameters to be passed to \code{plot};
      note that one should not use \code{pch} for split-plot designs.}
  \item{response}{ NULL or a character string that specifies response variable to be used, 
              must be an element of \code{response.names(obj)}; 
              if NULL, the first response from \code{response.names(obj)} is used}
  \item{code}{logical. If \code{TRUE} labels \dQuote{A},\dQuote{B}, etc. are used 
        instead of the names of the coefficients (factors). A legend linking 
        codes to names is provided.}
  \item{autolab}{ If TRUE, only the significant factors according to the Lenth method
                  (significance level given by \code{alpha}) are labelled. }
  \item{alpha}{ significanc level for the Lenth method }
  \item{faclab}{NULL or list. 
    If \code{NULL}, point labels are automatically determined according to the 
    setting of \code{code} (i.e. A,B,C etc. for \code{code=TRUE}, natural effect 
    names otherwise) and \code{autolab} (i.e. all effects are labelled if \code{autolab=FALSE},
    only significant effects are labelled if \code{autolab=TRUE}).  
    Otherwise, \code{faclab} can be used for manual labelling of certain effects 
    and should be a list with \code{idx} (integer vector referring to 
    position of effects to be labelled) and \code{lab} (character vector of labels)
    components. 
    }
  \item{block}{logical. If \code{TRUE}, the first factor is labelled as \dQuote{BK} (block).}
  \item{datax}{logical. If \code{TRUE}, the x-axis is used for the factor effects the
                the y-axis for the normal scores. The opposite otherwise.}
  \item{half}{logical. If \code{TRUE}, half-normal plot of effects is display.}
  \item{pch}{numeric or character. Points character.}
  \item{cex.fac}{numeric. Factor label character size.}
  \item{cex.lab}{numeric. Labels character size.}
  \item{cex.pch}{numeric. Points character size.}
  \item{cex.legend}{numeric. Legend size in case of codes.}
  \item{main}{NULL or character. Title of plot. If NULL, automatic title is generated.}
  \item{subtitle}{NULL or character. Sub title of plot. Should not be used for split-plot designs, 
     because automatic subtitle is generated for these.}
}

\details{
    The design underlying \code{fit} 
    has to be a (regular or non-regular) fractional factorial 2-level design. 
    Effects (except for the intercept) are displayed in a normal or half-normal 
    plot with the effects in the x-axis by default. 
    
    If \code{fit} is a design with at least one response variable 
    rather than a linear model fit, 
    the \code{lm}-method for class \code{design} is applied to it with 
    degree high enough that at least one effect is assigned to each column of the Yates matrix, 
    and the default method for \code{DanielPlot} is afterwards applied to the 
    resulting linear model.
    
    For split-plot designs, whole plot effects are shown as different plotting 
    characters, because they are potentially subject to larger variability, 
    and one should not be too impressed, if they look impressively large, 
    as this may well be indication of plot-to-plot variability rather than a 
    true effect.
}

\value{
    The function invisibly returns a data frame with columns: \code{x}, \code{y},
    \code{no}, \code{effect}, \code{coded} (if coded plot was requested) 
    and \code{pchs}, for the coordinates, the position numbers, 
    the effect names, the coded effect names, and the plotting characters 
    for plotted points.
    
    The plotting characters are particularly useful for split-plot designs and can be used 
    for subsequent separate plotting of whole-plot and split-plot effects, if necessary.
}

\references{
    Box G. E. P, Hunter, W. C. and Hunter, J. S. (2005)
    \emph{Statistics for Experimenters, 2nd edition}.
    New York: Wiley.

    Daniel, C. (1959) 
    Use of Half Normal Plots in Interpreting Two Level Experiments.
    \emph{Technometrics} \bold{1}, 311--340.
    
    Daniel, C. (1976) 
    \emph{Application of Statistics to Industrial Experimentation.}
    New York: Wiley.

    Lenth, R.V. (1989) Quick and easy analysis of unreplicated factorials.
    \emph{Technometrics} \bold{31}, 469--473.
    
    Lenth, R.V. (2006) Lenth s Method for the Analysis of Unreplicated Experiments.
    To appear in \emph{Encyclopedia of Statistics in Quality and Reliability}, Wiley, New York.
    Downloadable at \url{http://www.wiley.com/legacy/wileychi/eqr/docs/sample_1.pdf}.
}
\note{If you load package \pkg{BsMD} after package \pkg{FrF2}, 
    a mere call to function \code{DanielPlot} will use the function from package \pkg{BsMD} 
    rather than the one from package \pkg{FrF2}. You can explicitly request 
    usage of the \pkg{FrF2} function by \code{FrF2::DanielPlot}. }
\author{Ernesto Barrios, modified by Ulrike Groemping.}
\seealso{\code{\link{qqnorm}}, \code{\link[DoE.base]{halfnormal}}, 
   \code{\link[BsMD]{LenthPlot}}, \code{BsMD-package} }
\keyword{design}
