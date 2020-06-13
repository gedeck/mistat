  -------- -----------------
  OTURB1   R Documentation
  -------- -----------------

Cycle Times of a Piston from the Piston Simulator
=================================================

Description
-----------

50 cycle times (in *s*)of a piston gerated with
`pistonSimulation(seed=123)`. Cycle times are rounded to 3 decimals.

Usage
-----

    data(OTURB1)

References
----------

See `pistonSimulation`

Examples
--------

    data(OTURB1)

    REF <- round(pistonSimulation(seed=123)$seconds, 3)

    plot(OTURB1, type="b", lwd=6)

    lines(REF, col=2, lwd=2)

    sum(OTURB1 - REF)
