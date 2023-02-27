import router from '@ohos.router';
@Entry
@Component
struct WebPage {

  onPageHide() {
    router.clear()
  }

  controller:WebController = new WebController();

  build() {
    Row() {
      Column() {
        Web({ src:'https://app.privacy.hokkj.cn/', controller:this.controller })
      }
      .width('100%')
    }
    .height('100%')
  }
}