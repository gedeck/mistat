========= ===============
COMPURESP R Documentation
========= ===============

Computer Response Time Optimization
-----------------------------------

Description
~~~~~~~~~~~

The experiment described here was part of an extensive effort to
optimize a UNIX operating system.

Usage
~~~~~

::

   data(COMPURESP)

Format
~~~~~~

A data frame with 18 observations on the following 10 variables.

``F``
   a factor with levels ``1`` ``2``, representing KMCs used

``B``
   a factor with levels ``1`` ``2`` ``3``, representing File
   Distribution

``C``
   a factor with levels ``1`` ``2`` ``3``, representing Memory Size

``D``
   a factor with levels ``1`` ``2`` ``3``, representing System Buffers

``E``
   a factor with levels ``1`` ``2`` ``3``, representing Sticky Bits

``A``
   a factor with levels ``1`` ``2`` ``3``, representing Disk Drives

``G``
   a factor with levels ``1`` ``2`` ``3``, representing INODE Table
   Entries

``H``
   a factor with levels ``1`` ``2`` ``3``, representing Other System
   Tables

``Mean``
   mean time taken for the system to complete commands execution

``SN``
   S/N ratio *η = -10 log10(1/n ∑ y^2 )*

Details
~~~~~~~

The experiment described here was part of an extensive effort to
optimize a UNIX operating system running on a VAX 11-780 machine. The
machine had 48 user terminal ports, two remote job entry links, four
megabytes of memory, and five disk drives. The typical number of users
logged on at a given time was between 20 to 30.

**1. Problem Definition**. Users complained that the system performance
was very poor, especially in the afternoon. The objective of the
improvement effort was to both minimize response time and reduce
variability in response.

**2. Response variable**. In order to get an objective measurement of
the response time two specific representative commands called ‘standard’
and ‘trivial’ were used. The ‘standard’ command consisted of creating,
editing and removing a file. The ‘trivial’ command was the UNIX system
‘date’ command. Response times were measured by submitting these
commands every 10 minutes and clocking the time taken for the system to
complete their execution.

Source
~~~~~~

Pao, Phadke and Sherrerd (1985)

Examples
~~~~~~~~

::

   data(COMPURESP)

   layout(matrix(1:4, 2, byrow=TRUE))

   with(COMPURESP,
        interaction.plot(
          x.factor=F, 
          trace.factor=rep(0, length(F)), 
          response=SN, 
          legend=FALSE,
          type="b",
          pch=15:18,
          ylim=c(-17, -10)))

   with(COMPURESP,
        interaction.plot(
          x.factor=B, 
          trace.factor=rep(0, length(B)), 
          response=SN, 
          legend=FALSE,
          type="b",
          pch=15:18,
          ylim=c(-17, -10)))

   with(COMPURESP,
        interaction.plot(
          x.factor=C, 
          trace.factor=rep(0, length(C)), 
          response=SN, 
          legend=FALSE,
          type="b",
          pch=15:18,
          ylim=c(-17, -10)))

   with(COMPURESP,
        interaction.plot(
          x.factor=D, 
          trace.factor=rep(0, length(D)), 
          response=SN, 
          legend=FALSE,
          type="b",
          pch=15:18,
          ylim=c(-17, -10)))

   layout(1)
