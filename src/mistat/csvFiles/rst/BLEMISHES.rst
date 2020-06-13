========= ===============
BLEMISHES R Documentation
========= ===============

Number of Blemishes on Ceramic Plates
-------------------------------------

Description
~~~~~~~~~~~

Blemishes found on each of 30 ceramic plates.

Usage
~~~~~

::

   data(BLEMISHES)

Format
~~~~~~

A data frame with 30 observations:

``plateID``
   a factor

``count``
   an integer vector

Details
~~~~~~~

Blemishes will affect the final product's (hybrid micro electronic
components) electrical performance and its overall yield

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(BLEMISHES)
   table(factor(BLEMISHES$count, levels=0:5))
