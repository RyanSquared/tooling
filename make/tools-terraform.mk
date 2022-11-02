build: build/terraform-ignition build/terraform-aws
build: build/terraform-digitalocean build/terraform-local build/terraform-null
build: build/terraform-random

tools: tools/terraform-ignition tools/terraform-aws
tools: tools/terraform-digitalocean tools/terraform-local tools/terraform-null
tools: tools/terraform-random

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
