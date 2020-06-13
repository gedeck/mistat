====== ===============
OTURB2 R Documentation
====== ===============

Sample Mean and Standard Deviation of Cycle Times of a Piston
-------------------------------------------------------------

Description
~~~~~~~~~~~

In this data frame we have three variables. In the first we have the
sample size. In the second and third we have the sample means and
standard deviation.

Usage
~~~~~

::

   data(OTURB2)

Format
~~~~~~

A data frame with 10 observations on the following 3 variables.

``groupSize``
   a numeric vector

``xbar``
   a numeric vector

``std``
   a numeric vector

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(OTURB2)
   plot(OTURB2$xbar, type="b")
   plot(OTURB2$std, type="b")
