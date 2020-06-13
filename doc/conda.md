```
conda create --name mistat-dev python=3.8
conda activate mistat-dev

# conda install matplotlib
pip install pandas
# conda install scikit-learn

pip install tox twine pytest==5.3
```

```
python3 setup.py sdist bdist_wheel
python3 -m twine upload dist/*
```