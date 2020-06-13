  ------- -----------------
  PLACE   R Documentation
  ------- -----------------

Displacements of Electronic Components on Printed Circuit Boards
================================================================

Description
-----------

The observations are the displacements (position errors) of electronic
components on printed circuit boards. There are 26 boards. 16 components
are placed on each board. Each component has to be placed at a specific
location (*x,y*) on a board and with correct orientation *θ*.

Usage
-----

    data(PLACE)

Format
------

A data frame with 416 observations on the following 4 variables.

`crcBrd`

:   Circuit board number, a numeric vector

`xDev`

:   Error in placement along the *x*-axis, a numeric vector

`yDev`

:   Error in placement along the *y*-axis, a numeric vector

`tDev`

:   Error in orientation *θ*, a numeric vector

Source
------

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
--------

    data(PLACE)

    plot(PLACE[,-1])

    boxplot(xDev ~ crcBrd, data=PLACE, 
            ylab="xDev", xlab="crcBrd")

    PLACE$code <- factor(c(rep("lDev", 9*16),
                         rep("mDev", 3*16),
                         rep("hDev", 14*16)))

    plot(PLACE[,"xDev"], PLACE[,"yDev"],
         pch=as.integer(PLACE[,"code"]),
         main="", xlab="xDev", ylab="yDev")

    grid()
