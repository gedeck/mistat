```
conda create --name mistat-dev python=3.8
conda activate mistat-dev

pip install numpy scipy pandas matplotlib

pip install pytest==5.3 pytest-regressions
pip install tox twine 
```

```
python3 setup.py sdist bdist_wheel
python3 -m twine upload dist/*
```