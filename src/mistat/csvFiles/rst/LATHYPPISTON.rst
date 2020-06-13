============ ===============
LATHYPPISTON R Documentation
============ ===============

Latin Hypercube Design for the Piston Simulator
-----------------------------------------------

Description
~~~~~~~~~~~

A Latin Hypercube Design for the 7 ``pistonSimulation`` arguments and
Its response in seconds.

Usage
~~~~~

::

   data(LATHYPPISTON)

Format
~~~~~~

A data frame with 14 observations on the following 8 variables.

``m``
   a numeric vector

``s``
   a numeric vector

``v0``
   a numeric vector

``k``
   a numeric vector

``p0``
   a numeric vector

``t``
   a numeric vector

``t0``
   a numeric vector

``seconds``
   a numeric vector

Source
~~~~~~

Kenett, R., Zacks, S. with contributions by Amberti, D. *Modern
Industrial Statistics: with applications in R, MINITAB and JMP*. Wiley.

See Also
~~~~~~~~

``pistonSimulation``

Examples
~~~~~~~~

::

   data(LATHYPPISTON)

   library(DiceEval)

   Dice <- km(design=LATHYPPISTON[, !names(LATHYPPISTON) %in% "seconds"], 
               response=LATHYPPISTON[,"seconds"])

   #library(DiceView)

   #sectionview(Dice, 
   #            center=colMeans(LATHYPPISTON[, !names(LATHYPPISTON) %in% "seconds"]), 
   #            conf_lev=c(0.5, 0.9, 0.95), 
   #            title="", col_sur="darkgrey", lwd=2,
   #            Xname=colnames(LATHYPPISTON[, !names(LATHYPPISTON) %in% "seconds"]))


   layout(1)
