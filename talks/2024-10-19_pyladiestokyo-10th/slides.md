---
theme: "../../themes/geometricals"
titleTemplate: "PyCon JP 2024の採択会議を支えた技術 [PyCon JP 2024 LT]"
favicon: https://media.p3ac0ck.net/icons/peacock.jpg
layout: cover
lineNumbers: true
htmlAttrs:
  lang: ja
---

# PyCon JP 2024の<br />採択会議を支えた技術

## Streamlit, FirestoreとGoogle Cloud IAPを添えて

### 2024-09-27, [PyCon JP 2024](https://2024.pycon.jp) Day1 LT<br />by Peacock (Yoichi Takai) @peacock0803sz

---
layout: intro
---

# まえおき

<img src="/qrcode.svg" />

## 本日の資料 (URL or QRコードから)

<div class="url">

[`slides.p3ac0ck.net/pyconjp2024/`](https://slides.p3ac0ck.net/pyconjp2024/)

</div>

<div class="box">

**写真もご自由に <twemoji-camera />**  
ハッシュタグ: `#pyconjp`

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
    - PyCon JP 2024主催メンバー (会計リーダー)
    - 2022, 2023(APAC)では副座長

<!--
趣味: クラシック音楽、カメラ(α7 R3)、お酒等
-->

---

# 採択会議の苦労ポイント

- 近年はトーク枠に対して3倍以上のプロポーザル応募
- 年で話題(トラック)やレベルにバラつきがある(以下に例)
    - AI / ML系は応募多数だが、逆にIoT分野が少ない
    - 初心者向けが多く、上級者向けが少ない
- バランスを考慮しつつトークを採択する必要がある
    - レビュアーによるスコアの偏りも考慮する必要がある

---

# 採択会議を丸一日かけても全て決定するのは困難

例年、採択会議は以下のようなプロセスで進めている

1. 事前に3名以上のレビューによってスコア化される
1. 上位スコアのプロポーザルは採択会議前に確定する
1. 同一の投稿者によるプロポーザルをスコア順にソート
1. 採択会議で**残りのプロポーザルを確定**する

詳細: [PyCon JP 2024 プロポーザル採択の裏側](https://pyconjp.blogspot.com/2024/08/2024-behinde-selection.html)

---

# 昨年まで: スプレッドシート管理

- Pretalx(CfPシステム)上だけでは偏りなどを考慮できない
- レビュー結果をスプレッドシートでソート、偏りを可視化

## 問題点 (スプレッドシートの限界)

- 編集したくない項目も編集可能 -> 行ズレが発生した (2023)
- 個別レビューの無効・有効を切り替えられない
- 同一の投稿者による複数投稿を検出する方法に難アリ

<!--
で、昨年まではどうやって進めていたのかという話です。

Pretalxの画面ではトラックやレベルの偏りが見えないので、レビューの結果をエクスポートしてスプシにしていました。  
そこからレビューのスコア順にソートし、採択したプロポーザルの偏りを可視化していました

スプシの限界として以下のような問題を抱えていました。

- 実際に昨年、編集してはいけない項目も編集できたのが原因で行ズレが発生し、やりなおしを余儀なくされました
- ノーコメントで最低点など、一部無効にしたいレビューもありました
- それに、同一の投稿者による複数投稿をリストアップするのが可能ではあったものの、難しかった状況です。
-->

---

# Streamlit + Firestoreで実装してみた

StreamlitとFirestoreでダッシュボードが実装できるのでは!? と  
思い立ち、作ってみることに  

- [Streamlit](https://streamlit.io): Pythonでダッシュボードを比較的簡単に実装可能
- [Firestore](https://cloud.google.com/firestore/?hl=ja): リアルタイム更新を検知する仕組みに優れている
- デプロイ先環境: [Cloud Run](https://cloud.google.com/run?hl=ja) + [Cloud IAP](https://cloud.google.com/iap/docs/enabling-cloud-run?hl=ja)
    - 運営内部のみに共有するためIAPでGoogle認証を付与

---

# 結果: 概ね実装できた! (気がする)

- 動いて使えそうなものが実装できた
- リアルタイム更新で[Yuichiro Tachibana氏](https://x.com/whitphx_ja)に助言いただいた
    - FirestoreとStreamlitの繋ぎ込みに苦労していたため
- Google Cloud環境もTerraformで構築

---

# デモ1 (一覧画面)

<Youtube id="97t8jw2DO2Q" width="640" height="380"/>

---

# デモ2 (個別に採択・不採択を切り替え)

<Youtube id="fxPOxLichRA" width="640" height="380"/>

---

# 実際に運用して見えた課題

---
