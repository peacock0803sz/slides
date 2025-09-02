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
1. 他言語のパッケージマネージャとの違い
1. 主要なPythonパッケージマネージャの比較
1. 急浮上のパッケージマネージャ「uv」
1. 2025年版 ツール選択ガイド

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
    * ソースコード形式のパッケージ。インストール時にビルDが必要な場合がある
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

# 補足: 誤解されがちな`requirement.txt`の用法

* `requirements.txt`は**アプリケーション**の依存関係を固定(バージョンピニング)するためのもの
    * `pip freeze > requirements.txt`で生成されるファイルは、その環境を正確に再現するためのもの
* **ライブラリ**開発で依存関係を記述する場合は、`pyproject.toml`の`dependencies`にバージョン範囲を緩やかに指定するべき
    * ライブラリに`requirements.txt`を含めてしまうと、利用側のアプリケーションで依存関係の衝突を引き起こす原因になる

---

# Pipenv, Poetryの台頭

* 2017年ころに[Pipenv](https://pipenv.pypa.io/en/latest/)が登場し、ロックファイル(`Pipfile.lock`)を自動的に生成したり管理できるようになった
    * pipでは[Constraintsを使う必要](https://p3ac0ck.net/posts/20220315-pip-install-constraint/)があったが、手順が煩雑で浸透していない
    * ただし`setup.py`や`setup.cfg`で指定することはできず、独自の`Pipfile`というTOML形式のファイルで記述・管理する
* `pyproject.toml`(後述)が浸透してきた2019年ころから、このファイルを使える[Poetry](https://python-poetry.org)のシェアが伸びてきた

<!--
スピーカーノート:
なぜロックファイルが重要なのか？
「自分の環境では動くのに、サーバーでは動かない」という経験はありませんか？
これは依存ライブラリの"孫"依存（推移的依存）のバージョンが固定されていないために起こります。
ロックファイルは、ハッシュ値まで含めて環境の完全な再現性を保証する「未来への約束」です。
-->

---

# `setup.py` / `setup.cfg`から`pyproject.toml`へ

* 昔のPythonパッケージは`setup.py`でビルドやメタデータを定義していた
    * **功**: 柔軟性が高く、Pythonコードで複雑なビルド処理を記述できた
    * **罪**: 任意のコードが実行でき、実行するまで依存関係が不明だった (セキュリティリスク、鶏と卵問題)
* その後、静的に記述できる`setup.cfg`が推奨されるようになった
* **[PEP 518](https://peps.python.org/pep-0518/)** で`pyproject.toml`が導入、ビルドシステムの依存関係を記述可能に
* **[PEP 517](https://peps.python.org/pep-0517/)** でsetuptools以外のビルドバックエンドも選択可能に
* 現在では`pyproject.toml`にメタデータとビルド設定を記述するのが標準

<!--
詳細なスピーカーノート:
- `setup.py`の罪: `pip install`時に任意のコードが実行可能だったため、悪意あるコードを仕込むことができました。また、`setup.py`を実行するまでビルドに必要な依存関係が不明でした。
- `pyproject.toml`の登場により、FlitやPoetry、Hatchのようなモダンなツールが台頭する道が拓かれました。
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
- PEP 665の棄却は、Pythonの仕様策定プロセスがコミュニティの意見を尊重し、健全に機能している証拠とも言えます。
- `pylock.toml`の採択により、ツール間で互換性のあるロックファイルが利用可能になる未来が期待されます。
-->

---
layout: section
---

# 他言語のパッケージマネージャとの違い

---

# 他言語のパッケージマネージャとの比較

| 機能 \ ツール名      | **pip** | **uv** | npm | bundler | composer |  cargo |
| -------------------: | :-----: | :----: | :-: | :-----: | :------: |  :---: |
| パッケージ追加       |    ○    |    ○   |  ○  |    ○    |     ○    |    ○   |
| 開発用パッケージ管理 |    △    |    ○   |  ○  |    ×    |     ○    |    ○   |
| パッケージ更新       |    △    |    ○   |  ○  |    △    |     ○    |    ○   |
| パッケージ削除       |    △    |    ○   |  ○  |    △    |     ○    |    ○   |
| タスク定義・実行     |    ×    |    ○   |  ○  |    ○    |     ○    |    ○   |

<!--
* `pip`はあくまで**パッケージインストーラー**であり、npmやcargoのようなプロジェクト管理機能は持たない
* 開発用パッケージは`requirements-dev.txt`などで管理、更新は`pip-compile`など別ツールが必要だった
* Poetryやuvのようなモダンなツールは、これらの機能を`pyproject.toml`で統合的に扱えるようにしている
-->

---

# Python Packaging Authority (PyPA)

* PyPA: Pythonのパッケージングに関する標準仕様(PEP)の策定や、コアツール群をメンテナンスしているワーキンググループ
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
    * 原文: There should be one \-\- and preferably only one \-\- obvious way to do it.
* パッケージ管理の現状は上記に反しているように見えるかもしれない
* しかし、PyPAの思想は**疎結合なツールの組み合わせ**が基本
    *  `venv` / `virtualenv` (仮想環境管理), `pip` (インストーラ), `twine` (公開)
* PoetryやuvのようなAll-in Oneなツールは**密結合**なアプローチ
* しかし、標準仕様(PEP)に準拠しているためエコシステムの中で共存できる

<!--
スピーカーノート:
- 原文: "There should be one-- and preferably only one --obvious way to do it."
- 多様性と標準化のバランスを取るのがPyPAの役割
-->

---
layout: section
---

# 主要なパッケージ管理ツールの比較

---
layout: sectionImg
---

<div class="box">
<div class="inner">

# Pipenv

## <https://pipenv.pypa.io/en/latest/>

</div>
<img src="https://pipenv.pypa.io/en/latest/_static/pipenv.png" />
</div>

<!--
最初に紹介するのはPipenvです。

2018年頃に非常に人気がありましたが、その人気は落ち着いたように見えますが、現在もメンテナンスは続けられています。
これを知らない人はいますか？画期的なツールでした。しかし、私はこれをお勧めしないので、多くは説明しません。
-->

---

# Pipenv: Pros (長所)

- ロックファイルに対応
- パッケージの追加/アップグレードが容易
- virtualenvをラップ

# Pipenv: Cons (短所)

- 依存関係リゾルバが遅い (改善された？)
- PEP 621スタイルの`pyproject.toml`のサポートが限定的

<!--
ロックファイルをPythonコミュニティにもたらしたことで、非常に先進的でした。
`pipenv upgrade`コマンドで、依存関係を簡単にアップグレードできます。
また、virtualenvをラップすることも革命的でした。virtualenvのactivateやdeactivateを気にする必要がなくなりました。

しかし、**PEP 621**スタイルの`pyproject.toml`のサポートが限定的です。
新しいプロジェクトでこれを使用することは、もはや良い考えではないと思います。
-->

---
layout: sectionImg
---

<div class="box">
<div class="inner">

# Poetry

## <https://python-poetry.org/>

</div>

<img src="https://python-poetry.org/images/logo-origami.svg" />
</div>

<!--
次にPoetryです。

2020年頃に有名になったと記憶していますが、今でも人気のあるツールだと思います。
仕事や他のプロジェクトでこれを使っている方はどれくらいいますか？使っている方は手を挙げてください。
おお、たくさんいますね。このトークの中で最も人気のあるツールだと思いますが、私はこれをお勧めしません。
-->

---

# Poetry: Pros (長所)

- ロックファイルによる依存関係管理
- virtualenvをラップ
- タスクランナー(`poetry run`)を同梱
- wheelビルドのヘルパー機能

# Poetry: Cons (短所)

- [PEP 621](https://peps.python.org/pep-0621/)スタイルの`pyproject.toml`に非対応

<!--
Poetryには説明しきれないほど多くの機能がありますが、主にいくつかを紹介します。
言うまでもなく、Pipenvよりも後発なので、ロックファイルに対応し、virtualenvをラップしています。

そしてご存知かもしれませんが、Poetryが非常に革命的だった点は、タスクランナーとwheelビルドのヘルパーを同梱していたことです。これにより、パッケージ公開者はパッケージのビルド、テスト、公開が容易になります。

短所の一つは、PEP 621スタイルの`pyproject.toml`をサポートしていないことです。
PoetryはPEP 621が承認される前に登場しましたが、議論はまだ続いています。
virtualenvを持つプロジェクトにインストールすると、多くの依存パッケージと競合が発生する可能性があることに注意してください。
-->

---
layout: sectionImg
---

<div class="box">
<div class="inner">

# PDM

## <https://pdm.fming.dev/latest/>

</div>

<img src="https://pdm.fming.dev/latest/assets/logo.svg" />
</div>

<!--
3つ目はPDMです。

このトークのプロポーザルを書くまでこのツールを知りませんでしたが、非常に興味深いツールのようです。
-->

---

# PDM: Pros (長所)

- 高速な依存関係リゾルバ
    - ただし、別のリゾルバを選択することも可能
- [PEP 621](https://peps.python.org/pep-0621/)スタイルの`pyproject.toml`に対応
- タスクランナー(`pdm run`)、パッケージ公開機能を同梱

# PDM: Cons (短所)

- GitHubスターが少ない / あまり有名ではない

<!--
これには2つの利点があります。
1つ目は高速な依存関係リゾルバです。今日紹介するツールの中で最速です。しかし、別の依存関係リゾルバを選択することもできます。
次のポイントは、PEP 621スタイルの`pyproject.toml`をサポートしていることです。先の2つはサポートが限定的または非対応でしたが、これは既に対応済みです。そのため、フォーマットがPEPによって標準化されており、他のツールへの移行が容易かもしれません。
タスクランナー、wheelビルダー、パッケージ公開機能も含まれています。

一つの欠点は、有名ではないため、ユーザーが少なく、十分な知識（ナレッジ）がない可能性があることです。
-->

---
layout: sectionImg
---

# pip-tools

## <https://pip-tools.readthedocs.io/en/latest/>

<!--
4つ目はpip-toolsです。

これ以降のツール、pip-tools、hatch、pipは、すべてを網羅するものではなく、限定的な機能を提供するものであることに注意してください。
-->

---

# pip-tools: Pros (長所)

- 使い方がシンプル、**コマンドは2つだけ**
- PEP 621スタイルの`pyproject.toml`の依存関係定義に対応
    - pipやhatchと組み合わせ可能
- [Jazzband](https://jazzband.co)コミュニティによってメンテナンスされている

# pip-tools: Cons (短所)

- タスクランナー、wheelビルダー、パッケージ公開機能は含まれていない

<!--
使い方は非常にシンプルで、`pip-compile`と`pip-sync`の2つのコマンドしかありません。また、PEP 621スタイルの`pyproject.toml`での依存関係定義もサポートしています。
もう一つの利点は、Jazzbandコミュニティによってメンテナンスされており、多くのDjangoユーティリティがあることです。コミュニティによるガバナンスは非常に重要だと思います。

しかし、言うまでもなく、タスクランナー、wheelビルダー、パッケージ公開機能は含まれていません。
そのため、次に紹介するHatchと一緒に使うことをお勧めします。
-->

---
layout: sectionImg
---

<div class="box">
<div class="inner">

# Hatch

## <https://hatch.pypa.io/latest/>

</div>

<img src="https://hatch.pypa.io/latest/assets/images/logo.svg" />
</div>

<!--
5つ目はHatchです。pipを除けば、このトークで紹介する最後のツールです。

ごく最近公開されたもので、多くの方が興味を持っているかもしれません。
-->

---

# Hatch: Pros (長所)

- プロジェクトビルドのバックエンドとして設定可能
- [PyPA](https://www.pypa.io)によって活発にメンテナンスされており、ほぼ公式
- `pyproject.toml`仕様、[PEP 621](https://peps.python.org/pep-0621/)スタイルで動作

# Hatch: Cons (短所)

- 依存関係の更新機能は含まれていない
- ロックファイルに非対応

<!--
プロジェクトビルドのバックエンドとして非常に設定可能で、pip-toolsのような他のツールと一緒に使用できます。
そして、PyPA（Python Packaging Authority）によって活発にメンテナンスされており、ほぼ公式です。

新参者なので、もちろん`pyproject.toml`仕様、PEP 621スタイルで動作します。
しかし、設定可能であることは、ほぼ複雑であることと同じだと思います。使用するにはドキュメントを注意深く読んで理解する必要があります。

また、依存関係の更新機能やロックファイルは含まれていません。
-->

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
layout: section
---

# あなたのプロジェクトに最適なツールは？

---

# 2025年版 ツール選択ガイド

「で、結局何を使えばいいの？」という疑問に答えます。

| ユースケース | 推奨ツール | 理由 |
| :--- | :--- | :--- |
| **Webアプリ開発**<br/>(Django, FastAPI) | **Poetry** or **uv** | ロックファイルによる厳格な環境再現性が不可欠。`uv`の速度はデプロイ時間短縮に直結。 |
| **ライブラリ開発・公開** | **Hatch** or **PDM** | ビルド、バージョン管理、PyPI公開までのワークフローが洗練されている。PEP 621準拠。 |
| **データサイエンス**<br/>(Jupyter, scikit-learn) | **uv** or (`pip` + `pip-tools`) | 多数のバイナリパッケージを高速にインストールできる`uv`が有利。伝統的な`requirements.in`も依然有効。 |
| **ちょっとしたスクリプト** | `pip` + `venv` | 標準ライブラリだけで完結。シンプルで追加インストール不要。 |

---

# ベストプラクティスとアンチパターン

*   アンチパターン: ライブラリの`pyproject.toml`にバージョンを固定(`==`)
    * 利用側のアプリで依存関係衝突の地獄を見る原因になる
*   ベストプラクティス: 依存バージョンの使い分け
    * **ライブラリ開発**: `dependencies`には互換性のある範囲で緩やかに指定 (`>=`, `~=`)
    * **アプリケーション開発**: ロックファイルで全依存を厳格に固定
*   ベストプラクティス: 脆弱性管理を自動化する
    * `pip-audit`やGitHubの`Dependabot`をCIに組み込む

---
hideInToc: true
---

# まとめ

* Pythonのパッケージ管理は、**標準化(PEP)と多様なツールの競争**によって進化してきた
* `setup.py`の課題を`pyproject.toml`が解決し、ロックファイルが環境再現性を実現
* 特に**uv**は、既存のエコシステムとの互換性を保ちつつ、圧倒的なパフォーマンスで新たなスタンダードになりつつある
* **ツールの選択に銀の弾丸はない**。自分のプロジェクトの特性を理解し、適切なツールを選択・活用することが最も重要

---

# PyCon JP 2025
