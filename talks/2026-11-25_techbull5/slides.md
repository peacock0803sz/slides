---
theme: ../../themes/score
title: 手動反映は初回だけ
titleTemplate: "%s: 2026-11-25 TechBull mini LT&交流会！#5"
favicon: https://media.p3ac0ck.net/icons/peacock.jpg
layout: cover
lineNumbers: true
htmlAttrs:
  lang: ja
presenter: dev
seoMeta:
  ogTitle: 手動反映は初回だけ
  ogDescription: Peacock (Yoichi Takai), at 2026-11-25 TechBull mini LT&交流会！#5
  ogImage: https://slides.p3ac0ck.net/techbull5/cover.png
  ogUrl: https://slides.p3ac0ck.net/techbull5/index.html
  twitterCard: summary_large_image
  twitterTitle: 手動反映は初回だけ
  twitterDescription: Peacock (Yoichi Takai), at 2026-11-25 TechBull mini LT&交流会！#5
  twitterImage: https://slides.p3ac0ck.net/techbull5/cover.png
  twitterSite: https://slides.p3ac0ck.net/
  twitterUrl: https://slides.p3ac0ck.net/techbull5/index.html
hideInToc: true
---

# 手動反映は初回だけ

## ―  NixOS VMにだって自動デプロイできるもん！ ―

### Peacock (Yoichi Takai) / GROOVE X, Inc.<br>2026.11.25 TechBull mini LT&交流会！#5

<!--
冒頭で名前と所属だけ口頭で言う
-->

---
layout: two-cols
---

# 前提とモチベーション

