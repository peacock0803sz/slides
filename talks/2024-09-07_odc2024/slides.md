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
- Anacondaの使用方法・開発フローなど

---

# 今日話すこと

1. Python本体のバージョンを管理する方法
2. プロジェクト別に必要なものを管理する方法
    1. 個別に仮想環境を作成する
    2. 一つのPythonパッケージにする
    3. 必要な依存ライブラリを追加・管理する
3. 他の言語でやっている手順をPythonではどうやるか
4. おまけ: Linter & Formatterのベストプラクティス

---

# 誤解を解くために: 各種ツールの目的・対象

- `pip`:
- `pyenv`:
- `Pipenv`:
- `Poetry`:
- `Hatch`:

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

<!--
ここで番宣を挟みます
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

# 手動でバージョンを指定したい場合

- `numpy>=2.1.0` のように記載する必要がある
    - [バージョン指定子は `~=`, `==`, `!=`, `<=`, `>` などが使用可能](https://packaging.python.org/en/latest/specifications/version-specifiers/#id5)
    - Node.jsでよく見る `^` 表記は `~=` に相当する
- コマンド例: `uv add 'numpy ~= 2.1.*'`
    - Node.js (`package.json`)の `"numpy": "^2.1.0"` と等価
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

## Pythonパッケージ内で可能なこと・不可能なこと

---

# タスク実行 (`npm run` 相当)

- pipだけでは不可能で `pyproject.toml` にもPEPでは未規定
- uvでも完全に等価な機能は存在しない (2024年9月現在)
- Lint, Format実行程度であれば `uvx` で代替可能?
    - ただし`npx`同様に毎度パッケージ評価が走る
- `uv run` で仮想環境内のコマンドを実行はすることは可能
- **->** 現状だと[tox](https://tox.wiki/en/stable/)か[nox](https://nox.thea.codes/en/stable/)を使用するのが無難

---
layout: section
---

# おまけ1: Linter & Formatter事情

---

# Linter, FormatterはRuffが主流

---

# Ruffのルールについて

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
- 参考: <https://www.youtube.com/watch?v=c5zV9xBP-A0>

---

# Pipenv, Poetryでも標準化は達成できなかった
