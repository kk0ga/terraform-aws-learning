# terraform-aws-learning
Terraformを基礎から学ぶためのハンズオン・検証用リポジトリ。サンプルコードや実践的な構成を通してIaCを学習します。

## ディレクトリ構成

```text
terraform-aws-learning/
├── bootstrap/        # state保存用S3バケットを管理
└── infrastructure/   # 実際のAWSリソースを管理
```

## bootstrap

bootstrap は Terraform state を保存するためのS3バケットを管理します。初回はローカルstateで適用し、バケット作成後に同じバケットへ state を移行します。

含めている保護設定:

- S3 Versioning
- SSE-S3 によるデフォルト暗号化
- Block Public Access
- TLS 以外のアクセス拒否
- `force_destroy = false`
- `lifecycle.prevent_destroy = true`

### 初回作成

1. bootstrap 用の backend 設定ファイルを作成します。
2. backend を無効化してローカルstateで初期化します。
3. plan と apply で state バケットを作成します。

```bash
cd bootstrap
cp backend.hcl.example backend.hcl
terraform init -backend=false
terraform plan
terraform apply
```

### bootstrap state の移行

バケット作成後に bootstrap 自身のstateも同じS3へ移行します。

```bash
terraform init -migrate-state -backend-config=backend.hcl
```

bootstrap 側では以下を固定しています。

- bucket = terraform-aws-learning-state
- key = bootstrap/terraform.tfstate
- region = ap-northeast-1
- encrypt = true
- use_lockfile = true

## infrastructure

infrastructure は通常のAWSリソースを管理します。現状は学習用の SSM Parameter だけを含みます。

### 初期化

1. bootstrap で作成した state バケット名を backend 設定へ記入します。
2. S3 バックエンドを初期化します。

```bash
cd ../infrastructure
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

設定例:

```hcl
bucket = "your-terraform-state-bucket"
```

infrastructure 側では以下を固定しています。

- key = terraform-aws-learning/terraform.tfstate
- region = ap-northeast-1
- encrypt = true
- use_lockfile = true

## 補足

- bootstrap と infrastructure は同じS3バケットを使い、key を分けて state を分離します。
- 学習用途のため暗号化は SSE-S3 を採用し、SSE-KMS や DynamoDB locking は含めていません。
- 既存のローカル state ファイルは自動では移動しません。必要なら対象ディレクトリで `terraform init -migrate-state` を使って移行してください。
