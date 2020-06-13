  ------- -----------------
  GASOL   R Documentation
  ------- -----------------

Distillation Properties of Crude Oils
=====================================

Description
-----------

32 measurements of distillation properties of crude oils.

Usage
-----

    data(GASOL)

Format
------

A data frame with 32 observations on the following 5 variables.

`x1`

:   crude oil gravity (*API*), a numeric vector

`x2`

:   crude oil vapour pressure (*psi*), a numeric vector

`astm`

:   crude oil ASTM 10% point (*Fahrenheit*), a numeric vector

`endPt`

:   gasoline ASTM endpoint (*Fahrenheit*), a numeric vector

`yield`

:   yield of gasoline (in percentage of crude oil), a numeric vector

Source
------

Daniel and Wood (1971) pp. 165

Examples
--------

    data(GASOL)

    LmYield <- lm(yield ~ 1 + astm + endPt, 
                  data=GASOL)

    summary(LmYield)
