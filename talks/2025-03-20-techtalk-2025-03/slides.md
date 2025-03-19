---
theme: "../../themes/g-gen"
titleTemplate: ""
favicon: https://g-gen.co.jp/favicon.ico
layout: title
lineNumbers: true
htmlAttrs:
  lang: ja
---

### (週次) 技術勉強会

#### 2025-03-20 (Thu), Online

# 2025 年最新版<br />ナウい Python 開発環境の作り方

## クラウドサポート課 高井 陽一

---
layout: toc
---

# Table of Contents

1. 自己紹介、本セッションの対象者や目的
1. `pyproject.toml` でプロジェクト情報を管理
1. uv: プロジェクト管理ツール・インストーラー
    1. Python 本体のバージョンを管理する
    1. 仮想環境 (venv) を作成して管理する
    1. 依存パッケージを追加・更新する
1. ruff: 静的解析 & フォーマッター
    1. 静的解析 (Linter) でバグを防ぐ
    1. Python コードのフォーマット(整形)
1. GitHub Actions で自動チェック(CI)
1. まとめ
1. Appendix: `ruff` の型チェッカー機能(開発中)

---
layout: profile
---

::text::

## はじめに / Introduction

# 自己紹介: 高井 陽一 (Peacock)

- 2000 年 8 月生 (24 歳)
- X (Twitter) など各種 SNS: `peacock0803sz`
- 所属: クラウドソリューション部 クラウドサポート課
- 入社: 2022 年 12 月 (合併前の株式会社トップゲート)
- 主な保有資格
    - Professional Cloud Developer
    - Professional Cloud DevOps Engineer
- 以前はエンジニアとして様々な規模の IaC (Terraform) 案件へ参画
- アプリケーション開発では Python をよく使用 (たまに Go)
- 業務外のコミュニティ活動としては PyCon JP などでイベント運営

<img src="https://media.p3ac0ck.net/icons/PyConAPAC2023.jpg" />

<!--
まず軽く自己紹介をしますね。

とあるTerraform案件ではCompute Engineを数百台立ち上げるためにJinja Templateで生成させる、みたいな力技もやったことがあります(笑)
-->

---

## はじめに / Introduction

# 本セッションの対象者や目的など

---
layout: section
---

### 1

# uv: プロジェクト管理ツール

---

## uv: プロジェクト管理ツール

# 誤解を解くために: 各種ツールの目的・対象

