  -------- -----------------
  SOCELL   R Documentation
  -------- -----------------

Short Circuit Current of Solar Cells
====================================

Description
-----------

Short circuit current (ISC) of 16 solar cells measured at three time
epochs, one month apart.

Usage
-----

    data(SOCELL)

Format
------

A data frame with 16 observations on the following 3 variables.

`t1`

:   ISC at time epoch 1, a numeric vector

`t2`

:   ISC at time epoch 2, a numeric vector

`t3`

:   ISC at time epoch 3, a numeric vector

Details
-------

Telecommunication sattelites are powered while in orbit by solar cells.
Tadicell, a solar cells producer that supplies several satellite
manufacturers, was requested to provide data on the degradation of its
solar cells over time. Tadicell engineers performed a simulated
experiment in which solar cells were subjected to temperature and
illumination changes similar to those in orbit and measured the short
circuit current ISC (ampers), of solar cells at three different time
periods, in order to determine their rate of degradation.

Source
------

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
--------

    data(SOCELL)

    LmISC <- lm(t2 ~ 1 + t1, 
                data=SOCELL)

    summary(LmISC)