- 週次レポートのPythonジョブを、systemdのtimerで動かす
- OSの設定とジョブのコードを、1つの[flake](https://nix.dev/concepts/flakes)にまとめる
- GCE (Google Compute Engine)のVMはTerraformで建て、SSHは[IAP](https://docs.cloud.google.com/iap/docs/using-tcp-forwarding)越しのみ

VMに手を入れるのは最初の1回だけ。あとはVMがmainを自分で追う

::left::

## 最初の1回: 手動反映

手元から[nixos-anywhere](https://github.com/nix-community/nixos-anywhere)を実行し、DebianのVMを[NixOS](https://nixos.org/)で上書きする

::right::

## 2回目から: Pull型デプロイ

VMが毎時mainを取りに行き、<br />自分でswitchする。<br />CIはVMの鍵を持たない

<!--
15秒

毎週月曜日にレポートを生成するための、定期実行の置き場として新しく建てたVM。  
Pythonのジョブを毎週月曜にsystemdのtimerで動かし、結果をストレージに置いてチャットに要約を流す。OSの設定もジョブのコードも同じリポジトリにある。

最初の1回は手で入れる。2回目からはVMが自分でmainを追うので、もう手を入れない。
-->

---

# 最初の1回はDebianを建てて上書きする

- 手元からIAP越しにnixos-anywhereを1回だけ実行する
- 動いているDebianを[kexec](https://en.wikipedia.org/wiki/Kexec)でインストーラに切り替え、ディスクごと書き換える

```sh
nix run github:nix-community/nixos-anywhere -- \
  --flake .#cronjobs --build-on-remote \
  --target-host <user>@localhost -p 2222 \
  --post-kexec-ssh-port 2222
```

<!--
30秒

nixos-anywhereは、SSHで入れるLinuxが1台あれば、そこにNixOSを入れる。  
kexecで動いているDebianからNixOSのインストーラに乗り換え、diskoでディスクを切り直して入れる。

build-on-remoteを付けるのは、手元のMacではx86_64-linuxをビルドできないから。ビルドはVMにやらせる。  
イメージを焼いてから建てる方法もあるが、ビルドする場所が要るので見送った。

最後の行は次のスライドで説明する。
-->

---

# 罠1: kexecした後のインストーラに入れない

- [OS Login](https://docs.cloud.google.com/compute/docs/oslogin)の鍵は`authorized_keys`に書かれず、SSHのたびに問い合わせて取る
    - kexec後のインストーラには鍵がなく、rootのパスワードを聞かれて止まる
    - 先にDebianのrootの`authorized_keys`へ公開鍵を書き、インストーラに持ち込ませる
- IAPのトンネルは手元の2222番なのに、kexec後は22番へつなぎ直そうとする
    - nixos-anywhereのオプション`--post-kexec-ssh-port 2222`で再接続先をトンネルに向ける

<!--
40秒

一番ハマったところなので、少し溜める。

OS Loginの鍵はファイルに書かれておらず、sshdがログインのたびにOS Loginのサービスへ問い合わせる。  
kexecでDebianを捨てると、この仕組みごと消える。インストーラは鍵を知らないので、rootのパスワードを聞いてきて止まる。  
nixos-anywhereはDebianのrootのauthorized_keysをインストーラに持ち込むので、先にそこへ自分の公開鍵を書いておく。

もう1つはポート。IAPのトンネルは手元の2222番で受けているのに、nixos-anywhereはkexec後に22番へつなぎ直す。オプションで2222番を指定する。
-->

---

# 罠2: UEFIで起動するのにGRUB前提の設定

- Debian 13のイメージから建てたVMは、上書きした後もUEFIで起動する
- nixpkgsの[google-compute-config.nix](https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/virtualisation/google-compute-config.nix)はlegacyのGRUBが前提
- [systemd-boot](https://www.freedesktop.org/software/systemd/man/latest/systemd-boot.html)に替え、ぶつかる値だけを`mkForce`で上書きする

```nix
boot.loader.grub.enable = false;
boot.loader.grub.device = lib.mkForce "nodev";
boot.loader.systemd-boot.enable = true;
fileSystems."/".device = lib.mkForce "/dev/disk/by-label/nixos";
```

<!--
35秒

GCEのDebian 13のイメージはUEFIで起動し、OSを上書きしてもVMの起動方式は変わらない。  
一方でnixpkgsのGCE向け設定は、GRUBを/dev/sdaに入れる前提になっている。guest agentやOS Loginの設定はこのモジュールに任せたいので、importしたうえでsystemd-bootに替える。

fileSystemsのルートを丸ごとmkForceすると、diskoが入れたfsTypeまで消えて起動しなくなる。だから、ぶつかる末端の値だけを上書きする。  
diskoでext4のラベルをnixosにそろえたのも、このモジュールがラベルでルートを探すから。

署名のないsystemd-bootなので、Secure Bootは切っている。
-->

---

# 罠3: 入ったのにジョブがnumpyを読み込めない

- ジョブはsystemd 260の[DynamicUser](https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#DynamicUser=)で動かすつもりだった
- venvを置いたStateDirectoryがnoexecで渡され、numpyを読み込めない
- ジョブごとの固定ユーザーに替え、DynamicUserが付けていた制限は自分で書く

```nix
User = "cronjobs-${name}";
NoNewPrivileges = true;
ProtectSystem = "strict";
PrivateTmp = true;
```

<!--
35秒

これはNixOSに入った後の罠。

ジョブは最初DynamicUserで動かすつもりだった。ところがsystemd 260では、DynamicUserのStateDirectoryがnoexecのidmappedマウントで渡され、そこに作ったvenvからnumpyの共有ライブラリを読み込めなかった。実機で確かめている。

そこでジョブごとに固定のユーザーを作り、DynamicUserが暗黙に付けていたNoNewPrivilegesやProtectSystemなどは自分で書いた。

時間があれば、manylinuxのwheelがNixOSでlibstdc++を見つけられない件にも触れる。LD_LIBRARY_PATHで渡している。
-->

---

# 2回目からはVMが自分でmainを追う

- [system.autoUpgrade](https://nixos.org/manual/nixos/stable/#sec-upgrading-automatic)で、VMが毎時mainを取りに行ってswitchする
- CIは検査だけで、VMには触らない。つまりCIにVMの鍵を置かなくてよい
- 人がやるのは、PRをmainにマージすることだけ

<!--
20秒

ここまでが最初の1回で、2回目からは手を入れない。  
VMが毎時mainを取りに行き、nixos-rebuild switchまで自分でやる。CIはテストと評価だけでVMに触らないので、CIにVMの鍵を置かずに済む。

mainはブランチ保護でCIの成功を必須にしているので、検査を通ったコミットだけがVMに届く。
-->

---

# 設定は数行で済む

```nix
system.autoUpgrade = {
  enable = true;
  flake = "git+https://git.example.com/org/cronjobs?ref=main";
  dates = "*-*-* *:30:00";
  operation = "switch";
};
```

ジョブもflakeのソースから動くので、OSとジョブのコードはいつも同じコミット

<!--
25秒

flakeにmainを指し、毎時30分に取りに行かせる。月曜9時のジョブと重ならないよう時刻をずらしている。

ジョブのWorkingDirectoryもflakeのソースを指すので、OSの設定とジョブのコードはいつも同じコミットになり、switchすれば両方入れ替わる。

リポジトリを読むトークンはSecret Managerに置き、起動時と更新の前に/run/secretsへ取り出す。Nix storeには入れない。
-->

---
layout: summary
---

# まとめ: VMに手を入れるのは最初の1回だけ

1. 最初の1回は、nixos-anywhereで上書きする(手動)
   - OS Loginの鍵、IAPのポート、UEFIの起動、DynamicUserに気をつける
2. 2回目からは、VMがmainを取りに行く
   - CIは検査だけで、VMの鍵を持たない

<!--
15秒

最初の1回だけは手で入れる。罠はOS Login、IAP、UEFI、DynamicUserの4つ。  
2回目からはVMが自分でmainを追うので、もう手を入れず、CIに鍵も要らない。

交流会で聞かれそうなこと

- 壊れたコミットがmainに入ったら。ビルドが失敗すればswitchされず、今の世代のまま残り、失敗はチャットに通知される。動くが中身が壊れていたら、nixos-rebuild switch --rollbackで前の世代に戻す
- 反映までどれくらいか。毎時30分から45分の間に取りに行くので、最大で1時間ほど
- なぜイメージを焼かないのか。x86_64-linuxをビルドする場所がなく、更新のたびにVMを作り直す運用は重い。台数が増えたら考える
- 秘密はどうしているか。Secret Managerにだけ置き、起動時と更新やジョブの前に/run/secretsへ取り出す。gitにもNix storeにも入れない
-->
