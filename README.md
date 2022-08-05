# tooling
Automated configuration to build the tooling I use

## Dependencies

Most of the tools are built using Go. The last known working version for this
configuration is Go 1.17, but further versions should also work.

## Notes

ksops needs to be placed in the same file structure it's generated in, due to
how kustomize looks for plugins.

Terraform looks for plugins using a very specific format that I have replicated
in the environment file. Terraform also typically pulls the "latest" version of
a plugin when running `terraform init` rather than a cached version, so
if the version in the Terraform repository is further than installed locally,
that one will be preferred.
