'''
Created on Jan 15, 2021

@author: petergedeck
'''
from pathlib import Path
import os
import sys
from tempfile import NamedTemporaryFile
import subprocess

DATADIR = Path(__file__).parent / 'src' / 'mistat' / 'csvFiles'


def datafiles():
    for file in DATADIR.glob('*.csv.gz'):
        yield file


def md_file(datafile):
    from mistat.data import get_description_file
    return Path(get_description_file(datafile.name))


def rd_file(datafile):
    return DATADIR / 'rd' / datafile.with_suffix('').with_suffix('.Rd').name


def identify_missing_description():
    for datafile in sorted(datafiles()):
        if not md_file(datafile).exists():
            print(f'Missing description: {datafile.name}')


def convert_rd_to_md(rd, md):
    with NamedTemporaryFile(suffix='.html') as temphtml, NamedTemporaryFile(suffix='.rst') as temprst:
        print(f'convert {rd.stem}')
        Rd2HTML(rd, temphtml.name)
        pandoc(temphtml.name, temprst.name, format='rst')
        pandoc(temprst.name, md, format='markdown')


def pandoc(html, output, format=None):
    command = '/usr/local/bin/Rscript'
    p = subprocess.run(['pandoc', html, '-t', format, '-o', output],
                       capture_output=True)


def Rd2HTML(rd, html):
    with NamedTemporaryFile(suffix='.R') as tempR:
        with open(tempR.name, 'w') as f:
            print('library(tools)', file=f)
            print(f"Rd2HTML('{rd}', '{html}')", file=f)

        command = '/usr/local/bin/Rscript'
        p = subprocess.run([command, '--vanilla', tempR.name],
                           capture_output=True)


def prepare_md_files():
    for datafile in sorted(datafiles()):
        rd = rd_file(datafile)
        if not rd.exists():
            continue
        md = md_file(datafile)
        if not md.exists() or os.path.getmtime(md) < os.path.getmtime(rd):
            convert_rd_to_md(rd, md)


if __name__ == '__main__':
    sys.path.append(str(Path(__file__).resolve().parent / 'src'))
    print(sys.path)
    identify_missing_description()
    prepare_md_files()
