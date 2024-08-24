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
- 24歳、千葉県在住 (札幌出身)
- [株式会社G-gen](https://www.g-gen.co.jp/)でGoogle Cloudの技術サポート
- 技術イベント、カンファレンスが大好き
    - PyCon JP 2024主催メンバー (今年は会計リーダー)
    - オンライン開催のOSCで何度かセッションスタッフなど
- 趣味: クラシック音楽、カメラ(α7 R3)、お酒等

---

# 今日のモチベーション

- Python パッケージ管理ツールの周辺状況が変わってきた
    - [PEP 621: Storing project metadata in pyproject.toml](https://peps.python.org/pep-0621/)
    - [Poetry](https://python-poetry.org)の普及や[Hatch](https://hatch.pypa.io/latest/), [Rye](https://rye.astral.sh), [uv](https://docs.astral.sh/uv/)などの新しいツール
- これらの比較紹介を昨年[PyCon TW](https://tw.pycon.org/2023/en-us/conference/talk/274), [PyCon APAC](https://2023-apac.pycon.jp/timetable?id=XEGZUD)で発表したので、情報をアップデートしてPythonコミュニティの外にも共有したい

---

# 今日話さないこと

- PEP (Python Enhancement Proposal)の詳細や経緯など

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

管理ツールを用いる方法。**macOS, Linuxも今はこちらが良い**

- 昔は[pyenv](https://github.com/pyenv/pyenv)が主流だったが、少々お行儀が悪い
    - 環境変数 `$PATH`, `$PYTHONPATH` などが汚れる
- 2024年9月現在は[uvを使う](https://docs.astral.sh/uv/concepts/python-versions/)のがオススメ
    - `uv venv --python 3.11.6` でインストールしてvenvを作成
        - `3.11.6` まで不要なら `uv venv --python 3.11` でもOK

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

# プロジェトを一つのPythonパッケージにする

---

# 最低限の `pyproject.toml`

パッケージにするため `pyproject.toml` を以下内容で作成して<br /> 本体(`spam_eggs/__init__.py`)を作成すると、`spam_eggs` が<br /> `uv pip install -e .` 実行でインポートできるようになる

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

---
layout: section
---

# 依存パッケージを追加する方法

## `uv pip` を使う or `pyproject.toml` を直接編集する

---

# `uv pip` を実行する

---

# `pyproject.toml` を直接編集する

---
layout: section
---

# 他の言語ユーザー向けの情報

## Pythonパッケージ内で可能なこと・不可能なこと

---
layout: section
---

# おまけ: Linter & Formatter事情
