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

all: build


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


### RULES FOR TAGGING ###

tag-latest: $(BUILD_LATEST_DEP)
	$(DOCKER) image tag $(REPO_NAME)/$(IMAGE_NAME):$(LATEST_VERSION) $(REPO_NAME)/$(IMAGE_NAME):latest


### RULES FOR PUSHING ###

push: $(foreach version,$(VERSIONS),push-$(version)) $(PUSH_DEP)

define push-version
push-$1:
	$(DOCKER) image push $(REPO_NAME)/$(IMAGE_NAME):$(version)
endef
$(foreach version,$(VERSIONS),$(eval $(call push-version,$(version))))

push-latest: tag-latest $(PUSH_LATEST_DEP)
	$(DOCKER) image push $(REPO_NAME)/$(IMAGE_NAME):latest


### RULES FOR UPDATING ###

update:
	$(DOCKER) run --rm -v $$(pwd):/work -w /work buildpack-deps ./update.sh


.PHONY: all build tag-latest push push-latest update \
        $(foreach version,$(VERSIONS),build-$(version)) \
        $(foreach version,$(VERSIONS),push-$(version))
