FF_from_X <- function(X, randomize=TRUE, seed=NULL, alias.info=2){
  ## function to obtain a blocked full fractorial from a hand-crafted X matrix
  ## all information about dimensions is derived from X
  ## the function returns a data frame with first column Block 
  ##    and further columns numeric with -1/+1 notation of factors
  creator=sys.call()
  if (!all(X %in% c(0,1))) stop("all entries of X must be 0 or 1")
  if (!is.logical(randomize)) stop("randomize must be logical")
  n <- ncol(X)
  q <- nrow(X)
  nruns <- 2^n
  fn <- rep(list(c(-1,1)),n)
  names(fn) <- Letters[1:n] 
  desmat <- as.matrix(expand.grid(fn))
  
  Xlogic <- matrix(as.logical(X),q,n)
  allaliasedb <- blockgengroup(X)
  allaliasedb <- allaliasedb[nchar(allaliasedb)<=alias.info]
  block.gen <- strsplit(bg <- blockgencreate(X),"",fixed=TRUE)
  hilf <- 
  cbind(data.frame(Blocks=factor(as.numeric(factor(apply(sapply(block.gen, function(obj) apply(desmat[,obj, drop=FALSE], 1, prod)), 1, 
        function(obj) paste(obj, collapse=""))))), stringsAsFactors=TRUE), desmat, stringsAsFactors=TRUE)
  hilf <- hilf[ord(hilf),]
  run.no.in.std.order <- rownames(hilf)
  rownames(hilf) <- 1:nruns
  aliased <- list(legend=paste(Letters[1:n],Letters[1:n],sep="="),
                 main=character(0),
                 fi2=character(0))
  if (alias.info>2)
    aliased <- c(aliased, list(fi3=character(0)))
  di <- list(type="FrF2.blocked",
             block.name="Blocks",
             nruns=nruns, nfactors=n, 
             factor.names=fn, 
             nblocks = 2^(n-q),
             block.gen=bg,
             blocksize=2^q,
             ntreat=n,
             aliased.with.blocks=allaliasedb,
             aliased = aliased,
             bbreps=1,
             wbreps=1,
             FrF2.version = sessionInfo(package="FrF2")$otherPkgs$FrF2$Version,
             base.design=paste("generator columns: ", numeric(0)),
             replications=1,
             repeat.only=FALSE,
             randomize=randomize,
             seed=seed,
             creator=creator
             )
  ro <- data.frame(run.no.in.std.order=paste(run.no.in.std.order, 
                                        rep(1:di$nblocks, each=di$blocksize), 
                                        rep(1:di$blocksize, di$nblocks), sep="."),
              run.no= 1:nruns, 
              run.no.std.rp=paste(run.no.in.std.order, 
                                  rep(1:di$nblocks, each=di$blocksize), 
                                  rep(1:di$blocksize, di$nblocks), sep="."), 
                                  stringsAsFactors = TRUE)
  desnum <- model.matrix(~., hilf)
  class(hilf) <- c("design", "data.frame")
  design.info(hilf) <- di
  run.order(hilf) <- ro
  desnum(hilf) <- desnum
  ## randomization automatically uses the correct block factor
  if (randomize) hilf <- rerandomize.design(hilf, seed=seed)
  hilf
  }

X_from_profile <- function(n, q, profile=NULL){
  if (!length(n)==1) stop("n must be a single number")
  if (!length(q)==1) stop("q must be a single number")
  if (!is.numeric(n)) stop("n must be a number")
  if (!is.numeric(q)) stop("q must be a number")
  if (!floor(n)==n) stop("n must be integer")
  if (!floor(q)==q) stop("q must be integer")
  if (!is.numeric(profile)) stop("profile must be numeric")
  if (!all(floor(profile)==profile)) stop("profile must be integer")
  if (!(q<n && n>0 && q>0)) stop("unreasonable request")
  if (!sum(profile)==n) stop("n and profile do not match")
  div <- 2^q-1
  if (!length(profile)<=div) stop("q and profile do not match")
  Xcands <- lapply(1:div, function(obj) digitsBase(obj, 2, ndigits=q))
  profile <- sort(profile, decreasing = TRUE)
  lp <- length(profile)
  do.call(cbind, rep(Xcands[1:lp], times=profile))
}

X_from_parts <- function(n, q, parts){
  if (!length(n)==1) stop("n must be a single number")
  if (!length(q)==1) stop("q must be a single number")
  if (!is.numeric(n)) stop("n must be a number")
  if (!is.numeric(q)) stop("q must be a number")
  if (!floor(n)==n) stop("n must be integer")
  if (!floor(q)==q) stop("q must be integer")
  if (!(q<n && n>0 && q>0)) stop("unreasonable request")
  if (!is.list(parts)) stop("parts must be a list")
  elmts <- sort(unlist(parts))
  if (!length(elmts)==n) stop("n and parts do not match")
  if (!(all(elmts == 1:n) || all(elmts==Letters[1:n]))) 
    stop("parts has unsuitable elements")
  if (is.character(elmts))
    parts <- lapply(parts, function (obj) which(Letters %in% obj))
  div <- 2^q-1
  if (!length(parts)<=div) stop("q and parts do not match")
  profile <- lengths(parts)
  Xcands <- lapply(1:div, function(obj) digitsBase(obj, 2, ndigits=q))
  X <- matrix(NA, q, n)
  for (i in 1:length(parts))
    X[,parts[[i]]] <- Xcands[[i]]
  X
}

clear2fis_from_profile <- function(n, q, profile=NULL){
  if (!is.numeric(n) && is.numeric(q)) stop("n and q must be integer numbers")
  if (is.null(profile)) {
      ### default: most balanced
      profile <- rep(n%/%(2^q-1), 2^q-1)
      hilf <- n%%(2^q-1)
      if (hilf > 0) for (a in 1:hilf) profile[a] <- profile[a]+1
  }
  if (!is.numeric(profile)) stop("if given, profile must be a numeric vector")
  if (!sum(profile)==n) stop("entries of profile must sum to n")
  #  if (length(profile < 2^q-1) profile <- c(profile, rep(0, 2^q-1 - length(profile)))
  if (length(profile) > 2^q-1) stop("profile can have at most 2^q-1 entries")
  profile <- sort(profile, decreasing=TRUE)
  profile <- profile[profile>0]
  lims <- cumsum(profile)
  parts <- mapply(":", c(1,lims[-length(lims)]+1),lims, SIMPLIFY=FALSE)
  clear2fis <- matrix(NA,2,0)
  paare <- DoE.base:::nchoosek(length(parts),2)
  for (i in 1:ncol(paare)){
      clear2fis <- cbind(clear2fis, t(as.matrix(expand.grid(parts[[paare[1,i]]], parts[[paare[2,i]]]))))
  }
  clear2fis
}