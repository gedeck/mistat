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


def convert_R_description(name):
    """ Extract information from the R description file """
    data_file = get_description_file(name)
    if not data_file.exists():
        raise ValueError('Description file {name} not found')

    description = data_file.read_text()
    result = {}
    for line in description.split():
        line = line.strip()
        if '\name' in line:
            
        print(line)
        
def parse_R_description(text):
    key = None
    content = None
    for word in text.split():
        if word.startwith('\'):
          
        


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
    if name.endswith('.Rd'):
        name = name[:-3]
    description_file = DATA_DIR / f'{name}.Rd'
    if not description_file.exists():
        name = description_file.with_suffix('').name.rstrip(string.digits)
        description_file = DATA_DIR / f'{name}.Rd'
    return description_file
