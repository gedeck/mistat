phimax <- function(n, q, profile=NULL) {
  div <- 2^q-1
  if (is.null(profile)){
    v <- floor(n/div)
    w <- n - v*div
    return(choose(n,2) - v*w - div*choose(v, 2))
  }
  else{
    if (!length(profile)<=div)
      stop("for q = ", q ,", ", "profile must have length <= ", div)
    if (any(profile < 0)) 
      stop("entries of profile must be non-negative")
    if (any(!profile==floor(profile)) ) 
      stop("profile entries must be integers")
    if (!sum(profile)==n) 
      stop("profile entries must sum to ", n)
    return((sum(outer(profile,profile))-sum(profile^2))/2)
  }
}

Xcalc <- function(XI, gen){
  ## function to calculate Godolphin X matrix
  ## from a k-column XI matrix
  ## and generators for p additional factors
  ## generators can be 
  ##      a catalogue (e.g. catlg["7-2.1"] or 
  ##         catlg[nruns(catlg)==32 & nfac(catlg)==7])
  ##      a vector of Yates column numbers (e.g. c(7, 27))
  ##      a vector of defining contrasts (e.g. c("ABC","ABDE"))
  ##      a list of vectors of base column numbers
  ##               e.g. list(1:3, c(1,2,4,5))
  ## k is determined from the number of columns in XI,
  ## p from gen; the X matrix is augmented by 
  ##             p additional columns
  if (!is.matrix(XI)) stop("XI must be a binary matrix")
  if (!is.numeric(XI)) stop("XI must be a binary matrix")
  if (any(!XI %in% c(0,1))) stop("XI must be a binary matrix")
  k <- ncol(XI)
  loop <- FALSE
  if ("catlg" %in% class(gen)){
    if (length(gen) > 1) loop <- TRUE
    nfac <- nfac(gen)
    generator <- lapply(gen, function(obj) obj$gen)
    ps <- lengths(generator)
    if (!all(k + ps==nfac)) stop("input dimensions do not match")
    gen <- generator
    if (!loop) gen <- gen[[1]]
  } 
  else{
    #gen <- gen.check(k, gen)  ## list version
    gen <- gencalc(gen)       ## calculates Yates matrix column numbers
  }
  if (!loop){
    ## return matrix
    Z <- t(sapply(gen, function(obj) rev(digitsBase(obj, 2, k))))
    return(cbind(XI, XI%*%t(Z))%%2)
  }
  else{
    ## return list of matrices
    return(lapply(gen, function(obj){
      Z <- t(sapply(obj, function(obj2) rev(digitsBase(obj2, 2, k))))
      cbind(XI, XI%*%t(Z))%%2
    }))
  }
}


blockgengroup <- function(X, p=0, num=FALSE){
  ### used in blockgencreate
  ### this function returns the base effects that coincide with blocks
  ### in a design with p treatment effect generators
  ### where the q linearly independent rows of the qxn matrix X 
  ###    generate the principal block of the n factor design
  ### The function uses the first k=n-p columns of X only
  ###    it is assumed (but not checked!!) 
  ###    that the last p columns comply with the design structure
  ###    (is guaranteed if X was created with function colpick)
  k <- ncol(X) - p
  ## the potential linear combinations of X columns
  ff <- sfsmisc::digitsBase(1:(2^k-1))[k:1,]
  nam <- Letters[1:k]
  colnames(ff) <- 
    sapply(1:ncol(ff), function(obj) 
      paste0(nam[as.logical(ff[,obj])], collapse=""))
  XIIcalc <- (X[,1:k]%*%ff)%%2
  ## return names of effects whose columns are constant zeroes
  ## (effects confounded with blocks)
  if (!num) return(colnames(XIIcalc)[colSums(XIIcalc)==0])
  else return(which(colSums(XIIcalc)==0))
}

blockgencreate <- function(X, p=0){
  ## X is the matrix that defines the principal block
  ##    with block size 2^(nrow(X))
  ## p is the number of generators for treatment factors 
  ##    in the base design
  ## the last p columns of X must comply with the structure 
  ##    of the design
  
  ## the function does currently not exploit the direct knowledge from 
  ##    matrix X
  if (!is.matrix(X)) stop("XI must be a binary matrix")
  if (!is.numeric(X)) stop("XI must be a binary matrix")
  if (any(!X %in% c(0,1))) stop("XI must be a binary matrix")
  
  k <- ncol(X) - p        ## 2^k is the run size
  q <- nrow(X)
  k.block <- k - q        ## number of block generators needed
  block.gen <- blockgengroup(X, p, num=TRUE)
  ## 2^k block generators as Yates column numbers
#  if (k.block == 1) return(names(block.gen))       ## done
#  picked <- block.gen[1:2]
#  index <- 3
#  already_in <- c(picked, as.intBase(paste(rowSums(cbind(digitsBase(picked[1],2,k), digitsBase(picked[2],2,k)))%%2, collapse="")))
#  while (length(picked) < k.block){
#    cur <- block.gen[index]
#    if (cur %in% already_in) {
#      index <- index + 1
#      next
#    }
#    possibly_in <- sapply(already_in, function(obj) 
#      as.intBase(paste(rowSums(cbind(digitsBase(obj, 2, k), digitsBase(cur, 2, k)))%%2, collapse="")))
#    if (length(intersect(already_in, possibly_in))==0){ 
#      picked <- c(picked, cur)
#      already_in <- c(already_in, cur, possibly_in)
#      index <- index + 1
#    }
#  }
#  names(picked)
  names(block.gen[2^(0:(k.block-1))])
}

lazyExpandGrid <- function(...) {
  ## function for looping through a large grid that is too large to expand
  # from https://stackoverflow.com/questions/36143323/
  # pythons-xrange-alternative-for-r-or-how-to-loop-over-large-dataset-lazilly/36144255#36144255
  # r2evans based on contributions by alexis_laz
  dots <- list(...)
  argnames <- names(dots)
  if (is.null(argnames)) argnames <- paste0('Var', seq_along(dots))
  sizes <- lengths(dots)
  indices <- cumprod(c(1L, sizes))
  maxcount <- indices[ length(indices) ]
  i <- 0
  function(index) {
    i <<- if (missing(index)) (i + 1L) else index
    if (length(i) > 1L) return(do.call(rbind.data.frame, lapply(i, sys.function(0))))
    if (i > maxcount || i < 1L) return(FALSE)
    setNames(Map(`[[`, dots, (i - 1L) %% indices[-1L] %/% indices[-length(indices)] + 1L  ),
             argnames)
  }
}
