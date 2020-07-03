colpick <- function(design, q, all=FALSE, 
                    select.catlg=catlg, estimable=NULL,
                    method="VF2", sort="natural", res3=FALSE, all0=FALSE, 
                    quiet=FALSE, firsthit=is.numeric(design)){
  ## design is a character string that identifies a catalogued design
  ##    or a length 1 catlg object
  ##    of the number of factors for a full factorial
  ## q is log2 of the block size
  ## all = TRUE requests a list of results
  ## select.catlg is a design catalogue of class catlg
  ## estimable is a character vector of estimable 2fis in letter notation, 
  ##    or a two row numeric matrix with factor numbers (each column indicates a clear 2fi)
  ## all0 = TRUE also outputs X matrices with zero columns
  ## for all=FALSE, the function returns a list with an X matrix 
  ## the clear2fis, 
  ## and possibly a mapping (if estimable is specified)
  ## for all=TRUE, the function returns a list of three or four lists (X matrices, estimable 2fis, profiles)
  ## if estimable is specified, the fourth list indicates a re-mapping with which the requirement can be accommodated
  catlg <- select.catlg
  if (!("catlg" %in% class(design) || is.character(design) || is.numeric(design)))
    stop("design must be the number of factors of a full factorial", 
         " or a character string that refers to an element of select.catlg", 
         " or of class catlg")
  if (is.numeric(design)){
    element <- list(list(nfac  = design,
                         nruns = 2^design,
                         res = Inf,
                         nclear.2fis = choose(design, 2),
                         clear.2fis = combn(design, 2),
                         gen = numeric(0), 
                         WLP = rep(0, 4)))
    class(element) <- c("catlg", "list")
  }
  if (is.character(design)){
    element <- catlg[design]    ## class catlg
  }
  if ("catlg" %in% class(design)) element <- design[1]       ## more than one element is ignored without warning
  N <- element[[1]]$nruns
  n <- element[[1]]$nfac
  gen <- element[[1]]$gen         ## Yates column numbers
  p <- length(gen)
  k <- n - p
  
  ## clear before blocking
  clear2fis <- clear.2fis(element)
  nclear2fis <- nclear.2fis(element)
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
  
  if (!is.null(estimable)){
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
    #graph_requirement <- graph.empty(n = n, directed = FALSE)
    #graph_requirement <- add.edges(graph_requirement, estimable)
  } 
  Z <- t(sapply(gen, function(obj) rev(digitsBase(obj, 2, k))))
  div <- 2^q-1
  divbase <- 2^(0:(q-1))
  
  ## list of possible X column vectors
  Xcands <- lapply(1:div, function(obj) digitsBase(obj, 2, ndigits=q))
    
  success <- FALSE
  Xlist <- vector(mode="list")
  tablist <- vector(mode="list")
  clearlist <- vector(mode="list")
  if (!is.null(estimable)) maplist <- vector(mode="list")
  ## each row of picks provides a possible XI matrix
  poscands <- lapply(1:k, function(obj) 
    if (obj <= div) 
      1:obj
    else 1:div
  )
  nxt <- do.call(lazyExpandGrid, poscands)
  #picks <- as.matrix(expand.grid(poscands))
  #for storage reasons, avoid expand.grid
  nr <- prod(lengths(poscands))
  if (!quiet) message("checking up to ", nr, " matrices")
  
  ## initialize to a heavily balanced first matrix
  ## not yet using nxt()
  ## this makes full factorials without estimability requirements immediate
  ##     and may also be beneficial for fractions with easy structure
  ## nxt() is used at the end of the loop
  jetzt <- rep(1:div, (k%/%div+1))[1:k]
  i <- 0
  while (i <= nr){
    XI <- do.call(cbind, Xcands[jetzt])
    if (length(Z)>0){ 
      XII <- (XI%*%t(Z))%%2
      X <- cbind(XI, XII)
    }
    else X <- XI   ## full factorial
    ## rank check added May 29 2020
    rankdefect <- "try-error" %in% class(try(solve(tcrossprod(X)), silent=TRUE))
    if ((all(colSums(X) > 0) || all0) && !rankdefect){ 
      ## remove direct aliases from blocking
      if (length(clear2fis) > 0){
        ingroup <- character(0)
        for (i in 1:(n-1))
          for (j in (i+1):n)
            if (all(X[,i]==X[,j])) 
              ingroup <- c(ingroup,
                           ifelse(n<=50,
                                  paste0(Letters[i],Letters[j]),
                                  paste0("F",i,":F",j)))
            clearcur <- setdiff(clear2fis, ingroup)
      }
      else clearcur <- clear2fis
      if (is.null(estimable)){
        ### added April 4th 2020, return 
        ### blocking for full factorial as early as possible
        if (length(Z)==0 && !all)         
            return(list(X=X, clear2fis=clearcur))
        success <- TRUE 
        }
      else{
        map <- mapcalc.block(estimable, n, 
                             sapply(clearcur,
                                    function(obj) which(Letters %in% 
                                                          unlist(strsplit(obj, "", 
                                                        fixed=TRUE)))),
                             method=method, sort=sort)[[1]]
        if (!is.null(map)) {
          success <- TRUE
          if (success && !all && firsthit) 
              return(list(X=X, clear2fis=clearcur, map=map))
        }
        else{
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
      jetzt <- unlist(nxt())
      i <- i+1
      if (is.logical(jetzt)){
        if (!jetzt) break
      }
      next
      }## 
    tab <- sort(table(apply(X, 2, paste0, collapse="")))
    tab <- unname(tab)
    ## optimal in terms of maximum number
    if (length(clearcur)== min(phimax(n,q), nclear2fis) && !all){
      if (is.null(estimable)) 
        return(list(X=X, clear2fis=clearcur))
      else  {## if firsthit=FALSE
        return(list(X=X, clear2fis=clearcur, map=map))
      }
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
          maplist <- c(maplist, list(map))
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
    return(NULL)
  }
  if (all) {
    if (is.null(estimable)) 
      return(list(X_matrices=Xlist, clearlist=clearlist, profiles=tablist))
    else   ### firstcalc=FALSE, otherwise was already returned
      return(list(X_matrices=Xlist, clearlist=clearlist, profiles=tablist, maplist=maplist))
  } ## else
  
  lens <- lengths(clearlist)
  tablist <- tablist[lens==max(lens)]
  Xlist <- Xlist[lens==max(lens)]
  clearlist <- clearlist[lens==max(lens)]
  diffs <- sapply(tablist, function(obj) diff(range(obj)))
  pos <- which.min(diffs)
  if (!is.null(estimable))
    return(list(X=Xlist[[pos]], clear2fis=clearlist[[pos]], map=maplist[[pos]]))
  list(X=Xlist[[pos]], clear2fis=clearlist[[pos]])
}
