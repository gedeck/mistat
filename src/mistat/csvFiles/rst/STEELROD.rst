======== ===============
STEELROD R Documentation
======== ===============

50 Measurements of the Length of Steel Rods in *cm*
---------------------------------------------------

Description
~~~~~~~~~~~

Steel rods are used in the car and truck industry to strengthen vehicle
structures. Steel rods supplied by Urdon Industries are produced by a
process adjusted to obtain rods of length 20 cm. However, due to natural
fluctuations in the production process, the actual length of the rods
varies around the nominal value of 20 cm.

Usage
~~~~~

::

   data(STEELROD)

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(STEELROD)

   plot(STEELROD,       
        ylab = "Steel rod Length", 
        xlab = "Index") 
