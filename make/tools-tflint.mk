build: build/tflint-ruleset-aws

tools: tools/tflint-ruleset-aws

build/tflint-ruleset-aws: config/tools.env
	$(call clone-repo,tflint-ruleset-aws,$(TFLINT_RULESET_AWS_URL),$(TFLINT_RULESET_AWS_REF))

tools/tflint-ruleset-aws: build/tflint-ruleset-aws
	$(call build-go,tflint-ruleset-aws)
