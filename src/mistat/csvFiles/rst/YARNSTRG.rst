======== ===============
YARNSTRG R Documentation
======== ===============

Yarn strength
-------------

Description
~~~~~~~~~~~

Yarn strength is typically analyzed on a logarithmic scale. This
logarithmic transformation produces data that is more symmetrically
distributed. in YARNSTRG data there are *n = 100* values of *Y = ln(X)*
where *X* is the yarn-strength in *lb./22 yarns* of woolen fibers.

Usage
~~~~~

::

   data(YARNSTRG)

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(YARNSTRG)

   hist(YARNSTRG,  
        breaks=6,  
        main="",   
        xlab = "Log yarn strength")
