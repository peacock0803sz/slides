---
theme: "./"
titleTemplate: "Google Cloud で IaC: Terraform 開発と運用のイロハ集"
favicon: https://g-gen.co.jp/favicon.ico
layout: cover
htmlAttrs:
  lang: ja
---

# Google Cloud で IaC

## Terraform 開発と運用のイロハ集

### Mar 6, 2025<br />株式会社G-gen<br />高井 陽一

---
layout: toc
---

# 目次

1. 自己紹介、本セッションの目的・対象者
1. 開発編: 実装のアンチパターンあれこれ
1. 運用編: 焦らずトラブルシューティング
1. まとめ・参考文献など

---
layout: profile
---

::profile::

- X (Twitter) など各種 SNS: `peacock0803sz`
- 入社: 2022 年 12 月 (合併前の株式会社トップゲート)
- 受賞歴
    - [Partner Tech Blog Challenge (2023 年度)](https://cloud.google.com/blog/ja/topics/partners/google-cloud-partner-tech-blog-challenge-2023-winners?hl=ja)
    - [Partner Top Engineer 2025 (Serverless App Dev)](https://g-gen.co.jp/news/pte_2025.html)
- 以前は様々な規模の IaC (Terraform) 案件へ参画
- アプリケーション開発では Python をよく使用 (たまに Go)
- 業務外では PyCon JP などのイベント運営活動など

::affiliation::

<img src="https://media.p3ac0ck.net/icons/PyConAPAC2023.jpg" />

## 高井 陽一

クラウドソリューション部  
クラウドサポート課

---
layout: objective
---

# 本セッションの目的など

- 前提知識: Terraform (HCL) 文法やコマンドの基礎的な理解
    - ある程度 [Provider 公式ドキュメント](https://registry.terraform.io/providers/hashicorp/google/latest/docs)が読める前提
- 対象者: **Terraform 構築・運用の知見が不足** している人
    - 想定ロール: IaC をやりたいインフラ開発者・情報システム担当者など
- 動機・背景: 大規模かつ、複数人が関わった IaC 開発案件で得たノウハウの共有
    - 案件例 1: Cloud Run を活用したデプロイ頻度が高いアプリケーション基盤の開発
    - 案件例 2: 短期で数百規模の Google Cloud リソースを Terraform を使用して作成
- 持ち帰って欲しいこと
    - Terraform で IaC 開発を進めるための設計や構築に関するベストプラクティス
    - 実際に Terraform コードを運用する際の知見

<!--
まず始めに、本セッションの前提知識と対象者、持ち帰ってほしいことは次のとおりです。
-->

---
layout: objective
---

# IaC / Terraform の導入メリット

- IaC (infrastructure as Code): インフラ構成のコード管理
    - どこの構成をどのように誰が変更したかが分かる
    - 大規模・複雑な要件や複数人で構築する際のコストが低い

## Terraform の強み

- 複数人で開発する際のコストが低い
    - 誰かが操作している時は排他処理(ロック)が走る
- Vagrant で実績のある Hashicorp 社によって開発されている OSS 製品
    - サードパーティ OSS 含め、周辺エコスシテムが充実している
- 一般的な設定言語 (JSON, YAML など)より表現力が高く、汎用プログラミング言語 (Python, JavaScript など)より単純明快な言語 HCL (Hashicorp Configu Language) で記述できる

---
layout: section-blue
---

# 開発編

## 実装のアンチパターン集

<!--
それではさっそく、本編に入っていきたいと思います。  
まずは「開発編」と題して、Terraformコードの設計や実装についてのTipsを紹介していきます。
-->

---

# `.tfstate` ファイルの保存先 (バックエンド)

たとえ **開発者が一人でも Cloud Storage (GCS) の使用を推奨**  

## 主な理由・メリット

- 状態ロック(= 他の人が Terraform を操作できないようにする)が可能
- Cloud Storage の機能で復元が可能
- 複数人での開発へ移行するコストが低い
    - **CI/CD** (Cloud Build / GitHub Actions) **も容易** に構成可能

<!--
最初は何といっても、状態ファイルを保存する先のバックエンドについてです。

一人でインフラ担当という場合も多いかと思いますが、それでも **Cloud Storageを使うことを強く推奨** します。\
端末ロストや移行の際のコストが低いことはもちろん、復元ができたりもします。あとはやはり **複数人で開発する際への移行コスト** だと思っています。\
一人でローカルに置いているとバケット作って、gsutilコマンドでアップロードして、planで差分を確認して...みたいな手間があるので、最初からCloud Storageを使ってしまうのがオススメです。\
-->

---

# 実際の `backend` ブロックの記述例[^1]

```hcl
// backend.tf
terraform {
  backend "gcs" {
    bucket = "my-project"      // 必須
    prefix = "terraform-state" // 任意
  }
}
```

[^1]: [Backend block > gcs | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/language/backend/gcs)

<!--
実際のバックエンド設定はこうなります。バケット名は必須ですが、フォルダ階層を表わすプレフィックスは任意です。  
プレフィックスは、プロジェクトで1つのバケットを使用している場合などで活躍します。
-->

---

# Google Cloud API の有効化を待つ (Bad 例)

```hcl
resource "google_project_service" "compute_api" {
  project            = "my-project"
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_instance" "bastion" { // 引数略
  depends_on = [google_project_service.compute_api]
}
```

=> !?!?

```
Error: Error creating: googleapi: Error 403: API has not been used
                                  in project before or it is disabled.
```

<!--
続いて、また初期構築でハマりがちなAPI有効化した後の403エラーの対処です。  
こんなTerraformを書いて「動かない!?!?」ってなった経験のあるかた、多いんじゃないでしょうか。

2回applyを実行する、というゴリ押し回避策もありますが、全然スマートじゃないですよね。どうすれば良かったのでしょうか。
-->

---

# Google Cloud API の有効化を待つ (Good 例)

## 結局どうすれば良かったのか

Google Cloud API を有効化した直後にリソースを作成すると失敗する[^1] ので、  
有効化した後に **`time_sleep`[^2] を使用して少し待機させる** 必要がある <twemoji-light-bulb />  
**\+ `depends_on`[^3] で依存関係を明示的に指定** する

[^1]: [User Guide - google_project_service > Newly activated service errors | google provider (Terraform Registry)](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/google_project_service#newly-activated-service-errors)

[^2]: [time_sleep (Resource) | time provider (Terraform Registry)](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep)

[^3]: [The depends_on Meta-Argument | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)

<!--
答えはこうです。依存関係を明示しても直後は裏側でAPI有効化の反映がされていなくて、ちょっと待つ必要があるんですよね。
なので「time_sleepを使って待機させる」という操作を明示的に依存にしてやる必要があります。
-->

---

# Google Cloud API の有効化を待つ (Good 例)

```hcl
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

<!--
具体的にはこうなります。まずapi有効化の宣言をしたら、それを待つ`time_sleep`を作ってここでは3分待っています。で実際のリソース作成はそれを依存参照するようにすれば、一発で通るようになるはずです。  
慣れている場合だとモジュール構成にしてやったりもしますが、概要としては同じでモジュールを使用するところに記載してやりましょう。
-->

---

# リソース宣言で `count` 引数を避ける

## 何がダメなのか

- 繰り返しリソース作成する際に **`count.index` も使っている場合は危険信号[^1]**
    - (`for_each` は Terraform 0.13 頃に追加された機能だったので、古いコードでは稀にある)
- リソースの state 名が `resource_name[count.index]` の形式で作られてしまうため
    - 例: `google_compute_instance[0]`, `google_project_service[2]` など
- => リソースを増減する際に **インデックスずれが発生、大量に再作成** される

[^1]: [The count Meta-Argument > When to Use `for_each` Instead of `count` | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/language/meta-arguments/count#when-to-use-for_each-instead-of-count)

<!--
はい、次です。リソース宣言の引数にカウント使っていませんか? 古いコードを引き継ぐと結構遭遇する場合もありますが、今はあんまり使わない方がよいです。  
なぜかというと、ステートのアドレスがカウントのインデックス依存になってしまうからなんですよね。どういうことが起きるか具体的に見ていきましょう。
-->

---
layout: code
---

# `count` 引数を避ける (Bad 例)


```hcl{all|5-10}
locals { // zone の中身を変えたい
  scale         = 2
  zones         = ["asia-northeast1-a", "asia-northeast1-b"]
  machine_types = ["e2-micro", "e2-medium"]
 }

resource "google_compute_instance" "bastion" {
  count = local.scale

  name         = "bastion-${count.index + 1}"
  zone         = local.zones[count.index]
  machine_type = local.machine_types[count.index]
  // 他に boot_disk, network_interface は必要
}
```

<!--
はい、これがよくないコードの例です。踏み台のGCEインスタンスを作成するケースで見ていきましょう。
この引数たちに注目してみてください。次でどうなってしまうか、予想がつく人もいると思います。
-->

---
layout: code
---

# `count` 引数を避ける (Bad 例・変更後)


```hcl{all|2}
locals { // zones を ["asia-northeast1-b", "asia-northeast1-c"] から変更
  scale         = 2
  zones         = ["asia-northeast1-a", "asia-northeast1-b"]
  machine_types = ["e2-micro", "e2-medium"]
 }

resource "google_compute_instance" "bastion" {
  count = local.scale

  name         = "bastion-${count.index + 1}"
  zone         = local.zones[count.index]
  machine_type = local.machine_types[count.index]
  // 他に boot_disk, network_interface は必要
}
```

<!--
実際に変えてみましょう。片方のゾーンをasia-northeast1-cからasia-northeast1-aにしたいだけなんですが、どうなってしまうでしょうか。
-->

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
      ~ machine_type = "e2-medium"
    }

  # google_compute_instance.bastion[1] must be replaced
    // 同様に zone が "asia-northeast1-b" に、machine_type も "e2-medium" になる

Plan: 2 to add, 0 to change, 2 to destroy.
```

**!?!? <twemoji-thinking-face  />**

<!--
なぜか zones だけを変えたはずなのに、machine_typeもかわってしまうようです。
-->

---
layout: code
---

# どうしてこうなったのか (コード再掲)

```hcl{8-12}
locals { // zones を ["asia-northeast1-b", "asia-northeast1-c"] から変更
  scale         = 2
  zones         = ["asia-northeast1-a", "asia-northeast1-b"]
  machine_types = ["e2-micro", "e2-medium"]
 }

resource "google_compute_instance" "bastion" {
  count = local.scale

  name         = "bastion-${count.index + 1}"
  zone         = local.zones[count.index]
  machine_type = local.machine_types[count.index]
  // 他に boot_disk, network_interface は必要
}
```

<!--
カンの良い方々は気づいてるかもしれませんけど、配列のインデックスがズレると大変なことになりますね。\
これは結構単純なパターンですけど、実際にもっと変数が多いと管理が大変になってしまいます。どの配列の何番目の要素が何かを常に把握するのはつらいですね。
-->

---
layout: code
---

# `count` より `for_each` (Good 例)

```hcl{all|2-5|8-13}
locals {
  bastions = {
    "bastion-1" = { zone = "asia-northeast1-b", machine_type = "e2-micro" }
    "bastion-2" = { zone = "asia-northeast1-c", machine_type = "e2-medium" }
  }
}

resource "google_compute_instance" "bastion" {
  for_each = local.bastions

  name         = each.key
  zone         = each.value.zone
  machine_type = each.machine_type
}
```

<!--
これをfor_eachで書くとこうなります。bastionsというmap型を渡して、その中身を展開して複数台つくらせる宣言にします。
-->

---
layout: code
---

# `count` より `for_each` (Good 例・変更後)

```hcl{all|3-5}
locals {
  bastions = {
    "bastion-1" = { zone = "asia-northeast1-a", machine_type = "e2-micro" }  // b から a
    "bastion-2" = { zone = "asia-northeast1-b", machine_type = "e2-medium" } // c から b
  }
}

resource "google_compute_instance" "bastion" {
  for_each = local.bastions

  name         = each.key
  zone         = each.value.zone
  machine_type = each.machine_type
}
```

<!--
変更後はこうなります。\
これはmachine_typeに影響がないことが自明ですよね。
-->

---
layout: code
---

# `count` より `for_each` (Good 例・出力)

```{all|5,6,9|12-}
$ terraform plan
... (ここから抜粋)
  # google_compute_instance.bastion[0] must be replaced
-/+ resource "google_compute_instance" "bastion" {
      // zone だけ差分になる
      ~ zone = "asia-northeast1-b" -> "asia-northeast1-a" # forces replacement
}
  # google_compute_instance.bastion[1] must be replaced
    // 同様に zone だけ "asia-northeast1-b" から "asia-northeast1-c" に

Plan: 2 to add, 0 to change, 2 to destroy.

$ terraform state list
google_compute_instance.bastion["bastion-1"]
google_compute_instance.bastion["bastion-2"]
```

<!--
またplanを見てみましょう。これは期待通りになっているのではないでしょうか。\
これはmachine_typeも引きづられて変わっていないので安心ですね。\
さて、状態のアドレスがどうなっているかを見てみましょうか。さっきのインデックスが数字ではなく文字列になっているのがミソです。めでたしめでたし
-->

---

# リソース命名アンチパターン

```hcl
resource "resouce_type" "ここの命名規則の話" {}
```

- 大原則: **名詞形** を使う (形容詞で装飾する場合も、自然な名詞になるように)
- `kebab-case` (ハイフン区切り) ではなく `snake_case` (アンダースコア区切り)を使う
- 同じリソース定義が1つの場合は `main` や `default` を使い、複数ある場合は意味のある名前
- 単数形を使い、リソースの型 (Type) 名を繰り返さない
    - リソース参照する際には `resouce_type.ここの命名規則の話` のように使われる

参考: [一般的なスタイルと構造に関するベスト プラクティス > 命名規則を採用する | Terraform on Google Cloud ガイド](https://cloud.google.com/docs/terraform/best-practices/general-style-structure?hl=ja#naming-convention)

<!--
命名についても触れておきます。  
まず大前提として、小文字スネークケースの名詞形が基本です。形容詞などで補足しても自然な英語の名詞になるように心掛けましょう。
結構悩まれる方が多いリソース名にmainやdefaultを使うか問題ですが、使っても良い場合の代表的なのは「そのファイルに同じリソースタイプ定義が1つだけ」のときです。  
加えてリソースタイプを繰替えさないことでわかりやすく簡潔な名前になるとおもいます。
繰替えすとダメかというと、参照するときに resouce_type の部分も書くからです。
-->

---
layout: code
---

# リソース命名アンチパターン: 実例

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
<!--
では実際に例をみていきましょう。上が良いパターン、下がダメな方です。  
大文字小文字や単語区切りはもちろん、マジックナンバーとか VerySpecialName みたいなよくわからない名前はやめてください。本当に
アプリケーションを普段書いている人が見ると当たり前かもしれないですけど、案外こういう規則を守るのは大事ですよね。
-->

---

# モジュール設計ベストプラクティス

- 大原則: **Google Cloud のプロダクトカテゴリ単位でモジュール名にする**
    - `modules/vm` や `modules/compute_engine_disk` ではなく `modules/compute_engine`
        - NG 例 1: プロダクトカテゴリ名称ではなく `vm` や `db` のような名前
        - NG 例 2: ただ1リソースの定義 (例: `google_compute_instance`) だけを書いている
- モジュールディレクトリの直下は基本 `main.tf`, `variables.tf`, `outputs.tf` の3ファイルのみ
- 単純なリソース定義で要件を満たせるなら Google Cloud 提供モジュールではなく自作する
    - 複雑で Google Cloud で提供されているモジュールを使用する例: ロードバランサ[^1]

[^1]: [Repository: `terraform-google-modules/terraform-google-lb-http` | GitHub](https://github.com/terraform-google-modules/terraform-google-lb-http)

<!--
つづいて気になっている人も多いモジュール設計・分割の話です。  
以前AWSの話でブログに話題になっていましたが、Google Cloudでも同じことが言えます。
書いてないですが、命名は結構さっきの話と同じだと思っていいです。  
子モジュール(コンポーネント)は作成しないで、必要なら `components/` (モジュール外)へだしましょう。
-->

---
layout: compare
---

# モジュール設計ベストプラクティス (実例)

::left::

## <twemoji-thumbs-up /> GOOD / 推奨

- `environments/dev/`
    - `providers.tf`, `main.tf`, etc...
- `modules/`
    - `compute_engine/`
        - `main.tf`, `variables.tf`, `outputs.tf` (任意)
    - `cloud_sql/` (上記と同様)
    - `vpc_network/` (上記と同様)
- `components/`
    - `subnet/` ( `../compute_engine/` 同様)

::right::

## <twemoji-thumbs-down /> BAD / 非推奨

- `environments/dev/`
    - `providers.tf`, `main.tf`,<br />`DON'T remove.tf`
- `modules/`
    - `VPC_networks/`
        - `subnets/`
            - `main.tf`, `variables.tf`
            - `firewalls/`
                - `allow-ssh.tf`
    - `compute-instances/`
        - `alice.tf`, `bob.tf`

<!--
とても極端ですが、良い例と悪い例を挙げてみました。

DON'T remove.tf なんていうファイルは論外ですが、結構ごちゃごちゃしてしまっていますね。しかも大文字小文字も区切りも揃っていないですね。\
左側は中身も統一
-->

---

# HCL はある種の DSL: 過度な抽象化は禁物

DSL = Domain Specific Language (ドメイン固有言語)の略 ( `Makefile` や `.html` などが含まれる)

- <twemoji-thumbs-down /> 過度な抽象化の例
    1. 抽象化の必要がない値まで変数に切り出している
    1. モジュール定義側で巨大な `list` や `map` 型の変数を受け取って `for_each` で回している
- <twemoji-thumbs-up /> 現実的な落し所
    1. ハードコートしても構わない引数はモジュール定義側でベタ書きする
    1. モジュール定義側では **同じタイプの複数リソースを作成しない**
        1. 必要な要素(リソースに渡す引数)ごとに `variables.tf` に書き、使用する場所で繰り返す

<!--
開発編の最後に、これを言っておきます。

普段アプリケーション書いている人はやりたくなっちゃうかもしれないですけど...\
誤解をおそれず言うと、そんなに表現力の高い言語じゃないのでDon't Repeat Yourselfのしすぎは良くないって話です。
-->

---
layout: g-gen
---

<!--
休憩しつつ弊社についての紹介を掲載しておきます。
-->

---
layout: section-green
---

# 運用編

## 転ばぬ先の Tips あれこれ

<!--
はい、おまたせしました。ここからは実際に運用していくための色々を話せればと思います。
-->

---

# 勝手にリソース変更された!? でも慌てないで

勝手に **コンソールでリソースの一部を変更** されてしまい、Apply でコケる <twemoji-fearful-face />  
リソースの一部 = GCE のマシンタイプや Cloud Run の環境変数など

## 対応方法

1. 一旦対象のリソースを `terraform state rm` で管理下から外す
1. Terraform コードの該当箇所を修正
1. 管理下から外したリソースを `terraform import` で戻す
1. 再度 `terraform plan` で差分に問題ないことを確認

<!--
次もよくある「知らないところでリソース変更された」問題です。

これも落ち着いて対処すれば問題なく、安全に実際の設定を変えることなく更新できます。\
マネージャー層の方々向けに言っておくと、だからといって雑にコンソールで設定変更しちゃダメですよ(苦笑)
-->

---

# 自動デプロイの責務分割

## Question

Cloud Run / GKE で自動デプロイ (Cloud Build / GitHub Actions) の Terraform 管理すべきか? <twemoji-thinking-face />  
=> イメージ更新 + 反映のためにコード更新して `terraform apply` はイマイチそう <twemoji-face-with-monocle />

## Answer

Terraform 側では最終的な **イメージ名や sha256 ハッシュを指定しない**  
= Build & Push 後に更新(イメージ指定)だけ実施するような自動デプロイを構成[^1]

[^1]: [プルリクエストをトリガとするCloud Runのプレビュー環境自動デプロイを実装してみた | G-gen Tech Blog](https://blog.g-gen.co.jp/entry/deploy-preview-using-cloud-run-tagged-revision)

<!--
次に、結構悩んでいる人も多そうな「どこまでTerraformで自動デプロイ管理するか」問題です。

AWS の ECS だと結構認知されてきているような気がしますけど、基本的な考え方は同じです。\
Cloud Run や GKE の構成と、GitHub ActionsとかCloud Buildの自動デプロイを組むところまではTerraformでよいです。\
自動デプロイ側でイメージ名やハッシュは指定できるわけですから、そっち側で注入してやりましょう。
-->

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
<!--
実際のTerraformの方はこうなります。  
ミソはイメージで中身のない単純なもの(cloudrun/hello)とリビジョンを指定しないで、\
バージョンとイメージもTerraformで変更を検知しないように明示することです。
-->


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
<!--
ではCloud Buildの例で自動デプロイの構成をみてみます。

ここもミソはビルド完了を待って、自動的に決定される `$_SHORT_SHA` 変数を使ってプッシュしてから、\
Cloud Runサービス側の更新をかけています。\
こうすることでTerraformでは構成管理だけに集中して、アプリケーションのデプロイという責務と分離させることができます。
-->

---

# リファクタリングへの苦手意識をなくすには

## よくある不安

命名ベストプラクティスに則っていても **リファクタリングは避けられない**  
でも、実際にリファクタリング実行するのが怖い <twemoji-fearful-face />

## 解決策

**`terraform state mv` [^1] を理解** する。tfstate 内の **アドレス名を変える**

[^1]: [Manage resources in Terraform state > Move a resource to a different state file | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/tutorials/state/state-cli#move-a-resource-to-a-different-state-file)

<!--
つづいて、これも苦手というか食わずぎらいしている人も多いリファクタリングです。いくらベストプラクティスまもっていても避けられないです。

ベースの考え方は最初に話した「勝手に変更された」ときと同じです。\
ではひとつずつみていきましょう。
-->

---
layout: code
---

# `terraform state mv` を理解する

```
$ git diff compute_engine.tf
@@ -4,7 +4,7 @@

-resource "google_compute_instance" "VerySpecialName" {
+resource "google_compute_instance" "default" {
   for_each = local.bastions

$ terraform plan
... (中略、以下抜粋)
  # google_compute_instance.VerySpecialName["bastion-1"] will be destroyed
  # google_compute_instance.default["bastion-1"] will be created

Plan: 1 to add, 0 to change, 1 to destroy.
```

---
layout: code
---

## 実際に tfstate のアドレスを移動させる <twemoji-delivery-truck />

```{all|1-3|4-7|9-12}
$ terraform state list
google_compute_instance.VerySpecialName["bastion-1"]
google_compute_instance.VerySpecialName["bastion-2"]

$ terraform state mv \
    'google_compute_instance.VerySpecialName["bastion-1"]' \
    'google_compute_instance.default["bastion-1"]'

... (中略、以下抜粋)
Move "google_compute_instance.VerySpecialName[\"bastion-1\"]"
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

# コードレビュー: よくある課題 1

## フォーマットの指摘

```hcl
resource "google_compute_instance" "bastion" {
  name = "bastion-1"
  zone = "asia-northeast1-b"
  machine_type = "e2-micro"
}
```

レビュワー「イコールの後のスペースは連続行の長いところに揃えなきゃダメじゃない?」  
レビュイー「でも(マージされている)他の場所はこのスタイルでやってますよ <twemoji-face-with-monocle />」

<!--
最後はコードレビューの話です。こんなやりとり、嫌ですよね
-->

---

# コードレビュー: よくある課題 2

## コメントに実行計画 (Plan の差分)を貼って欲しい

レビュワー「`terraform plan` を手元で実行した結果を貼ってください」\
レビュイー「はい、これです (コードブロックを貼る)」\
レビュワー「`google_compute_instance.default["bastion-1"]` の `machine_type` が違うよ」\
レビュイー「(commit, push して) はい、直しました」\
レビュワー「じゃあまた `terraform plan` を手元で実行した結果を貼ってくれる?」

**=> 両者「面倒なコメント往復だな...」**

<!--
このplan差分を一々出すのも面倒ですよね。しかも結果をコピペして目視確認ヨシ! ってなんか前時代的ですよね。
-->
---

# コードレビュー: あるべき姿は?

アプリケーション開発と同じように **フォーマット確認、静的解析などを CI で実行**\
\+ **Plan の差分も自動的に出力** できればベストでは...?

## 答え: 標準コマンド編

- コード整形 (Formatter): 標準コマンド `terraform fmt` [^1]
- HCL の構文チェック: 標準コマンド `terraform validate` [^2]

[^1]: [Terraform CLI > Command: validate | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/cli/commands/validate)
[^2]: [Terraform CLI > Command: fmt | Terraform (Hashcorp Developer)](https://developer.hashicorp.com/terraform/cli/commands/fmt)

<!--
そうです。現代の我々はCI/CDという利器がありますから、これを使っていけばいいんです。\
ご存知の方々もいると思いますが、標準コマンドでもフォーマット実行と基本的な文法チェックをしてくれるんですよね。
-->

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

<!--
アプリケーション畑の人なら、もっと高度に静的解析したりしたいと思うかもしれません。それもできます。\
それにセキュリティ的にまずいことをやっていないかという検出もできます。\
具体的な例はあとで紹介しますが、デフォルト サービスアカウントに強い権限渡しちゃっているとかを教えてくれます。
-->

---
layout: compare
---

# 実際の動作例スクショ

::left::

## tfsec

<img src="/tfsec.png" />

::right::

## tfcmt

<img src="/tfcmt.png" />

<!--
ちょっとtfsecとtfcmtはイメージつきにくいと思うので分かりやすい実際の動作例スクショを貼っておきます。
こんな感じでtfsecのほうはプルリクにレビューしてくれて、tfcmtのほうはコメントで計画を教えてくれます。
-->

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

```yaml
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
layout: blog
---

<img src="/blog.png" />

# G-gen Tech Blog: <https://blog.g-gen.co.jp>

本セッションの **解説記事も後日公開予定**

## 関連記事

- <img src="/create-direct-workload-identity-for-gha-terraform.png" />[Google CloudとGitHub Actions(Terraform)を連携するDirect Workload Identityを作成するbashスクリプト (2024-12-11)](https://blog.g-gen.co.jp/entry/create-direct-workload-identity-for-gha-terraform)
- <img src="/using-terraform-via-github-actions.png" />[GitHub Actions を使って Google Cloud 環境に Terraform を実行する方法 (2023-01-23)](https://blog.g-gen.co.jp/entry/using-terraform-via-cloud-build)

<!--
さいごに、本セッションに関連する弊社ブログの記事を紹介しておきます。  
今回のフォローアップとして解説記事も考えておりますので、是非ウォッチしていただけると嬉しいです
-->

---
layout: thanks
---
