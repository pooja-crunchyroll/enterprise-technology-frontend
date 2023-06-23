# Inspired by Terraform makefile samples from Saurabh Hirani and Phil Porada
# http://saurabh-hirani.github.io/writing/2017/08/02/terraform-makefile
# https://github.com/pgporada/terraform-makefile

# This file is a WIP...
# Several of the commands work as expected but more time needs to be dedicated to this file if it is to become reliable

.PHONY: apply check-env check-gitleaks check-terraform check-terraform-docs check-tflint check-tfsec check-tfvars destroy destroy-target docs format help init init-reconfigure init-upgrade lint plan plan-destroy plan-target secure
.ONESHELL:

.DEFAULT_GOAL := help

##############################################
# Statuses
##############################################
STATUS_OK := $(shell echo "[OK]")
STATUS_CREATED := $(shell echo "[CREATED]")
STATUS_INSTALLED := $(shell echo "[INSTALLED]")
STATUS_WARN := $(shell echo "[WARN]")
STATUS_MISSING := $(shell echo "[MISSING]")

##############################################
# System
##############################################
OS := $(shell echo "$$(uname -s | awk '{print tolower($0)}')")
# x86_64 is equivalent to amd64
ARCH := $(shell if [ $$(uname -m) = x86_64 ]; then echo 'amd64'; else echo $$(uname -m); fi)

OS_SUPPORTED := $(shell if [ $(OS) = "darwin" ] || [ $(OS) = "linux" ]; then echo "true"; else echo "false"; fi)
CPU_SUPPORTED := $(shell if [ $(ARCH) = "amd64" ] || [ $(ARCH) = "arm64" ]; then echo "true"; else echo "false"; fi)
ATTEMPT_INSTALL := $(shell if [ $(OS_SUPPORTED) = "true" ] && [ $(CPU_SUPPORTED) = "true" ]; then echo "true"; else echo "false"; fi)

##############################################
# Repository
##############################################
ENV ?= sbx
APPLY_VARS := apply-tfvars/$(ENV).tfvars
INIT_VARS := init-tfvars/$(ENV).tfvars
BIN_PATH := .bin

# renovate: datasource=github-releases depName=hashicorp/terraform extractVersion=^v(?<version>.*)$
TERRAFORM_VERSION := 1.4.0
# renovate: datasource=github-releases depName=terraform-linters/tflint extractVersion=^v(?<version>.*)$
TFLINT_VERSION := 0.45.0
# renovate: datasource=github-releases depName=aquasecurity/tfsec extractVersion=^v(?<version>.*)$
TFSEC_VERSION := 1.28.1
# renovate: datasource=github-releases depName=terraform-docs/terraform-docs extractVersion=^v(?<version>.*)$
TFDOCS_VERSION := 0.16.0
# renovate: datasource=github-releases depName=zricethezav/gitleaks extractVersion=^v(?<version>.*)$
GITLEAKS_VERSION := 8.16.0

GITLEAKS_PATH := $(BIN_PATH)/gitleaks_$(GITLEAKS_VERSION)
TERRAFORM_PATH := $(BIN_PATH)/terraform_$(TERRAFORM_VERSION)
TFDOCS_PATH := $(BIN_PATH)/terraform-docs_$(TFDOCS_VERSION)
TFLINT_PATH := $(BIN_PATH)/tflint_$(TFLINT_VERSION)
TFSEC_PATH := $(BIN_PATH)/tfsec_$(TFSEC_VERSION)

##############################################
# Archives
##############################################
TERRAFORM_ARCHIVE := $(BIN_PATH)/terraform_$(TERRAFORM_VERSION)_$(OS)_$(ARCH).zip
TFLINT_ARCHIVE := $(BIN_PATH)/tflint_$(TFLINT_VERSION)_$(OS)_$(ARCH).zip

##############################################
# Makefile Commands
##############################################
help :
	@echo "Ease of life Makefile for common Terraform workflows. Encourages more consistent \
	Terraform workflows in both local development and CI/CD pipelines. The available targets for this Makefile are listed below.";
	echo "";
	echo "IMPORTANT: macOS ships with GNU Make 3.81, which does not support the .ONESHELL special target, and is considered outdated in general. \
	If you try to use GNU Make 3.81 for this Makefile, it will not work. \
	This Makefile was tested against GNU Make 3.82 and 4.3, on macOS 12.6, Debian Linux 11.5, Amazon Linux 2, and Alpine Linux 3.17." \
	Please ensure you are using a correct version of GNU Make before attempting to run this Makefile.;
	echo "";
	echo "Usage: [g]make [ENV=<environment>] <target>";
	echo "";
	echo "Available targets:";
	grep -E '^[a-zA-Z_-]+ :.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-17s\033[0m %s\n", $$1, $$2}';

