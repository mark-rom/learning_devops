To use specific backend instead of default local backend Terraform project should be initialized the following way

```terraform
terraform init -backend-config="./state.config"
```

```terraform
# show current terraform env
terraform workspace show
# create new terraform env
terraform workspace new <env-name>
# select an existing env
terraform workspace select default
# list all existing envs
terraform workspace list
```