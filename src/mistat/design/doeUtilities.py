
def addTreatments(design, mainEffects):
    """ Add treatments information to design matrix

    design is a pandas dataframe with the design matrix as created by the doepy package
    mainEffects is a list of the columns that define main effects
    """
    design = design.copy()
    mainEffects = list(mainEffects)
    # collect information about high values for each main effect
    high = {effect: design[effect].max() for effect in mainEffects}
    treatments = []
    for _, row in design.iterrows():
        treatment = ''.join([effect for effect in mainEffects if row[effect] == high[effect]])
        if not treatment:
            treatment = '(1)'
        treatments.append(treatment)
    design.insert(0, 'Treatments', treatments)
    return design


def _reduceTreatment(treatment):
    """ Reduce a treatment string that can contain same effects multiple times """
    effects = []
    for c in sorted(set(treatment)):
        if treatment.count(c) % 2 == 1:
            effects.append(c)
    return ''.join(sorted(effects))


def subgroupOfDefining(defining, noTreatment=''):
    """ Given the defining treatments of a design, enumerate the subgroup """
    subgroup = set(defining)
    for d in defining:
        subgroup.update([_reduceTreatment(d + sg) for sg in subgroup])
    subgroup.remove('')
    subgroup.add(noTreatment)
    return sorted(subgroup)


def aliasesInSubgroup(effect, defining):
    subgroup = subgroupOfDefining(defining)
    aliases = set()
    for treatment in subgroup:
        if not treatment:
            continue
        aliases.add(_reduceTreatment(effect + treatment))
    return sorted(aliases)