check-env :
	@if [ -z "$(ENV)" ]; then
		echo "[ERROR] Environment variable ENV is empty or not set."
		exit 1;
	else
		echo "Current Makefile environment value: $(ENV)";
	fi;

check-tfvars : check-env
	@if [ -n "$(ENV)" ] && [ ! -f "$(APPLY_VARS)" ]; then
		echo "[ERROR] Could not find variables file: $(APPLY_VARS). Try running 'make setup'."
		ERROR=1;
	fi
	if [ -n "$(ENV)" ] && [ ! -f "$(INIT_VARS)" ]; then
		echo "[ERROR] Could not find backend config variables file: $(INIT_VARS). Try running 'make setup'."
		ERROR=1;
	fi;
	@if [ -n "$$ERROR" ] && [ "$$ERROR" -eq 1 ]; then
		echo ""
		echo "Example usage: \`make plan ENV=dev\`"
		echo ""
		exit 1;
	else
		echo "Backend config: $(INIT_VARS)"
		echo "Terraform variables: $(APPLY_VARS)";
	fi;

check-gitleaks :
	@if [[ ! -x $(GITLEAKS_PATH) ]]; then
		echo "No gitleaks binary detected in $(BIN_PATH). Try running 'make setup'.";
		exit 1;
	fi;

check-terraform :
	@if [ ! -x $(TERRAFORM_PATH) ]; then
		echo "No terraform binary detected in $(BIN_PATH). Try running 'make setup'.";
		exit 1;
	fi;

check-tflint :
	@if [ ! -x $(TFLINT_PATH) ]; then
		echo "No tflint binary detected in $(BIN_PATH). Try running 'make setup'.";
		exit 1;
	fi;

check-tfsec :
	@if [ ! -x $(TFSEC_PATH) ]; then
		echo "No tfsec binary detected in $(BIN_PATH). Try running 'make setup'.";
		exit 1;
	fi;

check-terraform-docs :
	@if [ ! -x $(TFDOCS_PATH) ]; then
		echo "No terraform-docs binary in $(BIN_PATH). Try running 'make setup'.";
		exit 1;
	fi;

