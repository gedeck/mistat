import math


def stemLeafDiagram(X, rowsPerGroup, leafUnit=1.0, latex=False):
    sep = '&' if latex else ''

    X = X.sort_values(ignore_index=True)
    size = len(X)
    cumCount = 0
    revCumCount = size
    for _, group in X.groupby([int(xi * rowsPerGroup / (leafUnit * 10)) for xi in X]):
        count = len(group)
        cumCount += count
        # round down
        group = group.apply(lambda xi: math.floor(xi / leafUnit))
        digits = ''.join(f'{xi}'[-1] for xi in group)

        cumFreq = min(cumCount, revCumCount)
        if (cumCount >= size // 2) and (revCumCount >= size // 2):
            s = f'({count})'
            print(f'{s:>8s} {sep} {int(group.iloc[0]/10):-5d} {sep}  {digits}')
        else:
            print(f'{cumFreq:-8d} {sep} {int(group.iloc[0]/10):-5d} {sep}  {digits}')
        if latex:
            print('\\\\')
        revCumCount -= count
