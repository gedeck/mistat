# 
RUN=docker run -it --rm -p 5000:5000

PYWASH_IMAGE=mistat_pywash_1
TEST_IMAGE=mistat_test_1
JUPYTER_IMAGE=mistat_dev_jupyter
images: 
	# docker build -t $(PYWASH_IMAGE) -f docker/Dockerfile.pywash .
	docker build -t $(TEST_IMAGE) -f docker/Dockerfile.test .
	docker build -t $(JUPYTER_IMAGE) -f docker/Dockerfile.jupyter .


PYTEST=pytest -o cache_dir=/tmp --testmon --quiet -rP --durations=5
watch-tests:
	rm -f src/.testmondata
	docker run -it --rm -v $(PWD)/src:/src $(TEST_IMAGE) \
	  ptw --runner "$(PYTEST)"
	rm -f src/.testmondata

bash-tests:
	rm -f python/.testmondata
	docker run -it --rm -v $(PWD)/src:/src $(TEST_IMAGE) bash

pywash:
	docker run -it --rm -p 5000:5000 $(PYWASH_IMAGE)

bash-pywash:
	docker run -it --rm -p 5000:5000 $(PYWASH_IMAGE) bash

jupyter:
	docker run --rm -v $(PWD)/src:/src -p 8898:8898 $(JUPYTER_IMAGE) jupyter notebook --allow-root --port=8898 --ip 0.0.0.0 --no-browser