# Targets to check for necessary tools
setup : check-env ## Check for and install any missing tooling.

	@printf "Checking OS & CPU... ";
	if [ $(OS_SUPPORTED) = "false" ]; then
		echo "$(STATUS_WARN) Your operating system is not detected or is unsupported by this target. \
		You will need to manually install any missing tooling to $(BIN_PATH)"; 
	elif [ $(CPU_SUPPORTED) = "false" ]; then
		echo "$(STATUS_WARN) Your operating system is supported... However your CPU architecture is not detected or is unsupported by this target. \
		You will need to manually install any missing tooling to $(BIN_PATH)"; 
	else
		echo "$(STATUS_OK)";
	fi;

	printf "Checking for gzip, tar, unzip & wget... ";
	if [ ! -x "$$(command -v gzip)" ] || [ ! -x "$$(command -v tar)" ] || [ ! -x "$$(command -v unzip)" ] || [ ! -x "$$(command -v wget)" ]; then
		echo "$(STATUS_WARN) gzip, tar, unzip, and/or wget not detected in PATH but are required to install tooling to $(BIN_PATH). \
		Please install and try 'make setup' again";
	else
		echo "$(STATUS_OK)";
	fi;

	printf "Checking for $(BIN_PATH)... ";
	if [ -d "$(BIN_PATH)" ]; then
		echo "$(STATUS_OK)";
	else
		mkdir $(BIN_PATH);
		echo "$(STATUS_CREATED)";
	fi;

	printf "Checking for $(INIT_VARS)... ";
	if [ ! -d "$$(dirname $(INIT_VARS))" ]; then
		mkdir $$(dirname $(INIT_VARS));
	fi;
	if [ -f "$(INIT_VARS)" ]; then
		echo "$(STATUS_OK)";
	else
		touch "$(INIT_VARS)";
		echo "$(STATUS_CREATED)";
	fi;

	printf "Checking for $(APPLY_VARS)... ";
	if [ ! -d "$$(dirname $(APPLY_VARS))" ]; then
		mkdir $$(dirname $(APPLY_VARS));
	fi;
	if [ -f "$(APPLY_VARS)" ]; then
		echo "$(STATUS_OK)";
	else
		touch "$(APPLY_VARS)"
		echo "$(STATUS_CREATED)";
	fi;

	printf "Checking for gitleaks... ";
	if [ -x "$(GITLEAKS_PATH)" ]; then
		echo "$(STATUS_OK)";
	else
		if [ $(ATTEMPT_INSTALL) = "true" ]; then
			case $(ARCH) in amd64) GITLEAKS_ARCH=x64;; arm64) GITLEAKS_ARCH=arm64;; esac;
			( wget --output-document=- https://github.com/zricethezav/gitleaks/releases/download/v$(GITLEAKS_VERSION)/gitleaks_$(GITLEAKS_VERSION)_$(OS)_$${GITLEAKS_ARCH}.tar.gz \
			| tar --directory=$(BIN_PATH) --extract --gzip --file=- gitleaks \
			&& mv $(BIN_PATH)/gitleaks $(GITLEAKS_PATH) && chmod +x $(GITLEAKS_PATH) ) > /dev/null 2>&1;
			echo "$(STATUS_INSTALLED)";
		else
			echo "$(STATUS_MISSING) - Get it at https://github.com/zricethezav/gitleaks";
		fi;
	fi;

	printf "Checking for terraform... "
	if [ -x "$(TERRAFORM_PATH)" ]; then
		echo "$(STATUS_OK)";
	else
		if [ $(ATTEMPT_INSTALL) = "true" ]; then
			( wget --output-document=$(TERRAFORM_ARCHIVE) \
			https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_$(OS)_$(ARCH).zip \
			&& unzip $(TERRAFORM_ARCHIVE) -d $(BIN_PATH) && rm $(TERRAFORM_ARCHIVE) && mv $(BIN_PATH)/terraform $(TERRAFORM_PATH) && chmod +x $(TERRAFORM_PATH) ) > /dev/null 2>&1;
			echo "$(STATUS_INSTALLED)";
		else
			echo "$(STATUS_MISSING) - Get it at https://developer.hashicorp.com/terraform/downloads";
		fi;
	fi;

	printf "Checking for terraform-docs... "
	if [ -x "$(TFDOCS_PATH)" ]; then
		echo "$(STATUS_OK)";
	else
		if [ $(ATTEMPT_INSTALL) = "true" ]; then
			( wget --output-document=- https://github.com/terraform-docs/terraform-docs/releases/download/v$(TFDOCS_VERSION)/terraform-docs-v$(TFDOCS_VERSION)-$(OS)-$(ARCH).tar.gz \
			| tar --directory=$(BIN_PATH) --extract --gzip --file=- terraform-docs \
			&& mv $(BIN_PATH)/terraform-docs $(TFDOCS_PATH) && chmod +x $(TFDOCS_PATH) ) > /dev/null 2>&1;
			echo "$(STATUS_INSTALLED)";
		else
			echo "$(STATUS_MISSING) - Get it at https://terraform-docs.io/user-guide/installation/.";
		fi;
	fi;

	printf "Checking for tflint... ";
	if [ -x "$(TFLINT_PATH)" ]; then
		echo "$(STATUS_OK)";
	else
		if [ $(ATTEMPT_INSTALL) = "true" ]; then
			( wget --output-document=$(TFLINT_ARCHIVE) \
			https://github.com/terraform-linters/tflint/releases/download/v$(TFLINT_VERSION)/tflint_$(OS)_$(ARCH).zip \
			&& unzip $(TFLINT_ARCHIVE) -d $(BIN_PATH) && rm $(TFLINT_ARCHIVE) && mv $(BIN_PATH)/tflint $(TFLINT_PATH) && chmod +x $(TFLINT_PATH) ) > /dev/null 2>&1;
			echo "$(STATUS_INSTALLED)";
		else
			echo "$(STATUS_MISSING) - Get it at https://github.com/terraform-linters/tflint#installation.";
		fi;
	fi;

	printf "Checking for tfsec... ";
	if [ -x "$(TFSEC_PATH)" ]; then
		echo "$(STATUS_OK)";
	else
		if [ $(ATTEMPT_INSTALL) = "true" ]; then
			( wget --output-document=$(TFSEC_PATH) \
			https://github.com/aquasecurity/tfsec/releases/download/v$(TFSEC_VERSION)/tfsec-$(OS)-$(ARCH) \
			&& chmod +x $(TFSEC_PATH) ) > /dev/null 2>&1;
			echo "$(STATUS_INSTALLED)";
		else
			echo "$(STATUS_MISSING) - Get it at https://aquasecurity.github.io/tfsec/latest/guides/installation/.";
		fi;
	fi;

