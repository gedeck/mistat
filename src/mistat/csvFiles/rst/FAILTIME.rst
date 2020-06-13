======== ===============
FAILTIME R Documentation
======== ===============

Failure Times
-------------

Description
~~~~~~~~~~~

Failure times of 20 electric generators (in *hr*).

Usage
~~~~~

::

   data(FAILTIME)

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(FAILTIME)

   library(survival)

   SuRe <- survreg(
     Surv(time=FAILTIME) ~ 1 , 
     dist = "exponential")

   summary(SuRe)
