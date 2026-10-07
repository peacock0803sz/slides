---
theme: ./
title: 入門 Nix
htmlAttrs:
  lang: ja
layout: cover
callout: λ
lineNumbers: true
---

# 入門 Nix

## 純粋関数型パッケージマネージャで<br>Disposableな環境を構築するための第一歩

### 2025-04-26 (Sat)<br>Open Source un-Conference 2025 Kawagoe (LT)<br>Peacock (@peacock0803sz)

::figure::

<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
  <path d="m10 20-1.25-2.5L6 18" />
  <path d="M10 4 8.75 6.5 6 6" />
  <path d="m14 20 1.25-2.5L18 18" />
  <path d="m14 4 1.25 2.5L18 6" />
  <path d="m17 21-3-6h-4" />
  <path d="m17 3-3 6 1.5 3" />
  <path d="M2 12h6.5L10 9" />
  <path d="m20 10-1.5 2 1.5 2" />
  <path d="M22 12h-6.5L14 15" />
  <path d="m4 10 1.5 2L4 14" />
  <path d="m7 21 3-6-1.5-3" />
  <path d="m7 3 3 6h4" />
</svg>

---
layout: toc
hideInToc: true
---

# 目次

<Toc columns="2" maxDepth="2" />

---
layout: profile
image: https://media.p3ac0ck.net/icons/PyConAPAC2023.jpg
hideInToc: true
---

# お前、誰よ

- **名前** Peacock (高井 陽一)
  - SNS: peacock0803sz
- **仕事** (株) G-gen — Google Cloud の技術サポート
  - Google Cloud Partner Top Engineer 2025
- **活動** PyCon JP 2020–2025 主催メンバー
  - PyCon JP TV ディレクター
- **趣味** クラシック音楽、カメラ、ビール

---

# 今回話さないこと

- [Nix言語](https://nix.dev/tutorials/nix-language)の詳細な文法
  - 中に関数が書けるJSONだと思っていれば最低限読み書きできる
- NixOS, nix-darwinを使ったOSレベルの構成管理
- Nix Flakesとは何か
- Home Managerで全ての設定をNix言語で管理する方法

---
layout: section
---

# 導入: なぜNixなのか

---

## モチベーション・動機

- 前提: dotfilesで設定ファイルをGit管理している
- 普段使いの開発マシン (macOS) の再現性が下がっていた
  - Homebrewのformulaが増え、依存関係が衝突していた
- プロジェクトごとに異なる言語ランタイムのバージョンを管理したい
- **Disposableな環境** を構築することに憧れがあった

---

## Disposableとは

英和辞書で引くと「使い捨ての」「処分可能な」

<Crescendo>開発環境に当てはめると、いつ捨てて作り直しても困らない状態を指す</Crescendo>

<img src="/assets/disposable.png" width="640">

---
layout: image-portrait
image: https://img.p3ac0ck.net/figs/Lanterna.png
---

### つまり、どういうこと?

## 一定期間おきに<br>クリーンインストールできる状態を保つこと

<v-click>

- ローカルに重要なデータを溜めないため
- 構成管理のコードを定期的に運用し、陳腐化させないため
- 復旧・再構築の手順を忘れないため

</v-click>

---
layout: section
---

# Nixとは何者なのか

---
layout: image-landscape
image: https://img.p3ac0ck.net/figs/Lanterna.png
---

## Nixの概要

> Nixは、ビルドの結果を依存関係ツリーのハッシュで指定された一意のアドレスに保存し、アトミックなアップグレードを可能にする不変のパッケージストアを作成します。

出典: [NixOS 公式 Wiki](https://wiki.nixos.org/wiki/Nix_package_manager)

---
layout: two-cols
---

## 導入のPros/Cons

::left::

### Pros

- 今のマシンが突然の死を迎えても復旧が容易
- 複数環境 (異なる言語バージョン等) のデバッグが気軽
- Dockerより軽量に動作し、再現性が高い
- 約120,000のパッケージを収録

::right::

### Cons

<v-clicks>

- 独自DSL「Nix言語」の習得難易度が高い
- 構築に時間がかかる
- ストレージ容量を多く消費する

</v-clicks>

---
layout: numbers
hideInToc: true
---

## 数字で見る Nix

## 約12万

### pkgs

nixpkgs に収録されたパッケージ

## 1

### 行

nix.conf に書くおまじない

## 2

### パターン

ユーザー環境とプロジェクト毎の管理

---
layout: numbers
hideInToc: true
---

## 数字で見る Nix

## 約120,000

### pkgs

nixpkgs に収録されたパッケージ

## 1

### 行

nix.conf に書くおまじない

---
layout: section
---

# 実践Nix

## 開発環境をNixで管理する方法

---
layout: table
---

## インストール方法

| OS | コマンド | 備考 |
| --- | --- | --- |
| Linux<br>(Multi-user) | `curl -L https://nixos.org/nix/install`<br>` \| sh -s -- --daemon` | 推奨 |
| Linux<br>(Single-user) | `curl -L https://nixos.org/nix/install`<br>` \| sh -s -- --no-daemon` | 非推奨 |
| macOS | `curl -L https://nixos.org/nix/install`<br>` \| sh` | マルチユーザー<br>(既定) |
| WSL2<br>(systemd あり) | `curl -L https://nixos.org/nix/install`<br>` \| sh -s -- --daemon` | 推奨 |
| WSL2<br>(systemd なし) | `curl -L https://nixos.org/nix/install`<br>` \| sh -s -- --no-daemon` | シングルユーザー |

出典: [nix.dev/install-nix](https://nix.dev/install-nix)

---

## nix.conf の作成

Flakesと新しいコマンド体系を使うため、設定を1行書いておく

```ini [~/.config/nix/nix.conf]
experimental-features = flakes nix-command
```

---

## ユーザーレベルの管理

- dotfilesに `flake.nix` を置き、使うパッケージを列挙する
- `nix profile install .` で適用する
  - 更新は `nix profile upgrade` で一括

---

## プロジェクト毎の環境 (devenv)

- [devenv](https://devenv.sh): Nixで開発環境を宣言するツール
- direnvと連携して自動でPATHを通してくれる
- 言語ランタイムやサービス、タスクまでNix言語で書ける
  - `Makefile` を書かなくてよい

---

### devenv 使ってみる

```nix [devenv.nix]
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
layout: summary
hideInToc: true
---

# まとめ

1. Disposable な環境を目指す
   - 一定期間おきにクリーンインストールできる状態を保つ
2. ユーザー環境は flake.nix で宣言する
   - dotfiles に置き、nix profile install . で適用
3. プロジェクト毎の環境は devenv で
   - direnv と連携し、言語ランタイムやタスクまで宣言できる

---

# 参考文献・リンクまとめ

- [デスクトップ環境をdisposableに保つ - あんパン](https://masawada.hatenablog.jp/entry/2022/09/09/234159)
- [Nix package manager - NixOS Wiki](https://wiki.nixos.org/wiki/Nix_package_manager)
- [Install Nix - nix.dev](https://nix.dev/install-nix)
- [devenv](https://devenv.sh)
