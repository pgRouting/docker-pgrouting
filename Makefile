# When processing the rules for tagging and pushing container images with the
# "latest" tag, the following variable will be the version that is considered
# to be the latest.
LATEST_VERSION=16-3.4-3.6

# The following logic evaluates VERSION variable that may have
# been previously specified.
# The VERSIONS variable is also set to contain the version(s) to be processed.
ifdef VERSION
	VERSIONS = $(VERSION) # If a version was specified, VERSIONS only contains the specified version
else # If no version was specified, VERSIONS should contain all versions
	VERSIONS = $(foreach df,$(wildcard */Dockerfile),$(df:%/Dockerfile=%))
endif

BUILD_LATEST_DEP=build-$(LATEST_VERSION)
PUSH_LATEST_DEP=push-$(LATEST_VERSION)
PUSH_DEP=push-latest $(PUSH_LATEST_DEP)
# The "latest" tag shouldn't be processed if a VERSION was explicitly
# specified but does not correspond to the latest version.
ifdef VERSION
	ifneq ($(VERSION),$(LATEST_VERSION))
		PUSH_LATEST_DEP=
		BUILD_LATEST_DEP=
		PUSH_DEP=
	endif
endif

# The repository and image names default to the official but can be overriden
# via environment variables.
REPO_NAME  ?= pgrouting
IMAGE_NAME ?= pgrouting

DOCKER=docker

GIT=git
OFFIMG_LOCAL_CLONE=$(HOME)/official-images
OFFIMG_REPO_URL=https://github.com/docker-library/official-images.git


all: build test


### RULES FOR BUILDING ###

build: $(foreach version,$(VERSIONS),build-$(version))

define build-version
build-$1:
	$(DOCKER) build --pull -t $(REPO_NAME)/$(IMAGE_NAME):$(shell cat $1/version.txt) $1
	$(DOCKER) build -t $(REPO_NAME)/$(IMAGE_NAME)-extra:$(shell cat $1/version.txt) $1/extra
	if [ "$(shell echo $1)" != "$(shell cat $1/version.txt)" ]; then\
		$(DOCKER) tag $(REPO_NAME)/$(IMAGE_NAME):$(shell cat $1/version.txt) $(REPO_NAME)/$(IMAGE_NAME):$(shell echo $1);\
		$(DOCKER) tag $(REPO_NAME)/$(IMAGE_NAME)-extra:$(shell cat $1/version.txt) $(REPO_NAME)/$(IMAGE_NAME)-extra:$(shell echo $1);\
	fi
endef
$(foreach version,$(VERSIONS),$(eval $(call build-version,$(version))))


## RULES FOR TESTING ###

test-prepare:
ifeq ("$(wildcard $(OFFIMG_LOCAL_CLONE))","")
	$(GIT) clone $(OFFIMG_REPO_URL) $(OFFIMG_LOCAL_CLONE)
endif

test: $(foreach version,$(VERSIONS),test-$(version))

define test-version
test-$1: test-prepare
	$(OFFIMG_LOCAL_CLONE)/test/run.sh -c $(OFFIMG_LOCAL_CLONE)/test/config.sh -c test/pgrouting-config.sh $(REPO_NAME)/$(IMAGE_NAME):$(shell cat $1/version.txt)
	$(DOCKER) run --rm --name $(IMAGE_NAME)-extra-$(shell cat $1/version.txt) -e POSTGRES_PASSWORD=postgres -p 5432:5432 $(REPO_NAME)/$(IMAGE_NAME)-extra:$(shell cat $1/version.txt) osm2pgrouting --version
	# if [ "$(shell echo $1)" != "$(shell cat $1/version.txt)" ]; then\
	# 	$(OFFIMG_LOCAL_CLONE)/test/run.sh -c $(OFFIMG_LOCAL_CLONE)/test/config.sh -c test/pgrouting-config.sh $(REPO_NAME)/$(IMAGE_NAME):$(shell echo $1);\
	# 	$(DOCKER) run --rm --name $(IMAGE_NAME)-extra-$(shell echo $1) -e POSTGRES_PASSWORD=postgres -p 5432:5432 $(REPO_NAME)/$(IMAGE_NAME)-extra:$(shell echo $1) osm2pgrouting --version;\
	# fi
endef
$(foreach version,$(VERSIONS),$(eval $(call test-version,$(version))))

### RULES FOR TAGGING ###

tag-latest: $(BUILD_LATEST_DEP)
	$(DOCKER) image tag $(REPO_NAME)/$(IMAGE_NAME):$(LATEST_VERSION) $(REPO_NAME)/$(IMAGE_NAME):latest
	$(DOCKER) image tag $(REPO_NAME)/$(IMAGE_NAME)-extra:$(LATEST_VERSION) $(REPO_NAME)/$(IMAGE_NAME)-extra:latest


### RULES FOR PUSHING ###

push: $(foreach version,$(VERSIONS),push-$(version)) $(PUSH_DEP)

define push-version
push-$1:
	$(DOCKER) image push $(REPO_NAME)/$(IMAGE_NAME):$(shell cat $1/version.txt)
	$(DOCKER) image push $(REPO_NAME)/$(IMAGE_NAME)-extra:$(shell cat $1/version.txt)
	if [ "$(shell echo $1)" != "$(shell cat $1/version.txt)" ]; then\
		$(DOCKER) image push $(REPO_NAME)/$(IMAGE_NAME):$(shell echo $1);\
		$(DOCKER) image push $(REPO_NAME)/$(IMAGE_NAME)-extra:$(shell echo $1);\
	fi
endef
$(foreach version,$(VERSIONS),$(eval $(call push-version,$(version))))

push-latest: tag-latest $(PUSH_LATEST_DEP)
	$(DOCKER) image push $(REPO_NAME)/$(IMAGE_NAME):latest
	$(DOCKER) image push $(REPO_NAME)/$(IMAGE_NAME)-extra:latest


### RULES FOR UPDATING ###

update:
	$(DOCKER) run --rm -v $$(pwd):/work -w /work buildpack-deps ./update.sh


.PHONY: all build test-prepare test tag-latest push push-latest update \
	$(foreach version,$(VERSIONS),build-$(version)) \
	$(foreach version,$(VERSIONS),test-$(version)) \
	$(foreach version,$(VERSIONS),push-$(version))
