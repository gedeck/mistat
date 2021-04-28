###################################################
### Chap018Start
###################################################
library(mistat)


###################################################
### AcceptanceSampling01
###################################################
library(AcceptanceSampling)

as.data.frame(
  find.plan(PRP=c(0.01, 0.95), 
          CRP=c(0.08, 0.05), 
          type="hypergeom", N=100))


###################################################
### TableAcceptanceSamplingN100AB05 (eval = FALSE)
###################################################
p0 <- rep(c(0.01, 0.03), each=10)
pt <- rep(seq(0.05, to=0.32, by=0.03), 2)

res <-as.data.frame(
  find.plan(PRP=c(p0[1], 0.95),
          CRP=c(pt[1], 0.05),
          type="hypergeom", N=100))
for(i in 2:20){
  res <- rbind(res,
               find.plan(PRP=c(p0[i], 0.95),
                         CRP=c(pt[i], 0.05),
                         type="hypergeom", N=100))
}
res
rm(res)


###################################################
### TableAcceptanceSamplingN100A10B20 
###################################################
p0 <- rep(c(0.01, 0.03), each=10)
pt <- rep(seq(0.05, to=0.32, by=0.03), 2)

res <-as.data.frame(
  find.plan(PRP=c(p0[1], 0.90),
          CRP=c(pt[1], 0.20),
          type="hypergeom", N=100))
for(i in 2:20){
  res <- rbind(res,
               find.plan(PRP=c(p0[i], 0.90),
                         CRP=c(pt[i], 0.20),
                         type="hypergeom", N=100))
}
res
rm(res)


###################################################
### PlotOCpN100n50c1
###################################################
OC <- OC2c(n=50, 
           c=1, 
           type="hypergeom", 
           N=100, 
           pd=seq(0, 0.15, 
                  length.out=100))

plot(OC, type="l")

rm(OC)


###################################################
### TableOCpN100n50c1 
###################################################
OC <- OC2c(n=50,
           c=1,
           type="hypergeom",
           N=100,
           pd=seq(0, 0.15,
                  length.out=100))


data.frame(p=round(OC@pd[seq(1, 100, length.out=20)], 3),
  OCp=round(OC@paccept[seq(1, 100, length.out=20)], 4))

rm(OC)


###################################################
### PlotAOQN1000n250c5AOQ
###################################################
library(Dodge)
invisible(
  SSPlanBinomial(N=1000, 
                 n=250, 
                 Ac=5, 
                 p=seq(0.005, 0.035, 
                       length.out=200), 
                 Plots=TRUE))

layout(1)


###################################################
### PlotAOQN1000n250c5ATI
###################################################
invisible(
  SSPlanBinomial(N=1000, 
                 n=250, 
                 Ac=5, 
                 p=seq(0.005, 0.035, 
                       length.out=200), 
                 Plots=TRUE))

layout(1)


###################################################
### Chap018End
###################################################
detach(package:AcceptanceSampling)
detach(package:Dodge)
detach(package:mistat)


