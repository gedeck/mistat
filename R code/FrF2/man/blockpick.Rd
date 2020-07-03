\name{blockpick}
\alias{blockpick}
\alias{blockpick.big}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Function to show potential block assignments }
\description{
  Functions to investigate potential assignments of blocks 
  and show alias information of resulting designs, meant for expert users
}
\usage{
blockpick(k, gen, k.block, design = NULL, show = 10, 
                       alias.block.2fis = FALSE, select.catlg = catlg)
blockpick.big(k, gen, k.block, design = NULL, show = 10, 
                       alias.block.2fis = FALSE, select.catlg = catlg)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{k}{ the number of base factors (designs have \code{2^k} runs) }
  \item{gen}{ vector of generating columns from Yates matrix; 
        for a full factorial, choose \code{gen = 0} or 
        \code{gen=numeric(0)} for 
        no generating columns; but note that there is always just the one 
        and only catalogued design returned for a full factorial.\cr
        For function \code{blockpick}, \code{gen} refers to the generators 
        of the base design only, and block columns are automatically added by 
        \code{blockpick}.\cr
        For function \code{blockpick.big}, \code{gen} refers to the generators 
        for treatment factors and block generators. In fact, \code{blockpick.big} 
        will always use the first \code{k.block} (base) factors for block generation. 
        Hence, for example for generating a design in 64 runs and 7 factors with 
        32 blocks, \code{gen} must have 6 entries in order to accomodate the 
        7 treatment factors together with the 5 block generators.
        }
  \item{k.block}{ number of base factors needed for constructing blocks; 
        there will be \code{2^k.block} blocks in the design }
  \item{design}{ design name (character string) of a specific design from the 
        catalogue given in select.catlg }
  \item{show}{ numeric integer indicating how many results are to be shown;
        the search for possible allocations stops, once \code{show} variants 
        have been found. Note that the best designs may not be found early in 
        the process, especially if a large number of eligible columns is available 
        and many blocks are needed (e.g. 
        full factorial in 64 runs with 16 blocks). In such cases, increasing \code{show} may 
        lead to finding a better design (but may also increase calculation 
        time from long to unbearable).}
  \item{alias.block.2fis}{ logical, indicates whether 2fis may be aliased with blocks }
  \item{select.catlg}{ design catalogue of class \code{catlg} }
}
\details{
  Function \code{blockpick} is used per default by function \code{\link{FrF2}} 
  for problems with \code{choose(nruns-1-nfactors,k.block) < 100000} and without 
  estimability requirements. \code{blockpick} will find a design, if it exists. 
  However, it may take a long time and/or much storage space in problems with 
  large numbers of runs and blocks.

  In \pkg{FrF2} versions before 2.0, function \code{blockpick.big} was used for 
  large use cases; this can still be requested using argument \code{block.old=TRUE}. 
  Since FrF2 version 2, the \code{\link[FrF2:godolphin]{Godolphin (2019) based approach}} 
  is used instead, both for 
  large cases and for cases where blocking is combined with estimability requirements 
  (\code{clear=TRUE} only); the big advantage is the ability of combining blocking with 
  estimability requirements, and a substantial speed gain if small blocks are needed. 
  
  All approaches investigate the potential assignment of blocks such that 
  main effects of treatment factors are not aliased with block main effects. 
  It is left to the user whether or not 2fis amoong treatment effects may be 
  aliased with block main effects (option \code{alias.block.2fis}). (For the Godolphin 
  approach to work, one will usually need to set \code{alias.block.2fis} to TRUE.)
  
  Following Sun, Wu and Chen (1997), there is no single best block assignment. 
  \code{blockpick} uses their catalogue for full factorials (implemented up to 256 runs). 
  For fractional factorials, it develops designs according to a 
  principle similar to that underlying the Sun Wu Chen catalogue that works also in 
  uncatalogued situations. 
  
  Function \code{blockpick.big} uses a strategy similar to \code{\link{splitpick}} 
  and \code{\link{leftadjust}}
  and often finds a solution quickly where \code{blockpick} does not work with the 
  given ressources. However, it is not guaranteed to find existing solutions 
  or a best solution. 
  }

