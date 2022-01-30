# 

PYWASH_IMAGE=mistat_pywash_1
RUN=docker run -it --rm -p 5000:5000
RUN_IMAGE=$(RUN) $(PYWASH_IMAGE) 

pywash:
	$(RUN) $(PYWASH_IMAGE)

bash-pywash:
	$(RUN_IMAGE) bash

build: docker/image.pywash

docker/image.pywash: docker/Dockerfile.pywash
	docker build -t $(PYWASH_IMAGE) -f docker/Dockerfile.pywash .

