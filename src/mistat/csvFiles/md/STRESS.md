  -------- -----------------
  STRESS   R Documentation
  -------- -----------------

Stress Levels
=============

Description
-----------

Results of a 33 factorial experiment to investigate the effects of three
factors *A, B, C* on the stress levels of a membrane *Y*. The first
three columns of the data provide the levels of the three factors, and
column 4 presents the stress values.

Usage
-----

    data(STRESS)

Format
------

A data frame with 27 observations on the following 4 variables.

`A`

:   levels of factor *A*, a numeric vector

`B`

:   levels of factor *B*, a numeric vector

`C`

:   levels of factor *C*, a numeric vector

`stress`

:   stress levels of a membrane *Y*, a numeric vector

Source
------

Oikawa and Oka (1987)

Examples
--------

    data(STRESS)

    summary(                                       
      aov(stress ~ (A+B+C)^3 +I(A^2)+I(B^2)+I(C^2),
          data=STRESS))
