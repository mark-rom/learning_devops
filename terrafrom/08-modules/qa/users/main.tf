module "user" {
  source = "../../terraform-modules/users"
  # pass the variable value related to current environment
  environment = "qa"
}