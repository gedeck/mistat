=== ===============
CAR R Documentation
=== ===============

Car
---

Description
~~~~~~~~~~~

Records on 109 different car models, including number of cylinders,
origin, turn diamater, horsepower, and number of miles per gallon in
city driving.

Usage
~~~~~

::

   data(CAR)

Format
~~~~~~

A data frame with 109 observations on the following 5 variables.

``cyl``
   Number of cylinders, an integer vector

``origin``
   Car origin, 1 = US; 2 = Europe; 3 = Asia, an integer vector

``turn``
   Turn diamater, a numeric vector

``hp``
   Horsepower, a numeric vector

``mpg``
   Miles per gallon in city driving, a numeric vector

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(CAR)

   with(data=CAR, expr=table(cyl, origin))
