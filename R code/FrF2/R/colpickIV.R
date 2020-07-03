colpickIV <- function(design, q, all=FALSE, 
                    select.catlg=catlg, 
                    estimable=NULL, method="VF2", sort="natural", 
                    res3=FALSE, all0=FALSE, quiet=FALSE,
                    firsthit=is.numeric(design)){
  ## design is a character string that identifies a catalogued design
  ##    or a length 1 catlg object
  ##    of the number of factors for a full factorial
  ## q is log2 of the block size
  ## all = TRUE requests a list of results
  ## select.catlg is a design catalogue of class catlg
  ## estimable is a character vector of estimable 2fis in letter notation, 
  ##    or a two row numeric matrix with factor numbers (each column indicates a clear 2fi)
  ## method is the method to use for subgraph isomorphism checking
  ## sort is the method to use for pre-sorting in the subgraph isomorphism check
  ## all0 = TRUE also outputs X matrices with zero columns
  ## for all=FALSE, the function returns a list with an X matrix 
  ## the clear2fis, 
  ## and possibly a mapping (if estimable is specified)
  ## for all=TRUE, the function returns a list of three or four lists (X matrices, estimable 2fis, profiles)
  ## if estimable is specified, 
  ## the fourth list indicates a re-mapping with which the requirement can be accommodated
  catlg <- select.catlg
  if (!("catlg" %in% class(design) || is.character(design) || is.numeric(design)))
    stop("design must be the number of factors of a full factorial", 
         " or a character string that refers to an element of select.catlg", 
         " or of class catlg")
  if (is.numeric(design)){
    ## full factorial
    element <- list(list(nfac  = design,
                         nruns = 2^design,
                         res = Inf,
                         nclear.2fis = choose(design, 2),
                         clear.2fis = combn(design, 2),
                         gen = numeric(0), 
                         WLP = rep(0, 4),
                         dominating = TRUE))
    class(element) <- c("catlg", "list")
  }
  if (is.character(design)){
    element <- catlg[design]    ## class catlg
  }
  if ("catlg" %in% class(design)) 
    element <- design[1]       ## more than one element is ignored without warning
  N <- element[[1]]$nruns
  n <- element[[1]]$nfac
    #if (n>50) stop("colpickIV works for up to 50 factors only")
  gen <- element[[1]]$gen         ## Yates column numbers
  p <- length(gen)
  k <- n - p
  map <- NULL        ## overwrite any map object from global environment

  ## select adequate element of catlg in case of estimable
  if (!is.null(estimable)){
    ## stricter checks than with estimable.check
    ## as there need not be factor.names etc.
    if (!is.numeric(estimable) && !is.character(estimable))
      stop("estimable must be an integer-valued two row matrix",
           " or a character vector")
    if (is.numeric(estimable) && !is.matrix(estimable))
      stop("if numeric, estimable must be a matrix with two rows")
    if (is.numeric(estimable) && !nrow(estimable)==2)
      stop("if numeric, estimable must be a matrix with two rows")
    if (is.character(estimable)){
      colons <- grep(":", estimable)
      if (!(length(colons)==0 || length(colons)==length(estimable)))
          stop("All elements of estimable must have the same format")
      if (length(colons)==0)
      estimable <- sapply(estimable, 
                          function(obj) which(Letters %in% unlist(strsplit(obj, "", fixed=TRUE))))
      else   estimable <- sapply(estimable, 
                          function(obj) as.numeric(gsub( "F", "", unlist(strsplit(obj, ":", fixed=TRUE)) )))
      if (!is.matrix(estimable)) stop("invalid estimable")
     }
    ## estimable is now a two-row matrix
    ## obtain map with which the requirement set can be accommodated in the design
    if (p==0) map <- 1:n else
    map <- mapcalc(estimable, n, N, select.catlg=element, method=method, sort=sort, 
                   res3=res3, ignore.dom=TRUE)[[1]]
    ## adapt estimable to the mapping
    estimable <- matrix(map[estimable], nrow=2)  
    ## sort columns in ascending order
    for (i in 1:ncol(estimable)) estimable[,i] <- sort(estimable[,i])
    if (n<=50) estimchar <- sapply(1:ncol(estimable), 
                        function(obj) 
                          paste0(Letters[estimable[,obj]], collapse=""))
    else estimchar <- sapply(1:ncol(estimable), function(obj) 
      paste("F",estimable[,obj], sep="", collapse = ":"))
    ## character representation for later success checking
  } 

  ## clear before blocking
  clear2fis <- clear.2fis(element)
  if (length(clear2fis[[1]])==0) 
    clear2fis <- character(0) 
  else{
    if (n <= 50) 
    clear2fis <- sapply(1:ncol(clear2fis[[1]]), function(obj) 
      paste(Letters[clear2fis[[1]][,obj]], collapse = ""))
    else
    clear2fis <- sapply(1:ncol(clear2fis[[1]]), function(obj) 
      paste("F",clear2fis[[1]][,obj], sep="", collapse = ":"))
    }
  nclear2fis <- length(clear2fis)
  
  Z <- t(sapply(gen, function(obj) rev(digitsBase(obj, 2, k))))
  div <- 2^q-1

  ## list of possible X column vectors
  Xcands <- lapply(1:div, function(obj) digitsBase(obj, 2, ndigits=q))

  success <- FALSE
  Xlist <- vector(mode="list")
  tablist <- vector(mode="list")
  clearlist <- vector(mode="list")
  ## each row of picks provides a possible XI matrix
  ## lazy expanding in order to facilitate large problems
  ## modify Godolphin as follows:
  ##    only use up to the first e elements in position e
  poscands <- lapply(1:k, function(obj) 
    if (obj <= div) 
      1:obj
    else 1:div
  )
  nxt <- do.call(lazyExpandGrid, poscands)
  nr <- prod(lengths(poscands))
  # picks <- as.matrix(expand.grid(rep(list(1:div), k-1)))
  # picks would have nr rows
  message("checking up to ", nr, " matrices")
  
  ## initialize to a heavily balanced first matrix
  ## not yet using nxt()
  ## this makes full factorials without estimability requirements immediate
  ##     and may also be beneficial for fractions with easy structure
  ## nxt() is used at the end of the loop
  jetzt <- rep(1:div, (k%/%div+1))[1:k]
  i <- 0
  while (i <= nr){
    ## nr + 1, because the first jetzt is extra
    XI <- do.call(cbind, Xcands[jetzt])
        if (length(Z)>0){ 
          XII <- (XI%*%t(Z))%%2
          X <- cbind(XI, XII)
        }
        else X <- XI   ## full factorial
        
        ## skip settings with less than q different columns
        ## i.e. with row rank less than q
        hilf <- lapply(1:n, function(obj) X[,obj])
        if (length(unique(hilf)) < q){
          jetzt <- unlist(nxt())
          i <- i+1
          next 
        }
        
    if (all(colSums(X) > 0) || all0){ 
      ## remove direct aliases from blocking
      clearcur <- clear2fis
      if (length(clear2fis) > 0){
        ingroup <- character(0)
        for (ii in 1:(n-1))
          for (jj in (ii+1):n)
            if (all(X[,ii]==X[,jj]))
              ingroup <- c(ingroup,ifelse(n<=50,
                                  paste0(Letters[ii],Letters[jj]),
                                  paste0("F",ii,":F",jj)))
        clearcur <- setdiff(clearcur, ingroup)
      }
      
      if (is.null(estimable))
        success <- TRUE 
      else{
        if (all(estimchar %in% clearcur)) {
          success <- TRUE
          if (firsthit) 
            return(list(X=X, clear2fis=clearcur, map=map))
        }
        else{
          ## skip matrices that violate estimability requirement
          jetzt <- unlist(nxt())
          i <- i+1
          if (is.logical(jetzt)){
            if (!jetzt) break
          }
          next 
        }
      }  
    }
    else {
      ## skip matrices with all-zero column
      jetzt <- unlist(nxt())
      i <- i+1
      if (is.logical(jetzt)){
        if (!jetzt) break
      }
      next 
    }
    tab <- sort(table(apply(X, 2, paste0, collapse="")), decreasing = TRUE)
    tab <- unname(tab)
    ## optimal in terms of maximum number
    if (length(clearcur) == min(phimax(n,q), nclear2fis) && !all){
      ## maximum possible with this candidate and this q
      if (is.null(estimable)) 
        return(list(X=X, clear2fis=clearcur))
      else 
        return(list(X=X, clear2fis=clearcur, map=map))
    } else{
      if (is.null(estimable)){
        Xlist <- c(Xlist, list(X))
        tablist <- c(tablist, list(tab))
        clearlist <- c(clearlist, list(clearcur))
      }
      else{
        if (!is.null(map)){
          Xlist <- c(Xlist, list(X))
          tablist <- c(tablist, list(tab))
          clearlist <- c(clearlist, list(clearcur))
        }
      }
    }
    ## obtain next entry (will be FALSE, if no further entry available)
    jetzt <- unlist(nxt())  ## should get the next entry
    i <- i+1
    if (is.logical(jetzt)){
      if (!jetzt) break
      }
  } ## end of loop
  if (!success) {
    if (!quiet) message("no suitable block arrangement was found")
    return(invisible(NULL))
  }
  if (all) {
    if (is.null(estimable)) 
      return(list(X_matrices=Xlist, clearlist=clearlist, profiles=tablist))
    else
      return(list(X_matrices=Xlist, clearlist=clearlist, profiles=tablist, map=map))
  } ## else
  
  lens <- lengths(clearlist)
  tablist <- tablist[lens==max(lens)]
  Xlist <- Xlist[lens==max(lens)]
  clearlist <- clearlist[lens==max(lens)]
  diffs <- sapply(tablist, function(obj) diff(range(obj)))
  pos <- which.min(diffs)
  if (is.null(estimable))
    return(list(X=Xlist[[pos]], clear2fis=clearlist[[pos]]))
  else
    return(list(X=Xlist[[pos]], clear2fis=clearlist[[pos]], map=map))
}

