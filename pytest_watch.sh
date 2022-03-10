rm .testmondata
# rm .coverage
# rm -rf htmlcov
# rm -rf .pytest_cache
# ptw --runner "pytest --testmon --quiet -rP --cov --cov-append --cov-report html:../htmlcov "
ptw --runner "pytest --testmon --quiet -rP"
