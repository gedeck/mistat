========= ===============
KEYBOARDS R Documentation
========= ===============

New Designs of Feyboards for Desktop Computers
----------------------------------------------

Description
~~~~~~~~~~~

The design of the keyboard might have effect on the speed of typing or
on the number of typing ``errors``. Noisy factors are ``typist`` or type
of ``job``. Letters A, B, C, D of variable ``keyboard`` denote the
designs.

Usage
~~~~~

::

   data(KEYBOARDS)

Format
~~~~~~

A data frame with 25 observations on the following 4 variables.

``typist``
   The typist, a factor with levels ``1`` ``2`` ``3`` ``4`` ``5``

``job``
   The type of job, a factor with levels ``1`` ``2`` ``3`` ``4`` ``5``

``keyboard``
   Keyboard design, a factor with levels ``A`` ``B`` ``C`` ``D`` ``E``

``errors``
   Number of typing errors, a numeric vector

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(KEYBOARDS)

   boxplot(errors ~ keyboard, data=KEYBOARDS, ylab="Errors")
