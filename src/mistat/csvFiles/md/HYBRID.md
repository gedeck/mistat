  -------- -----------------
  HYBRID   R Documentation
  -------- -----------------

Resistance Values of Res 3
==========================

Description
-----------

A subset of data in HADPAS, only variable `res3` is recorded. HYBRID
contains values for hybrids 1 to 3, HYBRID1 contains hybrid 1 data and
HYBRID2 contains values of hybrids 1 and 2.

Usage
-----

    data(HYBRID)

Format
------

A data frame (a vector for HYBRID1) with 32 observations on the
following variables.

`hyb1`

:   resistance measurements (*Ω*) of Res 3, a numeric vector

`hyb2`

:   resistance measurements (*Ω*) of Res 3, a numeric vector

`hyb3`

:   resistance measurements (*Ω*) of Res 3, a numeric vector

Source
------

See `HADPAS`

Examples
--------

    data(HYBRID)

    lapply(HYBRID, var)
