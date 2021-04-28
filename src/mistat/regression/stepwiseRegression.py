import warnings

import statsmodels.formula.api as smf
import statsmodels.stats as sms


def find_best_model_partialF(outcome, variable_sets, data, old_model, opt_max):
    optF = 1 if opt_max else -1
    partialF = 0
    best_model = None
    best_vars = None
    for variables in variable_sets:
        formula = f'{outcome} ~ 1'
        if variables:
            formula = f"{formula} + {' + '.join(variables)}"
        new_model = smf.ols(formula, data=data).fit()
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            comparison = sms.anova.anova_lm(old_model, new_model)
        if optF * partialF < optF * comparison.F[1]:
            best_vars = variables
            best_model = new_model
            partialF = comparison.F[1]
    return best_vars, best_model, partialF


def stepwise_regression(outcome, all_vars, data):
    # initial model
    model = smf.ols(f'{outcome} ~ 1', data=data).fit()

    include = set()
    step = 0
    F_to_add = 4
    F_to_remove = 4
    all_vars = set(all_vars)
    while len(include) != len(all_vars):
        step += 1
        partialF = 0

        # try to add variables to model
        candidates = [include | {xl} for xl in all_vars.difference(include)]
        best_vars, best_model, partialF = find_best_model_partialF(outcome,
                                                                   candidates, data, model, True)

        # stop if best partial-F is below cutoff
        if partialF < F_to_add:
            break
        print(f'Step {step} add - (F: {partialF:.2f}) ', end='')
        print(f' {" ".join(sorted(best_vars))}')
        model = best_model
        include = best_vars

        # try to exclude variables from model
        if len(include) < 2:
            continue
        candidates = [include - {xl} for xl in include]
        best_vars, best_model, partialF = find_best_model_partialF(outcome,
                                                                   candidates, data, model, False)

        # continue with adding if best partial-F is above cutoff
        if partialF < F_to_remove:
            continue

        print(f'Step {step} remove - (F: {partialF:.2f})')
        print(f' {" ".join(sorted(best_vars))}')
        model = best_model
        include = best_vars
    return include, model
