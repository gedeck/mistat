  ----- -----------------
  MPG   R Documentation
  ----- -----------------

Gasoline Consumption of Cars by Origin
======================================

Description
-----------

Gasoline consumption (in miles per gallon in city driving) of cars by
origin. There are 3 variables representing samples of sizes *n1 = 58*,
*n2 = 14* and *n3 = 37*.

Usage
-----

    data(MPG)

Format
------

A data frame with 58 observations on the following 3 variables.

`origin1`

:   Gasoline consumption, a numeric vector

`origin2`

:   Gasoline consumption, a numeric vector

`origin3`

:   Gasoline consumption, a numeric vector

Source
------

See `CAR`

Examples
--------

    data(MPG)

    library(boot)

    set.seed(123)

    B <- apply(MPG, MARGIN=2, 
               FUN=boot, 
               statistic=function(x, i){
                 var(x[i], na.rm = TRUE)
               }, 
               R = 500)

    Bt0 <- sapply(B, 
                  FUN=function(x) x$t0)

    Bt <-  sapply(B, 
                  FUN=function(x) x$t)

    Bf <- max(Bt0)/min(Bt0)

    FBoot <- apply(Bt, MARGIN=1, 
                   FUN=function(x){
                     max(x)/min(x)
                   })

    Bf

    quantile(FBoot, 0.95)

    sum(FBoot >= Bf)/length(FBoot)

    rm(Bt0, Bt, Bf, FBoot)
