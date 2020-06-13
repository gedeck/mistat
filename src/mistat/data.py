'''
Created on Jun 12, 2020

@author: gedeck
'''
from pathlib import Path
import string

import pandas as pd


DATA_DIR = Path(__file__).parent / 'csvFiles'


def load_data(name):
    """ Returns the data either as a Pandas data frame or series """
    data_file = get_data_file(name)
    if not data_file.exists():
        raise ValueError('Data file {name} not found')
    data = pd.read_csv(data_file)
    if data.shape[1] == 1:
        return data[data.columns[0]]
    return data


def describe_data(name):
    """ Return information about the data file """
    description_file = get_description_file(name)
    if not description_file.exists():
        raise ValueError('Description for data file {name} not found')
    text = description_file.read_text()
    text = text.replace('R Documentation', 'Documentation')
    return text


def get_data_file(name):
    if name.endswith('.gz'):
        name = name[:-3]
    if name.endswith('.csv'):
        name = name[:-4]
    return DATA_DIR / f'{name}.csv.gz'


def get_description_file(name):
    if name.endswith('.gz'):
        name = name[:-3]
    if name.endswith('.csv'):
        name = name[:-4]
    if name.endswith('.md'):
        name = name[:-3]
    description_file = DATA_DIR / 'md' / f'{name}.md'
    if not description_file.exists():
        name = description_file.with_suffix('').name.rstrip(string.digits)
        description_file = DATA_DIR / 'md' / f'{name}.md'
    return description_file
