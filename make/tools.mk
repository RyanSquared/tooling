# 8 processes is probably enough to build all processes on a machine with 8 GB
# of RAM without running out of RAM
GOFLAGS ?= -p 8 -v -trimpath -ldflags=-w
GOARCH ?= $(shell go version | cut -d' ' -f4 | tr / _)

# Arguments: 1: binary, 2: pkg?, 3: output?, 4: build directory?
define build-go
	cd build/$(1)$(if $(4),/$(4),) && go build $(GOFLAGS) -o $(PWD)/tools/$(if $(3),$(3),$(1))$(if $(2), $(2),)
endef

# Arguments: 1: binary, 2: repository, 3: ref
define clone-repo
	mkdir -p build
	git clone $(2) build/$(1) 2>/dev/null || test -d build/$(1) && git -C build/$(1) fetch >/dev/null
	git -C build/$(1) checkout $(3) 2>/dev/null
	test `git -C build/$(1) rev-parse HEAD` = $(3)
endef

build: build/kubectl build/k9s build/sops build/ksops
build: build/kustomize build/terraform build/terraform-ignition
build: build/terraform-aws build/terraform-digitalocean build/terraform-local
build: build/terraform-null build/talosctl build/yq

tools: tools/kubectl tools/k9s tools/sops tools/viaduct.ai/v1/ksops/ksops
tools: tools/kustomize tools/terraform tools/terraform-ignition
tools: tools/terraform-aws tools/terraform-digitalocean tools/terraform-local
tools: tools/terraform-null tools/talosctl tools/yq

.PHONY: clean-tools
clean-tools:
	rm -rf tools/*

build/kubectl: config/tools.env
	$(call clone-repo,kubectl,$(KUBECTL_URL),$(KUBECTL_REF))

tools/kubectl: build/kubectl
	$(call build-go,kubectl,$(KUBECTL_PKG))

build/k9s: config/tools.env
	$(call clone-repo,k9s,$(K9S_URL),$(K9S_REF))

tools/k9s: build/k9s
	$(call build-go,k9s)

build/sops: config/tools.env
	$(call clone-repo,sops,$(SOPS_URL),$(SOPS_REF))

tools/sops: build/sops
	$(call build-go,sops,go.mozilla.org/sops/v3/cmd/sops)

build/ksops: config/tools.env
	$(call clone-repo,ksops,$(KSOPS_URL),$(KSOPS_REF))

tools/viaduct.ai/v1/ksops/ksops: build/ksops
	# Note: This file structure is important, as it must be mirrored where
	# kustomize looks for plugins.
	# See also: https://github.com/kubernetes-sigs/kustomize/blob/master/api/konfig/plugins.go#L19-L21
	$(call build-go,ksops,,viaduct.ai/v1/ksops/ksops)

build/kustomize: config/tools.env
	$(call clone-repo,kustomize,$(KUSTOMIZE_URL),$(KUSTOMIZE_REF))

tools/kustomize: build/kustomize
	$(call build-go,kustomize,,,kustomize)

build/terraform: config/tools.env
	$(call clone-repo,terraform,$(TERRAFORM_URL),$(TERRAFORM_REF))

tools/terraform: build/terraform
	$(call build-go,terraform)

build/terraform-ignition: config/tools.env
	$(call clone-repo,terraform-ignition,$(TERRAFORM_IGNITION_URL),$(TERRAFORM_IGNITION_REF))

tools/terraform-ignition: build/terraform-ignition
	$(call build-go,terraform-ignition)

build/terraform-aws: config/tools.env
	$(call clone-repo,terraform-aws,$(TERRAFORM_AWS_URL),$(TERRAFORM_AWS_REF))

tools/terraform-aws: build/terraform-aws
	$(call build-go,terraform-aws)

build/terraform-digitalocean: config/tools.env
	$(call clone-repo,terraform-digitalocean,$(TERRAFORM_DIGITALOCEAN_URL),$(TERRAFORM_DIGITALOCEAN_REF))

tools/terraform-digitalocean: build/terraform-digitalocean
	$(call build-go,terraform-digitalocean)

build/terraform-local: config/tools.env
	$(call clone-repo,terraform-local,$(TERRAFORM_LOCAL_URL),$(TERRAFORM_LOCAL_REF))

tools/terraform-local: build/terraform-local
	$(call build-go,terraform-local)

build/terraform-null: config/tools.env
	$(call clone-repo,terraform-null,$(TERRAFORM_NULL_URL),$(TERRAFORM_NULL_REF))

tools/terraform-null: build/terraform-null
	$(call build-go,terraform-null)

build/terraform-random: config/tools.env
	$(call clone-repo,terraform-random,$(TERRAFORM_RANDOM_URL),$(TERRAFORM_RANDOM_REF))

tools/terraform-random: build/terraform-random
	$(call build-go,terraform-random)

build/talosctl: config/tools.env
	$(call clone-repo,talosctl,$(TALOSCTL_URL),$(TALOSCTL_REF))

tools/talosctl: build/talosctl
	$(call build-go,talosctl,$(TALOSCTL_PKG))

build/yq: config/tools.env
	$(call clone-repo,yq,$(YQ_URL),$(YQ_REF))

tools/yq: build/yq
	$(call build-go,yq)
