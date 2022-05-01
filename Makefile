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