- pip: Python 3 系から同梱のパッケージインストーラー
- pyenv: Python 本体を複数バージョン使えるようにするもの
- Pipenv: 仮想環境・依存パッケージ管理ツール
- Poetry: 仮想環境・依存パッケージ管理ツール (後発)
- Hatch: Pythonプロジェクト管理ツールで PyPA が開発元
    - [PyPA](https://www.pypa.io/en/latest/): Python Packaging Authority, PyPI や周辺ツールを開発・メンテナンスしている

---

## uv: プロジェクト管理ツール

# 今まで: マイナーバージョン(3.y)まで管理する

- ほとんど用途はこちらの方法で十分だった
- 別のコマンド名でインストールできる
    - `python3.9` と `python3.10` は別のコマンド

### インストール方法

- Windows / macOS: Python 公式インストーラーで十分
    - CLI パッケージとして管理したいなら管理ツール(後述)
- Linux: 手動でビルド(後述) or 管理ツールなどを使う

---

## uv: プロジェクト管理ツール

# 手動でビルド・管理する (主に Linux)

Python.jp の「非公式Pythonダウンロードリンク」が便利
<https://pythonlinks.python.jp>

- apt or yum はビルドに必要なパッケージ・手順が書いてある
- `./configure --prefix` でインストール先を指定し PATH 追加が無難

ビルド手順

```
./configure --prefix=$HOME/.local/python313/
make
make install
```

---

## uv: プロジェクト管理ツール

# これから: 管理ツール (uv) を使う

最近話題になっている管理ツールを用いる方法で、  
**macOS & Linux も今はこちらがスマート**

- 昔は[pyenv](https://github.com/pyenv/pyenv)が主流だったが、少々お行儀が悪い
    - 環境変数 `$PATH`, `$PYTHONPATH` などが汚れる
- 2024 年 9 月現在は [uv を使う](https://docs.astral.sh/uv/concepts/python-versions/)のがオススメ
    - `uv venv --python 3.11.6` でインストール & venv 作成
        - `3.11.6` まで不要なら `--python 3.11` でも問題ない

---

## uv: プロジェクト管理ツール

# 個別にプロジェクト用の仮想環境を作成する

プロジェクト個別に依存ライブラリなどを管理するために venv (仮想環境)を作る必要がある  
(Node.js で言うと `node_modules` のような役割をするもの)

- uv を使っている場合(前述): `uv venv -p 3.13`
- uv なしの場合: `./path/to/python -m venv <venv_name>`

これでカレント直下の `.venv` に仮想環境フォルダが作成される

---

## uv: プロジェクト管理ツール

# 仮想環境のアクティベート (uvを使わない場合)

Node.js (npm) のように自動で仮想環境を認識はしてくれない。アクティベーションが必要  
**ただし、uv コマンドを使っている場合は不要**

- Bash, Zsh: `source <venv_name>/bin/activate`
- Fish: `source <venv_name>/bin/activate.fish`
- Cmd.exe: `<venv_name>\Scripts\Activate.bat`
- PowerShell: `<venv_name>\Scripts\Activate.ps1`

---

## uv: プロジェクト管理ツール

# なぜパッケージングすることが必要なのか

- Pythonのimport文は複雑。相対importも可能だが難しい
- なるべく絶対importを使いたい
    - 絶対import: パッケージ名から記載していく方法
    - 相対import: カレントファイルを起点に探索する方法
- ので、現在のプロジェクトをインストールする必要がある
- つまりプロジェクトをパッケージとして作成する必要がある

---

## uv: プロジェクト管理ツール

# 最低限の `pyproject.toml`

パッケージにするため `pyproject.toml` を作成して<br /> 本体(`etude/__init__.py`)を作成すると、`etude` が<br /> `uv sync` 実行でimport可能になる

```toml{all|1-3|5-7|all}
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "etude"
version = "2025.3.0"
```

<!--
相対インポート
-->

---

## uv: プロジェクト管理ツール

# ディレクトリ構造の作り方

2種類あるが、スタンダードは "flat layout" (ただし[議論は続いている](https://packaging.python.org/en/latest/discussions/src-layout-vs-flat-layout/))  
以下のような構造になっている (ディレクトリ名は変更する必要アリ)

```
.
├── README.md
├── pyproject.toml
├── etude/
│   ├── __init__.py
│   └── main.py
├── tests/
│   ├── conftest.py
│   └── test_main.py
└── scripts/
    └── decrease_world_suck.py
```

<!--
**インポート可能な名前である必要があるので、ディレクトリ名もsnake caseにする必要があります**
-->

---

## uv: プロジェクト管理ツール

# 依存パッケージの追加: `uv add` (おすすめ)

- `uv add <package_name>` で依存パッケージが追加される
- `pyproject.toml` もバージョン指定込みで追記される
- (uv 0.3.0から) `uv.lock` という独自形式のLockファイルが作成される
    - `package-lock.json` (Node.js)などと同じ役割で、同様にGitで管理して良い

---

## uv: プロジェクト管理ツール

# パッケージのバージョンを指定する場合

- `numpy~=2.1.0` のように記載する必要がある
    - [バージョン指定子は `~=`, `==`, `!=`, `<=`, `>` などが使用可能](https://packaging.python.org/en/latest/specifications/version-specifiers/#id5)
    - Node.jsでよく見る `^` 表記は `~=` に相当する
- コマンド例: `uv add 'numpy ~= 2.1.0'`
    - Node.jsの `"numpy": "^2.1.0"` と等価
    - 文字列として評価されるなら指定子の間のスペースは任意

---

## uv: プロジェクト管理ツール

# `pyproject.toml` を直接編集する

1. `project.dependencies` に文字列の配列として書けば良い
    - バージョン指定子の有無は問われない
2. `uv sync` を実行すると仮想環境に同期される
    - 自動的にLockファイルも更新される

```toml
[project]
name = "sandbox"
dependencies = [
    "numpy>=2.1.0",
]
```

---


## おまけ

# 参考リンク集
