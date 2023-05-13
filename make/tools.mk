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
	mkdir -p build/$(1)
	git -C build/$(1) init
	git -C build/$(1) remote add origin $(2) || true
	git -C build/$(1) fetch origin $(3)
	git -C build/$(1) -c advice.detachedHead=false checkout $(3)
	test `git -C build/$(1) rev-parse HEAD` = $(3)
endef

build: build/kubectl build/k9s build/sops build/ksops build/kustomize
build: build/terraform build/talosctl build/helm build/tflint build/yq

tools: tools/kubectl tools/k9s tools/sops tools/kustomize
tools: tools/terraform tools/talosctl tools/helm tools/tflint tools/yq
tools: build/viaduct.ai/v1/ksops/ksops

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
	$(call build-go,sops,$(SOPS_PKG))

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

build/talosctl: config/tools.env
	$(call clone-repo,talosctl,$(TALOSCTL_URL),$(TALOSCTL_REF))

tools/talosctl: build/talosctl
	$(call build-go,talosctl,$(TALOSCTL_PKG))

build/helm: config/tools.env
	$(call clone-repo,helm,$(HELM_URL),$(HELM_REF))

tools/helm: build/helm
	$(call build-go,helm,$(HELM_PKG))

build/tflint: config/tools.env
	$(call clone-repo,tflint,$(TFLINT_URL),$(TFLINT_REF))

tools/tflint: build/tflint
	$(call build-go,tflint)

build/yq: config/tools.env
	$(call clone-repo,yq,$(YQ_URL),$(YQ_REF))

tools/yq: build/yq
	$(call build-go,yq)
