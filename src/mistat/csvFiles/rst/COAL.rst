==== ===============
COAL R Documentation
==== ===============

Number of Coal Mine Disasters
-----------------------------

Description
~~~~~~~~~~~

Data on the number of coal mine disasters (explosions) in England, per
year, for the period 1850 to 1961.

Usage
~~~~~

::

   data(COAL)

Source
~~~~~~

Kenett, R. and Zacks, S. (1998) *Modern Industrial Statistics: The
Design and Control of Quality and Reliability*. Duxbury Press.

Examples
~~~~~~~~

::

   data(COAL)
   Bp <- barplot(COAL)                  
                                        
   axis(side=1,                         
        labels=seq(
          from=1850, 
          to=1960, 
          by=10),  
        at=Bp[rep(c(TRUE,               
                    rep(FALSE, 9)),     
                  10)])                 
                                        
   rm(Bp)
