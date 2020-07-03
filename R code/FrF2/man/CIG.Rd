\name{CIG}
\alias{CIGstatic}
\alias{CIG}
\alias{gen2CIG}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Clear interactions graph from catlg entry }
\description{
  Function CIG creates a clear interactions graph (CIG) 
  from a catlg design (design name must be given). 
  Function CIGstatic allows to create a static graph from a dynamically-adjusted 
  one. 
}
\usage{
CIG(design, select.catlg = catlg, nfac = NULL, static = FALSE, 
   layout = layout.auto, label = "num", plot = TRUE, ...)
CIGstatic(graph, id, label = "num", xlim = c(-1,1), ylim = c(1,-1), ...)
gen2CIG(nruns, gen)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{design}{a character string that identifies a design in the catalogue specified 
       by option \code{select.catlg}, \cr
       OR a class \code{catlg} object with a single entry, \cr
       OR a formula with all main effects and the requested clear 2-factor 
       interactions, \cr
       OR a character vector of length more than one with two-letter combinations of 
       the clear 2-factor interactions,\cr
       OR a numeric two-row matrix with factor numbers of the clear 2-factor 
       interactions,\cr
       OR a character two-row matrix with factor names of the clear 2-factor 
       interactions.\cr
       The first two are for graphing design CIGs, the other ones for requirement 
       set CIGs.}
  \item{select.catlg}{name of catalogue (not in quotes); 
        only relevant, if \code{design} is a character string}
  \item{nfac}{number of factors; this is not needed for a class \code{catlg} object, 
       or if the graph is supposed to show only factors that are involved 
       in at least one interaction}
  \item{static}{logical. If \code{TRUE}, a static graphic is produced, 
        otherwise an interactive graphic is created that can be modified 
        by moving aroung nodes; only relevant for \code{plot=TRUE}}
  \item{layout}{ignored for \code{static=FALSE};\cr
        possible values are two-column matrices with number of rows 
        equal to the number of vertices of the graph, or layout parameters for 
        function \code{\link[igraph]{plot.igraph}} as described in 
        \code{\link[igraph]{plot.common}} 
        and \code{\link[igraph]{layout}};\cr
        default: \code{layout.auto} (changed with version 1.6, was \code{layout.circle} 
        before}
  \item{label}{in effect for \code{catlg} object only (character design name or 
        class \code{catlg} object);\cr
        a character string that decides for numeric labels or 
        character labels; any string other than the default will invoke the 
        factor letters as labels}
  \item{plot}{a logical that decides whether a plot is requested (default: \code{TRUE});\cr
        plotting can be suppressed, if graph creation is desired for calculating 
        graph characteristics with functions from package \code{igraph} 
        (e.g. \code{\link[igraph:cliques]{clique.number}},
        \code{\link[igraph:cliques]{largest.cliques}}, 
        \code{\link[igraph:independent.vertex.sets]{independence.number}},
        \code{\link[igraph:degree]{degree}}) }
  \item{\dots}{further arguments to be passed to function \code{\link[igraph]{tkplot}}, 
      or graphical parameters to be passed to \code{plot}.}
  \item{graph}{a graph object from package \code{igraph}, or a list whose first 
        element is such a graph object (like the output from function \code{CIG})}
  \item{id}{identification number of the interactive graph to be reproduced in 
        static form; this number can be found in the header line of the graphics window}
  \item{xlim}{horizontal axis limits}
  \item{ylim}{vertical axis limits (per default reversed in order to exactly 
        reproduce the interactive graph) }
  \item{nruns}{number of runs of the design to be graphed }
  \item{gen}{generator (vector of Yates matrix column numbers) }
}

\details{
    The design depicted in \code{CIG} has to be the name (character string) of a 
    regular fractional factorial 2-level design present in \code{select.catlg}. 
    
    Clear 2fis are depicted as edges in the graph. In the interactive graph, 
    users can change the layout manually or with the menus. For example, 
    the Reingold-Tilford layout can be chosen, with a root vertex specified; 
    this sometimes helps in identifying groups 
    of vertices that are not connected with each other. 
    
    Previous versions of package \code{igraph} used to internally number the 
    vertices from 0 to number of vertices -1, not from 1 to number of vertices. 
    This has been changed 
    in June 2012 (FrF2 adapted to this change with version 1.5).
    
    Function \code{CIGstatic} serves the purpose to statically create the current 
    interactively modified graph; 
    the usual annotation possibilities for plots are available.
    
    Function \code{gen2CIG} returns a graph object that can be plotted or otherwise 
    investigated with graph-related 
    functionality.
}

\value{
    For \code{plot=FALSE} or \code{plot=TRUE} with \code{static=TRUE}, 
    function \code{CIG} visibly (\code{plot=FALSE}) or invisibly (\code{plot=TRUE}) 
    returns a graph from package \code{igraph}.\cr
    For \code{plot=TRUE} with \code{static=FALSE}, 
    the function returns a list with the first element \code{graph} 
    the element \code{coords} with the coordinates of that graph. \cr
    Function \code{CIGstatic} works on the list produced by function \code{CIG} 
    by plotting the graph statically using the positioning from the 
    current interactive picture. 
    
    Function \code{gen2CIG} returns a clear interactions graph that can e.g. be 
    plotted with functions \code{plot} (\code{\link[igraph]{plot.igraph}}) or 
    \code{\link[igraph]{tkplot}}.
}

\references{
Groemping, U. (2010). Creating clear designs: a graph-based algorithm and a 
   catalogue of clear compromise plans. 
   \emph{Reports in Mathematics, Physics and Chemistry}, report 05/2010, 
   Department II, Beuth University of Applied Sciences Berlin.
   (Preprint for IIE Transactions; IIE Transactions is available at 
   \url{http://www.tandfonline.com}.)

}
\examples{
\dontrun{
ex.CIG <- CIG("9-4.2", vertex.color="white", vertex.label.color="darkred")
## play around with the dynamic graph until it looks right
## look up its id number in the title bar of the graph window and use it for id
par(xpd=TRUE)
CIGstatic(ex.CIG, id=1)
}

graph1 <- CIG("9-4.2", plot=FALSE)   ### create graph object from design name
### calculate graph properties
require(igraph)
degree(graph1)
clique.number(graph1)
independence.number(graph1)
largest.cliques(graph1)

graph2 <- gen2CIG(32, c(7,11,14,29))   ### create graph object from generator columns
### check isomorphism to graph1
graph.isomorphic(graph1, graph2)

\dontrun{
## use a CIG for manual design search
## requirement set: 
estim <- compromise(9, 8:9)$requirement ## all interactions of factors 8 and 9 (H, J)
## graph the requirement set CIG
CIG(estim, vertex.color="white", vertex.label.color="darkred")
## a human can easily see that columns 1, 8 and 9 are worth a try for factors P, Q and R
CIG("9-4.1", vertex.color="white", vertex.label.color="darkred")
    ## obviously, 9-4.1 cannot accommodate the requirement set
CIG("9-4.2", vertex.color="white", vertex.label.color="darkred")
    ## 9-4.2 can, by assigning factors H and J to columns 5 and 9
## function FrF2 automatically does such matchings
}
}
\author{Ulrike Groemping}
\seealso{\code{\link[igraph]{plot.igraph}}, \code{\link[igraph]{tkplot}},
   \code{\link[igraph]{plot.common}} }
\keyword{design}
