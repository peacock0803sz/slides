---
theme: "../../themes/simple"
titleTemplate: "#pyconshizu LT: %s"
favicon: https://media.p3ac0ck.net/icons/peacock.jpg
layout: cover
lineNumbers: true
htmlAttrs:
  lang: ja
hideInToc: true
---

# 入門 Nix <twemoji-snowflake />

## 純粋関数型パッケージマネージャでDisposableな環境を構築するための第一歩

### 2025-02-08 (Sat)<br />PyCon mini Shizuoka 2024 continue (LT)<br />Peacock (`@peacock0803sz`)

<PoweredBySlidev class="text-lg absolute bottom-5 right-5" />
---
layout: intro
hideInToc: true
---

# 本日の資料 (URL or QRコード)

### [`https://slides.p3ac0ck.net/nix-intro-202502/`](https://slides.p3ac0ck.net/nix-intro-202502/)

## 写真もご自由に <twemoji-camera />

<img src="/qrcode.png" />

---
layout: toc
hideInToc: true
---

# 目次

<Toc maxDepth="2" columns="2"/>

---
layout: profile
hideInToc: true
---

<img src="https://media.p3ac0ck.net/icons/PyConAPAC2023.jpg" />

# お前、誰よ

- 名前: Peacock (高井 陽一), SNS -> `peacock0803sz`
- 仕事: [(株) G-gen](https://g-gen.co.jp/), Google Cloudの技術サポート
    - [Google Cloud Partner Top Engineer 2025受賞](https://g-gen.co.jp/news/pte_2025.html)
- 2019年9月にPythonコミュニティで職を得て5年経った
- 技術イベント、カンファレンスが大好き
    - PyCon JP 2020 - [2025](https://2025.pycon.jp/)主催メンバー(スタッフ)
    - [PyCon JP TV](https://tv.pycon.jp)ディレクター
- 趣味: クラシック音楽、カメラ(α7R III)、ビールなど
    - 技術カンファレンスの撮影スタッフもやっている

---

# 今回話さないこと

- [Nix言語](https://nix.dev/tutorials/nix-language)の詳細な文法について
    - 中に関数が書けるJSONだと思っていれば最低限読み書きできるはず
- [NixOS](https://nixos.org), [nix-darwin](https://daiderd.com/nix-darwin/)について、これらを使用したOSレベルの構成管理方法
- [Nix Flakes](https://nix.dev/concepts/flakes)とは何か
    - 雑な解説: モダンなNixパッケージ定義の方法・書式
- VS Code, IntelliJ IDEAなどのGUIツールのインストール・管理方法
- [Home Manager](https://github.com/nix-community/home-manager)を使用して全てNix言語で設定を管理する方法
- [direnv](https://direnv.net) (ディレクトリ移動時に自動でコマンドを実行する)

<!--
今回は時間の都合上、これらの話題については扱いません
-->

---
layout: section
---

# 導入: なぜNixなのか

---

## モチベーション・動機

- 前提: 日常的にdotfilesを使用してGitベースで設定ファイルを管理している
    - Neovim(エディタ), fish(シェル), WezTerm(ターミナル), etc ...
- 普段使用している開発マシン(macOS)の環境の再現性が低下しつつあった
    - [Homebrew](https://brew.sh)のパッケージ(formula)が増えてしまい、依存関係の衝突が<br>発生していた
- プロジェクトによって異なるバージョンの言語ランタイムなどを管理したい
    - anyenv, asdf, miseなどのプロジェクトはあるが、更新が遅かったり微妙
- [**「Disposableな環境」**](https://masawada.hatenablog.jp/entry/2022/09/09/234159)を構築することに憧れがあった

<!--
日常的にdotfilesで管理はしていたけれど、完璧ではない状態でした
-->

---

## Disposableとは

### 英和辞書で引いてみる

<img src="/assets/disposable.png" width="840">

---

### つまり、どういうこと?

Answer: 一定期間おきにクリーンインストールできる状態を保つこと

- 理由:
    - ローカルに重要なデータを溜めないようにするため
    - 構成管理しているコードを定期的に運用し、陳腐化させないようにするため
    - プロジェクトの復旧・再構築手順を忘れないようにするため

-> これをNixによって解決したい

出典: [デスクトップ環境をdisposableに保つ - あんパン](https://masawada.hatenablog.jp/entry/2022/09/09/234159)

<!--
つまり「使い捨てられる環境ってどういうこと」って話なんですが、これですね。

実現するモチベーションだったり、理由はこれら3つなんですが、特に2,3つめが大きいと思っています。
-->

---
layout: section
---

# Nixとは何者なのか

<!--
さて、ここまで散々Nixについてモチベーションだとか動機を語ってきましたが、一体Nixとは何ぞやという話をようやく持ち出します。
-->

---

## Nixとは何者なのか

(前略) Nixは、ビルドの結果を完全な依存関係ツリーのハッシュで指定された **一意のアドレスに保存し、アトミックなアップグレード**、ロールバック、およびパッケージの異なるバージョンの同時インストールを可能にする **不変のパッケージ ストア** を作成し、本質的に依存関係の地獄を排除します。

> (前略) Nix **stores the results of the build in unique addresses** specified by a hash of the complete dependency tree, creating an **immutable package store that allows for atomic upgrades**, rollbacks and concurrent installation of different versions of a package, essentially eliminating dependency hell.

出典: [NixOS公式Wiki](https://wiki.nixos.org/wiki/Nix_package_manager)

<!--
公式Wikiから抜粋引用すると、こんなことが書いてあります。
はい。皆さんが大好きな「アトミックな操作が可能」な「不変」のストア(置き場)を作成できます。
-->

---

## Nixを導入するPros/Cons

- Pros (メリット)
    - 今のマシンが >>>突然の死<<< を迎えても代わりがあれば復旧が容易
    - 複数環境(異なる言語バージョン等)でのデバッグが気軽にできる
    - Dockerなどの仮想レイヤと比べて軽量に動作する & 再現性が高い
    - brew, apt などよりも多数(約120,000)のパッケージが収録
- Cons (デメリット)
    - Nix言語という(関数型の)独自DSLの習得難易度が比較的高い
    - 構築に時間がかかる(実は筆者もまだ完璧な状態ではない)
    - ストレージ容量を通常より多く消費する

<!--
んで、実際に何が嬉しいのか、また導入する痛み、みたいなところはこんなところだと思っています。
-->

---
layout: section
---

# 実践Nix

## 開発環境をNixで管理する方法

<!--
さて、ここから実践編として、ユーザー環境全体とプロジェクト固有の2パターンで依存関係を管理する方法を紹介します。
-->

---

## インストール方法

- 前提: マシン内のユーザー全員が使える[マルチユーザー モード](https://nix.dev/manual/nix/2.18/installation/multi-user.html)が推奨
    - ストアを `/nix/store` に作成する兼ね合いでシングルユーザーは非推奨
        - ストア = インストールしたパッケージの実態があるディレクトリ
- Linux: `curl -L https://nixos.org/nix/install | sh -s -- --daemon`
- macOS: `curl -L https://nixos.org/nix/install | sh`
- Windows (WSL2): systemdが有効なら後者が推奨
    1. `curl -L https://nixos.org/nix/install | sh -s -- --no-daemon`
    1. `curl -L https://nixos.org/nix/install | sh -s -- --daemon`

出典: <https://nix.dev/install-nix>

<!--
インストール方法についても記載していますが、詳細は公式ドキュメントを参照してください。
-->

---

## 前提: `nix.conf` の作成

以下の機能を使うために、`$HOME/.config/nix/nix.conf` を作成する必要がある

- [Flakes](https://nixos.wiki/wiki/flakes)の有効化: モダンなNixパッケージ定義の方法・書式を使うため
- [nix-command](https://nixos.wiki/wiki/Nix_command): 新しいコマンド体系を使うため

```bash {all|2|all}
cat <<EOF > "$HOME/.config/nix/nix.conf"
experimental-features = flakes nix-command
EOF
```

<!--
ここで一手間、おまじないが必要です。

解説を省略したflakesという機能、コマンド体系を最新のものにするために設定を1行書きます。
-->

---

## ユーザーレベルで使うパッケージを管理する

dotfilesリポジトリを運用している場合、`$HOME/dotfiles/flake.nix` を作成  
適用コマンド: `nix profile install .`  
省略なしフルバージョン: [flake.nix - peacock0803sz/dotfiles | GitHub](https://github.com/peacock0803sz/dotfiles/blob/master/flake.nix)

```nix
{
  description = "My first flake";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
  outputs = { nixpkgs, ... }:
  let 
    pkgs = import nixpkgs { system = "aarch64-darwin"; };
  in {
    packages.default = pkgs.buildEnv {
      name = "my-first-flake";
      paths = with pkgs; [ fish direnv uv devenv ]; # 必要なパッケージを列挙
    };
  };
}
```

---

## プロジェクト毎の環境を管理する

- プロジェクトで環境構築手順を共有するときの課題
    - Makefileなどでセットアップ手順を簡略化しても、各ツールや言語ランタイムのバージョンまでは保証できない
    - とは言え、Dockerの中に閉じ込めてしまうと富豪的な開発マシンが必要になってしまう
- -> Nixを用いることで**羃等性も担保できる**
    - 評価結果がハッシュ値で保存され、同じ結果のパッケージはキャッシュから取得できる

---

### 解法: [devenv](https://devenv.sh)

> Fast, Declarative, Reproducible and Composable Developer Environments using Nix

### メリット

- direnvと連携して自動でPATHを通してくれる
- Nix言語で記述できる -> **羃等性が担保** されている
- タスク定義を書ける -> `Makefile` を書かなくてよい
    - Pythonのように標準でタスクランナーがない言語やモノレポ構成でも楽

---

### devenv使ってみる

```bash
cd path/to/myapp
git init  # gitリポジトリでなくてもOK
devenv init
```

### `devenv.nix`

```nix
{ pkgs, ... }: {
  packages = with pkgs; [ git ];
  languages.python = { enable = true; uv.enable = true; };
  services.postgres.enable = true;
  tasks."myapp:hello" = {
    exec = "echo 'Hello world from Python!'";
  };
}
```

---
hideInToc: true
---

## 宣伝: Nix 日本語コミュニティ + Nix meetup #2

- Nix日本語コミュニティ (nix-ja)
    - connpass: <https://nix-ja.connpass.com>
    - Discordサーバー: <https://discord.com/invite/TYytzedtbe>
    - NixConf読書会(設定ファイルを読む会): オンラインで開催中
        - 詳細: <https://scrapbox.io/nix-ja/NixConf読書会>
- 3/9(日), Nix meetup #2開催予定
    - 場所: ピクシブ株式会社(東京・千駄ヶ谷)
    - <https://nix-ja.connpass.com/event/342908/>

---

# 参考文献・リンクまとめ

- [デスクトップ環境をdisposableに保つ | あんパン](https://masawada.hatenablog.jp/entry/2022/09/09/234159)
- [Nix package manager | NixOS Wiki](https://wiki.nixos.org/wiki/Nix_package_manager)
- [Multi-User Mode | Nix Reference Manual](https://nix.dev/manual/nix/2.18/installation/multi-user.html)
- [Install Nix | nix.dev documentation](https://nix.dev/install-nix)
- [Nix command | NixOS Wiki](https://nixos.wiki/wiki/Nix_command)
- [flake.nix - peacock0803sz/dotfiles | GitHub](https://github.com/peacock0803sz/dotfiles/blob/master/flake.nix)
- [nix-community/nix-direnv | GitHub](https://github.com/nix-community/nix-direnv)

<PoweredBySlidev class="text-lg absolute top-5 right-5" />
