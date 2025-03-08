---
theme: "./"
favicon: https://media.p3ac0ck.net/icons/peacock.jpg
layout: cover
hideInToc: true
lineNumbers: true
htmlAttrs:
  lang: ja
---

# NixConf読書会の紹介

### 2025-03-09 (Sun), Nix meetup #2

#### Peacock (`peacock0803sz`)

##### © Licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

---
layout: intro
hideInToc: true
---

# 本日の資料 (URL or QRコード)

### [https://slides.p3ac0ck.net/nix-meetup2/](https://slides.p3ac0ck.net/nix-meetup2/)

## 写真もご自由に <twemoji-camera />

<img src="/qrcode.svg" />

---
layout: toc
hideInToc: true
---

# 目次

<Toc maxDepth="2" columns="2"/>

---
layout: profile
---

<img src="https://media.p3ac0ck.net/icons/PyConAPAC2023.jpg" />

# お前、誰よ (自己紹介)

- 名前: Peacock (高井 陽一), SNS => `peacock0803sz`
- 仕事: [(株) G-gen](https://g-gen.co.jp/)でGoogle Cloudの技術サポート
    - [Google Cloud Partner Top Engineer 2025受賞](https://g-gen.co.jp/news/pte_2025.html)
- 環境: macOS, WezTerm, fish, Neovim
- 技術イベント、カンファレンスが大好き
    - PyCon JP 2020 - [2025](https://2025.pycon.jp/)主催メンバー(スタッフ)
    - [PyCon JP TV](https://tv.pycon.jp)ディレクター
- 趣味: クラシック音楽、カメラ(α7R III)、ビールなど
    - 技術カンファレンスの撮影スタッフも

---
layout: section
---

# NixConf読書会とは

---

一言で: **Nix日本語コミュニティで開催する隔週のオンライン読書会イベント**

- 日時: 毎週日曜日16:00 ~ 16:30 (30分を予定、多少延長する可能性あり)
    - 第8回から運営(Peacock)の都合により20:00 ~ 20:30開催でやっています
- 場所: nix-ja Discordの `#読書会` チャンネル (テキストと音声)
    - Discord への招待リンク: https://discord.com/invite/TYytzedtbe
- 目的: Nixに関するコードやドキュメントを読んで設計や知見について共有したり議論
    - 輪読会のイメージだが事前の予習などは不要で、読みながら会話する

---

## 開催のきっかけ

- vim-jpでは[vimrc読書会](https://vim-jp.org/reading-vimrc/)が開催されている
    - 毎週オンラインでチャットに集まって誰かの `.vimrc` を読む会
- 2024年ごろから[vim-jp](https://vim-jp.org/) SlackではNixがブームで、専用チャンネル `#tech-nix` も本記事執筆時点で約300人のメンバーがいる人気コンテンツ
- 昨年2024-12-10に「vimrc読書会のようなnix dotfiles輪読会が欲しい」と `@satler` さんが発言していた

---

それなら、と「せっかくだしnix-jaの方でやりませんか?」と私が提案した

![](/background.png)

ただしvimrc読書会(全てチャットのみでやり取り)とは違って、音声チャットも使いながら進める

---
layout: section
---

# 開催遍歴を振り返る

---
layout: table
hideInToc: true
---

# 開催遍歴を振り返る

|  No | 開催日時                 | 対象リポジトリ                   |
| --: | :----------------------: | :------------------------------- |
|  #1 | 2024-12-20 16:00 ~ 16:30 | `github:peacock0803sz/dotfiles`  |
|  #2 | 2024-12-20 16:00 ~ 16:30 | `github:yasunori0418/dotfiles`   |
|  #3 | 2025-01-05 16:15 ~ 16:45 | `github:asa1984/dotfiles` (前編) |
|  #4 | 2025-01-12 16:00 ~ 16:30 | `github:asa1984/dotfiles` (後編) |
|  #5 | 2025-01-20 16:00 ~ 16:30 | `github:tositada17/nixos-wsl`    |
|  #6 | 2025-01-26 16:00 ~ 16:30 | `github:kuuote/nixconf`          |
|  #7 | 2025-02-16 16:00 ~ 16:30 | `github:LnL7/dotfiles`           |
|  #8 | 2025-03-02 20:00 ~ 20:30 | `github:NixOS/nixpkgs/lib`       |

---

# NixConf読書会のこれから
