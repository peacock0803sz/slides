<template>
  <div class="slidev-layout override pyconjp2024">
    <h1><twemoji-megaphone /> PyCon JP 2024 チケット発売中!</h1>
    <div class="box">
      <img src="/PyConJP2024_tate.svg" />
      <div class="info">
        <div class="connpass-box">
          <img class="qrcode" src="/pyconjp2024-qrcode.svg" />
          <div class="connpass-inner">
            <p class="date">
              <span class="mmdd">9.27<span class="weekday">(金)</span> - 29<span class="weekday">(日)</span></span><br />
              <span class="conference-days">※カンファレンスは27, 28の2日間</span>
            </p>
            <p>@TOC有明コンベンションホール</p>
          </div>
        </div>
        <p class="more">
          <span class="ticket">チケットはconnpass (QRコード)から</span><br />
          <span class="website">詳細(公式Webサイト):
            <a href="https://2024.pycon.jp/">https://2024.pycon.jp</a></span>
        </p>
        <p class="discount">学生・25歳以下は割引アリ</p>
      </div>
    </div>
  </div>
</template>

<style>
@import url("https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@100..900&display=swap");

.slidev-layout.pyconjp2024 {
  font-family: "Noto Sans JP", sans-serif;
  margin-top: 5px;
  margin-bottom: 5px;
  margin-left: 0px;
  margin-right: 0px;
  display: grid;
}

.slidev-layout.pyconjp2024 h1 {
  justify-self: center;

  padding-bottom: 0px;
  margin-bottom: 0px;

  color: #005399;
  font-size: 48px;
  font-weight: 800;
}

.slidev-layout.pyconjp2024>div.box {
  justify-self: center;

  display: grid;
  grid-template-columns: 230px 520px;
  column-gap: 30px;
  margin-left: 20px;
  margin-right: 20px;
}

.slidev-layout.pyconjp2024>div.box>div.info {
  p.date {
    font-size: 32px;
    font-weight: 400;

    span.mmdd {
      font-size: 60px;
      font-weight: 600;
    }

    span.mmdd>span.weekday {
      font-size: 24px;
    }

    span.conference-days {
      font-size: 22px;
    }
  }

  p {
    justify-self: left;
    font-size: 24px;
    font-weight: 400;
    margin-top: 10px;
    margin-bottom: 10px;
  }

  p.discount {
    padding-top: 10px;
    padding-bottom: 10px;
    font-size: 40px;
    font-weight: 800;
  }

  p.more {
    line-height: 2;

    span.ticket {
      font-weight: 600;
    }
  }

  div.connpass-box {
    display: grid;
    grid-template-columns: 150px 380px;
    grid-column-gap: 20px;

    div.connpass-inner {
      display: grid;
      padding-top: 10px;

      p {
        justify-self: left;
        margin-top: 10px;
        margin-bottom: 10px;
      }
    }
  }
}
</style>
