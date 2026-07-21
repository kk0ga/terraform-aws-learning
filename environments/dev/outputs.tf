output "ssm_parameter_arn" {
  description = "ARN of the development SSM parameter"
  value       = module.ssm_parameter.arn
}