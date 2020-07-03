mapcalc.block <- function (estimable, nfac, 
                           clearcur, method="VF2", sort = "natural") 
{
  ## used in colpickV
  ## clearcur is the set of clear 2fis after removing
  ## aliases with the block factor
  go2 <- graph.empty(n = nfac, directed = FALSE)
  go2 <- add.edges(go2, estimable)
  deg2 <- degree(go2)
  if (sort %in% c("high", "low")) {
    if (sort == "low") 
      ord2 <- order(deg2)
    else ord2 <- order(deg2, decreasing = TRUE)
    go2 <- permute.vertices(go2, invperm(ord2))
  }
  degree2 <- rev(cumsum(rev(table(deg2))))   ## make it faster to reject non-isomorphic cases
  degs2 <- as.numeric(names(degree2))        ## required minimum degrees
  indep2 <- independence.number(go2)         ## required maximum independence number
  clique2 <- clique.number(go2)              ## required minimum clique size
  map <- NULL
  go1 <- graph.empty(n = nfac, directed = FALSE)
  go1 <- add.edges(go1, clearcur)
  ## optionally sort vertices by degree, 20 Jul 2012
  deg1 <- degree(go1)
  if (sort %in% c("high", "low")) {
    if (sort == "low") 
      ord1 <- order(deg1)
    else ord1 <- order(deg1, decreasing = TRUE)
    go1 <- permute.vertices(go1, invperm(ord1))
  }
  degree1 <- rev(cumsum(rev(table(deg1))))
  degs1 <- as.numeric(names(degree1))
  if (max(degs2) <= max(degs1)) {
    ## if max(degs2)>max(degs1), subgraph isomorphism is impossible
    comp <- sapply(degs2, function(obj) degree1[min(which(degs1 >= 
                                                            obj))])
    comp[is.na(comp)] <- 0
    if (any(comp < degree2)) return(NULL)
    ## added further pre-filtering criteria 9 July 2012
    if (independence.number(go1) > indep2) return(NULL)
    if (clique.number(go1) < clique2) return(NULL)
    if (method=="LAD") 
      erg <- graph.subisomorphic.lad(go2, go1)
    else erg <- graph.subisomorphic.vf2(go1, go2)
    if (erg$iso) {
      if (method=="LAD") map <- list(erg$map)
      else map <- list(erg$map21)
      if (sort %in% c("high", "low")) 
        map <- list(ord1[map[[1]]][invperm(ord2)])
      return(map)
    }
  }
  return(NULL)
}
