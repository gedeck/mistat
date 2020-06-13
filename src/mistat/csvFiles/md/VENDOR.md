  -------- -----------------
  VENDOR   R Documentation
  -------- -----------------

Number of cycles required until latch failure
=============================================

Description
-----------

Number of cycles reqiored until latch failure in 30 floppy disk drives
from three different disk vendors.

Usage
-----

    data(VENDOR)

Format
------

A data frame with 10 observations on the following 3 variables.

`vendor1`

:   number of cycles required until latch failure for vendor *A\_1*, a
    numeric vector

`vendor2`

:   number of cycles required until latch failure for vendor *A\_2*, a
    numeric vector

`vendor3`

:   number of cycles required until latch failure for vendor *A\_3*, a
    numeric vector

Details
-------

Three different vendors are considered for supplying cases for floppy
disk drives. The question is whether the latch mechanism that opens and
closes the disk loading slot is sufficiently reliable. In order to test
the reliability of this latch, three independent samples of cases, each
of size *n = 10*, were randomly selected from the production lots of
these vendors. The testing was performed on a special apparatus that
opens and closes a latch, until it breaks. The number of cycles required
until latch failure was recorded. In order to avoid uncontrollable
environmental factors to bias the results, the order of testing of cases
of different vendors was completely randomized. In data VENDOR there are
the results of this experiment, arranged in 3 columns. Column 1
represents the sample from vendor *A\_1*; column 2 that of vendor *A\_2*
and column 3 of vendor *A\_3*.

Source
------

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
--------

    data(VENDOR)

    VENDOR <- stack(VENDOR)               

    VENDOR$ind <- as.factor(VENDOR$ind)   

    VENDOR$values <- sqrt(VENDOR$values)  

    confint(lm(values ~ -1 + ind,         
               data=VENDOR))
