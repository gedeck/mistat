========== ===============
GASTURBINE R Documentation
========== ===============

Gas Turbine Cycle Times
-----------------------

Description
~~~~~~~~~~~

125 gas turbine cycle times divided in 25 samples of 5 observations.

Usage
~~~~~

::

   data(GASTURBINE)

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(GASTURBINE)

   plot(rowMeans(GASTURBINE), type="b")
