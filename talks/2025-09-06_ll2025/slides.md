---
theme: ../../themes/simple
titleTemplate: "%s: 2025-09-06 Learn Languages 2025"
favicon: https://media.p3ac0ck.net/icons/peacock.jpg
layout: cover
lineNumbers: true
htmlAttrs:
  lang: ja
seoMeta:
  ogTitle: Pythonパッケージマネージャの過去と現在と未来
  ogDescription: Peacock (Yoichi Takai), at 2025-09-06 Learn Languages 2025
  ogImage: https://slides.p3ac0ck.net/ll2025/cover.png
  ogUrl: https://slides.p3ac0ck.net/ll2025/index.html
  twitterCard: summary_large_image
  twitterTitle: Pythonパッケージマネージャの過去と現在と未来
  twitterDescription: Peacock (Yoichi Takai), at 2025-09-06 Learn Languages 2025
  twitterImage: https://slides.p3ac0ck.net/ll2025/cover.png
  twitterSite: https://slides.p3ac0ck.net/
  twitterUrl: https://slides.p3ac0ck.net/ll2025/index.html
hideInToc: true
---

# Python<br />パッケージマネージャの<br />過去と現在と未来

### Peacock (Yoichi Takai)<br />2025-09-06 Learn Languages 2025

---
layout: intro
hideInToc: true
---

# 本日の資料 (URL or QRコード)

### [`https://slides.p3ac0ck.net/ll2025/`](https://slides.p3ac0ck.net/ll2025/)

## 写真もご自由に <twemoji-camera />

<QRCode text="https://slides.p3ac0ck.net/ll2025/" />

---
layout: toc
---

# 目次

1. 前提: 用語のおさらい解説
1. Pythonパッケージマネージャの歴史
    1. Easy Installからpipまで、Pipenv, Poetryの台頭
    1. `setup.py` (`.cfg`)から`pyproject.toml`への移行
    1. uvの急浮上と`pylock.toml`の動向
1. 他言語のパッケージマネージャとの違い
    1. 他言語のパッケージマネージャとの比較
    1. Python Packaging Authority (PyPA), Python的な思想
1. 急浮上のパッケージマネージャ「uv」
    1. uvの機能・特徴、個人的uvのオススメ使い方

---
layout: profile
---

<img src="https://media.p3ac0ck.net/icons/PyConAPAC2023.jpg" />

# お前、誰よ

