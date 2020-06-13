====== ===============
SOLDEF R Documentation
====== ===============

Solder Defects
--------------

Description
~~~~~~~~~~~

Solder defects on 380 printed circuits boards of varying size.

Usage
~~~~~

::

   data(SOLDEF)

Details
~~~~~~~

In SOLDEF we present results of testing batches of circuit boards for
defects in solder points, after wave solderings. The batches includes
boards of similar design. There were close to 1,000 solder points on
each board. The results Xtare number of defects per *10^6* points
*(PPM)*. The quality standard is *λ_0 = 100 (PPM)*. *λ_t* values below
*λ_0* represent high quality soldering. In this data file there are N =
380 test results. Only 78 batches had an *X_t* value greater than *λ_0 =
100*.

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(SOLDEF)

   hist(SOLDEF)
