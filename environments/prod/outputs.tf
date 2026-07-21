output "ssm_parameter_arn" {
  description = "ARN of the production SSM parameter"
  value       = module.ssm_parameter.arn
}