init : check-terraform check-tfvars ## Initialize a new or existing Terraform working directory by creating initial files, loading any remote state, downloading modules, etc.
	@$(TERRAFORM_PATH) init -backend-config="$(INIT_VARS)";

init-reconfigure : check-terraform check-tfvars ## Reconfigure a backend, ignoring any saved configuration.
	@$(TERRAFORM_PATH) init -backend-config="$(INIT_VARS)" -reconfigure;

init-upgrade : check-terraform check-tfvars ## Install the latest module and provider versions allowed within configured constraints.
	@$(TERRAFORM_PATH) init -backend-config="$(INIT_VARS)" -upgrade;

lint : check-terraform check-tflint ## Check the current directory for errors, deprecated syntax, unused declarations, and best-practices recommendations and formats all .tf and .tfvars files.
	@$(TERRAFORM_PATH) fmt  -diff;
	$(TERRAFORM_PATH) validate;
	if [ "$$?" != "0" ]; then exit 1; fi;
	$(TFLINT_PATH) --init > /dev/null 2>&1;
	$(TFLINT_PATH);
	if [ "$$?" != "0" ]; then exit 1; fi;

secure : check-tfsec check-gitleaks ## Uses tfsec to perform static analysis of your Terraform configuration to spot potential security issues. Does not scan downloaded modules. Also scans for secrets with gitleaks.
	@if [ -f "$(APPLY_VARS)" ]; then
		echo "Terraform variables: $(APPLY_VARS)";
		$(TFSEC_PATH) --exclude-downloaded-modules --minimum-severity MEDIUM --tfvars-file $(APPLY_VARS) .;
		if [ "$$?" != "0" ]; then exit 1; fi;
	else
		$(TFSEC_PATH) --exclude-downloaded-modules --minimum-severity MEDIUM .;
		if [ "$$?" != "0" ]; then exit 1; fi;
	fi;

	$(GITLEAKS_PATH) detect --no-git --redact;
	if [ "$$?" != "0" ]; then exit 1; fi;

docs : check-terraform-docs ## Use terraform-docs to generate Markdown documentation for a module.
	@$(TFDOCS_PATH) markdown table --sort-by required -c .config/.terraform-docs.yml .;

plan : check-terraform check-tfvars ## Generates a speculative execution plan, showing what actions Terraform would take to apply the current configuration.
	@$(TERRAFORM_PATH) plan -lock=true -input=false -refresh=true -var-file="$(APPLY_VARS)";

plan-target : check-terraform check-tfvars ## Generates a speculative execution plan, showing what actions Terraform would take to apply the current configuration for a particular resource.
	@echo "Example to type for the following question: module.rds.aws_route53_record.rds-master";
	read -p "PLAN target: " DATA && $(TERRAFORM_PATH) plan -lock=false -refresh=true -var-file="$(APPLY_VARS)" -target=$$DATA;

plan-destroy : check-terraform check-tfvars ## Generates a speculative execution plan, showing what actions Terraform would take to destroy the current configuration.
	@$(TERRAFORM_PATH) plan -lock=false -refresh=true -destroy -var-file="$(APPLY_VARS)";

apply : check-terraform check-tfvars lint secure ## Lints, checks security, and then creates or updates infrastructure according to Terraform configuration files in the current directory.
	@$(TERRAFORM_PATH) apply -refresh=true -var-file="$(APPLY_VARS)";

destroy : check-terraform check-tfvars ## Destroy Terraform-managed infrastructure.
	@$(TERRAFORM_PATH) apply -refresh=true -destroy -var-file="$(APPLY_VARS)";

destroy-target : check-terraform check-tfvars ## Destroy a specific Terraform-managed resource. This also destroys chained resources.
	@echo "Example to type for the following question: module.rds.aws_route53_record.rds-master";
	read -p "Destroy target: " DATA && $(TERRAFORM_PATH) apply -refresh=true -destroy -var-file="$(APPLY_VARS)" -target=$$DATA;
