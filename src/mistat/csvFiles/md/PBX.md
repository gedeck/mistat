  ----- -----------------
  PBX   R Documentation
  ----- -----------------

Software Errors Found in Testing a PBX
======================================

Description
-----------

Software errors found in testing a Private Branch Exchange electronic
switch. Errors are labeled according to the software unit where they
occurred (e.g. \"EKT\", Electronic Key Telephone).

Usage
-----

    data(PBX)

Format
------

The format is: Named num \[1:5\] 473 252 110 100 65 - attr(\*,
\"names\")= chr \[1:5\] \"GEN\" \"VHS\" \"HI\" \"LO\" \...

Source
------

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
--------

    data(PBX)

    barplot(PBX)            
