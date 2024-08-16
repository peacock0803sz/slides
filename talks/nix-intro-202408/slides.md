---
theme: "../../themes/simple"
titleTemplate: "%s"
favicon: https://media.p3ac0ck.net/icons/peacock.jpg
layout: cover
lineNumbers: true
htmlAttrs:
  lang: ja
hideInToc: true
---

# 入門 Nix

## 純粋関数型パッケージマネージャでDisposableな環境を構築するための第一歩

### 2024-08-16 株式会社G-gen 社内LT<br>高井 陽一 (Peacock)

---
layout: toc
hideInToc: true
---

# 目次

<Toc maxDepth="2" columns="2"/>

---

# 今回話さないこと

- [Nix言語](https://nix.dev/tutorials/nix-language)の詳細な文法について
    - 中に関数が書けるJSONだと思っていれば最低限読み書きできるはず
- [NixOS](https://nixos.org), [nix-darwin](https://daiderd.com/nix-darwin/)について、これらを使用したOSレベルの構成管理方法
- [Nix Flakes](https://nix.dev/concepts/flakes)とは何か
- VS Code, IntelliJ IDEAなどのGUIツールのインストール・管理方法
- [Home Manager](https://github.com/nix-community/home-manager)を使用して全てNix言語で設定を管理する方法
- [devenv](https://devenv.sh), [devbox](https://www.jetify.com/devbox)などの開発環境ツール・関連プロジェクトについて

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
- [「Disposableな環境」](https://masawada.hatenablog.jp/entry/2022/09/09/234159)を構築することに憧れがあった

<!--
日常的にdotfilesで管理はしていたけれど、完璧ではない状態でした
-->

---

## Disposableとは: 英和辞書で引いてみる

<img src="/assets/disposable.png" width="840">

---

### つまり、どういうこと?

Answer: 一定期間おきにクリーンインストールできる状態を保つこと

- 理由:
    - ローカルに重要なデータを溜めないようにするため
    - 構成管理しているコードを定期的に運用し、陳腐化させないようにするため
    - 復旧・再構築手順を忘れないようにするため

-> これをNixによって解決したい (けど、筆者も現時点で全部できていない)

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

## Nixとは (NixOS公式Wikiより)

(前略) Nixは、ビルドの結果を完全な依存関係ツリーのハッシュで指定された一意のアドレスに保存し、アトミックなアップグレード、ロールバック、およびパッケージの異なるバージョンの同時インストールを可能にする不変のパッケージ ストアを作成し、本質的に依存関係の地獄を排除します。

> (前略) Nix stores the results of the build in unique addresses specified by a hash of the complete dependency tree, creating an immutable package store that allows for atomic upgrades, rollbacks and concurrent installation of different versions of a package, essentially eliminating dependency hell.

出典: <https://nixos.wiki/wiki/Nix_package_manager>


<!--
公式Wikiから抜粋引用すると、こんなことが書いてあります。
はい。皆さんが大好きな「アトミックな操作が可能」な「不変」のストア(置き場)を作成できます。
-->

---

## Nixを導入するメリット・デメリット

- Pros (メリット)
    - 新しいマシンのセットアップに時間がかからない
    - 今のマシンが >>>突然の死<<< を迎えても代わりがあれば復旧が容易
    - 不具合の切り分けが気軽にできる
- Cons (デメリット)
    - 構築に時間がかかる (筆者もまだ完璧な状態ではない)
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

- マシン内のユーザー全員が使える[マルチユーザー モード](https://nix.dev/manual/nix/2.18/installation/multi-user.html)が推奨
- シングルユーザー(ユーザー空間に閉じた)インストールも可能だが、ストアを `/nix/store` に作成する兼ね合いで推奨されていない
    - ストア: インストールしたパッケージの実態があるディレクトリ

インストールコマンド(Linux / macOS)

- Linux: `curl -L https://nixos.org/nix/install | sh -s -- --daemon`
- macOS: `curl -L https://nixos.org/nix/install | sh`

出典: <https://nix.dev/install-nix>

<!--
インストール方法についても記載していますが、詳細はこの資料とか公式ドキュメントを参照してください。
-->

---

## 前提: `nix.conf` の作成

以下の機能を使うために、`$HOME/.config/nix/nix.conf` を作成する必要がある

- Flakesの有効化
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

dotfilesリポジトリを運用している(設定ファイルがGit管理されている)場合、`$HOME/dotfiles/flake.nix` を以下のように書く  
省略なしフルバージョン: [flake.nix - peacock0803sz/dotfiles (GitHub)](https://github.com/peacock0803sz/dotfiles/blob/master/flake.nix)

```nix{all|3|6|7|9-12|all}
{
  description = "My dotfiles flake";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
  outputs = { nixpkgs, ... }:
  let 
    pkgs = import nixpkgs { system = "aarch64-darwin"; };
    packages = with pkgs; [ fish direnv go ]; # ここで必要なパッケージを列挙する
  in {
    packages.default = pkgs.buildEnv {
      name = "my-env";
      paths = packages;
    };
  };
}
```

---

## プロジェクト個別で使う環境を管理する

- プロジェクトで環境構築手順を共有するときの課題
    - Makefileなどでセットアップ手順を簡略化しても、各ツールや言語ランタイムのバージョンまでは保証できない
    - とは言え、Dockerの中に閉じ込めてしまうと富豪的な開発マシンが必要になってしまう
- -> Nixを用いることで**羃等性も担保できる**
    - 評価結果がハッシュ値で保存され、同じ結果のパッケージはキャッシュから取得できる

---

### [nix-direnv](https://github.com/nix-community/nix-direnv) を用いた解決策

- プロジェクト毎で依存パッケージを管理する場合は [nix-direnv](https://github.com/nix-community/nix-direnv) を使うと便利
    - グローバル空間にインストールしない、プロジェクト毎に違う言語環境など
    - nix-direnv: [direnv](https://direnv.net) の仕組みでNix式を評価し、パッケージの取得と配置を実行するプラグイン的な存在
- -> anyenv, asdf, miseのような対象を(付随パッケージも含め)管理可能
    - プロジェクトA: Java 18, Nodejs 18
    - プロジェクトB: Java 20, Nodejs 20

---

### Gitリポジトリに含める(プロジェクトで共有する)場合

-> `flake.nix` をリポジトリ直下に配置して `use flake` を `.envrc` に追記

```nix{all|7,8|10-12|all}
{
  description = "my techtalks";
  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };
  outputs = { nixpkgs, ... }:
  let 
    pkgs = import nixpkgs { system = "aarch64-darwin"; };
    # 以下に必要なパッケージを列挙する
    packages = with pkgs; [ nodejs_20 corepack_20 ];
  in {
    devShells.default = pkgs.mkShell {
      packages = packages;
    };
  };
}
```

---

### リポジトリに含めない(プロジェクトで共有しない)場合

-> `default.nix` をリポジトリ直下に配置して `use nix` を `.envrc` に追記

```nix{all|3-7|all}
{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  packages = with pkgs; [
    nodejs_20 corepack_20 # ここに必要なパッケージを列挙する
  ];
}
```

---

# 参考文献・リンクまとめ

- [デスクトップ環境をdisposableに保つ - あんパン](https://masawada.hatenablog.jp/entry/2022/09/09/234159)
- [Nix package manager - NixOS Wiki](https://nixos.wiki/wiki/Nix_package_manager)
- [Multi-User Mode - Nix Reference Manual](https://nix.dev/manual/nix/2.18/installation/multi-user.html)
- [Install Nix — nix.dev documentation](https://nix.dev/install-nix)
- [Nix command - NixOS Wiki](https://nixos.wiki/wiki/Nix_command)
- [flake.nix - peacock0803sz/dotfiles (GitHub)](https://github.com/peacock0803sz/dotfiles/blob/master/flake.nix)
- [GitHub - nix-community/nix-direnv](https://github.com/nix-community/nix-direnv)

<PoweredBySlidev class="text-lg absolute top-5 right-5" />
