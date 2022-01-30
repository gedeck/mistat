'''
Utility functions for "Data Mining for Business Analytics: Concepts, Techniques, and 
Applications in Python"

(c) 2019 Galit Shmueli, Peter C. Bruce, Peter Gedeck 
'''
from pathlib import Path

import setuptools


def getVersion():
    f = Path(__file__).parent / 'src' / 'mistat' / 'version.py'
    lines = f.read_text().split('\n')
    version = [s for s in lines if '__version__' in s][0]
    version = version.split('=')[1].strip().strip("'")
    return version


with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="mistat",
    version=getVersion(),
    author="Peter Gedeck",
    author_email="mail@petergedeck.com",
    description="Utility functions for 'Modern Industrial Statistics'",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/gedeck/mistat",
    packages=setuptools.find_packages("src"),
    package_dir={'': 'src'},
    package_data={
        "mistat": ["csvFiles/*.csv.gz", "nlp/*.txt.gz"],
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],

    test_suite='nose.collector',
    tests_require=['nose'],
)
