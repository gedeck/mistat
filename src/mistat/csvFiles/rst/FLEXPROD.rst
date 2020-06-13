======== ===============
FLEXPROD R Documentation
======== ===============

The Quinlan Experiment at Flex Products
---------------------------------------

Description
~~~~~~~~~~~

Flex Products is a subcontractor of General Motors, manufacturing
mechanical speedometer cables. The basic cable design has not changed
for fifteen years and General Motors had experienced many disappointing
attempts at reducing the speedometer noise level.

Usage
~~~~~

::

   data(FLEXPROD)

Format
~~~~~~

A data frame with 16 observations on the following 16 variables.

``A``
   Liner O.D., a factor with levels ``1`` ``2``

``B``
   Liner Die, a factor with levels ``1`` ``2``

``C``
   Liner Material, a factor with levels ``1`` ``2``

``D``
   Liner Line Speed, a factor with levels ``1`` ``2``

``E``
   Wire Braid Type, a factor with levels ``1`` ``2``

``F``
   Braiding Tension, a factor with levels ``1`` ``2``

``G``
   Wire Diameter, a factor with levels ``1`` ``2``

``H``
   Liner Tension, a factor with levels ``1`` ``2``

``I``
   Liner Temperature, a factor with levels ``1`` ``2``

``J``
   Coating Material, a factor with levels ``1`` ``2``

``K``
   Coating Dye Type, a factor with levels ``1`` ``2``

``L``
   Melt Temperature, a factor with levels ``1`` ``2``

``M``
   Screen Pack, a factor with levels ``1`` ``2``

``N``
   Cooling Method, a factor with levels ``1`` ``2``

``O``
   Line Speed, a factor with levels ``1`` ``2``

``SN``
   Signal to noise ratio, a numeric vector

Details
~~~~~~~

*Problem Definition:* the product under investigation is an extruded
thermoplastic speedometer casing used to cover the mechanical
speedometer cable on automobiles. Excessive shrinkage of the casing is
causing noise in the mechanical speedometer cable assembly.

*Response variable:* the performance characteristic in this problem is
the post extrusion shrinkage of the casing. The percent shrinkage is
obtained by measuring approximately 600mm of casing that has been
properly conditioned *(A)*, placing that casing in a two hour heat soak
in an air circulating oven, reconditioning the sample and measuring the
length *(B)*. Shrinkage is computed as: *Shrinkage = 100 \* (A-B)/A*.

*Factor Levels:* Existing (1) - Changed (2)

*Number of Replications:* four random samples of 600mm from the 3000
feet manufactured at each experimental run.

*Data Analysis:* signal to noise ratios *(SN)* are computed for each
experimental run and analyzed using main effect plots and an ANOVA.
Savings are derived from Loss function computations.

The signal to noise formula used by Quinlan is:

*η = -10 log_10 (1/n ∑ y^2)*

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(FLEXPROD)

   aov(SN ~ . , data=FLEXPROD)
