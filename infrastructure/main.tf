// backend 分離後も動作確認しやすいよう、最小の学習用リソースを残している。
resource "aws_ssm_parameter" "example" {
  name  = "/sandbox/example-message"
  type  = "String"
  value = "hello-from-terraform"
  tier  = "Standard"
}