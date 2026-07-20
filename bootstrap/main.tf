// S3 への平文 HTTP アクセスを明示的に拒否する。
data "aws_iam_policy_document" "terraform_state" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.terraform_state.arn,
      "${aws_s3_bucket.terraform_state.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.state_bucket_name
  # state オブジェクトが残っている限り、バケットごと破棄しない。
  force_destroy = false

  lifecycle {
    # Terraform からの誤削除を plan 時点で止める。
    prevent_destroy = true
  }

  tags = {
    Name      = "Terraform State"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.terraform_state.json
}

// state には機微な情報が入りうるため、公開設定を全面的に無効化する。
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// バケット設定として暗号化を明示し、設定差分を Terraform で検知できるようにする。
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// 過去の state を復旧できるようにバージョニングを必須化する。
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}