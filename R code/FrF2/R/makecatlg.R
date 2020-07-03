makecatlg <- function(k, gen){
    ## May 29 2020: let the WLP start with position 1
    ## May 29 2020: 
    if (!is.numeric(gen)) stop("gen must be a numeric vector of generators")
    if (!all(gen%%1==0)) stop("gen must be integer")
    if (any(gen < 1 | gen >=2^k)) stop("gen must be a positive integer of at most ", 2^k)
    if (any(gen %in% 2^(0:(k-1)))) stop("gen must not refer to any base columns")
    p <- length(gen)
    allwords <- words.all(k, gen, max.length=4)$words.up.to.length.4
    clear2fis <- DoE.base:::nchoosek(k+p, 2)  ## initialize to all clear
    ## extract the words
    if (length(allwords[[1]])==0)  WLP <- c(0,0,0,0,NA) else{
      ## error for resolution 3 (could also allow this for other purposes)
      if (any(lengths(allwords)<=3)) stop("design has resolution less than IV")
      WLP <- c(0, 0, 0, length(allwords), NA)
      ## remove non-clear words of length 2
      notclear <- sapply(1:ncol(clear2fis),
        function(obj) any(sapply(allwords, function(obj2) all(clear2fis[,obj] %in% obj2))))
#        function(obj) any(sapply(allwords[[1]], function(obj2) all(obj %in% obj2))))
      clear2fis <- clear2fis[,!notclear]
    }
    nclear2fis <- ncol(clear2fis)
    aus <- list(list(nruns=2^k, nfac=k+length(gen), gen=gen, res=ifelse(length(allwords[[1]])>0, 4, 5),
           WLP=WLP,
           clear.2fis=clear2fis,
           nclear.2fis=nclear2fis))
           ## more is not needed, resolution is set to 5 (might in fact be larger)
    names(aus) <- paste0(k+p, "-", p, ".custom")
    class(aus) <- c("catlg","list")
    aus
}