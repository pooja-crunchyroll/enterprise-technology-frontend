<!-- BEGIN_TF_DOCS -->
# Repository: gcp-live-et-template-infra

GitHub: [Crunchyroll-ET/gcp-live-et-databricks-infra](https://github.com/Crunchyroll-ET/gcp-live-et-template-infra)

## Notes
* Manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml .`

## Assumptions we make
* We assume a basic knowledge of Terraform
* We assume you know how to switch TF states to new environments
* We assume that if you find something wrong or have an improvement you will submit a PR and run terraform-docs
* **Most importantly, we assume that you have read this README file**

## Standards we assume
* Follow the Terraform standards outlined [here](https://www.terraform-best-practices.com/code-structure) for code structure conventions
* Follow the Terraform standards outlined [here](https://www.terraform-best-practices.com/naming) for resource naming conventions
* Use a `providers.tf` file for provider specific information

## Documentation for Generic Files
### `README.md`
* The file you are reading! I'm always updated via TF Docs `.config/.terraform-docs.yml`

### `.gitignore`
* This is your gitignore, and contains a slew of default standards

### `.config/.terraform-docs.yml`
* This file auto generates your `README.md` file

## Documentation for Terraform Files & Folders
### `.terraform`
* Exists after a successful `terraform init`
* Delete this folder and then run another `terraform init` when switching environments

### `data.tf`
* This data file contains all references for data providers, these are fairly generic

### `provider.tf`
* This file contains the necessary provider(s) and there configurations

### `state.tf`
* The Crunchyroll-ET standard for Terraform remote state management

### `variables.tf`
* All variables related to this repo for all facets

### `outputs.tf`
* Makes information about your infrastructure available on the command line

### `versions.tf`
* This file contains the required Terraform versions, as well as the required providers and their versions

### `.terraform.lock.hcl`
* This file contains the hashes of the Terraform providers and modules we're using

# How to Run Terraform Against GCP
## Tutorial
If you have never run against GCP before, you will need to install gcloud in your local machine. Mac users can do this using using brew (view the [official docs](https://cloud.google.com/sdk/docs/install-sdk) for more info):
```
brew install google-cloud-sdk
```

Then, you will need to configure the CLI by executing the following command and answering its questions:
```
gcloud init
```

Next, you authenticate against GCP. This will open a browser window and ask for access:
```
gcloud auth login
```

Ensure you are in the right GCP project by running the following command. For most projects, the project ID should be the root GCP project, `cr-et-core`:
```
gcloud config set project cr-et-core
```

Last, generate the application-default credentials for Terraform to use:
```
gcloud auth application-default login
```

## GCP Command Summary
Below is a easy-access place for the GCP commands you'll need:
```
brew install google-cloud-sdk
gcloud init
gcloud auth login
gcloud config set project GCP_PROJECT_ID
gcloud auth application-default login
```

# Environment Commands
## SBX (PROJECT_NAME)
### Commands
```shell
terraform init -backend-config=./init-tfvars/sbx.tfvars
terraform plan -var-file ./apply-tfvars/sbx.tfvars
terraform apply -var-file ./apply-tfvars/sbx.tfvars
```
## DEV (PROJECT_NAME)
### Commands
```shell
terraform init -backend-config=./init-tfvars/dev.tfvars
terraform plan -var-file ./apply-tfvars/dev.tfvars
terraform apply -var-file ./apply-tfvars/dev.tfvars
```
## STG (PROJECT_NAME)
### Commands
```shell
terraform init -backend-config=./init-tfvars/stg.tfvars
terraform plan -var-file ./apply-tfvars/stg.tfvars
terraform apply -var-file ./apply-tfvars/stg.tfvars
```
## PRD (PROJECT_NAME)
### Commands
```shell
terraform init -backend-config=./init-tfvars/prd.tfvars
terraform plan -var-file ./apply-tfvars/prd.tfvars
terraform apply -var-file ./apply-tfvars/prd.tfvars
```
---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.50 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.48 |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name_prefix"></a> [application\_name\_prefix](#input\_application\_name\_prefix) | String to use as prefix on object names | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to target | `string` | `"us-east-1"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Name of the Cost Center to associate to this GCP resource | `string` | n/a | yes |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name string to be used for decisions and name generation | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GCP region to target | `string` | `"us-west1"` | no |
| <a name="input_management_team"></a> [management\_team](#input\_management\_team) | Name of the team managing this GCP resource | `string` | n/a | yes |
| <a name="input_source_org"></a> [source\_org](#input\_source\_org) | name of org which holds this repository | `string` | `"crunchyroll-et"` | no |
| <a name="input_source_repo"></a> [source\_repo](#input\_source\_repo) | name of repo which holds this code | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_name_prefix"></a> [application\_name\_prefix](#output\_application\_name\_prefix) | string to prepend to all resource names |
| <a name="output_aws_account_id"></a> [aws\_account\_id](#output\_aws\_account\_id) | Account which terraform was run on |
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | AWS Region to target |
| <a name="output_gcp_region"></a> [gcp\_region](#output\_gcp\_region) | GCP Region to target |

---
<!-- END_TF_DOCS -->