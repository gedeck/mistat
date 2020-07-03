\name{FrF2}
\alias{FrF2}
\alias{FrF2.currentlychecked}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Function to provide regular Fractional Factorial 2-level designs }
\description{
  Regular fractional factorial 2-level designs are provided. 
  Apart from obtaining the usual minimum aberration designs in a fixed number of runs, it is possible to 
  request highest number of free 2-factor interactions instead of minimum aberration or to 
  request the smallest design that fulfills certain requirements (e.g. resolution V with 8 factors).
}
\usage{
FrF2(nruns = NULL, nfactors = NULL, factor.names = if (!is.null(nfactors)) {
        if (nfactors <= 50) Letters[1:nfactors] else 
                             paste("F", 1:nfactors, sep = "")} else NULL, 
        default.levels = c(-1, 1), ncenter=0, center.distribute=NULL, 
        generators = NULL, design = NULL, 
        resolution = NULL, select.catlg=catlg, 
        estimable = NULL, clear = TRUE, method="VF2", sort="natural", 
        ignore.dom = !isTRUE(all.equal(blocks,1)), 
        useV = TRUE, firsthit=FALSE, res3 = FALSE, max.time = 60, 
        perm.start=NULL, perms = NULL, 
        MaxC2 = FALSE, replications = 1, repeat.only = FALSE, 
        randomize = TRUE, seed = NULL, alias.info = 2, 
        blocks = 1, block.name = "Blocks", block.old=FALSE, 
        force.godolphin=FALSE,
        bbreps=replications, wbreps=1, 
        alias.block.2fis = FALSE, 
        hard = NULL, check.hard=10, WPs=1,nfac.WP=0,
        WPfacs=NULL, check.WPs = 10, ...)
FrF2.currentlychecked()
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{nruns}{ Number of runs, must be a power of 2 (4 to 4096), if given. 
  
      The number of runs can also be omitted. In that case, 
      if \code{resolution} is specified, the function looks for the smallest 
      design of the requested resolution that accomodates \code{nfactors} factors. 
      If the smallest possible design is a full factorial or not catalogued, 
      the function stops with an error.
      
      If \code{generators} is specified, \code{nruns} is required.
      
      If estimable is specified and \code{nruns} omitted, 
      \code{nruns} becomes the size of the smallest design that 
      MIGHT accomodate the effects requested in \code{estimable}. 
      If this run size turns out to be too low, an error is thrown. 
      In that case, explicitly choose \code{nruns} as twice the run size 
      given in the error message and retry. }
  \item{nfactors}{ is the number of 2-level factors to be investigated. 
      It can be omitted, if it is obvious from \code{factor.names}, 
      a specific catalogued design given in \code{design}, 
      \code{nruns} together with \code{generators}, or 
      \code{estimable}. 
      
      If \code{estimable} is used for determining 
      the number of factors, it is assumed that the largest main effect position number 
      occurring in \code{estimable} coincides with \code{nfactors}. 
      
      For blocked designs, block generator columns are not included in 
      \code{nfactors}, except if 
      the user explicitly specifies 2-level block generation factors as 
      part of the fractional factorial design (e.g. a factor shift with levels 
      morning and afternoon). 
      
      For automatically-generated split-plot designs (cf. details section), 
      \code{nfactors} simply is the number of all factors (whole plot and split plot together). 
      If \code{nfac.WP < log2(WPs)}, the algorithm will add (an) artificial plot generation factor(s). 
      \cr
      For manually-specified split-plot designs (through options \code{generators} or 
      \code{design} together with \code{WPfacs}), the user must specify at least \code{log2(WPs)} 
      split plot factors, i.e. \code{nfac.WP >= log2(WPs)} is required (and must, if necessary, 
      be achieved by adding \code{log2(WPs) - nfac.WP} extra independent generator columns 
      for the whole plot structure, which have to be counted in \code{nfac.WP} and \code{nfactors}).}
  \item{factor.names}{ a character vector of \code{nfactors} factor names 
      or a list with \code{nfactors} elements;\cr 
      if the list is named, list names represent factor names, otherwise default factor names are used;\cr 
      the elements of the list are \cr
      EITHER vectors of length 2 with factor levels for the respective factor\cr
      OR empty strings. 
      For each factor with an empty string in factor.names, the levels given in 
      \code{default.levels} are used;\cr
       Default factor names are the first elements of the character vector \code{\link[DoE.base:utilities]{Letters}}, 
       or the factors position numbers preceded by capital F in case of more than 50 factors. }
  \item{default.levels}{ default levels (vector of length 2) for all factors for 
      which no specific levels are given }
  \item{ncenter}{ number of center points per block; \code{ncenter > 0} 
        is permitted, if all factors are quantitative and the design is not a split-plot design }
  \item{center.distribute}{ the number of positions over which the center points 
        are to be distributed for each block; if NULL (default), center points are 
        distributed over end, beginning, and middle (in that order, if there are fewer than three center points) 
        for randomized designs, and appended to the end for non-randomized designs. 
        for more detail, see function \code{\link{add.center}}, which does the work.
        }
  \item{generators}{ There are \code{log2(nruns)} base factors the full factorial 
        of which spans the design (e.g. 3 for 8 runs). 
        The generators specify how the remaining factors 
        are to be allocated to interactions of these.
        
        \code{generators} can be 
        
        a list of vectors with position numbers of base factors (e.g. c(1,3,4) 
        stands for the interaction between first, third and fourth base factor) 
        
        a vector of character representations of these interactions, 
        e.g. \dQuote{ACD} stands for the same interaction as above
        
        a vector of columns numbers in Yates order (e.g. 13 stands for ACD). 
        Note that the columns 1, 2, 4, 8, etc., i.e. all powers of 2, are reserved 
        for the base factors and cannot be used for assigning additional factors, 
        because the design would become a resolution II design. For looking up 
        which column number stands for which interaction, type e.g. 
        \code{names(Yates)[1:15]} for a 16 run design.
        
        In all cases, preceding the respective entry with a minus sign 
        (e.g. -c(1,3,4), \dQuote{-ACD}, -13) implies that the levels 
        of the respective column are reversed.\cr
        WARNING: Minus signs do not cause an error, but neither have an effect in case 
        of automatic assignment of split-plot designs or hard-to-change columns.
        }
  \item{design}{ is a character string specifying the name of a design listed 
        in the catalogue specified as \code{select.catlg}, which is usually 
        the catalogue \code{\link{catlg}}
        }
  \item{resolution}{ is the arabic numeral for the requested resolution of the design. 
        \code{FrF2} looks for a design with at least this resolution. 
        Option \code{resolution} does not work, if \code{estimable}, \code{blocks} 
        or \code{WPs} are specified, and neither if \code{nruns} is given.\cr
        A design with resolution III (resolution=3) confounds main effects 
        with 2-factor interactions, a design with resolution IV confounds main 
        effects with three-factor interactions or 2-factor interactions with each other, 
        and designs with resolution V or higher are usually regarded as very strong, 
        because all 2-factor interactions are unconfounded with each other and 
        with main effects.}
  \item{select.catlg}{ specifies a catalogue of class \code{catlg} from 
        which an adequate design is selected and adapted. \cr
        The specified catalogue is used for design construction, 
        unless \code{generators} explicitly constructs a 
        non-catalogued design. The default \code{\link{catlg}} is adequate for most 
        applications. 
        
        If a specific different catalogue of designs is available, 
        this can be specified here. \cr
        Specification of a smaller subset of designs is useful, if \code{estimable} 
        has been given and \code{clear=FALSE}, for restricting the search 
        to promising designs.
        
        \link[FrF2.catlg128:Catalogues]{Names of catalogues from package} \pkg{FrF2.catlg128} 
        can be given here without prior loading of that package; loading of the package 
        and the selected catalogue will then happen automatically, provided the 
        package is installed (for version >=1.2 of package \pkg{FrF2.catlg128}; 
        for earlier versions, the suitable catalogue has to be manually loaded 
        using the \code{data()} command).
        }                
  \item{estimable}{ indicates the 2-factor interactions (2fis) that are to be estimable in 
        the design. Consult the specific help file (\code{\link{estimable.2fis}}) 
        for details of two different approaches of requesting estimability, 
        as indicated by the status of the \code{clear} option. \code{estimable} cannot be 
        specified together with \code{splitplot}, \code{generators} or \code{design}.

        \code{estimable} can be\cr 
        a numeric matrix with two rows, each column of which indicates one interaction,
        e.g. column 1 3 for interaction of the first with the third factor\cr
        OR\cr
        a character vector containing strings of length 2 with capital letters from \code{Letters} 
        (cf. package \pkg{DoE.base})
        for the first 25 factors and small letters for the last 25 (e.g. \code{c("AB","BE")} \cr
        OR\cr
        a formula that contains an adequate model formula, e.g. \cr
        \code{formula("~A+B+C+D+E+(F+G+H+J+K+L)^2")} \cr
        for a model with (at least) eleven factors. \cr
        The names of the factors used in the formula can be the same letters usable in 
        the character vector (cf. above, A the first factor, B the second etc.), 
        or they can correspond to the factor names from 
        \code{factor.names}. 
        }
  \item{clear}{ logical, indicating how estimable is to be used. See \code{\link{estimable.2fis}}. }
  \item{method}{ character string indicating which subgraph isomorphism search routine 
        of package \pkg{igraph} is used (\code{graph.subisomorphic.vf2} or 
        \code{graph.subisomorphic.lad}). 
        The default \code{"VF2"} uses VF2 algorithm by Cordella et al. (2001), 
        which was the only available algorithm before version 1.7 of package FrF2. 
        The alternative \code{"LAD"} uses the LAD algorithm by Solnon (2010), which was 
        reported to be substantially faster than VF2 especially for some notoriously 
        difficult VF2 cases (see Gr?mping 2014b).         
        This option is relevant for \code{estimable} with \code{clear=TRUE} only.\cr
        NOTE: The resulting design may be different for different settings of this option!}
  \item{sort}{ character string indicating how the estimability requirement and the 
        candidate design clear 2fis are handed to 
        the subgraph isomorphism search routine of package \pkg{igraph}. 
        The default \code{"natural"} leaves them in unchanged order (like in 
        \pkg{FrF2} versions up to 1.6). \code{sort="high"} and \code{sort="low"} sort 
        both requirement set and candidate design graph according to vertex degrees (high 
        first or low first). 
        
        This option is relevant for \code{estimable} with \code{clear=TRUE} only.\cr
        It has been added, because pre-sorting of vertices sometimes speeds up the 
        search by several orders of magnitude especially for the \code{VF2} method.\cr
        NOTE: The resulting design may be different for different settings of this option!}
  \item{ignore.dom}{ logical, default FALSE for unblocked designs, TRUE for blocked designs; 
        if TRUE, \code{estimable} ignores 
        the dominating attribute of the catalogue entries; can be useful for 
        searching a blocked design with estimable 2fis from a reduced catalogue}
  \item{useV}{ NULL or logical; relevant for designs with \code{blocks} and \code{estimable} only; 
        if TRUE, function \code{link{colpick}} is used (default), otherwise function \code{link{colpickIV}}; 
        if set to NULL, \code{colpick} is used for fractions with resolution at least V and function 
        \code{link{colpickIV}} for resolution IV fractions;\cr
        \code{useV=FALSE} does the subgraph isomorphism check once only, 
        at the expense of missing out opportunities; it may be worth trying \code{useV=NULL} 
        or \code{useV=FALSE} for resolution IV situations, 
        for which the search takes very long with the default}
  \item{firsthit}{ logical; relevant for designs with \code{blocks} and \code{estimable} only; 
        if FALSE, the function tries to find a design with as many as possible clear 2fis, 
        otherwise the function stops at the first possible blocking; in case of resource problems, 
        setting \code{firsthit} to TRUE may be helpful}
  \item{res3}{ logical; if TRUE, \code{estimable} includes resolution III designs 
        into the search for adequate designs; otherwise resolution IV and higher designs 
        are included only. }
  \item{max.time}{ maximum time for design search as requested by \code{estimable}, 
        in seconds (default 60); introduced for \code{clear=FALSE} situations because
        the search can take a long time in complicated or unlucky situations;
        set max.time to Inf if you want to force a search over an extended period of 
        time; however, be aware that it may still take longer than feasible 
        (cf. also \code{\link{estimable.2fis}})}
  \item{perm.start}{ used with \code{estimable} specified, and \code{clear=FALSE}.\cr
        Provides a start permutation for permuting experiment factors (numeric vector). 
        This is useful for the case that a previous search was not (yet) successful 
        because of a time limit, since the algorithm notifies the user about the 
        permutation at which it had to stop.}
  \item{perms}{ used with \code{estimable} specified, and \code{clear=FALSE}.\cr
        Provides the matrix of permutations of experiment factors to be tried; each 
        row is a permutation. For example, for an 11-factor design with the 
        first six factors and their 2fis 
        estimable, it is only relevant, which of the eleven factors are to be allocated 
        to the first six experiment factors, and these as well as the other five factors can be 
        in arbitrary order. This reduces the number of required permutations from 
        about 40 Mio to 462. 
        It is recommended to use \code{perms} whenever possible, if \code{clear=FALSE}, 
        since this dramatically improves performance of the algorithm.
        
        It is planned to automatically generate perms for certain structures like 
        compromise designs in the (not so near) future.}
  \item{MaxC2}{ is a logical and defaults to FALSE. If TRUE, 
        maximizing the number of clear 2-factor interactions takes precedence 
        over minimizing aberration. Resolution is always considered first. 
        \code{MaxC2} is ignored when using the \code{estimable} option.
        \code{MaxC2=TRUE} is not a recommended choice. }
  \item{replications}{ positive integer number. Default 1 (i.e. each row just once). 
       If larger, each design run is executed replication times. 
       If \code{repeat.only}, repeated measurements 
       are carried out directly in sequence, i.e. no true replication takes place, 
       and all the repeat runs are conducted together. It is likely that the error 
       variation generated by such a procedure will be too small, so that average values 
       should be analyzed for an unreplicated design. 
       
       Otherwise (default), the full experiment is first carried out once, then 
       for the second replication and so forth. In case of randomization, 
       each such blocks is randomized separately. In this case, replication variance is 
       more likely suitable for usage as error variance 
       (unless e.g. the same parts are used for replication runs although build 
       variation is important).}
  \item{repeat.only}{ logical, relevant only if replications > 1. If TRUE, 
        replications of each run are grouped together 
       (repeated measurement rather than true replication). The default is 
       \code{repeat.only=FALSE}, i.e. the complete experiment 
       is conducted in \code{replications} blocks, and each run occurs in each block.  }
  \item{randomize}{ logical. If TRUE, the design is randomized. This is the default. 
       In case of replications, the nature of randomization depends on the setting of 
       option \code{repeat.only}.}
  \item{seed}{ optional seed for the randomization process \cr
        In R version 3.6.0 and later, the default behavior of function \code{\link{sample}}
        has changed. If you work in a new (i.e., >= 3.6.-0) R version and want to reproduce 
        a randomized design from an earlier R version (before 3.6.0), 
        you have to change the RNGkind setting by\cr
        \code{RNGkind(sample.kind="Rounding")}\cr
        before running function \code{FrF2}.\cr
        It is recommended to change the setting back to the new recommended way afterwards:\cr
        \code{RNGkind(sample.kind="default")}\cr
        For an example, see the documentation of the example data set \code{\link[DoE.base]{VSGFS}}.
        }
  \item{alias.info}{ can be 2 or 3, gives the order of interaction effects for which 
       alias information is to be included in the \code{aliased} component of the 
       \code{design.info} element of the output object. }
  \item{blocks}{ is EITHER \cr 
       the number of blocks into which the experiment is subdivided \cr
       OR a character vector of names of independent factors that are used as block constructors \cr
       OR a vector of Yates column numbers
       OR a list of generators similar to list entries for \code{generators}. \cr
       In the latter case, 
       the differences to \code{generators} are \cr 
       \itemize{
       \item that numbers/letters refer to the factors of the experiment and not to 
       column numbers of the Yates matrix 
       \item that numbers/letters can refer to *all* \code{nfactors} factors rather than the log2(nruns) base factors only, 
       \item that one single number is always interpreted as the number of blocks rather than a column reference, 
       \item that individual numbers are allowed in a list (i.e. individual factors specified in the experiment can be used as block factors) and
       \item that no negative signs are allowed. }
       
       If \code{blocks} is a single number, it must be a power of 2. 
       A blocked design can have at most \code{nruns-blocks-1} treatment 
       factors, but should usually have fewer than that. \cr
       
       If the experiment is randomized, randomization happens within blocks. 
       In case of many blocks, units should also be randomized to blocks wherever possible! \cr
       
       For the statistical and algorithmic background of blocked designs, see \code{\link{block}}.
       }
  \item{block.name}{ name of the block factor, default \dQuote{Blocks}}
  \item{block.old}{logical; if TRUE, blocking behavior of FrF2 version 1.7.2 is activated}
  \item{force.godolphin}{logical; if TRUE, blocking is forced to be done with the 
       Godolphin method (see \code{\link{block}})}
  \item{bbreps}{ between block replications; these are always taken as genuine replications, 
       not repeat runs; default: equal to \code{replications};
       CAUTION: you should not modify \code{bbreps} if you do not work with blocks, 
       because the program code uses it instead of \code{replications} in some places }
  \item{wbreps}{ within block replications; whether or not these are taken as genuine replications 
       depends on the setting of \code{repeat.only}}
  \item{alias.block.2fis}{ logical indicating whether blocks may be aliased 
       with 2fis (default: \code{FALSE}); \cr
       it will often be necessary to modify this option, because there is otherwise no solution.\cr 
       CAUTION: If \code{alias.block.2fis=TRUE} and the design is relatively small 
       (i.e. not with the Godolphin 2019 method), 
       no effort is made to avoid aliasing 
       of 2fis with block main effects, even if complete de-aliasing were possible.}
  \item{hard}{ gives the number of hard to change factors. These must be the 
       first factors in \code{factor.names}. Implementation is via a non-randomized split-plot 
       design with as few as possible whole plots (number of possible whole plots is 
       determined via left-adjustment) and as few as possible non-hard factors 
       within the whole plot structure (by applying split-plot after left-adjustment).\cr
       Observations within whole plots are randomized, whole plots themselves are not 
       randomized (contrary to split plot designs).\cr
       From the statistical point of view, randomisation of whole plots is strongly 
       preferrable (cf. \code{\link{splitplot}} for a brief discussion of the difference).
       If this appears feasible, you may want to explicitly handle the situation 
       by treating the hard to change factors as whole-plot factors via \code{WPs} and \code{nfac.WP}.
       }
  \item{check.hard}{ is the number of candidate designs from the catalogue specified 
       in \code{select.catlg} that are checked for making hard-to-change factors 
       change as little as possible.\cr
       The default is 10 - if too many changes are needed, a larger choice might 
       help find a design with fewer level changes (but will also take longer run time
       and will find a worse design in terms of resolution / aberration). \cr
       If you want to use the best design and do not want to compromise the confounding 
       structure for ease-of-change reasons, set check.hard to 1.}  
  \item{WPs}{ is the number of whole plots and must be a power of 2.\cr
       If \code{WPs > 1}, at least one of \code{nfac.WP} or \code{WPfacs} must be given.\cr
       If \code{WPs = 1}, all settings for split-plot related options are ignored.\cr
       
       For statistical and algorithmic information on treatment of split-plot designs 
       see the separate help file \code{\link{splitplot}}.
       }
  \item{nfac.WP}{ is the number of whole plot factors and must be smaller than \code{WPs}.
       
       The \code{nfac.WP} whole plot factors are counted within \code{nfactors}. 
       Per default, the first \code{nfac.WP} factors are the whole plot factors.
       
       If a design is provided and whole plot factors are manually provided 
       (design or generators option together with \code{WPfacs}), 
       \code{nfac.WP} can be omitted (i.e. remains 0). If given, it must coincide with 
       the length of \code{WPfacs}.

       If \code{nfac.WP} is given without \code{WPfacs}only, \code{generators} must not be given.

       If \code{nfac.WP} is omitted (i.e. remains 0) and \code{WPs} > 1, an error is thrown, 
       because the situation is a block rather than a split-plot situation 
       (and either it was forgotten to specify 
       the number of whole plot factors, or blocks should be specified).
        }
  \item{WPfacs}{ is per default NULL. In this case, the first \code{nfac.WP} factors are 
       considered whole plot factors (and are, if necessary, automatically supplemented by 
       additional whole plot constructor factors). \cr
       If \code{WPfacs} is given, it must specify at least \code{log2(WPs)} whole plot factors. 
       A custom design must be specified 
       with options \code{design} or \code{generators}, and the requested factors in 
       \code{WPfacs} must indeed create a split-plot structure with \code{WPs} whole plots. 
       If the number of whole plots created by the whole plot factors differs from 
       \code{WPs} or factors other than the specified factors from \code{WPfacs} would 
       in fact become whole plot factors as well, an error is thrown.
       
       \code{WPfacs} can be any of\cr 
       a vector or list of factor position numbers\cr
       OR\cr
       a character vector of factor position letters from \code{Letters}\cr
       OR\cr
       a character vector with entries \dQuote{F} followed by factor position number\cr
       OR\cr
       a character vector of factor names (this takes precedence over factor letters, 
       i.e. if the factor names were B, A, C, D, and E, factor letter entries in the \code{nfac.WP} 
       are interpreted as factor names, not position letters).\cr
       It is not possible to specify additional whole plot generators 
       from interaction effects manually through \code{WPfacs}. 
       Rather, all whole plot factors - even artificial ones needed only to increase the number 
       of plots - need to be included in the design factors. }
  \item{check.WPs}{ is the number of potential split-plot designs that are 
       compared by function \code{splitpick} w.r.t. resolution of the whole plot
       portion of the design. This option is effective, if \code{nfac.WP>k.WP} 
       (i.e. bad resolution possible) and nfac.WP not larger than half 
       the number of plots (i.e. resolution better than III is possible). 
       The default is 10 - if not satisfied with the structure of the whole plot 
       factors, a larger choice might help find a better design (but also take 
       longer run time). }
  \item{\dots}{ currently not used }
}
\details{
  Per default, the function picks the best design from the 
  default design catalogue \code{\link{catlg}} (a list object of class \code{catlg}). 
  
  Alternatively, the user can explicitly specify a design through accessing 
  a specific catalogued design using the \code{design} option or specifying non-catalogued 
  generators via the \code{generators} option.

  Apart from generation of simple fractional factorial designs based on catalogued 
  or non-catalogued generators, function \code{FrF2} allows specification of blocked designs 
  and split-plot designs, as well as specification of a set of 2fis that are required to be estimable. 
  The implementation of these possibilities is explained in the separate help files \code{\link{block}}, 
  \code{\link{splitplot}} and \code{\link{estimable.2fis}}. If you consider to use 
  option \code{hard}, it may also be worth while to look at the \code{\link{splitplot}} 
  help file.
  
  Function \code{FrF2} is still under development, although most features are 
  now included, and the principle structure of inputs and outputs should not change 
  much any more. Please contact me with any suggestions for improvements.
  
  Function \code{FrF2.currentlychecked} is meant as a diagnostic tool, 
  when searching for designs with option \code{estimable}
  and \code{clear=TRUE}. If the search takes very long, it can be interrupted 
  (CAUTION: in some igraph versions, interrupting the search may crash R). 
  After a successful interruption, and \code{FrF2.currentlychecked()} 
  returns a character string with the name of the design that was checked at the 
  time of interruption. 
}
\value{
  Function \code{FrF2} returns a data frame of S3 class \code{\link[DoE.base:class-design]{design}} 
  that has attached attributes that can be accessed 
  by functions \code{\link[DoE.base:class-design-methods]{desnum}}, 
  \code{\link[DoE.base:class-design-methods]{run.order}} and 
  \code{\link[DoE.base:class-design-methods]{design.info}}. 
  
  The data frame itself contains the design with levels coded as requested. 
  If no center points have been requested, the design columns are factors with 
  contrasts \code{-1} and \code{+1} (cf. also \code{\link[DoE.base]{contr.FrF2}}); in case 
  of center points, the design columns are numeric.
  
  The following attributes are attached to it: 
  \item{desnum}{Design matrix in -1/1 coding}
  \item{run.order}{a three column data frame;\cr 
       the first column (\code{run.no.in.std.order})
       contains the run number in standard order, possibly including a block number 
       and in that case also a number for the original position within the block,\cr 
       the second column (\code{run.no}) contains the actual run number as randomized, \cr
       the third column contains (\code{run.no.std.rp}) contains the content 
       of the first column accumulated with a replication identifier, if applicable.\cr
       A few remarks on the run number in standard order are needed here: \cr
       In blocked and split plot designs, the run number in standard 
       order refers to a row ordering with the first base factor changing \emph{slowest}, 
       different from the usual order with the first base factor changing \emph{fastest}. 
       Also note that the run number in standard order may not refer to 
       the base columns one would naturally expect for designs created with blocking,  
       estimable 2fis or split plot designs; the elements \code{map} and/or  
       \code{orig.fac.order} of the attribute \code{design.info} help identify 
       which base factors drive the run number in standard order.
       (In case of option \code{hard=TRUE}, the remark on split plot designs applies, 
       and the numbering refers to the special slow change matrix from 
       Cheng et al. 1998.)\cr
       Before version 2 of package FrF2, blocking for large situations was internally 
       done with function \code{blockpick.big}. This behavior can be reproduced 
       using the argument \code{block.old=TRUE}; if blocking for a large design is 
       not successful otherwise, \code{block.old=TRUE} might be worth a try. 
       For blocked designs created internally with 
       function \code{blockpick.big}, 
       the run number in standard order is not easily related to the final 
       design.}
  \item{design.info}{list with the entries 
  \describe{
    \item{type}{ character string \dQuote{full factorial}, \dQuote{FrF2}, 
         \dQuote{FrF2.estimable}, \dQuote{FrF2.generators}, \dQuote{FrF2.blocked} 
         or \dQuote{FrF2.splitplot} depending on the 
         type of design}
    \item{nruns}{ number of runs (replications are not counted) }
    \item{nfactors}{ number of factors; since version 0.97, 
         this is also true for designs of type \code{FrF2.blocked} 
         (\code{nfactors} is now equal to \code{ntreat}) and for designs of type 
         \code{FrF2.splitplot}, where \code{nfactors} is now the sum of \code{nfac.WP} and \code{nfac.SP}.}
    \item{ntreat}{ for designs of type \code{FrF2.blocked} only; \cr
         number of treatment factors }
    \item{nfac.WP}{ for designs of type \code{FrF2.splitplot} only; \cr
         number of whole plot factors (including extra factors that may have been 
         added for whole plot construction); these are the first factors in the 
         design data frame }
    \item{nfac.SP}{ for designs of type \code{FrF2.splitplot} only; \cr
         number of split-plot factors }
    \item{nlevels}{for designs of type \code{full factorial} only; \cr
         vector with number of levels for each factor 
         (of course, all the \code{nfactors} entries are \dQuote{2} for \code{FrF2})}
    \item{factor.names }{ list named with (treatment) factor names and containing as 
         entries vectors of length two each with coded factor levels }
    \item{FrF2.version }{ version number of package FrF2, 
         supporting correct usage of \code{FrF2}-specific functionality in 
         functions \code{summary} and \code{generators} 
         methods for class \code{design}}
    \item{nblocks}{for designs of type \code{FrF2.blocked} only; \cr
         number of blocks}
    \item{block.gen}{vector of columns of the Yates matrix for generating 
         block factors in case of automatic block generation \cr 
         OR list of (vectors of) factor numbers in case the \code{blocks} 
         argument specifies certain factor combinations for blocking; ; \cr
         for designs of type \code{FrF2.blocked} only}
    \item{blocksize}{for designs of type \code{FrF2.blocked} only; \cr
         size of each block (without consideration of \code{wbreps})}
    \item{nWPs}{for designs of type \code{FrF2.splitplot} only; \cr
         number of whole plots}
    \item{plotsize}{for designs of type \code{FrF2.splitplot} only; \cr
         size of each plot (without consideration of repeat.only replications if applicable)}
    \item{orig.fac.order }{designs of type \code{FrF2.splitplot} only; \cr
         factor order of the design before reshuffling of factors in order 
         to accomodate the split plot request; 
         the run number in standard order can only be interpreted together 
         with this information}
    \item{catlg.entry }{ for designs of type \code{FrF2} only; \cr
         list with one element, which is the entry of \code{catlg} 
         on which the design is based}
    \item{generators }{ for designs of type \code{FrF2.generators} only; \cr
         character vector of generators in the form D=ABC etc.}
    \item{base.design }{ for designs of type \code{FrF2.blocked} or \code{FrF2.splitplot} only; \cr
         gives a character string that contains the name of the base design 
         in the catalogue or the column numbers of generating columns in Yates matrix; 
         in case of automatic block generation, the exclusion or inclusion of \code{k.block} 
         in the number of design factors / generators 
         indicates whether the design was generated using function 
         \code{\link{blockpick}} or \code{\link{blockpick.big}}.}
    \item{aliased.with.blocks}{ for designs of type \code{FrF2.blocked} only; \cr
         treatment effects that are aliased with block main effects,
         up to 2fis or 3fis, depending on the choice of \code{alias.info}}
    \item{aliased }{ alias structure of main effects, 2fis and possibly 3fis,
         depending on the choice of \code{alias.info}; 
         For non-blocked and non-split-plot designs, \code{aliased} is 
         itself a list of the two or three components main, fi2, and optionally fi3, given 
         in terms of factor letters from \code{Letters} (up to 50~factors) 
         or \code{F1}, \code{F2}, and so forth (more than 50~factors). 
         For blocked and split-plot designs, \code{aliased} is a single list 
         with an entry for each column of the Yates matrix that accomodates 
         aliased low-order effects, and entries are in terms of factor names.)}
    \item{replication }{ option setting in call to \code{FrF2} }
    \item{repeat.only }{ option setting in call to \code{FrF2} }
    \item{bbreps}{for designs of type \code{FrF2.blocked} only; 
         number of between block replications}
    \item{wbreps}{for designs of type \code{FrF2.blocked} only; 
         number of within block replications;\cr
         \code{repeat.only} indicates whether these are replications or repetitions only}
    \item{map }{ the mapping relation between factors in the base design and 
         experimental factors, after using option \code{estimable} and for split-plot designs}
    \item{clear }{ option setting in call to \code{FrF2}, in case of \code{estimable} }
    \item{res3}{ option setting in call to \code{FrF2}, in case of \code{estimable} }
    \item{randomize }{ option setting in call to \code{FrF2} }
    \item{seed }{ option setting in call to \code{FrF2} }
    \item{creator }{ call to function FrF2 
         (or stored menu settings, if the function has been called via the R commander plugin 
         \pkg{RcmdrPlugin.DoE}) }
    \item{ncube }{ number of cube points per block, in case center points have been requested }
    \item{ncenter }{ number of center points per block, in case center points have been requested }
         }
       }
}
\references{
Bingham, D.R., Schoen, E.D. and Sitter, R.R. (2004). 
Designing Fractional Factorial Split-Plot Experiments with Few Whole-Plot Factors. 
\emph{Applied Statistics} \bold{53}, 325-339.

Bingham, D. and Sitter, R.R. (2003). Fractional Factorial Split-Plot Designs
for Robust Parameter Experiments. \emph{Technometrics} \bold{45}, 80-89.

Bisgaard, S. (1994a). Blocking generators for small 2\^(k-p) designs. 
\emph{J. Quality Technology} \bold{26}, 288-294.

Chen, J., Sun, D.X. and Wu, C.F.J. (1993) 
A catalogue of 2-level and 3-level orthogonal arrays. 
\emph{International Statistical Review} \bold{61}, 131-145. 

Cheng, C.-S., Martin, R.J., and Tang, B. (1998). 
Two-level factorial designs with extreme numbers of level changes. \emph{Annals of Statistics} 
\bold{26}, 1522-1539.

Cheng, C.-S. and Tsai, P.-W. (2009). 
Optimal two-level regular fractional factorial block and split-plot designs. 
\emph{Biometrika} \bold{96}, 83-93.

Cheng, S.W. and Wu, C.F.J. (2002). 
Choice of optimal blocking schemes in 2-level and 3-level designs. 
\emph{Technometrics} \bold{44}, 269-277. 

Cordella, L.P., Foggia, P., Sansone, C. and Vento, M. (2001). 
An improved algorithm for matching large graphs. \emph{Proc. of the 3rd 
IAPR TC-15 Workshop on Graphbased Representations in Pattern Recognition},
149--159.

Godolphin, J. (2019). Construction of blocked factorial designs to estimate main effects and selected two-factor interactions. \url{https://arxiv.org/abs/1907.02373}

Groemping, U. (2012). Creating clear designs: a graph-based algorithm and a 
catalogue of clear compromise plans. \emph{IIE Transactions} \bold{44}, 988--1001.
Preprint available at \url{http://www1.beuth-hochschule.de/FB_II/reports/Report-2010-005.pdf}. 

Groemping, U. (2014a). {R} Package {FrF2} for Creating and Analyzing Fractional 
Factorial 2-Level Designs. \emph{Journal of Statistical Software}, \bold{56}, 
Issue 1, 1-56. \url{http://www.jstatsoft.org/v56/i01/}.
    
Groemping, U. (2014b). A Note on Dominating Fractional Factorial 
Two-Level Designs With Clear Two-Factor Interactions. \emph{Technometrics} 
\bold{56}, 42--45.
    
Groemping, U. (2019). An Algorithm for blocking regular 2-level fractional factorial designs, while keeping selected two-factor interactions clear. 
   \emph{Reports in Mathematics, Physics and Chemistry}, \href{http://www1.beuth-hochschule.de/FB_II/reports}{technical report}, 
   Department II, Beuth University of Applied Sciences Berlin.

Huang, P., Chen, D. and Voelkel, J.O. (1998). Minimum-Aberration Two-Level Split-Plot Designs. 
\emph{Technometrics} \bold{40}, 314-326. 

Mee, R. (2009). \emph{A Comprehensive Guide to Factorial Two-Level Experimentation}. 
New York: Springer.

Solnon, C. (2010). AllDifferent-based Filtering for Subgraph Isomorphism.
\emph{Artificial Intelligence} \bold{174}, 850--864.

Sun, D.X., Wu, C.F.J. and Chen, Y.Y. (1997). 
Optimal blocking schemes for 2\^p and 2\^(n-p) designs. \emph{Technometrics} \bold{39}, 
298-307. 

Wu, C.F.J. and Chen, Y. (1992) 
A graph-aided method for planning two-level experiments when certain interactions 
are important. 
\emph{Technometrics} \bold{34}, 162-175. 
}

\section{Warning}{
   Since R version 3.6.0, the behavior of function \code{\link{sample}} has changed 
   (correction of a biased previous behavior that should not be relevant for the randomization of designs). 
   For reproducing a randomized design that was produced with an earlier R version, 
   please follow the steps described with the argument \code{seed}.
}
\author{ Ulrike Groemping }

\seealso{ See also \cr
\code{\link{FrF2Large}} for regular fractional factorial designs 
with more than 4096 runs (these are not supported by a design catalogue, except for 
a few resolution V designs which have not been checked for any optimality among the resolution V designs), \cr
\code{\link{pb}} for non-regular fractional factorials according 
to Plackett-Burman, \cr
\code{\link{catlg}} for the underlying design catalogue and some accessor functions,\cr
and \code{\link{block}}, \code{\link{splitplot}} or \code{\link{estimable.2fis}} 
for statistical and algorithmic information on the respective topic.}
\examples{
## maximum resolution minimum aberration design with 4 factors in 8 runs
FrF2(8,4)
## the design with changed default level codes
FrF2(8,4, default.level=c("current","new"))
## the design with number of factors specified via factor names 
      ## (standard level codes)
FrF2(8,factor.names=list(temp="",press="",material="",state=""))
## the design with changed factor names and factor-specific level codes
FrF2(8,4, factor.names=list(temp=c("min","max"),press=c("low","normal"),
     material=c("current","new"),state=c("new","aged")))
## a full factorial
FrF2(8,3, factor.names=list(temp=c("min","max"),press=c("low","normal"),
     material=c("current","new")))
## a replicated full factorial (implicit by low number of factors)
FrF2(16,3, factor.names=list(temp=c("min","max"),press=c("low","normal"),
     material=c("current","new")))
## three ways for custom specification of the same design
FrF2(8, generators = "ABC")
FrF2(8, generators = 7)
FrF2(8, generators = list(c(1,2,3)))
## more than one generator
FrF2(8, generators = c("ABC","BC"))
FrF2(8, generators = c(7,6))
FrF2(8, generators = list(c(1,2,3),c(2,3)))
## alias structure for three generators that differ only by sign
design.info(FrF2(16,generators=c(7,13,15),randomize=FALSE))$aliased
design.info(FrF2(16,generators=c(7,-13,15),randomize=FALSE))$aliased
design.info(FrF2(16,generators=c(-7,-13,-15),randomize=FALSE))$aliased
## finding smallest design with resolution 5 in 7 factors
FrF2(nfactors=7, resolution=5)
## same design, but with 12 center points in 6 positions
FrF2(nfactors=7, resolution=5, ncenter=12, center.distribute=6)


## maximum resolution minimum aberration design with 9 factors in 32 runs
## show design information instead of design itself
design.info(FrF2(32,9))
## maximum number of free 2-factor interactions instead of minimum aberration
## show design information instead of design itself
design.info(FrF2(32,9,MaxC2=TRUE))

## usage of replication
## shows run order instead of design itself
run.order(FrF2(8,4,replication=2,randomize=FALSE))
run.order(FrF2(8,4,replication=2,repeat.only=TRUE,randomize=FALSE))
run.order(FrF2(8,4,replication=2))
run.order(FrF2(8,4,replication=2,repeat.only=TRUE))


\dontrun{
## examples below do work, but are repeated in the 
## respective method's separate help file and are therefore prevented 
## from running twice

########## automatic blocked designs ###################
## from a full factorial ##
FrF2(8,3,blocks=2)
## with replication
run.order(FrF2(8,3,blocks=2,wbreps=2))
run.order(FrF2(8,3,blocks=2,wbreps=2,repeat.only=TRUE))
run.order(FrF2(8,3,blocks=2,bbreps=2))
run.order(FrF2(8,3,blocks=2,bbreps=2,wbreps=2))

## automatic blocked design with fractions
FrF2(16,7,blocks=4,alias.block.2fis=TRUE,factor.names=c("MotorSpeed", 
      "FeedMode","FeedSizing","MaterialType","Gain","ScreenAngle","ScreenVibLevel"))
## isomorphic non-catalogued design as basis
FrF2(16,gen=c(7,11,14),blocks=4,alias.block.2fis=TRUE)
## FrF2 uses blockpick.big and ignores the generator
FrF2(64,gen=c(7,11,14),blocks=16,alias.block.2fis=TRUE, block.old=TRUE)
## FrF2 uses Godolphin approach
FrF2(64,gen=c(7,11,14),blocks=16,alias.block.2fis=TRUE)

########## manual blocked design ####################
### example that shows why order of blocks is not randomized
### can of course be randomized by user, if appropriate
FrF2(32,9,blocks=c("Day","Shift"),alias.block.2fis=TRUE, 
    factor.names=list(Day=c("Wednesday","Thursday"), Shift=c("Morning","Afternoon"),
        F1="",F2="",F3="",F4="",F5="",F6="",F7=""), default.levels=c("current","new"))

########## blocked design with estimable 2fis ####################
### all interactions of last two factors to be estimable clearly
### in 64 run design with blocks of size 4
### not possible with catalogue entry 9-3.1
FrF2(64, 6, blocks=16, factor.names=Letters[15:20], 
                 estimable=compromise(6,3)$requirement,
                 alias.block.2fis=TRUE, randomize=FALSE)
FrF2(design="9-3.2", blocks=16, alias.block.2fis=TRUE, 
    factor.names = list(C1="",C2="",C3="",C4="",C5="",C6="",C7="",
    N1=c("low","high"),N2=c("low","high")), 
    default.levels = c("current","new"),
    estimable=compromise(9, 8:9)$requirement)
FrF2(256, 13, blocks=64, alias.block.2fis=TRUE, 
    factor.names = list(C1="",C2="",C3="",C4="",C5="",C6="",C7="",C8="",
    N1=c("low","high")), 
    default.levels = c("current","new"),
    estimable=compromise(13, 1)$requirement)

########## hard to change factors ####################
## example from Bingham and Sitter Technometrics 19999
## MotorSpeed, FeedMode,FeedSizing,MaterialType are hard to change
BS.ex <- FrF2(16,7,hard=4,
     factor.names=c("MotorSpeed", "FeedMode","FeedSizing","MaterialType",
                  "Gain","ScreenAngle","ScreenVibLevel"), 
     default.levels=c("-","+"),randomize=FALSE)
design.info(BS.ex)
BS.ex
## NOTE: the design has 8 whole plots.
## If randomize=FALSE is used like here, the first hard-to-change factors 
## do not always change between whole plots. 
## A conscious and honest decision is required whether this is 
##    acceptable for the situation at hand!
## randomize=TRUE would cause more changes in the first four factors.

########## automatic generation for split plot ##########
## 3 control factors, 5 noise factors, control factors are whole plot factors
## 8 plots desired in a total of 32 runs
## Bingham Sitter 2003
BS.ex2a <- FrF2(32, 8, WPs=8, nfac.WP=3, 
      factor.names=c(paste("C",1:3,sep=""), paste("N",1:5,sep="")),randomize=TRUE)

## manual generation of this same design
BS.ex2m <- FrF2(32, 8, generators=c("ABD","ACD","BCDE"),WPs=8, WPfacs=c("C1","C2","C3"), nfac.WP=3, 
      factor.names=c(paste("C",1:3,sep=""),paste("N",1:5,sep="")),randomize=TRUE)

## design with few whole plot factors
## 2 whole plot factors, 7 split plot factors
## 8 whole plots, i.e. one extra WP factor needed
BSS.cheese.exa <- FrF2(32, 9, WPs=8, nfac.WP=2, 
      factor.names=c("A","B","p","q","r","s","t","u","v"))
design.info(BSS.cheese.exa)
## manual generation of the design used by Bingham, Schoen and Sitter
## note that the generators include a generator for the 10th spplitting factor
    ## s= ABq, t = Apq, u = ABpr and v = Aqr, splitting factor rho=Apqr
BSS.cheese.exm <- FrF2(32, gen=list(c(1,2,4),c(1,3,4),c(1,2,3,5),c(1,4,5),c(1,3,4,5)), 
      WPs=8, nfac.WP=3, WPfacs=c(1,2,10),
      factor.names=c("A","B","p","q","r","s","t","u","v","rho"))
design.info(BSS.cheese.exm)

########## usage of estimable ###########################
  ## design with all 2fis of factor A estimable on distinct columns in 16 runs
  FrF2(16, nfactors=6, estimable = rbind(rep(1,5),2:6), clear=FALSE)
  FrF2(16, nfactors=6, estimable = c("AB","AC","AD","AE","AF"), clear=FALSE)
  FrF2(16, nfactors=6, estimable = formula("~A+B+C+D+E+F+A:(B+C+D+E+F)"), 
       clear=FALSE)
            ## formula would also accept self-defined factor names
            ## from factor.names instead of letters A, B, C, ...
            
  ## estimable does not need any other input
  FrF2(estimable=formula("~(A+B+C)^2+D+E"))

  ## estimable with factor names 
  ## resolution three must be permitted, as FrF2 first determines that 8 runs 
  ##     would be sufficient degrees of freedom to estimate all effects 
  ##     and then tries to accomodate the 2fis from the model clear of aliasing in 8 runs
  FrF2(estimable=formula("~one+two+three+four+two:three+two:four"), 
       factor.names=c("one","two","three","four"), res3=TRUE)
  ## clear=FALSE allows to allocate all effects on distinct columns in the 
  ##     8 run MA resolution IV design
  FrF2(estimable=formula("~one+two+three+four+two:three+two:four"), 
       factor.names=c("one","two","three","four"), clear=FALSE)

  ## 7 factors instead of 6, but no requirements for factor G
  FrF2(16, nfactors=7, estimable = formula("~A+B+C+D+E+F+A:(B+C+D+E+F)"), 
       clear=FALSE)
  ## larger design for handling this with all required effects clear
  FrF2(32, nfactors=7, estimable = formula("~A+B+C+D+E+F+A:(B+C+D+E+F)"), 
       clear=TRUE)
  ## 16 run design for handling this with required 2fis clear, but main effects aliased
  ## (does not usually make sense)
  FrF2(16, nfactors=7, estimable = formula("~A+B+C+D+E+F+A:(B+C+D+E+F)"), 
       clear=TRUE, res3=TRUE)
}
## example for the sort option added with version 1.6-1
## and for usage of a catalogue from package FrF2.catlg128 (simplified with version 1.6-5)
  \dontrun{
  estim <- compromise(17,15:17)$requirement  ## all interactions of factors 15 to 17 (P,Q,R)
  ## VF2 algorithm without pre-sorting of vertices
  ### CAUTION: in some igraph versions, the following may crash R ###
  FrF2(128, 17, estimable=estim, select.catlg=catlg128.17) 
                        ## very slow, interrupt with ESC key after a short while
                        ## !!! save all important work before, in case R crashes
  FrF2.currentlychecked()   ## displays the design that was currently checked 
                            ## should be 17-10.2407, if the interrupt was successful
  ## VF2 algorithm with pre-sorting of vertices
  FrF2(128, 17, estimable=estim, sort="high", select.catlg=catlg128.17)  ## very fast
  FrF2(128, 17, estimable=estim, sort="low", select.catlg=catlg128.17)  ## very fast
  ## LAD algorithm
  FrF2(128, 17, estimable=estim, method="LAD", select.catlg=catlg128.17)  ## very fast
  ## guaranteed to be MA clear design 
  ## only works, if package FrF2.catlg128 is installed
  }

## example for necessity of perms, and uses of select.catlg and perm.start
## based on Wu and Chen Example 1
  \dontrun{
  ## runs per default about max.time=60 seconds, before throwing error with 
  ##        interim results
  ## results could be used in select.catlg and perm.start for restarting with 
  ##       calculation of further possibilities
  FrF2(32, nfactors=11, estimable = formula("~(A+B+C+D+E+F)^2"), clear=FALSE)
  ## would run for a long long time (I have not yet been patient enough)
  FrF2(32, nfactors=11, estimable = formula("~(A+B+C+D+E+F)^2"), clear=FALSE, 
       max.time=Inf)
  ## can be easily done with perms, 
  ## as only different subsets of six factors are non-isomorphic
  perms.6 <- combn(11,6)
  perms.full <- matrix(NA,ncol(perms.6),11)
  for (i in 1:ncol(perms.6))
     perms.full[i,] <- c(perms.6[,i],setdiff(1:11,perms.6[,i]))
  FrF2(32, nfactors=11, estimable = formula("~(A+B+C+D+E+F)^2"), clear=FALSE, 
      perms = perms.full )
  }
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ array }
\keyword{ design }% __ONLY ONE__ keyword per line
