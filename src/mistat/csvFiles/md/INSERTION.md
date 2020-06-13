  ----------- -----------------
  INSERTION   R Documentation
  ----------- -----------------

Components Insertions into a Board
==================================

Description
-----------

Data represents a large number of insertions with *k=9* different
components. The result of each trial (insertion) is either Success (no
insertion error) or Failure (insertion error).

Usage
-----

    data(INSERTION)

Format
------

A data frame with 9 (*k*) observations on the following 3 variables.

`comp`

:   Component, a factor with levels `C1` `C2` `C3` `C4` `C5` `C6` `C7`
    `C8` `C9`

`fail`

:   Failure, a numeric vector

`succ`

:   Success, a numeric vector

Details
-------

Components are:

`C1:` Diode

`C2:` 1/2 Watt Canister

`C3:` Jump Wire

`C4:` Small Corning

`C5:` Large Corning

`C6:` Small Bullet

`C7:` 1/8 Watt Dogbone

`C8:` 1/4 Watt Dogbone

`C9:` 1/2 Watt Dogbone

Source
------

See `PLACE`

Examples
--------

    data(INSERTION)

    barplot(INSERTION$fail / 
              (INSERTION$fail + INSERTION$succ) * 
              100, 
            names.arg=INSERTION$comp, 
            ylab= "Percentage")
