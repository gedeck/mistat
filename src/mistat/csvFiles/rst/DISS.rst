==== ===============
DISS R Documentation
==== ===============

Dissolution Data
----------------

Description
~~~~~~~~~~~

Dissolution data of a new product and a reference approved product.

Usage
~~~~~

::

   data(DISS)

Format
~~~~~~

A data frame with 12 observations on the following 4 variables.

``batch``
   a factor with levels ``REF`` ``TEST``

``tablet``
   a factor with levels ``1`` ``2`` ``3`` ``4`` ``5`` ``6``

``min15``
   a numeric vector

``min90``
   a numeric vector

Source
~~~~~~

Tsong et al., (1996).

Examples
~~~~~~~~

::

   data(DISS)
   ## maybe str(DISS) ; plot(DISS) ...
