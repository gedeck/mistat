'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import math


def stemLeafDiagram(X, rowsPerGroup, leafUnit=1.0, latex=False):
    sep = '&' if latex else ''

    X = X.sort_values(ignore_index=True)
    size = len(X)
    cumCount = 0
    revCumCount = size
    lastGroupNr = None
    for _, group in X.groupby([int(xi * rowsPerGroup / (leafUnit * 10)) for xi in X]):
        count = len(group)
        cumCount += count
        # round down
        group = group.apply(lambda xi: math.floor(xi / leafUnit))
        digits = ''.join(f'{xi}'[-1] for xi in group)

        cumFreq = min(cumCount, revCumCount)
        groupNr = int(group.iloc[0]/10)
        if lastGroupNr and lastGroupNr < groupNr - 1:
            # add lines with no values
            while lastGroupNr < groupNr - 1:
                lastGroupNr += 1
                s = '0'
                print(f'{s:>8s} {sep} {lastGroupNr:-5d} {sep}')
        lastGroupNr = groupNr
        if (cumCount >= size // 2) and (revCumCount >= size // 2):
            s = f'({count})'
            print(f'{s:>8s} {sep} {groupNr:-5d} {sep}  {digits}')
        else:
            print(f'{cumFreq:-8d} {sep} {groupNr:-5d} {sep}  {digits}')
        if latex:
            print('\\\\')
        revCumCount -= count
