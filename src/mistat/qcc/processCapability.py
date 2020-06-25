'''
Created on Jun 20, 2020

@author: petergedeck
'''
from scipy import stats

from mistat.qcc.qualityControlChart import QualityControlChart
import numpy as np
import pandas as pd


class ProcessCapability:
    """ Computes process capability indices for a qcc object of type 'xbar' """

    def __init__(self, qcc, spec_limits, std_dev=None, target=None, nsigmas=None,
                 confidence_level=0.95):
        if not isinstance(qcc, QualityControlChart):
            raise ValueError('Argument qcc must be a QualityControlChart object')
        if qcc.qcc_type not in ('xbar', 'xbar.one'):
            raise ValueError('Process Capability Analysis only available for charts type "xbar" and "xbar.one" charts')

        self.qcc = qcc
        data = self.qcc.data
        self.nobs = np.count_nonzero(~np.isnan(data))
        self.center = qcc.center
        self.std_dev = std_dev or qcc.std_dev

        lsl = spec_limits[0]
        usl = spec_limits[1]
        self.spec_limits = pd.DataFrame({'LSL': [lsl], 'USL': [usl]})

        has_target = target is not None
        self.target = target or np.nanmean(self.spec_limits)
        if target is None:
            self.target = np.nanmean(self.spec_limits)
            has_target = True

        # validation:
        # - only one of lcl or ucl can be NaN
        # - target must be between self.spec_limits

        self.nsigmas = nsigmas or self.qcc.nsigmas
        if not self.nsigmas:
            raise ValueError('nsigmas not available from qcc object. Provide nsigmas as argument.')

        self.confidence_level = confidence_level
        self.calcPCIndices()

        self.exp_LSL = np.NaN
        if not np.isnan(lsl):
            self.exp_LSL = stats.norm.cdf((lsl - self.center) / self.std_dev) * 100
        self.exp_USL = np.NaN
        if not np.isnan(usl):
            self.exp_USL = (1 - stats.norm.cdf((usl - self.center) / self.std_dev)) * 100
        self.obs_LSL = np.nanmean(data < lsl) * 100
        self.obs_USL = np.nanmean(data > usl) * 100

    def calcPCIndices(self):
        usl = self.spec_limits.values[0, 1]
        lsl = self.spec_limits.values[0, 0]
        nsigmas = self.nsigmas
        std_dev = self.std_dev
        center = self.center
        target = self.target

        self.Cp = (usl - lsl) / (2 * nsigmas * std_dev)
        self.Cp_u = (usl - self.center) / (nsigmas * std_dev)
        self.Cp_l = (self.center - lsl) / (nsigmas * std_dev)
        self.Cp_k = min(self.Cp_u, self.Cp_l)
        self.Cpm = self.Cp / np.sqrt(1 + ((center - target) / std_dev) ** 2)

        alpha = 1 - self.confidence_level
        alphas = [alpha / 2, 1 - alpha / 2]
        n = self.nobs
        self.Cp_limits = [self.Cp * np.sqrt(stats.chi2(n - 1).ppf(a) / (n - 1)) for a in alphas]
        self.Cp_l_limits = [self.Cp_l * (1 + f * stats.norm.ppf(self.confidence_level) *
                                         np.sqrt(1 / (9 * n * self.Cp_l**2) + 1 / (2 * (n - 1))))
                            for f in (-1, 1)]
        self.Cp_u_limits = [self.Cp_u * (1 + f * stats.norm.ppf(self.confidence_level) *
                                         np.sqrt(1 / (9 * n * self.Cp_u**2) + 1 / (2 * (n - 1))))
                            for f in (-1, 1)]
        self.Cp_k_limits = [self.Cp_k * (1 + f * stats.norm.ppf(1 - alpha / 2) *
                                         np.sqrt(1 / (9 * n * self.Cp_k**2) + 1 / (2 * (n - 1))))
                            for f in (-1, 1)]

        ratio = (center - target) / std_dev
        df = n * (1 + ratio**2) / (1 + 2 * ratio**2)
        self.Cpm_limits = [self.Cpm * np.sqrt(stats.chi2(df).ppf(a) / df) for a in alphas]

#   invisible(list(
#                  exp = { exp <- c(exp.LSL, exp.USL)/100
#                          names(exp) <- c("Exp < LSL", "Exp > USL")
#                          exp },
#                  obs = { obs <- c(obs.LSL, obs.USL)/100
#                          names(obs) <- c("Obs < LSL", "Obs > USL")
#                          obs }
#                  ))

