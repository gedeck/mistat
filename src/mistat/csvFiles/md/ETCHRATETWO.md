  ------------- -----------------
  ETCHRATETWO   R Documentation
  ------------- -----------------

Data on the Rate of Etching (two samples)
=========================================

Description
-----------

Rate of removal of field oxide in two different semiconductor plasma
etching processes, A and B.

Usage
-----

    data(ETCHRATETWO)

Format
------

A data frame with 12 observations on the following 2 variables.

`A`

:   a numeric vector, rate of etching, sample A

`B`

:   a numeric vector, rate of etching, sample B

Source
------

Digital Equipment Corporation (1988).

Examples
--------

    data(ETCHRATETWO)

    boxplot(values ~ ind, data=stack(ETCHRATETWO))
