======= ===============
OELECT1 R Documentation
======= ===============

Electric Voltage Outputs of Another Rectifying Circuit
------------------------------------------------------

Description
~~~~~~~~~~~

25 electric voltage outputs of a rectifying circuit (*V*).

Usage
~~~~~

::

   data(OELECT1)

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(OELECT)

   data(OELECT1)

   randomizationTest(list(a=OELECT, b=OELECT1), 
                     R=500, calc=mean, 
                     fun=function(x) x[1]-x[2])
