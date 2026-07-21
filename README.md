# terraform-aws-learning
Terraformを基礎から学ぶためのハンズオン・検証用リポジトリ。サンプルコードや実践的な構成を通してIaCを学習します。

## ディレクトリ構成

```text
terraform-aws-learning/
├── bootstrap/                 # state 保存用 S3 バケットを管理
├── environments/
│   ├── dev/                   # 開発環境の root module
│   └── prod/                  # 本番環境の root module
├── modules/
│   └── ssm-parameter/         # 環境共通の SSM Parameter module
└── infrastructure/            # dev state 移行専用の旧構成
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
terraform init -backend=false
terraform plan
terraform apply
```

### bootstrap state の移行

バケット作成後に bootstrap 自身のstateも同じS3へ移行します。

```bash
terraform init -migrate-state
```

bootstrap 側では以下を固定しています。

- bucket = terraform-aws-learning-state
- key = bootstrap/terraform.tfstate
- region = ap-northeast-1
- encrypt = true
- use_lockfile = true

## environments

dev と prod は、それぞれ独立した S3 backend key と Terraform state を持ちます。共通の AWS リソース定義は `modules/` に置き、各環境は module の入力値と環境固有のタグだけを定義します。

| 環境 | S3 backend key | SSM Parameter |
| --- | --- | --- |
| dev | `infrastructure/dev/terraform.tfstate` | `/sandbox/example-message` |
| prod | `infrastructure/prod/terraform.tfstate` | `/prod/example-message` |

### dev

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### prod

```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

`terraform.tfvars` にはサンプル値のみを保持します。機密値を扱う場合は、値をリポジトリへ保存せず、CI/CD のシークレットや安全な変数配布手段を使用してください。

## 既存 infrastructure state の dev への移行

既存の `/sandbox/example-message` は dev 環境へ引き継ぎます。先に移行を実施してから dev を apply してください。

1. 旧 backend の state を dev 用 key へ移します。実行時に state 移行を確認するプロンプトが出たら承認します。

```bash
cd infrastructure
terraform init -migrate-state \
	-backend-config="bucket=terraform-aws-learning-state" \
	-backend-config="key=infrastructure/dev/terraform.tfstate" \
	-backend-config="region=ap-northeast-1" \
	-backend-config="encrypt=true" \
	-backend-config="use_lockfile=true"
```

2. dev root module を初期化し、移行結果を確認します。`moved` ブロックにより、SSM Parameter は再作成されず module 配下の address へ移動します。

```bash
cd ../environments/dev
terraform init
terraform plan
```

plan に SSM Parameter の destroy/create が含まれないことを確認してから apply してください。

移行完了後の `infrastructure/` は実行しないでください。state を dev key へ移した後に旧構成を apply すると、同じ Parameter を重複管理しようとします。

## 検証

リモート backend を使用せず構文を検証するには、各ディレクトリで次を実行します。

```bash
terraform fmt -check -recursive

cd modules/ssm-parameter
terraform init -backend=false
terraform validate

cd ../../environments/dev
terraform init -backend=false
terraform validate

cd ../prod
terraform init -backend=false
terraform validate
```

## 補足

- bootstrap、dev、prod は同じ S3 バケットを使い、key を分けて state を分離します。
- 学習用途のため暗号化は SSE-S3 を採用し、SSE-KMS や DynamoDB locking は含めていません。
- 既存の state は自動では移動しません。dev へ移行する場合は上記の `terraform init -migrate-state` を使用してください。
