---
theme: "../../themes/g-gen"
favicon: https://g-gen.co.jp/favicon.ico
layout: cover
lineNumbers: true
htmlAttrs:
  lang: ja
---

### (週次) 技術勉強会

#### 2025-03-20 (Thu), Online

# 2025 年最新版<br />ナウい Python 開発環境の作り方

## クラウドサポート課 高井 陽一

---
layout: intro
---

# 本日の資料はこちら

### [https://slides.p3ac0ck.net/techtalk-2025-03/](https://slides.p3ac0ck.net/techtalk-2025-03/)

## 写真もご自由に <twemoji-camera />

<QRCode text="https://slides.p3ac0ck.net/techtalk-2025-03/" />

---
layout: toc
---

# Table of Contents

1. 自己紹介、本セッションの対象者や目的
1. `pyproject.toml` でプロジェクト情報を管理
1. uv: プロジェクト管理ツール・インストーラー
1. ruff: 静的解析 & フォーマッター
1. GitHub Actions で自動チェック(CI)
1. まとめ
1. おまけ: `ruff` の型検査を実施する機能(開発中)

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

# 本セッションの概要や目的

[Open Developers Conference 2024](https://slides.p3ac0ck.net/odc2024/1) **(2024-09-07) の更新版**

- Python パッケージ管理ツールの周辺状況が変わってきた
    - [PEP 621: Storing project metadata in `pyproject.toml`](https://peps.python.org/pep-0621/)
    - [Poetry](https://python-poetry.org) の普及や [Hatch](https://hatch.pypa.io/latest/), [Rye](https://rye.astral.sh), [uv](https://docs.astral.sh/uv/) などの新しいツールの台頭
- これらの比較紹介を 2023 年に [PyCon TW](https://tw.pycon.org/2023/en-us/conference/talk/274), [PyCon APAC](https://2023-apac.pycon.jp/timetable?id=XEGZUD) で発表した
- その中で uv がスタンダードとして落ち着いたので、新しい方法として広めたい
- 同じ開発元が公開している [Ruff](https://astral.sh/ruff) という静的解析・フォーマッターの情報も紹介

---

## はじめに / Introduction

# 昔の Python 開発のスタンダード

注) 昔 = 2022 年くらいまでの Python 界隈

- `setup.py` or `setup.cfg` でパッケージ定義を書く
- `pip` や `setuptools` を使って依存関係を管理
- 静的解析 (Lint) は Flake8
- フォーマッターは Black, isort
- 型ヒントも浸透しきっていない

-> これら **全部が違う方法に置き換わ** っている

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
    - [PyPA](https://www.pypa.io/en/latest/): Python Packaging Authority, PyPI や周辺ツールを管理している組織
- uv: 最近 Python 界隈で勢いのある [Astral 社](https://astral.sh/) が開発しているパッケージ管理ツール

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

最近話題になっている uv という管理ツールを用いる方法

**macOS & Linux も今はこちらがスマート**

- 昔は[pyenv](https://github.com/pyenv/pyenv)が主流だったが、少々お行儀が悪い
    - 環境変数 `$PATH`, `$PYTHONPATH` などが汚れる
- 現在は [uv を使う](https://docs.astral.sh/uv/concepts/python-versions/)のがオススメ
    - `uv venv --python 3.12.9` でインストール & venv 作成
        - `3.12.9` まで不要なら `--python 3.12` でも問題ない

---

## uv: プロジェクト管理ツール

# 個別にプロジェクト用の仮想環境を作成する

プロジェクト個別に依存ライブラリなどを管理するために venv (仮想環境)を作る必要がある  
(Node.js で言うと `node_modules` のような役割をするもの)

- uv を使っている場合(前述): `uv venv -p 3.12`
- uv なしの場合: `./path/to/python -m venv .venv`

これでカレント直下の `.venv` に仮想環境フォルダが作成される

---

## uv: プロジェクト管理ツール

# 仮想環境のアクティベート (uvを使わない場合)

Node.js (npm) のように自動で認識はしてくれない。アクティベーションが必要  

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

だいたい以下のような構造になっている (ディレクトリ名は変更する必要アリ)

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

# 依存パッケージの追加方法

- (後述) 直接 `pyproject.toml` を編集して `uv sync` を実行する
- (オススメ) `uv add` コマンドを使う
    - `uv add <package_name>` で依存パッケージを追加
    - `pyproject.toml` もバージョン指定込みで追記される
    - (uv 0.3.0 から) `uv.lock` という独自形式の Lock ファイルが作成される
        - `package-lock.json` (Node.js) などと同じ役割で、Git 管理下に置く
        - (参考) Python 標準の Lock ファイルの策定を議論中 ([PEP 751](https://peps.python.org/pep-0751/))

---

## uv: プロジェクト管理ツール

# パッケージのバージョンを詳細に指定する方法

- `numpy~=2.1.0` のように記載する必要がある
    - [バージョン指定子は `~=`, `==`, `!=`, `<=`, `>` などが使用可能](https://packaging.python.org/en/latest/specifications/version-specifiers/#id5)
    - Node.js でよく見る `^` 表記は `~=` に相当するが、ほとんど `>=` で OK
- コマンド例: `uv add 'numpy ~= 2.1.0'`
    - Node.js の `"numpy": "^2.1.0"` と等価
    - 文字列として評価されるなら指定子の間のスペースは任意

---

## uv: プロジェクト管理ツール

# `pyproject.toml` を直接編集する

1. `project.dependencies` に文字列の配列として書くだけ
    - バージョン指定子は任意
2. `uv sync` を実行すると仮想環境に同期される
    - 自動的に Lock ファイルも更新される

```toml
[project]
name = "etude"
dependencies = ["numpy>=2.1.0"]
```

---

## uv: プロジェクト管理ツール

# uv を使って開発時だけ使うパッケージを管理する

- やりたいこと: `ruff` (後述)や `pytest` などの開発時だけに使うパッケージも管理
- 方法: [Dependency groups](https://docs.astral.sh/uv/concepts/projects/dependencies/#development-dependencies) を活用する
    - 実行例: `uv add --dev ruff pytest` (`--dev` は `--group dev` と等価)
    - `pyproject.toml` に書いてあれば `uv sync --dev` or `uv sync --all-groups`

```toml
[project]
name = "etude"
dependencies = ["numpy>=2.1.0"]

[dependency-groups]
dev = ["pytest>=8.3.5", "ruff>=0.11.2"]
```

---
layout: section
---

### 2

# Ruff: 静的解析・フォーマッター

## *An extremely fast Python linter, written in Rust.*

---

## Ruff: 静的解析・フォーマッター

# Ruff とは

[公式ドキュメント](https://docs.astral.sh/ruff/)より抜粋して拙訳すると

- 他の静的解析、フォーマッターより 10 ~ 100 倍高速
- `pip` でインストール可能 & `pyproject.toml` をサポート
- 気軽に試すことができる Flake8, isort, Black と同等の OSS
- エラーの自動修正をサポート(例: 自動で使っていない import 文を消す)
- flake8-bugbear などの人気 Flake8 プラグインから 800 ルール以上が組み込み
- 公式で VS Code などのエディタ拡張が公開されている

---

## Ruff: 静的解析・フォーマッター

# インストール・初期設定

**目標:** Flake8, Black, isort 相当のタスクを実行できるようになる

1. uv で追加: `uv add --dev ruff` を実行
1. `pyproject.toml` に以下を追記
    - 設定オプションの一覧: <https://docs.astral.sh/ruff/settings/>
    - 静的解析 (Lint) のルール一覧: <https://docs.astral.sh/ruff/rules/>

```toml
[tool.ruff]
target-version = "py313"  # Python 3.12 なら py312

[tool.ruff.lint]
select = ["E", "F", "I"]  # E=pycodestyle, F=Pyflakes, I=isort
```

---

## Ruff: 静的解析・フォーマッター

# 使ってみる

```python
import sys

def main():
    number = 42
    print(3*   19 )
    print(os.environ.get("HOME"))

if __name__ == "__main__":
    main()
```

上記を `main.py` (`pyproject.toml` と同じ階層)に保存して `ruff check .` を実行

---

## Ruff: 静的解析・フォーマッター

# 実行結果例

```
(demo) $ ruff check .
demo/main.py:1:1: I001 [*] Import block is un-sorted or un-formatted
  |
1 | import sys
  | ^^^^^^^^^^ I001
2 |
3 | def main():
  |
  = help: Organize imports

(中略)

Found 4 errors.
[*] 2 fixable with the `--fix` option (1 hidden fix can be enabled with the `--unsafe-fixes` option).
```

---

## Ruff: 静的解析・フォーマッター

# 実際のエディタ画面

<img src="/ruff.png" />

---

## Ruff: 静的解析・フォーマッター

# 修正するには

- 静的解析: `ruff check --fix .` で可能なものは自動修正
    - エディタの Code Action 機能で修正も可能 (スクショ)
- フォーマット崩れ: `ruff format .` or エディタのフォーマット機能を使う

<img src="/ruff-action.png" />

---

## さいごに

# まとめ

- `pyproject.toml` & uv でプロジェクト情報や依存パッケージを管理する
    - プロジェクト初期化は `uv init` を実行して `pyproject.toml` を修正
    - 依存パッケージの追加は `uv add` コマンドを使用
    - グローバルに uv をインストールすると Python のバージョンも管理できて便利
- Ruff で静的解析・フォーマットを行う
    - `ruff check` でエラーを検出
    - `ruff format` でフォーマットを行う
    - エディタ拡張 (VS Code など) も公開されているので活用する

---

## Appendix (おまけ) 1

# Ruff で型検査の機能が実装中

<Tweet id="1884651482009477368" />

---

## Appendix (おまけ) 2

# `requirements.txt` で全部バージョン固定は NG

詳細: <https://zenn.dev/peacock0803sz/articles/acd723d5a5fa0b>

### TL;DR

- **今なら uv にお任せで問題ない**
- `pip freeze > requirements.txt` で全てのバージョンを固定するのはダメ
    - `-r requirements.txt` ではパッケージ自体の指定も含んでしまうため
- `pip install -c constraints.txt` で [Constraints Files](https://pip.pypa.io/en/stable/user_guide/#constraints-files) を使う
    - こちらは `-r requirements.txt` とは違って「バージョン指定のみ」をする
