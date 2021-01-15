  -------- -----------------
  ALMPIN   R Documentation
  -------- -----------------

Aluminium Pins (2 dimensions)
=============================

Description
-----------

Records of 2 dimension variables (a subset of `ALMPIN`) measured in *mm*
on 70 alluminium pins used in airplanes, in order of production.

Usage
-----

    data(ALMPIN)

Format
------

A data frame with 70 observations on the following 2 variables.

`capDiam`

:   diameter of the cap on top of the pin, a numeric vector

`lenNocp`

:   length of the pin without the cap, a numeric vector

Details
-------

For details see dataset `ALMPIN`

Source
------

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
--------

    data(ALMPIN)

    cor(ALMPIN)

    plot(ALMPIN)
