\name{IAPlot}
\alias{MEPlot}
\alias{MEPlot.design}
\alias{MEPlot.default}
\alias{IAPlot}
\alias{IAPlot.design}
\alias{IAPlot.default}
\alias{intfind}
\alias{check}
\alias{remodel}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Main Effects and Interaction Plots }
\description{
  Main effects plots and interaction plots are produced. The other documented 
  functions are not intended for users. 
}
\usage{
MEPlot(obj, ...)
\method{MEPlot}{design}(obj, ..., response = NULL)
\method{MEPlot}{default}(obj, main = paste("Main effects plot for", respnam), 
    pch = 15, cex.xax = par("cex.axis"), cex.yax = cex.xax, mgp.ylab = 4, 
    cex.title = 1.5, cex.main = par("cex.main"), 
    lwd = par("lwd"), abbrev = 3, select = NULL, ...)

IAPlot(obj, ...)
\method{IAPlot}{design}(obj, ..., response = NULL)
\method{IAPlot}{default}(obj, main = paste("Interaction plot matrix for", respnam), 
    pch = c(15, 17), cex.lab = par("cex.lab"), cex = par("cex"), 
    cex.xax = par("cex.axis"), cex.yax = cex.xax, cex.title = 1.5, 
    lwd = par("lwd"), abbrev = 4, select = NULL, show.alias = FALSE, ...)
         
intfind(i, j, mat)

check(obj)

remodel(obj)

}

\arguments{
  \item{obj}{ an experimental design of class \code{\link[DoE.base:class-design]{design}} 
              with the \code{type} element of the \code{design.info} attribute 
              containing \dQuote{FrF2} or \dQuote{pb}\cr
              OR\cr
              a linear model object with 2-level factors or numerical 
              2-level variables; \cr
              the structure must be such that effects are either fully 
              aliased or orthogonal, like in a regular fractional factorial 2-level 
              design;\cr
              note that \code{IAPlot} currently requires the response in \code{obj} to be 
              a pre-defined variable and not a calculated quantity}
  \item{\dots}{ further arguments to be passed to the default function; \cr
              \dots in the default method are not used, they have been added because of 
              formal requirements only }
  \item{response}{ character string that specifies response variable to be used, 
              must be an element of \code{response.names(obj)}; 
              if NULL, the first response from \code{response.names(obj)} is used}
  \item{main}{ overall title for the plot assembly }
  \item{pch}{ Plot symbol number \code{MEPlot}, 
              or vector of two plot symbol numbers for the lower 
              and higher level of the trace factor \code{iap}}
  \item{cex.xax}{ size of x-axis annotation, defaults to \code{cex.axis}-parameter }
  \item{cex.yax}{ size of y-axis annotation, defaults to cex.xax }
  \item{mgp.ylab}{horizontal placement of label of vertical axis in \code{MEPlot}}
  \item{cex.title}{multiplier for size of overall title 
              (cex.main is multiplied with this factor) } 
  \item{cex.main}{ size of individual plot titles in \code{MEPlot} } 
  \item{cex.lab}{ Size of variable names in diagonal panels of interaction plots
              produced by \code{IAPlot}.}
  \item{cex}{ size of plot symbols in interaction plots }
  \item{lwd}{ line width for plot lines and axes }
  \item{abbrev}{ number of characters shown for factor levels }
  \item{select}{ vector with position numbers of the main effects to be displayed; \cr
              default: all main effects; the default implies the full interaction plot matrix 
              for \code{IAPlot}.\cr
              For \code{IAPlot}, the full interaction plot matrix for the selected 
              factors is displayed. Of course, at least two factors must be selected. 
              Furthermore, the linear model \code{obj} must at least contain one 
              interaction term among the selected variables. 
              For interactions that do not occur in the linear model, not plot is shown.
              An interaction plot matrix of data means can be obtained by 
              specifying the model with all possible 2-factor interactions (e.g. formula 
              \code{y~(.)^2} for a regular 2-level fractional factorial, for which 
              \code{y} is the only response and all other variables are 2-level factors).
              }
  \item{show.alias}{ if TRUE, the interaction plot shows the number 
              of the list entry from aliases(obj)\$aliases 
              (cf. \code{\link{aliases}}) in order to support immediate 
              diagnosis of which depicted interaction may be due to other 
              than the shown effect because of aliasing;\cr
              CAUTION: if the \code{select} option is used, 
              the model is reduced to the selected factors, i.e. aliases with 
              unselected factors are not shown!}
  \item{i}{integer, for internal use only}
  \item{j}{integer, for internal use only}
  \item{mat}{matrix, for internal use only}
}

\details{
    For functions \code{MEPlot} or \code{IAPlot}, 
    if \code{obj} is a design with at least one response variable 
    rather than a linear model fit, 
    the \code{lm}-method for class \code{design} is applied to it with the 
    required degree (1 or 2), 
    and the default method for the respective function is afterwards applied to the 
    resulting linear model.
    
  \describe{
  \item{MEPlot}{produces plots of all main effects in the model, 
              or selected ones if \code{select} is specified}
  \item{IAPlot}{produces plots of all interaction effects in the model,
              or selected ones if \code{select} is specified}
  \item{intfind}{is an internal function not directly useful for users}
  \item{check}{is an internal function for checking whether the model complies 
              with assumptions (fractional factorial of 2-level factors 
              with full or no aliasing, not partial aliasing; 
              this implies that Plackett-Burman designs with partial aliasing 
              of 2-factor interactions give an OK (=TRUE) in \code{check} for 
              pure main effects models only.)}
  \item{remodel}{is an internal function that redoes factor values into -1 and 1 
              coding, regardless of the contrasts that have been used for the 
              original factors;
              numerical data are transformed by subtracting the mean and dividing 
              by half the range (max-min), which also transforms them to -1 and 1 
              coding in the 2-level case (and leads to an error otherwise)}
  }
}
\value{
  \code{MEPlot} and \code{IAPlot} invisibly return the plotted effects (two-row 
           matrix or four-row matrix, respectively). If \code{show.alias=TRUE}, 
           the matrix returned by IAPlot has as the attribute \code{aliasgroups},
           which contains all alias groups (list element number corresponds to 
           number in the graphics tableau).
  
  The internal function \code{check} is used within other functions for checking 
           whether the model is a fractional factorial with 2-level factors and 
           no partial aliasing, as requested for the package to work.  
           It is applied to remodeled objects only and returns a logical.  
           If the returned value is FALSE, the calling function fails. 
              
  The internal function \code{intfind} returns an integer (length 1 or 0). 
           It is not useful for users.
  
  The internal function \code{remodel} is applied to a linear model object and 
  returns a list of two components:
      \item{model }{is the redone model with x-variables recoded to numeric 
              -1 and 1 notation and aov objects made into \dQuote{pure} lm objects}
      \item{labs }{is a list preserving the level information from original factors
               (levels are minus and plus for numerical variables)}
}

\references{ 
    Box G. E. P, Hunter, W. C. and Hunter, J. S. (2005)
    \emph{Statistics for Experimenters, 2nd edition}.
    New York: Wiley.
 }
\author{ Ulrike Groemping }

\seealso{ \code{\link{FrF2-package}} for examples }
\keyword{ design }
