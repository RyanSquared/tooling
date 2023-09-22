BINDIR ?= $(HOME)/bin
KUSTOMIZE_PLUGIN_HOME ?= $(HOME)/.config/kustomize/plugin
TF_PLUGIN_CACHE_DIR ?= $(BINDIR)
TFLINT_PLUGIN_CACHE_DIR ?= $(HOME)/.tflint.d/plugins
DOCKER_IMAGE_NAME ?= tooling
DOCKER_TARGET ?= output
TOOLS ?= tools

.PHONY: default
default: tools

include $(PWD)/config/tools.env
include $(PWD)/make/tools.mk
include $(PWD)/make/tools-terraform.mk
include $(PWD)/make/tools-tflint.mk

.PHONY: clean
clean: clean-tools clean-build

.PHONY: clean-build
clean-build:
	# yes, -f is necessary, because of git meta files
	rm -rf build

.PHONY: docker
docker:
	DOCKER_BUILDKIT=1 docker build -t $(DOCKER_IMAGE_NAME) --target $(DOCKER_TARGET) --progress=plain --build-arg TOOLS="$(TOOLS)" .

.PHONY: echo
echo:
	@echo "BINDIR?=$(BINDIR)"
	@echo "KUSTOMIZE_PLUGIN_HOME?=$(KUSTOMIZE_PLUGIN_HOME)"
	@echo "TF_PLUGIN_CACHE_DIR?=$(TF_PLUGIN_CACHE_DIR)"
	@echo "GOFLAGS?=$(GOFLAGS)"
	@echo "GOARCH?=$(GOARCH)"
	@echo "TOOLS?=$(TOOLS)"
	@echo "DOCKER_IMAGE_NAME?=$(DOCKER_IMAGE_NAME)"
	@echo "DOCKER_TARGET?=$(DOCKER_TARGET)"
	@echo "TOOLS?=$(TOOLS)"
	@cat config/tools.env | grep '^export' | cut -d' ' -f2
	@cat config/tools.env | grep '^export' | cut -d' ' -f2

.PHONY: install
install: tools
	mkdir -p $(BINDIR)
	mkdir -p $(KUSTOMIZE_PLUGIN_HOME)
	rsync -r tools/ $(BINDIR)
	rsync -r tools/ $(KUSTOMIZE_PLUGIN_HOME)
	mkdir -p $(BINDIR)/$(shell dirname $(TERRAFORM_AWS_BINARY))
	install $(BINDIR)/terraform-aws $(BINDIR)/$(TERRAFORM_AWS_BINARY)
	mkdir -p $(BINDIR)/$(shell dirname $(TERRAFORM_IGNITION_BINARY))
	install $(BINDIR)/terraform-ignition $(BINDIR)/$(TERRAFORM_IGNITION_BINARY)
	mkdir -p $(BINDIR)/$(shell dirname $(TERRAFORM_DIGITALOCEAN_BINARY))
	install $(BINDIR)/terraform-digitalocean $(BINDIR)/$(TERRAFORM_DIGITALOCEAN_BINARY)
	mkdir -p $(BINDIR)/$(shell dirname $(TERRAFORM_LOCAL_BINARY))
	install $(BINDIR)/terraform-local $(BINDIR)/$(TERRAFORM_LOCAL_BINARY)
	mkdir -p $(BINDIR)/$(shell dirname $(TERRAFORM_NULL_BINARY))
	install $(BINDIR)/terraform-null $(BINDIR)/$(TERRAFORM_NULL_BINARY)
	mkdir -p $(BINDIR)/$(shell dirname $(TERRAFORM_RANDOM_BINARY))
	install $(BINDIR)/terraform-random $(BINDIR)/$(TERRAFORM_RANDOM_BINARY)
	mkdir -p $(TFLINT_PLUGIN_CACHE_DIR)
	install $(BINDIR)/tflint-ruleset-* $(TFLINT_PLUGIN_CACHE_DIR)
