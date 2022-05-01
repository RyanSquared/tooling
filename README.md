# tooling
Automated configuration to build the tooling I use

## Dependencies

Most of the tools are built using Go. The last known working version for this
configuration is Go 1.17, but further versions should also work.

## Notes

ksops needs to be placed in the same file structure it's generated in, due to
how kustomize looks for plugins.

terraform pulls in third-party providers that at this point are not
automatically built by this project; once they are built, they should be placed
into ~/.terraform.d/plugins/registry.terraform.io/ in a file structure that
resembles: `<namespace>/<provider>/<version>/<os>_<arch>/terraform-provider-<provider>_<version>`.
Sometimes these packages are suffixed with `_x4` or `_x5`, I'm not sure why, if
you have issues you can probably just try suffixing it with whatever is
provided by Terraform's registry. An example can look like:
`~/.terraform.d/plugins/registry.terraform.io/hashicorp/aws/3.22.0/darwin_arm64/terraform-provider-aws_v3.22.0_x5`
