```
conda create --name mistat-dev python=3.8
conda activate mistat-dev

# conda install matplotlib
conda install pandas
# conda install scikit-learn

conda install tox
conda install twine
```

```
python3 setup.py sdist bdist_wheel
python3 -m twine upload dist/*
```