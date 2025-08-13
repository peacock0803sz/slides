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

# Pythonパッケージマネージャの歴史

---

# Easy Install時代

---

# pipの登場

---

# Pipenv, Poetryの台頭

---

# `setup.py` / `setup.cfg`から`pyproject.toml`へ

---

# uvの急浮上と`pylock.toml`

---
layout: section
---

# 他言語のパッケージマネージャとの違い

---

# 他言語のパッケージマネージャとの比較

| 機能 \ ツール名      | pip | npm | bundler | composer | go mod | cargo |
| -------------------: | :-: | :-: | :-----: | :------: | :----: | :---: |
| パッケージ追加       |  ○  |  ○  |    ○    |     ○    |    ○   |   ○   |
| 開発用パッケージ管理 |  ×  |  ○  |         |          |        |       |
| パッケージ更新       |  ×  |  ○  |         |          |        |       |
| パッケージ削除       |  ○  |  ○  |         |          |        |       |
| タスク定義・実行     |  ×  |  ○  |         |          |        |       |

---

# Python Packaging Authority (PyPA)

---

# Python的な思想とは

---

## 誤解されがちな`requirement.txt`の用法

---
layout: section
---

# 急浮上のパッケージマネージャ「uv」

---

# uvの機能・特徴

---

# 個人的uvのオススメ使い方

---
hideInToc: true
---

# まとめ

---
hideInToc: true
---

# PyCon JP 2025
