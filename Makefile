VERSIONS = $(foreach df,$(wildcard */Dockerfile),$(df:%/Dockerfile=%))
REPO_NAME  ?= pgrouting
IMAGE_NAME ?= pgrouting

all: build

build: $(VERSIONS)

define pgrouting-version
$1:
	docker build --pull -t $(REPO_NAME)/$(IMAGE_NAME):$(shell cat $1/version.txt) $1
	docker build -t $(REPO_NAME)/$(IMAGE_NAME)-extra:$(shell cat $1/version.txt) $1/extra
	if [ "$(shell echo $1)" != "$(shell cat $1/version.txt)" ]; then\
		docker tag $(REPO_NAME)/$(IMAGE_NAME):$(shell cat $1/version.txt) $(REPO_NAME)/$(IMAGE_NAME):$(shell echo $1);\
		docker tag $(REPO_NAME)/$(IMAGE_NAME)-extra:$(shell cat $1/version.txt) $(REPO_NAME)/$(IMAGE_NAME)-extra:$(shell echo $1);\
	fi
endef
$(foreach version,$(VERSIONS),$(eval $(call pgrouting-version,$(version))))

update:
	docker run --rm -v $$(pwd):/work -w /work buildpack-deps ./update.sh

.PHONY: all build update $(VERSIONS)
