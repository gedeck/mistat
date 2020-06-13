  ------------ -----------------
  CONTACTLEN   R Documentation
  ------------ -----------------

Length of the Electrical Contacts
=================================

Description
-----------

length (in *cm*) of the electrical contacts of relays in samples of size
five, taken hourly from a running process.

Usage
-----

    data(CONTACTLEN)

Format
------

A numeric matrix with five columns representing a sample and twenty rows
representing hourly samples.

Source
------

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
--------

    data(CONTACTLEN)

    library(qcc)

    qcc(CONTACTLEN, type="xbar")
