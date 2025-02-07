<template>
  <div class="slidev-layout profile">
    <h1>自己紹介 / お前、誰よ</h1>
    <div class="flex flex-row">
      <div class="affiliation basis-48">
        <slot name="affiliation" />
      </div>
      <div class="profile basis-128">
        <slot name="profile" />
      </div>
    </div>
  </div>
</template>

<style lang="postcss">
.slidev-layout.profile {
  background-image: url("../assets/profile.svg");

  padding-top: 30px;
  padding-left: 50px;
}

.slidev-layout.profile h1 {
  font-size: 30px;
  margin-bottom: 10px;
}

.slidev-layout.profile div.profile {
  margin-top: 30px;
  padding-left: 30px;
  font-size: 12px;
}

.slidev-layout.profile div.profile>*>li {
  line-height: 2;
}

.slidev-layout.profile div.affiliation {
  justify-items: center;
}

.slidev-layout.profile div.affiliation>p {
  font-size: 10px;
  text-align: center;
  margin-top: 0px;
  line-height: 2.0;
}

.slidev-layout.profile div.affiliation>h2 {
  font-size: 18px;
  color: #4285f4;
  margin-top: 15px;
  margin-bottom: 0px;
}

.slidev-layout.profile div.affiliation>img {
  border-radius: 50%;
  float: inherit;
  width: 128px;
  height: 128px;
  margin-top: 10px;
}
</style>
