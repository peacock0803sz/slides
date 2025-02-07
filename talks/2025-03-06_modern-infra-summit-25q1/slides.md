---
theme: "../../themes/modern-infra-summit-25q1"
titleTemplate: "Google Cloud で IaC: Terraform 開発と運用のイロハ集"
favicon: https://g-gen.co.jp/favicon.ico
layout: cover
htmlAttrs:
  lang: ja
---

### Google Cloud Modern Infra Summit '25

# Google Cloud で IaC<br />Terraform 開発と運用のイロハ集

## 株式会社G-gen 高井 陽一

---
layout: objective
---

# 本セッションの目的など

- 前提知識: Terraform (HCL) 文法やコマンドの基礎的な理解
    - ある程度 [Provider 公式ドキュメント](https://registry.terraform.io/providers/hashicorp/google/latest/docs)が読める前提
- 対象者: **Terraform 構築・運用の知見が不足** している人
    - 想定ロール: IaC をやりたいインフラ開発者・情報システム担当者など
- 目的・持ち帰って欲しいこと
    - Terraform で IaC 開発を進めるための設計・構築ノウハウ
    - 実際に Terraform を運用する際の知見

---
layout: section-blue
---

# 開発編

## 実装のアンチパターン集

---

# `.tfstate` ファイルの保存先 (バックエンド)

たとえ **開発者が一人でも Cloud Storage (GCS) の使用を推奨**  

(\+ [Google Cloud Storage は 状態ロックをサポート](https://developer.hashicorp.com/terraform/language/state/locking)している)

## 主な理由・メリット

- Cloud Storage の機能で復元が可能
- 複数人での開発へ移行するコストが低い
    - **CI/CD** (Cloud Build / GitHub Actions) **も容易** に構成可能

---

# 実際の `backend` ブロックの記述例[^1]

```hcl
// backend.tf
terraform {
  backend "gcs" {
    bucket = "my-project" // 必須
    prefix = "tfstate"    // 任意
  }
}
```

[^1]: [Backend block > gcs | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/language/backend/gcs)

---

# Google Cloud API の有効化を待つ (Bad 例)

```hcl{all|2-6|8|all}
// compute_engine.tf
resource "google_project_service" "compute_api" {
  project            = "my-project"
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_instance" "bastion" { } // 引数略
```

=> !?!?

```
Error: Error creating: googleapi: Error 403: API has not been used
                                  in project before or it is disabled.
```

---

# Google Cloud API の有効化を待つ (Good 例)

## 結局どうすれば良かったのか

Google Cloud API を有効化した直後にリソースを作成すると失敗する[^1]ので、  
有効化した後に **`time_sleep` [^2]を使用して少し待機させる** 必要がある <twemoji-light-bulb />  
**\+ `depends_on` [^3]で依存関係を明示的に指定** する

[^1]: [User Guide - google_project_service > Newly activated service errors | google provider (Terraform Registry)](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/google_project_service#newly-activated-service-errors)

[^2]: [time_sleep (Resource) | time provider (Terraform Registry)](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep)

[^3]: [The depends_on Meta-Argument | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)

---

# Google Cloud API の有効化を待つ (Good 例)

```hcl{all|2|4-8|6|9-12|11|all}
// compute_engine.tf
resource "google_project_service" "compute_api" { } // 引数略

resource "time_sleep" "wait_3m" {
  create_duration = "3m"
  depends_on      = [google_project_service.compute_api]
}

resource "google_compute_instance" "bastion" {
  // name, machine_type など、必要な引数
  depends_on = [time_sleep.wait_3m]
}
```

---

# リソース宣言で `count` 引数を避ける

## 何がダメなのか

- 繰り返しリソース作成する際に **`count.index` も使っている場合は危険信号[^1]**
    - (`for_each` は Terraform 0.13 頃に追加された機能だったので、古いコードでは稀にある)
- リソースの state 名が `resource_name[count.index]` の形式で作られてしまうため
    - 例: `google_compute_instance[0]`, `google_project_service[2]` など
- => リソースを増減する際に **インデックスずれが発生、大量に再作成** される

[^1]: [The count Meta-Argument > When to Use `for_each` Instead of `count` | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/language/meta-arguments/count#when-to-use-for_each-instead-of-count)

---
layout: code
---

# `count` 引数を避ける (Bad 例)


```hcl{all|5-10|7-8|all}
locals {
  zones = ["asia-northeast1-b", "asia-northeast1-c"]
}

resource "google_compute_instance" "bastion" {
  count = 2

  name = "bastion-${count.index + 1}"
  zone = local.zones[count.index]
  // 他 machine_type など
}
```

---
layout: code
---

# `count` 引数を避ける (Bad 例・変更後)


```hcl{all|2}
locals {
  zones = ["asia-northeast1-b", "asia-northeast1-c"]
}

resource "google_compute_instance" "bastion" {
  count = 2

  name = "bastion-${count.index + 1}"
  zone = local.zones[count.index]
  // 他 machine_type など
}
```

---
layout: code
---

# `count` 引数を避ける (Bad 例・出力)

```{all|3-9}
$ terraform plan
... (ここから抜粋)
  # google_compute_instance.bastion[0] must be replaced
-/+ resource "google_compute_instance" "bastion" {
        name = "bastion-1"
      ~ zone = "asia-northeast1-b" -> "asia-northeast1-a" # forces replacement
    }

  # google_compute_instance.bastion[1] も zone が "asia-northeast1-b" になる
... (ここまで抜粋)

Plan: 2 to add, 0 to change, 2 to destroy.
```

**!?!? <twemoji-thinking-face  />**

<!--
あれっ。実行計画を見るとなぜか2つとも作成しなおしてしまうようです。

どうしてでしょう。お気づきの方はいますか？<切り替え>
-->

---
layout: code
---

# どうしてこうなったのか 

(コード再掲)

```hcl{8-9}
locals {
  zones = ["asia-northeast1-b", "asia-northeast1-c"]
}

resource "google_compute_instance" "bastion" {
  count = 2

  name = "bastion-${count.index + 1}"
  zone = local.zones[count.index]
  // 他 machine_type など
}
```

<!--
はい、そうです。引数でindexを参照しているため、ズレている引数が変更不可能な場合は
-->

---
layout: code
---

# `count` より `for_each` (Good 例)

```hcl{all|5-10|7-8|all}
locals {
  bastions = {
    "bastion-1" = { zone = "asia-northeast1-b" }
    "bastion-2" = { zone = "asia-northeast1-a" }
  }
}

resource "google_compute_instance" "bastion" {
  for_each = local.bastions

  name = each.key
  zone = each.value.zone
}
```

---
layout: code
---

# `count` より `for_each` (Good 例・出力)

```{1-3|2-3|5-14|10|all}
$ terraform state list
google_compute_instance.bastion["bastion-1"]
google_compute_instance.bastion["bastion-2"]

$ terraform plan
... (ここから抜粋)
  # google_compute_instance.bastion["bastion-2"] must be replaced
-/+ resource "google_compute_instance" "bastion" {
        name = "bastion-2"
      ~ zone = "asia-northeast1-c" -> "asia-northeast1-a" # forces replacement
    }
... (ここまで抜粋)

Plan: 1 to add, 0 to change, 1 to destroy.
```

---

# 命名アンチパターン(リソース編)

```hcl
resource "resouce_type" "ここの命名規則の話" {}
```

- 大原則: **名詞形** を使う (形容詞で装飾する場合も、自然な名詞になるように)
- `kebab-case` ではなく `snake_case` を使う
- 同じリソース定義が1つの場合は `main` や `default` を使う
    - 複数ある場合は意味のある名前を使う (マジックナンバーを避ける)
- 単数形を使い、リソースの型 (Type) 名を繰り返さない

参考: [一般的なスタイルと構造に関するベスト プラクティス > 命名規則を採用する | Terraform on Google Cloud ガイド](https://cloud.google.com/docs/terraform/best-practices/general-style-structure?hl=ja#naming-convention)

---
layout: code
---

# 命名アンチパターン(リソース編): 実例

## <twemoji-thumbs-up /> GOOD / 推奨

```hcl
resource "google_compute_instance" "web_primary" {}
resource "google_compute_instance" "sql_proxy" {}
resource "google_service_account" "main" {}
```

## <twemoji-thumbs-down /> BAD / 非推奨

```hcl
resource "google_compute_instance" "ComputeEngine-Web1" {}
resource "google_compute_instance" "ComputeEngine-SQLProxy" {}
resource "google_service_account" "ServiceAccount-VerySpecialName" {}
```

---

# 命名ベストプラクティス: モジュール編

- 大原則: **Google Cloud のプロダクト単位でモジュールを作成**
    - `modules/vm` ではなく `modules/compute_engine`
- 単純なリソース定義であれば Google Cloud 提供モジュールではなく自作してしまう
    - 複雑で Google Cloud で提供されているモジュールを使用する例: ロードバランサ

---

# HCL はあくまで DSL: 過度な抽象化は禁物

- <twemoji-thumbs-down /> 過度な抽象化の例
    1. 抽象化の必要がない値まで変数に切り出している
    1. モジュール定義側で巨大な `list` や `map` 型の変数を受け取って `for_each` で回している
- <twemoji-thumbs-up /> 現実的な落し所
    1. ハードコートしても構わない引数はモジュール定義側でベタ書きする
    1. モジュール **定義側では単一のリソースのみ** を宣言する
        1. 必要な要素(リソースに渡す引数)ごとに `variables.tf` に書き、使用する場所で繰り返す

---
layout: section-green
---

# 運用編

## 転ばぬ先の Tips あれこれ

---

# 自動デプロイの責務分割

## Question

Cloud Run / GKE で自動デプロイ (Cloud Build / GitHub Actions) の Terraform 管理すべきか? <twemoji-thinking-face />  
=> イメージ更新 + 反映のためにコード更新して `terraform apply` はイマイチそう <twemoji-face-with-monocle />

## Answer

Terraform 側では最終的な **イメージ名や sha256 ハッシュを指定しない**  
= Build & Push 後に更新(イメージ指定)だけ実施するような自動デプロイを構成[^1]

[^1]: [プルリクエストをトリガとするCloud Runのプレビュー環境自動デプロイを実装してみた | G-gen Tech Blog](https://blog.g-gen.co.jp/entry/deploy-preview-using-cloud-run-tagged-revision)

---
layout: code
---

# 自動デプロイの責務分離: Terraform

```hcl{all|5-8|10-12}
resource "google_cloud_run_v2_service" "backend" {
  name     = "my-project-backend"
  location = "asia-northeast1"
  template {
    containers {
      image = "gcr.io/cloudrun/hello"
      // ports, env, volume_mounts など
    }
  }
  lifecycle {
    ignore_changes = [client, client_version, template[0].containers[0].image]
  }
}
```

---
layout: code
---

# 自動デプロイの責務分離: Cloud Build

```yaml{all|5-8|9-12}
steps:
  - name: gcr.io/cloud-builders/docker
    args: ["build", "-t", "$_REPO:$_SHORT_SHA", "...(中略)", "."]
    id: build
  - name: gcr.io/cloud-builders/docker
    args: ["push", "$_REPO:$_SHORT_SHA"]
    id: push
    waitFor: ["build"]
  - name: gcr.io/cloud-builders/gcloud-slim
    args: ["run", "deploy", "$_SERVICE", "--image", "$_REPO:$_SHORT_SHA"]
    id: deploy
    waitFor: ["push"]
substitutions:
  _IMAGE_REPO: asia-northeast1-docker.pkg.dev/my-project/backend/runner
  _SERVICE: my-project-backend
```

---

# 勝手にリソース変更された!? でも慌てないで

勝手に **コンソールでリソースの一部を変更** されてしまい、Apply でコケる <twemoji-fearful-face />  
リソースの一部 = GCE のマシンタイプや Cloud Run の環境変数など

## 対応方法

1. 一旦対象のリソースを `terraform state rm` で管理下から外す
1. Terraform コードの該当箇所を修正
1. 管理下から外したリソースを `terraform import` で戻す
1. 再度 `terraform plan` で差分に問題ないことを確認

---

# リファクタリングへの苦手意識をなくすには

## よくある不安

命名ベストプラクティスに則っていても **リファクタリングは避けられない**  
でも、実際にリファクタリング実行するのが怖い <twemoji-fearful-face />

## 解決策

**`terraform state mv` [^1]を理解** する。tfstate 内の **アドレス名を変える**

[^1]: [Manage resources in Terraform state > Move a resource to a different state file | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/tutorials/state/state-cli#move-a-resource-to-a-different-state-file)

---
layout: code
---

# `terraform state mv` を理解する

```
$ git diff compute_engine.tf
@@ -4,7 +4,7 @@

-resource "google_compute_instance" "bastion" {
+resource "google_compute_instance" "default" {
   for_each = local.bastions

$ terraform plan
... (中略、以下抜粋)
  # google_compute_instance.bastion["bastion-1"] will be destroyed
  # google_compute_instance.default["bastion-1"] will be created

Plan: 1 to add, 0 to change, 1 to destroy.
```

---
layout: code
---

## 実際に tfstate のアドレスを移動させる <twemoji-delivery-truck />

```{all|1-2|4-9}
$ terraform state list
google_compute_instance.bastion["bastion-1"]

$ terraform state mv \
    'google_compute_instance.bastion["bastion-1"]' \
    'google_compute_instance.default["bastion-1"]'
Move "google_compute_instance.bastion[\"bastion-1\"]"
  to "google_compute_instance.default[\"bastion-1\"]"
Successfully moved 1 object(s).
```

---
layout: code
---

## 移動後 <twemoji-party-popper />

```
$ terraform state list
google_compute_instance.default["bastion-1"]

$ terraform plan
... (中略)
No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration
  and found no differences, so no changes are needed.
```

---

# コードレビューを快適に実施するために

## 悩み・課題

アプリケーション開発と同じように静的解析などを CI 実行させたいが、どんなのが良いか? <twemoji-face-with-monocle />

## 答え: 標準コマンド編

- コード整形 (Formatter): 標準コマンド `terraform fmt` [^1]
- HCL の構文チェック: 標準コマンド `terraform validate` [^2]

[^1]: [Terraform CLI > Command: validate | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/cli/commands/validate)
[^2]: [Terraform CLI > Command: fmt | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/cli/commands/fmt)

---

## 答え: サードパーティー OSS 編

- 静的解析 (Linter): tflint[^1]
    - 実際は `reviewdog/action-tflint`(<https://github.com/reviewdog/action-tflint>) を使用
- セキュリティチェック: tfsec[^2]
    - 実際は `reviewdog/action-tfsec` (<https://github.com/reviewdog/action-tfsec>) を使用
- Plan 結果の整形・プレビュー通知: tfcmt[^3]

[^1]: <https://github.com/terraform-linters/tflint>
[^2]: <https://github.com/aquasecurity/tfsec>
[^3]: <https://github.com/suzuki-shunsuke/tfcmt>

---
layout: code
---

## GHA 実装例: `terraform fmt` / `validate`

```yaml
jobs:
  validate-fmt:
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: ${{ env.TERRAFORM_VERSION }}

      - run: terraform validate .
      - run: terraform fmt -recursive -check -diff .
```

---
layout: code
---

## GHA 実装例: tflint / tfsec

```yaml{all|2|6-10|12-14|15-16}
jobs:
  tflint:
    permissions: {contents: read, id-token: write, pull-request: write}
    steps:
      # actions/checkout, hashicorp/setup-terraform を先程同様に
      - uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ env.WORKLOAD_IDENTITY_PROVIDER }}
          service_account: ${{ secrets.SERVICE_ACCOUNT }}

      - run: terraform init
        working-directory: ${{ env.TARGET_DIR }}

      - uses: reviewdog/action-tflint@v1  # tflint の場合
        with: {reporter: github-pr-review, filter_mode: nofilter, tflint_rulesets: google}
```

---
layout: code
---

## GHA 実装例: tfcmt

```yaml
  tfcmt:
    permissions: {contents: read, id-token: write, pull-request: write}
    steps:
      # google-github-actions/auth まで先程同様
      - name: tfcmt
        working-directory: ${{ env.TARGET_DIR }}
        run: |
          export GITHUB_TOKEN=${{ secrets.GITHUB_TOKEN }} && mkdir .bin/ && cd .bin
          wget https://github.com/suzuki-shunsuke/tfcmt/releases/download/${{ env.TFCMT_VERSION }}/tfcmt_linux_amd64.tar.gz
          tar -zxf tfcmt_linux_amd64.tar.gz
          cd ..
          terraform init
          ./.bin/tfcmt -log-level=debug plan -- terraform plan
```

---
layout: refs
---

# 再掲: 参考リンク集 (1/2)

- [Terraform provider for Google Cloud | Terraform Registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Backend block > gcs | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/language/backend/gcs)
- [User Guide - google_project_service > Newly activated service errors | google provider (Terraform Registry)](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/google_project_service#newly-activated-service-errors)
- [The count Meta-Argument > When to Use `for_each` Instead of `count` | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/language/meta-arguments/count#when-to-use-for_each-instead-of-count)
- [一般的なスタイルと構造に関するベスト プラクティス > 命名規則を採用する | Terraform on Google Cloud ガイド](https://cloud.google.com/docs/terraform/best-practices/general-style-structure?hl=ja#naming-convention)
- [プルリクエストをトリガとするCloud Runのプレビュー環境自動デプロイを実装してみた | G-gen Tech Blog](https://blog.g-gen.co.jp/entry/deploy-preview-using-cloud-run-tagged-revision)
- [Manage resources in Terraform state > Move a resource to a different state file | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/tutorials/state/state-cli#move-a-resource-to-a-different-state-file)

---
layout: refs
---

# 再掲: 参考リンク集 (2/2)

- [Terraform CLI > Command: validate | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/cli/commands/validate)
- [Terraform CLI > Command: fmt | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/cli/commands/fmt)
- [Repository: `terraform-linters/tflint` | GitHub](https://github.com/terraform-linters/tflint)
- [Repository: `reviewdog/action-tflint`](https://github.com/reviewdog/action-tflint)
- [Repository: `aquasecurity/tfsec` | GitHub](https://github.com/aquasecurity/tfsec)
- [Repository: `reviewdog/action-tflint`](https://github.com/reviewdog/action-tflint)
- [Repository: `suzuki-shunsuke/tfcmt` | GitHub](https://github.com/suzuki-shunsuke/tfcmt)

---

# Thank You
