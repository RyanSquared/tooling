BINDIR ?= $(HOME)/bin
KUSTOMIZE_PLUGIN_HOME ?= $(BINDIR)
TF_PLUGIN_CACHE_DIR ?= $(BINDIR)

.PHONY: default
default: tools

include $(PWD)/make/tools.mk
include $(PWD)/config/tools.env

.PHONY: clean
clean: clean-tools clean-build

.PHONY: clean-build
clean-build:
	# yes, -f is necessary, because of git meta files
	rm -rf build

.PHONY: docker
docker:
	docker buildx build -o tools .

.PHONY: echo
echo:
	@echo "BINDIR?=$(BINDIR)"
	@echo "KUSTOMIZE_PLUGIN_HOME?=$(KUSTOMIZE_PLUGIN_HOME)"
	@echo "TF_PLUGIN_CACHE_DIR?=$(TF_PLUGIN_CACHE_DIR)"
	@echo "GOFLAGS?=$(GOFLAGS)"
	@echo "GOARCH?=$(GOARCH)"
	@cat config/tools.env | grep '^export' | cut -d' ' -f2

.PHONY: install
install: tools
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