#
#
# process.capability <- function(object, spec.limits, target, std.dev, nsigmas, confidence.level = 0.95, breaks="scott", add.stats=TRUE, print=TRUE, digits = getOption("digits"), restore.par=TRUE)
# {
# # Computes process capability indices for a qcc object of type "xbar"
# # and plot the histogram

#   title <- paste("Process Capability Analysis\nfor", object$data.name)
#
#   xlim <- range(x, USL, LSL, target, na.rm = TRUE)
#   xlim <- xlim+diff(xlim)*c(-0.1,0.1)
#   xx <- seq(min(xlim), max(xlim), length=250)
#   dx <- dnorm(xx, center, std.dev)
#   h <- hist(x, breaks = breaks, plot=FALSE) # compute histogram
#   ylim <- range(h$density, dx)
#   ylim <- ylim+diff(ylim)*c(0,0.05)
#
#   tab <- cbind(c(Cp, Cp.l, Cp.u, Cp.k, Cpm),
#                rbind(Cp.limits, Cp.l.limits, Cp.u.limits,
#                      Cp.k.limits, Cpm.limits))
#   rownames(tab) <- c("Cp", "Cp_l", "Cp_u", "Cp_k", "Cpm")
#   colnames(tab) <- c("Value", names(Cp.limits))
#
#   oldpar <- par(no.readonly = TRUE)
#   if(restore.par) on.exit(par(oldpar))
#   mar <- c(4.1,2.1,3.6,2.1)
#   par(bg  = qcc.options("bg.margin"),
#       cex = oldpar$cex * qcc.options("cex"),
#       mar = if(add.stats) pmax(mar, c(8.6+is.null(center)*-1,0,0,0)) else mar)
#
#   plot(0, 0, type="n", xlim = xlim, ylim = ylim,
#        axes = FALSE, ylab="", xlab = "")
#   usr <- par()$usr
#   rect(usr[1], usr[3], usr[2], usr[4], col = qcc.options("bg.figure"))
#   axis(1); box()
#   top.line <- par("mar")[3]-length(capture.output(cat(title))) - 0.5
#   mtext(title, side = 3, line = top.line,
#         font = par("font.main"),
#         cex  = qcc.options("cex"),
#         col  = par("col.main"))
#   # draw histogram
#   plot(h, add = TRUE, freq = FALSE)
#   # add graphical info
#   abline(v=c(LSL,USL), col=2, lty=3, lwd=2)
#   text(LSL, usr[4], "LSL", pos=3, offset=0.2, cex=0.8, xpd = TRUE)
#   text(USL, usr[4], "USL", pos=3, offset=0.2, cex=0.8, xpd = TRUE)
#   if(has.target)
#     { abline(v=target, col=2, lty=2, lwd=2)
#       text(target, usr[4], "Target", pos=3, offset=0.2, cex=0.8, xpd = TRUE) }
#   lines(xx, dx, lty=2)
#
#   if(add.stats)
#     { # computes the x margins of the figure region
#       plt <- par()$plt
#       px <- diff(usr[1:2])/diff(plt[1:2])
#       xfig <- c(usr[1]-px*plt[1], usr[2]+px*(1-plt[2]))
#       at.col <- xfig[1] + diff(xfig[1:2])*c(0.07, 0.35, 0.56, 0.75)
#       top.line <- 3
#       # write info at bottom
#       #--
#       mtext(paste("Number of obs = ", n, sep = ""),
#             side = 1, line = top.line, adj = 0, at = at.col[1],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("Center = ", signif(center, digits), sep = ""),
#             side = 1, line = top.line+1, adj = 0, at = at.col[1],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("StdDev = ", signif(std.dev, digits), sep = ""),
#             side = 1, line = top.line+2, adj = 0, at = at.col[1],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       #--
#       mtext(ifelse(has.target, paste("Target = ", signif(target, digits), sep = ""),
#                                paste("Target = ")),
#             side = 1, line = top.line, adj = 0, at = at.col[2],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("LSL = ", ifelse(is.na(LSL), "", signif(LSL, digits)), sep = ""),
#             side = 1, line = top.line+1, adj = 0, at = at.col[2],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("USL = ", ifelse(is.na(USL), "", signif(USL, digits)), sep = ""),
#             side = 1, line = top.line+2, adj = 0, at = at.col[2],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       #--
#       mtext(paste("Cp     = ", ifelse(is.na(Cp), "", signif(Cp, 3)), sep = ""),
#             side = 1, line = top.line, adj = 0, at = at.col[3],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("Cp_l  = ", ifelse(is.na(Cp.l), "", signif(Cp.l, 3)), sep = ""),
#             side = 1, line = top.line+1, adj = 0, at = at.col[3],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("Cp_u = ", ifelse(is.na(Cp.u), "", signif(Cp.u, 3)), sep = ""),
#             side = 1, line = top.line+2, adj = 0, at = at.col[3],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("Cp_k = ", ifelse(is.na(Cp.k), "", signif(Cp.k, 3)), sep = ""),
#             side = 1, line = top.line+3, adj = 0, at = at.col[3],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("Cpm  = ", ifelse(is.na(Cpm), "", signif(Cpm, 3)), sep = ""),
#             side = 1, line = top.line+4, adj = 0, at = at.col[3],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       #--
#       mtext(paste("Exp<LSL ", ifelse(is.na(exp.LSL), "", paste(signif(exp.LSL, 2), "%", sep="")), sep = ""),
#             side = 1, line = top.line, adj = 0, at = at.col[4],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("Exp>USL ", ifelse(is.na(exp.USL), "", paste(signif(exp.USL, 2), "%", sep="")), sep = ""),
#             side = 1, line = top.line+1, adj = 0, at = at.col[4],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("Obs<LSL ", ifelse(is.na(obs.LSL), "", paste(signif(obs.LSL, 2), "%", sep="")), sep = ""),
#             side = 1, line = top.line+2, adj = 0, at = at.col[4],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#       mtext(paste("Obs>USL ", ifelse(is.na(obs.USL), "", paste(signif(obs.USL, 2), "%", sep="")), sep = ""),
#             side = 1, line = top.line+3, adj = 0, at = at.col[4],
#             font = qcc.options("font.stats"),
#             cex = par("cex")*qcc.options("cex.stats"))
#     }
#
#   if(print)
#     { cat("\nProcess Capability Analysis\n")
#       cat("\nCall:\n", deparse(match.call()), "\n\n", sep = "")
#       cat(paste(formatC("Number of obs = ", width=16),
#                 formatC(n, width=12, flag="-"),
#                 formatC("Target = ", width=10),
#                 ifelse(has.target, formatC(signif(target,digits=digits), flag="-"), ""),
#                 "\n", sep=""))
#       cat(paste(formatC("Center = ", width=16),
#                 formatC(signif(center, digits=digits), width=12, flag="-"),
#                 formatC("LSL = ", width=10),
#                 ifelse(is.na(LSL), "", formatC(signif(LSL, digits=digits), flag="-")),
#                 "\n", sep=""))
#       cat(paste(formatC("StdDev = ", width=16),
#                 formatC(signif(std.dev, digits=digits), width=12, flag="-"),
#                 formatC("USL = ", width=10),
#                 ifelse(is.na(USL), "", formatC(signif(USL, digits=digits), flag="-")),
#                 "\n", sep=""))
#       cat("\nCapability indices:\n\n")
#       print(tab, digits=4, na.print="", print.gap=2)
#       cat("\n")
#       cat(paste("Exp<LSL", ifelse(is.na(exp.LSL), "\t",
#                                    paste(format(exp.LSL, digits=2), "%\t", sep="")),
#                 "Obs<LSL", ifelse(is.na(obs.LSL), "",
#                                    paste(format(obs.LSL, digits=2), "%\n", sep=""))))
#       cat(paste("Exp>USL", ifelse(is.na(exp.USL), "\t",
#                                    paste(format(exp.USL, digits=2), "%\t", sep="")),
#                 "Obs>USL", ifelse(is.na(obs.USL), "",
#                                    paste(format(obs.USL, digits=2), "%\n", sep=""))))
#     }
#
#   invisible(list(nobs = n, center = center, std.dev = std.dev,
#                  target = target,
#                  spec.limits = { sl <- c(LSL, USL)
#                                  names(sl) <- c("LSL", "USL")
#                                  sl },
#                  indices = tab,
#                  exp = { exp <- c(exp.LSL, exp.USL)/100
#                          names(exp) <- c("Exp < LSL", "Exp > USL")
#                          exp },
#                  obs = { obs <- c(obs.LSL, obs.USL)/100
#                          names(obs) <- c("Obs < LSL", "Obs > USL")
#                          obs }
#                  ))
# }
