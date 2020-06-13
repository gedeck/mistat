  --------- -----------------
  RNORM10   R Documentation
  --------- -----------------

Random Sample from N(10, 1)
===========================

Description
-----------

Random sample of size *n = 28* from the normal distribution *N(10,1)*.

Usage
-----

    data(RNORM10)

Source
------

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
--------

    data(RNORM10)

    plot(RNORM10, type="b")

    abline(h=10, lwd=2, col=2)
