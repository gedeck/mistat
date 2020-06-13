  -------- -----------------
  HADPAS   R Documentation
  -------- -----------------

Resistance Values of Hybrids
============================

Description
-----------

Several resistance measurements (*Ω*) of five types of resistances (Res
3, Res 18, Res 14, Res 7 and Res 20), which are located in six hybrid
micro circuits simultaneously manufactured on ceramic substrates. There
are altogether 192 records for 32 ceramic plates.

Usage
-----

    data(HADPAS)

Format
------

A data frame with 192 observations on the following 7 variables.

`diska`

:   ceramic plate, a numeric vector

`hyb`

:   hybrid micro circuit, a numeric vector

`res3`

:   a numeric vector

`res18`

:   a numeric vector

`res14`

:   a numeric vector

`res7`

:   a numeric vector

`res20`

:   a numeric vector

Source
------

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
--------

    data(HADPAS)

    boxplot(HADPAS$res3 ~ HADPAS$hyb)
