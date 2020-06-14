'''
Created on Jun 13, 2020

@author: petergedeck
'''
from dataclasses import dataclass, InitVar
import numpy as np
import pandas as pd


@dataclass
class PistonSimulator:
    m: float = 60
    s: float = 0.02
    v0: float = 0.01
    k: float = 5000
    p0: float = 110000
    t: float = 296
    t0: float = 360

    n_simulation: int = 50  # desired number of simulations
    seed: float = None
    check: bool = True

    errors: InitVar[dict] = {
        m: 0.1,
        s: 0.01,
        v0: 0.00025,
        k: 50,
        p0: 0.01,
        t: 0.13,
        t0: 0.13
    }

    def __post_init__(self):
        if self.seed is not None:
            np.random.seed(seed=self.seed)

        validate_range(self.m, 30, 60, 'Piston weight m is out of range, [30, 60] kg')
        validate_range(self.s, 0.005, 0.02, "Piston surface area s is out of range, [0.005, 0.020] m^2")
        validate_range(self.v0, 0.002, 0.01, "Value of initial gas volume v0 is out of range, [0.002, 0.010] m^3")
        validate_range(self.k, 1000, 5000, "Value of spring coefficient k is out of range, [1000, 5000] N/m")
        validate_range(self.p0, 90000, 110000,
                       "Value of atmospheric pressure p0 is out of range, [90000, 110000] N/m^2")
        validate_range(self.t, 290, 296, "Value of ambient temperature t is out of range, [290, 296] K")
        validate_range(self.t0, 340, 360, "Value of filling gas temperature t0 is out of range, [340, 360] K")

        if self.n_simulation < 1:
            raise ValueError('Number of simulations must be greater 1')

        # Convert to lists
        maxsize = self.n_simulation
        for option in ('m', 's', 'v0', 'k', 'p0', 't', 't0'):
            values = convert_to_list(getattr(self, option))
            maxsize = max(maxsize, len(values))
            setattr(self, option, values)

        # Make sure that the vectors are all the same length
        for option in ('m', 's', 'v0', 'k', 'p0', 't', 't0'):
            values = getattr(self, option)
            if not len(values) % maxsize:
                raise ValueError(f'Inconsistent length of option {option}')
            values = list(repeat_elements(values, maxsize // len(values)))
            setattr(self, option, values)

    def simulate(self):
        pass


def validate_range(value, left, right, message):
    if isinstance(value, list):
        if not all(left <= v <= right for v in value):
            raise ValueError(message)
    else:
        if not left <= value <= right:
            raise ValueError(message)


def convert_to_list(value):
    if isinstance(value, list):
        return value
    return [value]


def repeat_elements(values, nrepeat):
    for value in convert_to_list(values):
        yield from [value] * nrepeat

#   X <- matrix(NA, 14, n)
#   if(!is.na(seed))
#     set.seed(seed)
#   # .runifsum(n, min -3, max = 3, k = 6) * sqrt(2) * Sd[j]
#   # is quite close to rnorm(n, 0, Sd[j])
#   # for(col in 1:n){
#   #   for(row in 1:7){
#   #     X[row, col] <- .runifsum(1, min = -3, max = 3, k = 6) * sqrt(2) * Sd[row]
#   #   }
#   # }
#   for(row in 1:7){
#     X[row, ] <- rnorm(n, mean=0, sd=Sd[row])
#   }
#
#   X[8,] <- m
#   X[9,] <- s
#   X[10,] <- v0
#   X[11,] <- k
#   X[12,] <- p0
#   X[13,] <- t
#   X[14,] <- t0
#
#   res <- as.data.frame(t(apply(X, 2, .tCycle)))
#   class(res) <- c(class(res), "mistatSimulation", "pistonSimulation")
#   return(res)
# }
#
#
# # a random number from uniform sum distribution [0, k]
# .runifs <- function(k){
#   return(sum(runif(k)))
# }
# # n random numbers from uniform sum distribution [min, max], k is parameter n
# .runifsum <- function(n, min = 0, max = 1, k = 6){
#   if(max <= min || n < 1 || k < 1)
#     stop("wrong parameters")
#
#   x <- replicate(n, .runifs(k = k))
#   return(((x/k)*(max-min))+min)
# }
#
# .tCycle <- function(x){
#   Ms <- x[8] + x[1] # a value and its error
#   Ss <- x[9] + x[2]
#   if(Ss < 0)
#     Ss <- 0.00001
#   V0s <- x[10] + x[3]
#   if(V0s < 0)
#     V0s <- 0.001
#   Ks <- x[11] + x[4]
#   P0s <- x[12] + x[5]
#   if(P0s < 0)
#     P0s <- 0.001
#   Tms <- x[13] + x[6]
#   T0s <- x[14] + x[7]
#   Mg <- Ks*0.2 #X0
#   A <- (P0s*Ss) + (2*Mg) - (Ks*V0s/Ss)
#   V <- Ss*(sqrt(((A)^2) + (4*Ks*P0s*V0s*Tms/T0s))-A)/(2*Ks)
#   res <- 2*pi * sqrt(Ms / (Ks + ((Ss ^ 2) * P0s * V0s * Tms) / (T0s * V * V)))
#   res <- c(x[8:14], res)
#   names(res) <- c("m", "s", "v0", "k", "p0", "t", "t0", "seconds")
#   return(res)
# }
