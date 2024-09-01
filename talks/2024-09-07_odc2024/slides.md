---
theme: "../../themes/geometricals"
titleTemplate: "[ODC2024] Pythonパッケージ管理ツールの最新情報 (Version 2024.09)"
favicon: https://media.p3ac0ck.net/icons/peacock.jpg
layout: cover
lineNumbers: true
htmlAttrs:
  lang: ja
---

# Pythonパッケージ管理<br>ツールの最新情報

## Version 2024.09

### 2024-09-07<br />[Open Developers Conference 2024](https://event.ospn.jp/odc2024/),<br />Peacock (Yoichi Takai) @peacock0803sz

---
layout: intro
---

# まえおき

<img src="/qrcode.svg" />

## 本日の資料 (URL or QRコードから)

<div class="url">

[`slides.p3ac0ck.net/odc2024/`](https://slides.p3ac0ck.net/odc2024/)

</div>

<div class="box">

**写真もご自由に <twemoji-camera />**  
ハッシュタグ: `#opendevcon`

</div>

※ 内容は個人の見解であり、この発表の所属としての<br />一般社団法人PyCon JP Associationを代表するものではありません

---
layout: profile
---

<img src="https://media.p3ac0ck.net/icons/PyConAPAC2023.jpg" />

# 自己紹介 (お前、誰よ)

- 名前: Peacock (Yoichi Takai)
    - 各種SNS: `peacock0803sz`
- 仕事: [株式会社G-gen](https://www.g-gen.co.jp/)で技術サポート
- 技術イベント、カンファレンスが大好き
    - PyCon JP 2024主催メンバー (今年は会計リーダー)
    - オンライン開催のOSCで何度かセッションスタッフなど

<!--
趣味: クラシック音楽、カメラ(α7 R3)、お酒等
-->

---

# 今日のモチベーション

- Python パッケージ管理ツールの周辺状況が変わってきた
    - [PEP 621: Storing project metadata in `pyproject.toml`](https://peps.python.org/pep-0621/)
    - [Poetry](https://python-poetry.org)の普及や[Hatch](https://hatch.pypa.io/latest/), [Rye](https://rye.astral.sh), [uv](https://docs.astral.sh/uv/)などの新しいツールの台頭
- これらの比較紹介を昨年[PyCon TW](https://tw.pycon.org/2023/en-us/conference/talk/274), [PyCon APAC](https://2023-apac.pycon.jp/timetable?id=XEGZUD)で発表したので、情報をアップデートしてPythonコミュニティの外にも共有したい

---

# 今日話さないこと

- パッケージ管理ツール(Poetry, uvなど)の実装やその背景
- PEP (Python Enhancement Proposal)の詳細や経緯
- 複数バージョンのテスト実行など、ライブラリ作者向け情報
    - アプリケーションの開発プロジェクトに絞って話す予定
- Anacondaを用いた方法・開発フローなど

<!--
今日はPEP 621しか個別の番号に言及しません
-->

---
layout: toc
---

# 目次: 今日話すこと 

1. Python本体のバージョンを管理する方法
2. プロジェクト別に必要なものを管理する方法
    1. 個別に仮想環境を作成する
    2. 一つのPythonパッケージにする
    3. 必要な依存ライブラリを追加・管理する
3. 他の言語でやっている手順をPythonではどうやるか
4. おまけ1: Linter & Formatterのベストプラクティス
4. おまけ2: Pythonパッケージングの歴史概要

---

# 誤解を解くために: 各種ツールの目的・対象

- `pip`: Python 3系から同梱のパッケージインストーラー
- `pyenv`: Python本体を複数バージョン使えるようにするもの
- `Pipenv`: 仮想環境・依存パッケージ管理ツール
- `Poetry`: 仮想環境・依存パッケージ管理ツール (後発)
- `Hatch`: Pythonプロジェクト管理ツールでPyPAが開発元
    - [PyPA](https://www.pypa.io/en/latest/): Python Packaging Authority, PyPIや周辺ツールを開発・メンテナンスしている

---
layout: section
---

# Python本体のバージョン管理

---

# 今まで: マイナーバージョン(3.y)まで管理する

- ほとんど用途はこちらの方法で十分だった
- 別のコマンド名でインストールできる
    - `python3.9` と `python3.10` は別のコマンド

## インストール方法

- Windows / macOS: Python公式インストーラーで十分
    - CLIパッケージとして管理したいなら管理ツール(後述)
- Linux: 手動でビルド(後述) or 管理ツールなどを使う

---

# 手動でビルド・管理する (主にLinux)

Python.jpの「非公式Pythonダウンロードリンク」が便利
<https://pythonlinks.python.jp>

- apt, yumでビルドに必要なパッケージ・手順が書いてある
- `./configure --prefix` ではインストール先を指定してPATHを通すのが無難

---

# これから: 管理ツール(uv)を使う

最近話題になっている管理ツールを用いる方法で、  
**macOS, Linuxも今はこちらがスマート**

- 昔は[pyenv](https://github.com/pyenv/pyenv)が主流だったが、少々お行儀が悪い
    - 環境変数 `$PATH`, `$PYTHONPATH` などが汚れる
- 2024年9月現在は[uvを使う](https://docs.astral.sh/uv/concepts/python-versions/)のがオススメ
    - `uv venv --python 3.11.6` でインストール & venv作成
        - `3.11.6` まで不要なら `--python 3.11` でも問題ない

---
layout: pyconjp2024
---

# <twemoji-megaphone /> PyCon JP 2024 チケット発売中!

<!--
ここで番宣を挟みます

さて、今月末に迫ってきたPyCon JP 2024ですがチケットは購入いただけましたか?  
初心者から上級者まで様々なPythonユーザー向けにトークが2日間たくさんあります  
今年は公式パーティーもチケットに含まれています。
-->

---
layout: section
---

# プロジェクト別に必要なものを<br />管理する

---

# 個別にプロジェクト用の仮想環境を作成する

プロジェクト個別に依存ライブラリなどを管理するためにvenv(仮想環境)を作る必要がある  
(Node.js で言うと `node_modules` のような役割をするもの)

- uvを使っている場合(前述): `uv venv <venv_name>`
- uvなしの場合: `./path/to/python -m venv <venv_name>`

これで `<venv_name>` の場所に仮想環境フォルダが作成される

---

# 仮想環境のアクティベート (uvを使わない場合)

Node.js (npm)のように自動で仮想環境を認識はしてくれない。アクティベーションが必要  
**ただし、uvを使っている場合は不要**

- Bash, Zsh: `source <venv_name>/bin/activate`
- Fish: `source <venv_name>/bin/activate.fish`
- Cmd.exe: `<venv_name>\Scripts\Activate.bat`
- PowerShell: `<venv_name>\Scripts\Activate.ps1`

---
layout: section
---

# プロジェトを一つのパッケージにまとめる

## ライブラリとして配布するためではなく

---

# なぜパッケージングすることが必要なのか

- Pythonのimport文は複雑。相対importも可能だが難しい
- なるべく絶対importを使いたい
    - 絶対import: パッケージ名から記載していく方法
    - 相対import: カレントファイルを起点に探索する方法
- ので、現在のプロジェクトをインストールする必要がある
- つまりプロジェクトをパッケージとして作成する必要がある

---

# 最低限の `pyproject.toml`

パッケージにするため `pyproject.toml` を以下内容で作成して<br /> 本体(`spam_eggs/__init__.py`)を作成すると、`spam_eggs` が<br /> `uv sync` 実行でimport可能になる

```toml{all|1-3|5-7|all}
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "spam-eggs"
version = "2020.0.0"
```

<!--
相対インポート
-->

---

# ディレクトリ構造の作り方

2種類あるが、スタンダードは"flat layout" ([議論は続いている](https://packaging.python.org/en/latest/discussions/src-layout-vs-flat-layout/))
概ね以下のような構造になっているが、**ディレクトリ名は注意**

```
.
├── README.md
├── pyproject.toml
├── spam_eggs/
│   ├── __init__.py
│   └── module.py
└── scripts/
    └── decrease_world_suck.py
```

<!--
**インポート可能な名前である必要があるので、ディレクトリ名もsnake caseにする必要があります**
-->

---
layout: section
---

# 依存パッケージを追加する方法

## `uv add` を使う or `pyproject.toml` を直接編集する

---

# `uv add` を実行する (おすすめ)

- `uv add <package_name>` で依存パッケージが追加される
- `pyproject.toml` もバージョン指定込みで追記される
- (uv 0.3.0から) `uv.lock` という独自形式のLockファイルが作成される
    - `package-lock.json` (Node.js)などと同じ役割で、同様にGitで管理して良い

---

# バージョンを細かく指定したい場合

- `numpy>=2.1.0` のように記載する必要がある
    - [バージョン指定子は `~=`, `==`, `!=`, `<=`, `>` などが使用可能](https://packaging.python.org/en/latest/specifications/version-specifiers/#id5)
    - Node.jsでよく見る `^` 表記は `~=` に相当する
- コマンド例: `uv add 'numpy ~= 2.1.*'`
    - Node.jsの `"numpy": "^2.1.0"` と等価
    - 文字列として評価されるなら指定子の間のスペースは任意

---

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
layout: section
---

# 他の言語ユーザー向けの情報

## Pythonパッケージ内で不可能なこと

---

# タスク実行 (`npm run` 相当)

- pipだけでは不可能で `pyproject.toml` にもPEPでは未規定
- uvでも完全に等価な機能は存在しない (2024年9月現在)
- Lint, Format実行程度であれば `uvx` で代替可能?
    - ただし`npx`同様に毎度パッケージ評価が走る
- `uv run` で仮想環境内のコマンドを実行はすることは可能
- **->** 現状だと[tox](https://tox.wiki/en/stable/)か[nox](https://nox.thea.codes/en/stable/)を使用するのが無難

---

# その他、他の言語では可能な未実装の機能

- `site_packages` の実態を1箇所にまとめられるツール(bundlerやpnpmのようなもの)
- `cargo doc` のようなドキュメント生成機能
    - docstringはある仕組みだが、ドキュメント生成は不可能
    - [Sphinx](https://www.sphinx-doc.org/en/master/), [MkDocs](https://www.mkdocs.org)のようなツールが必要

---
layout: section
---

# おまけ1: Linter & Formatter事情

---

# Linter(静的解析), FormatterはRuffが主流

- Linter(静的解析)は[Flake8](https://pypi.org/project/flake8/), Formatterは[Black](https://pypi.org/project/black/)が主流だった
- 現在はどちらも[Ruff](https://docs.astral.sh/ruff/)に移行したプロジェクトが多い
    - Rust製で高速でモダンなLinter & Formatter
    - uvと同じ開発元のAstralが作っている
    - isort(import文の順番をFormatする)相当の機能もある
    - `setup.cfg` ではなく `pyproject.toml` で設定可能

---

# Ruffのルール・実行の手順

設定ファイル(`pyproject.toml`)の例:

```toml{all|4|5|all}
[tool.ruff]
target-version = "py311"
[tool.ruff.lint]
select = ["E", "F", "I"]
unfixable = ["F401", "F841"]
```

- `ruff check .` でLinter実行(`--fix` で修正も可能)
- `ruff format .` でFormat実行(`--diff` で差分確認など)

<!--
- デフォルトで1行は88文字(Blackと同じ)
- Lintのルールは `E`, `F` でFlake8相当で `I` も含めるとisort互換
-->

---
layout: section
---

# おまけ2: 歴史の話

---

# 歴史は長く、標準化は避けられてきた過去

- そもそもpipすら同梱されていなかった時代が長い
    - 昔はeasy_installというスクリプトを実行していた
    - そこからdistutils, setuptoolsが実装された
        - 注: distutilsは現在Deprecated
- venvの元となったvirtualenvも2007年
- 参考: [PythonのPackage Managerを深く知るためのリンク集 by @vaaaaanquish | GitHub Gist](https://gist.github.com/vaaaaanquish/1ad9639d77e3a5f0e9fb0e1f8134bc06)

---

# Pipenv, Poetryと[PEP 621](https://peps.python.org/pep-0621/)の採択・実装の普及

- Pipenv, Poetryの形式も標準として採用されなかった過去
    - Pipenvは当初独自のファイルだった(現在はPEP 621準拠)
    - Poetryも `pyproject.toml` に記述だが、独自の名前空間
        - こちらは未だにPEP 621準拠していない
- ここ数年でPEP 621準拠の実装がスタンダードになってきた
- Astralによって開発されているuvも機能が充実してきた
    - 一般的な開発プロジェクトでも採用している例が増加

---
layout: section
---

# おわりに

## まとめ・参考資料集

---

# まとめ

- Python本体のバージョン管理はuvを使うのがオススメ
- プロジェクト個別の仮想環境作成もuvがオススメ
    - 構造はプロジェクト直下にパッケージ名のフォルダを作成
    - 依存パッケージの追加は `uv add` を使う
- タスクランナーや依存を1箇所にまとめたり、ドキュメント生成をするような機能は標準では不可能
- Linter & FormatterはRuffを使うのが高速でモダン

---

# その他の参考資料など (1/2)

- PyCon APAC 2023 (英語発表)
    - 資料: <https://slides.p3ac0ck.net/pyconapac2023/1>
    - 動画アーカイブ: <https://www.youtube.com/watch?v=909hErbppUo>
- uv公式ドキュメント: <https://docs.astral.sh/uv/>
- venv(Python公式ドキュメント): <https://docs.python.org/3.12/library/venv.html>

---

# その他の参考資料など (2/2)

- Python Packaging User Guide
    - 英語: <https://packaging.python.org/en/latest/>
    - 日本語: <https://packaging.python.org/ja/latest/>
- 筆者のPythonプロジェクト用テンプレート: <https://github.com/peacock0803sz/python-template/>

---
layout: pyconjp2024
---

# おしまい / PyCon JP 2024で再開! <twemoji-waving-hand />

<!--
PyCon JP 2024で再開しましょうー
-->
