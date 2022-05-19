# TODO: can we optimize out command? probably not because of _PKG values
# Command most times will be in the format of:
# go build -v -trimpath -ldflags=-w -o $(PWD)/tools/k9s
# that might be optional
# Arguments: 1: binary, 2: url, 3: ref/tag, 4: command
define build-go
	mkdir -p build tools
	git clone $(2) build/$(1) || true
	git -C build/$(1) checkout $(3)
	sh -c "cd build/$(1) && $(4)"
endef

# 8 processes is probably enough to build all processes on a machine with 8 GB
# of RAM without running out of RAM
GOFLAGS=-p 8 -v -trimpath -ldflags=-w

tools: tools/kubectl tools/k9s tools/sops tools/viaduct.ai/v1/ksops/ksops tools/kustomize tools/terraform tools/terraform-ignition tools/terraform-aws

.PHONY: clean-tools
clean-tools:
	rm -rf tools/*

tools/kubectl:
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/kubectl $(KUBECTL_PKG)")
	$(call build-go,kubectl,"$(KUBECTL_URL)","$(KUBECTL_REF)","$(CMD)")

tools/k9s:
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/k9s")
	$(call build-go,k9s,"$(K9S_URL)","$(K9S_REF)","$(CMD)")

tools/sops:
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/sops go.mozilla.org/sops/v3/cmd/sops")
	$(call build-go,sops,"$(SOPS_URL)","$(SOPS_REF)","$(CMD)")

tools/viaduct.ai/v1/ksops/ksops:
	# Note: This file structure is important, as it must be mirrored where
	# kustomize looks for plugins.
	# See also: https://github.com/kubernetes-sigs/kustomize/blob/master/api/konfig/plugins.go#L19-L21
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/viaduct.ai/v1/ksops/ksops")
	$(call build-go,ksops,"$(KSOPS_URL)","$(KSOPS_REF)","$(CMD)")

tools/kustomize:
	$(eval CMD="cd kustomize && go build $(GOFLAGS) -o $(PWD)/tools/kustomize")
	$(call build-go,kustomize,"$(KUSTOMIZE_URL)","$(KUSTOMIZE_REF)","$(CMD)")

tools/terraform:
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/terraform")
	$(call build-go,terraform,"$(TERRAFORM_URL)","$(TERRAFORM_REF)","$(CMD)")

tools/terraform-ignition:
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/terraform-ignition")
	$(call build-go,terraform-ignition,"$(TERRAFORM_IGNITION_URL)","$(TERRAFORM_IGNITION_REF)","$(CMD)")

tools/terraform-aws:
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/terraform-aws")
	$(call build-go,terraform-aws,"$(TERRAFORM_AWS_URL)","$(TERRAFORM_AWS_REF)","$(CMD)")

tools/terraform-digitalocean:
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/terraform-digitalocean")
	$(call build-go,terraform-digitalocean,"$(TERRAFORM_DIGITALOCEAN_URL)","$(TERRAFORM_DIGITALOCEAN_REF)","$(CMD)")

tools/terraform-local:
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/terraform-local")
	$(call build-go,terraform-local,"$(TERRAFORM_LOCAL_URL)","$(TERRAFORM_LOCAL_REF)","$(CMD)")

tools/terraform-null:
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/terraform-null")
	$(call build-go,terraform-null,"$(TERRAFORM_NULL_URL)","$(TERRAFORM_NULL_REF)","$(CMD)")

tools/talosctl:
	$(eval CMD="go build $(GOFLAGS) -o $(PWD)/tools/talosctl $(TALOSCTL_PKG)")
	$(call build-go,talosctl,"$(TALOSCTL_URL)","$(TALOSCTL_REF)","$(CMD)")
