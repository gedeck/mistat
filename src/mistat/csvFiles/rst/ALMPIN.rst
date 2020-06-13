====== ===============
ALMPIN R Documentation
====== ===============

Aluminium Pins (6 dimensions)
-----------------------------

Description
~~~~~~~~~~~

Records of 6 dimension variables (a subset of 2 in ``ALMPIN2``) measured
in *mm* on 70 alluminium pins used in airplanes, in order of production.

Usage
~~~~~

::

   data(ALMPIN)

Format
~~~~~~

A data frame with 70 observations on the following 6 variables.

``diam1``
   pin diameter at specified location, a numeric vector

``diam2``
   pin diameter at specified location, a numeric vector

``diam3``
   pin diameter at specified location, a numeric vector

``capDiam``
   diameter of the cap on top of the pin, a numeric vector

``lenNocp``
   length of the pin without the cap, a numeric vector

``lenWcp``
   length of the pin with the cap, a numeric vector

Details
~~~~~~~

The aluminum pins are inserted with air-guns in pre-drilled holes in
order to combine critical airplane parts such as wings, engine supports
and doors.

The measurements were taken in a computerized numerically controlled
(CNC) metal cutting operation. The six variables are Diameter 1,
Diameter 2, Diameter 3, Cap Diameter, Lengthncp and Lengthwcp. All the
measurements are in millimeters. The first three variables give the pin
diameter at three specified locations. Cap Diameter is the diameter of
the cap on top of the pin. The last two variables are the length of the
pin, without and with the cap, respectively.

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(ALMPIN)

   cor(ALMPIN)

   plot(ALMPIN)
