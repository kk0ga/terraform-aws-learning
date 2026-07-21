module "ssm_parameter" {
  source = "../../modules/ssm-parameter"

  name  = var.parameter_name
  tags  = local.common_tags
  value = var.parameter_value
}