\value{
  The function \code{blockpick} outputs a list of entries with information on at most \code{show} suitable 
  assignments. It ends with an error, if no suitable solution can be found.
  
  \item{gen}{generator column numbers of the base design (w.r.t. the Yates matrix)}
  \item{basics}{named vector with number of runs (\code{nruns}), number of blocks (\code{nblocks}), 
        number of treatment factors (\code{ntreat}) and resolution of base design (\code{res.base});
        the vector is numeric or character, depending on whether resolution is known exactly or 
        as \dQuote{5+} only}
  \item{blockcols}{matrix with at most show rows; each row contains the \code{k.block} 
        column numbers (w.r.t. the Yates matrix) of the block generators
        for the current assignment (the \code{2^k.block-1} columns for block main 
        effects can be obtained from these).}
  \item{alias.2fis.block}{list of character vectors, which contain the 2fis 
        aliased with block main effects for the respective rows of \code{blockcols}}
  \item{nblock.2fis}{vector with number of 2fis aliased with block main effects 
        for the respective rows of \code{blockcols}}
  \item{nclear.2fis}{vector with number of 2fis clear (of aliasing with block main effects 
        and treatment main effects or 2fis) 
        for the respective rows of \code{blockcols}}
  \item{clear.2fis}{list of character vectors, which contain the 2fis that are 
        counted in \code{nclear.2fis} 
        for the respective rows of \code{blockcols}}
  }

\references{ 
Chen, J., Sun, D.X. and Wu, C.F.J. (1993) 
A catalogue of 2-level and 3-level orthogonal arrays. 
\emph{International Statistical Review} \bold{61}, 131-145. 

Sun, D.X., Wu, C.F.J. and Chen, Y.Y. (1997). 
Optimal blocking schemes for 2\^p and 2\^(n-p) designs. \emph{Technometrics} \bold{39}, 
298-307. 
}
\author{ Ulrike Groemping }

\seealso{ See Also \code{\link{FrF2}}  }
\examples{
## look at possibilities for running a 32 run design with 6 factors in 8 blocks
## running this without alias.block.2fis=TRUE throws an error: not possible
\dontrun{blockpick(k=5,design="6-1.1",k.block=3)}
## the 8th to 10th design have more clear 2fis than the earlier ones
blockpick(k=5,design="6-1.1",k.block=3,alias.block.2fis=TRUE)
## function FrF2 can be used to manually accomodate this 
des32.6fac.8blocks.MaxC2 <- FrF2(32,6,blocks=c(3,12,21),alias.block.2fis=TRUE)
summary(des32.6fac.8blocks.MaxC2)
## automatic block generation leads to more aliased 2fis
summary(FrF2(32,6,blocks=8,alias.block.2fis=TRUE))

## look at possibilities for blocking design 7-3.1 from Chen, Sun, Wu catalogue
blockpick(4,design="7-3.1",k.block=2,alias.block.2fis=TRUE)

## big design
## running this throws an error on many machines because of too little memory
\dontrun{blockpick(6,design="7-1.2",k.block=5,alias.block.2fis=TRUE)}
## for obtaining a design for this scenario with blockpick.big, 
## the number of factors must be increased to 7+k.block=12
## designs 12-6.1 and 12-6.2 dont do it, 12-6.3 does
bpb <- blockpick.big(6,design="12-6.3",k.block=5,alias.block.2fis=TRUE)
bpb
## based on the result of blockpick.big, a blocked design can be obtained as follows:
## (not run for saving check time on CRAN)
\dontrun{
des64.7fac.32blocks <- FrF2(64,gen=bpb$gen[1,], blocks = as.list(1:5), 
   alias.block.2fis=TRUE)
str(des64.7fac.32blocks)
## if the seven factors are to be named A,...,G:
des64.7fac.32blocks <- FrF2(64,gen=bpb$gen[1,], blocks = as.list(1:5), 
   alias.block.2fis=TRUE, factor.names=c(paste("b",1:5,sep=""),Letters[1:7]))
str(des64.7fac.32blocks)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
