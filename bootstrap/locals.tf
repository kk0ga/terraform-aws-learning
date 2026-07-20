locals {
  # 学習用に固定名を使う。実運用では account ID などを含めて一意性を確保する。
  state_bucket_name = "terraform-aws-learning-state"
}