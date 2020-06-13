  ---------- -----------------
  ELECINDX   R Documentation
  ---------- -----------------

Bernoulli Sample on OELECT Data
===============================

Description
-----------

Bernoulli sample in which, we give a circuit in OELECT the value 1 if
its electric output is in the interval (216, 224) and the value 0
otherwise.

Usage
-----

    data(ELECINDX)

Source
------

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

See Also
--------

`OELECT`

Examples
--------

    data(ELECINDX)

    qbinom(p=0.5, size=100, prob=mean(ELECINDX))
