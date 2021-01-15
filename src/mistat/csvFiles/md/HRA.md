  -------- -----------------
  ALMPIN   R Documentation
  -------- -----------------

Annual customer satisfaction survey (19 dimensions)
===================================================

Description
-----------

Annual customer satisfaction survey directed at customers of an
electronic product distributed worldwide. The survey assesses
satisfaction levels regarding different features of the product and
related services. The questionnaire is composed of 81 questions,
including demographics and overall satisfaction. The answers were
aggregated into 19 categories

Usage
-----

    data(ALMPIN)

Format
------

A data frame with 58 observations on the following 19 variables.

`PeopleFactor` `TiredStaff` `Confidence` `Age` `WorkFactor`
`Timeofoperation` `ProcedureRoutine` `ProcedurePracticed` `Noisy`
`Lighting` `Temperature` `OrganizationFactor` `Crewsize`
`Crewexperience` `Crewstress` `WellWritten` `ProcedureUnderstood`
`Inspections` `humanError`

Source
------

Kenett RS, Salini S (eds) (2012) *Modern Analysis of Customer Surveys:
With Applications Using R*. Wiley.

Examples
--------

    data(ALMPIN)

    cor(ALMPIN)

    plot(ALMPIN)