- 名前: Peacock (高井 陽一), SNS -> `peacock0803sz`
- 仕事: [株式会社G-gen](https://g-gen.co.jp/)でGoogle Cloudの技術サポート
    - [Google Cloud Partner Top Engineer 2025受賞](https://g-gen.co.jp/news/pte_2025.html)
- 技術イベント、カンファレンスが大好き
    - PyCon JP 2020 - [2025](https://2025.pycon.jp/)主催メンバー(スタッフ)
    - [PyCon JP TV](https://tv.pycon.jp)ディレクター
- 趣味: クラシック音楽、カメラ(α7R III)、ビールなど
    - 技術カンファレンスの撮影スタッフもやっている
    - Open Source Conferenceで2020年ころに配信スタッフ業

---
layout: section
---

# 前提: 用語のおさらい解説

---

# 用語解説 (1/3)

* **PEP (Python Enhancement Proposal)**
    * Pythonの機能追加や改善などを提案・議論・決定するためのドキュメント
    * パッケージ管理に関する重要な仕様もPEPとして提案されている (例: [PEP 621](https://peps.python.org/pep-0621/))
* **PyPI (Python Package Index)**
    * `pip`がデフォルトでパッケージを探しに行く公式のパッケージリポジトリ
    * `pip install <package-name>`でインストールできるのは、ここに登録されているパッケージ

---

# 用語解説 (2/3)

* **パッケージ (Package) / モジュール (Module)**
    * **モジュール**: Pythonのコードが書かれた単一のファイル (`.py`)
    * **パッケージ**: モジュールや他のパッケージをまとめたディレクトリ構造。再利用可能な単位として配布される
* **仮想環境 (Virtual Environment)**
    * プロジェクトごとに独立したPythonの実行環境とライブラリを管理する概念
    * `venv`モジュールで作成するのが標準的 (`python -m venv .venv`)

---

# 用語解説 (3/3)

* **sdist (Source Distribution)**
    * ソースコード形式のパッケージ。インストール時にビルドが必要な場合がある
    * `tar.gz`形式で配布される
* **Wheel**
    * ビルド済みのパッケージ形式。`sdist`より高速にインストールできる
    * `.whl`という拡張子で、ファイル名にPythonバージョンやOSなどの情報が含まれる
    * 基本的に`pip`はWheel形式を優先してインストールしようとする

---
layout: section
---

# Pythonパッケージマネージャの歴史

---

# Easy Install時代

* 大昔(2004 - 2008年ころ)は[Easy Install](https://setuptools.pypa.io/en/latest/deprecated/easy_install.html)というPythonモジュールでパッケージのダウンロード、ビルド、インストールなどをやっていた
    * PyPI(パッケージレジストリ)に登録されているパッケージの場合は`easy_install SQLObject`でインストールする
* 基本的にはEgg形式のパッケージをインストールできるのみの単純なもの
* 以下のような場合は手動で特定のディレクトリに配置する必要がある
    * 既にインストールしたパッケージのアンインストール
    * [Wheel](https://packaging.python.org/en/latest/glossary/#term-Wheel)形式のパッケージをインストール

---

# pipの登場

* 2008年の後半ころにEasy Installの代替としてpipが登場した
* Python 3.4(2014年リリース)からPython本体に同梱されるようになった
* Easy Installでは不可能だったがpipで可能になったこと
    * Wheel形式のパッケージがインストール
    * Eggではなくフラットな[sdist](https://packaging.python.org/en/latest/glossary/#term-Source-Distribution-or-sdist)形式パッケージをインストール
    * [Requirementsファイル](https://packaging.python.org/en/latest/glossary/#term-Requirements-File)(`requirement.txt`)の指定や出力
    * インストール済パッケージの一覧を表示

---

# Pipenv, Poetryの台頭

* 2017年ころに[Pipenv](https://pipenv.pypa.io/en/latest/)が登場し、ロックファイル(`Pipfile.lock`)を自動的に生成したり管理できるようになった
    * pipでは[Constraintsを使う必要](https://p3ac0ck.net/posts/20220315-pip-install-constraint/)があったが、手順が煩雑で浸透していない
    * ただし`setup.py`や`setup.cfg`で指定することはできず、独自の`Pipfile`というTOML形式のファイルで記述・管理する
* `pyproject.toml`(後述)が浸透してきた2019年ころから、このファイルを使える[Poetry](https://python-poetry.org)のシェアが伸びてきた

---

# `setup.py` / `setup.cfg`から`pyproject.toml`へ

* 昔のPythonパッケージは`setup.py`でビルドやメタデータを定義していた
    * 問題点: 任意のPythonコードが実行でき、実行するまで依存関係が不明
* その後、静的に記述できる`setup.cfg`が推奨されるようになった
* **[PEP 518](https://peps.python.org/pep-0518/)** で`pyproject.toml`が導入、ビルドシステムの依存関係を記述可能に
* **[PEP 517](https://peps.python.org/pep-0517/)** でsetuptools以外のビルドバックエンドも選択可能に
* 現在では`pyproject.toml`にメタデータとビルド設定を記述するのが標準

<!--
詳細なスピーカーノート:
- これによりFlitやPoetryのようなモダンなツールが台頭
- セキュリティリスクの改善も大きな要因
-->

---

# uvの急浮上と`pylock.toml`

* Rust製の静的解析ツール「[ruff](https://astral.sh/ruff)」で注目を浴びた[Astral社](https://astral.sh)が「uv」をリリース
* `pip`や`pip-tools`, `venv`の機能を単一のバイナリで提供し、圧倒的なパフォーマンスを誇る
* `pylock.toml`という新しいロックファイル形式のサポートも試験的に導入
    * [PEP 665](https://peps.python.org/pep-0665/)で提案された`pyproject.lock`は一度棄却された
    * その後、再度[PEP 751](https://peps.python.org/pep-0751/)で`pylock.toml`として再度提案されて採択された

<!--
スピーカーノート:
- pylock.tomlもその流れを汲んでおり、今後の動向が注目される
- uvの登場でPythonパッケージ管理の高速化が一気に進んだ
-->

---
layout: section
---

# 他言語のパッケージマネージャとの違い

---

# 他言語のパッケージマネージャとの比較

| 機能 \ ツール名      | pip | npm | bundler | composer | go mod | cargo |
| -------------------: | :-: | :-: | :-----: | :------: | :----: | :---: |
| パッケージ追加       |  ○  |  ○  |    ○    |     ○    |    ○   |   ○   |
| 開発用パッケージ管理 |  △  |  ○  |    ○    |     ○    |    ○   |   ○   |
| パッケージ更新       |  △  |  ○  |    ○    |     ○    |    ○   |   ○   |
| パッケージ削除       |  ○  |  ○  |    ○    |     ○    |    ○   |   ○   |
| タスク定義・実行     |  ×  |  ○  |    ○    |     ○    |    ×   |   ○   |

<!--
* `pip`はあくまで**パッケージインストーラー**であり、npmやcargoのようなプロジェクト管理機能は持たない
* 開発用パッケージは`requirements-dev.txt`などで管理、更新は`pip-compile`など別ツールが必要だった
* Poetryやuvのようなモダンなツールは、これらの機能を`pyproject.toml`で統合的に扱えるようにしている
-->

---

# Python Packaging Authority (PyPA)

* PyPAは、Pythonのパッケージングに関する標準仕様(PEP)の策定や、コアツール群をメンテナンスしているワーキンググループ
* **特定のツールを「公式」と定めるのではなく、標準仕様を定めることで、多様なツールが共存できるエコシステム**を目指している
    * コアツール: `pip`, `setuptools`, `virtualenv`, `twine`など
* この思想が、Pythonのパッケージ管理が「ツールが多くて複雑」と言われる一因でもある
    * 逆に言えば、用途に応じて最適なツールを組み合わせる**柔軟性**がある

<!--
スピーカーノート:
- twine: PyPIへのアップロードツール
- warehouse: PyPIのバックエンド
-->

---

# Python的な思想とは

* [The Zen of Python](https://peps.python.org/pep-0020/)では「明白な方法は一つ、できれば唯一つであるべき」
* パッケージ管理の現状はこれに反しているように見えるかもしれない
* しかし、PyPAの思想は**疎結合なツールの組み合わせ**が基本
    *  `venv` (仮想環境管理), `pip` (インストーラ), `twine` (公開)
* Poetryやuvのようなオールインワンツールは**密結合**なアプローチだが、標準仕様(PEP)に準拠しているためエコシステムの中で共存できる

<!--
スピーカーノート:
- 原文: "There should be one-- and preferably only one --obvious way to do it."
- 多様性と標準化のバランスを取るのがPyPAの役割
-->

---

## 誤解されがちな`requirement.txt`の用法

* `requirements.txt`は**アプリケーション**の依存関係を固定(バージョンピニング)するためのもの
    * `pip freeze > requirements.txt`で生成されるファイルは、その環境を正確に再現するためのもの
* **ライブラリ**開発で依存関係を記述する場合は、`pyproject.toml`の`dependencies`にバージョン範囲を緩やかに指定するべき
    * ライブラリに`requirements.txt`を含めてしまうと、利用側のアプリケーションで依存関係の衝突を引き起こす原因になる

---
layout: section
---

# 急浮上のパッケージマネージャ「uv」

---

# uvの機能・特徴

* **圧倒的なパフォーマンス**
    * Rust製で、依存関係の解決やパッケージのダウンロード・ビルドを並列で実行
    * グローバルキャッシュを賢く利用し、`pip`と比較して10倍から100倍高速
* **オールインワン**
    * `pip`, `pip-tools`, `virtualenv`の主要な機能を単一のバイナリで提供
    * `uv pip install`, `uv venv`, `uv pip compile`のように一貫したインターフェース
* **プロジェクト管理**: `uv init`, `uv add`でプロジェクト作成・管理
* **Pythonバージョン管理**: 複数バージョンの自動インストール・切り替え

---

# 個人的uvのオススメ使い方

* **CI/CDでの利用**
    * キャッシュ効率が良く高速なため、CI/CDパイプラインにも適している
    * GitHub Actionsでは[`setup-uv`](https://github.com/astral-sh/setup-uv)が利用可能

---
hideInToc: true
---

# まとめ

* Pythonのパッケージ管理は、標準化(PEP)と多様なツールの開発によって進化してきた
* かつては`pip`を中心とした疎結合なツールを組み合わせるのが主流だった
* Poetryやuvのようなモダンなオールインワンツールが登場し、利便性が大きく向上
* 特に**uv**は、既存のエコシステムとの互換性を保ちつつ、圧倒的なパフォーマンスで新たなスタンダードになりつつある
* 自分のプロジェクトの特性やチームの好みに合わせて、適切なツールを選択することが重要

---

# PyCon JP 2025
