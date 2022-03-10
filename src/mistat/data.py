# mypy: disallow_untyped_defs,disallow_untyped_calls
'''
Modern Statistics: A Computer Based Approach with Python
Industrial Statistics: A Computer Based Approach with Python

(c) 2022 Ron Kenett, Shelemyahu Zacks, Peter Gedeck
'''
import string
from pathlib import Path
from typing import Dict, Union

import pandas as pd

DATA_DIR = Path(__file__).parent / 'csvFiles'

DatasetType = Union[pd.DataFrame, pd.Series, Dict[str, pd.Series]]


def load_data(name: str) -> DatasetType:
    """ Returns the data either as a Pandas data frame or series """
    data_file = get_data_file(name)
    if not data_file.exists():
        raise ValueError('Data file {name} not found')
    if name in SPECIAL_DATASETS:
        return SPECIAL_DATASETS[name](data_file)
    data = pd.read_csv(data_file)
    if data.shape[1] == 1:
        return data[data.columns[0]]  # pylint: disable=unsubscriptable-object
    return data


def describe_data(name: str) -> str:
    """ Return information about the data file """
    description_file = get_description_file(name)
    if not description_file.exists():
        raise ValueError('Description for data file {name} not found')
    text = description_file.read_text()
    text = text.replace('R Documentation', 'Documentation')
    return text


def get_data_file(name: str) -> Path:
    if name.endswith('.gz'):
        name = name[:-3]
    if name.endswith('.csv'):
        name = name[:-4]
    return DATA_DIR / f'{name}.csv.gz'


def get_description_file(name: str) -> Path:
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


def load_process_segment(data_file: Path) -> Dict[str, pd.Series]:
    data = pd.read_csv(data_file)
    return {column: data[column].dropna() for column in data.columns}


SPECIAL_DATASETS = {
    'PROCESS_SEGMENT': load_process_segment,
}
